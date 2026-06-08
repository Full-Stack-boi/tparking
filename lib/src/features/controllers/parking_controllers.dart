import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tparking/src/features/core/controllers/car_register_list.dart';
import 'package:tparking/src/features/core/screens/dashboard/dashboard.dart';
import '../models/car_model.dart';
import 'package:tparking/src/repository/authentication_repository/user_repository/user_repository.dart';
import 'notification_local.dart';

class ParkingController extends GetxController {
  final _supabase = Supabase.instance.client;
  var parkingHours = 10.0.obs;
  var selectedBuilding = "A".obs;
  TextEditingController carRegistrationController = TextEditingController();

  // Dynamic list of parking slots loaded from Database
  var parkingSlots = <CarModel>[].obs;

  // Get filtered parking slots based on the selected building (e.g. "A", "B", "C")
  List<CarModel> get filteredParkingSlots {
    return parkingSlots.where((slot) => slot.building == selectedBuilding.value).toList();
  }

  // Get filtered parking slots grouped by floor
  Map<String, List<CarModel>> get groupedFilteredParkingSlots {
    // Register Rx variables with GetX/Obx even when returning cached slots
    final _ = parkingSlots.length + selectedBuilding.value.hashCode;

    if (_cachedGroupedSlots != null) return _cachedGroupedSlots!;

    final Map<String, List<CarModel>> groups = {};
    
    // Sort slots by name to ensure consistent UI order
    final sortedSlots = List<CarModel>.from(parkingSlots);
    sortedSlots.sort((a, b) => (a.slotName ?? '').compareTo(b.slotName ?? ''));

    for (var slot in sortedSlots) {
      final floorName = slot.floor ?? 'Floor 1';
      groups.putIfAbsent(floorName, () => []).add(slot);
    }

    // Sort map keys to ensure Floor 1, Floor 2, Floor 3 sequence
    final sortedKeys = groups.keys.toList()..sort();
    final Map<String, List<CarModel>> sortedGroups = {};
    for (var key in sortedKeys) {
      sortedGroups[key] = groups[key]!;
    }
    _cachedGroupedSlots = sortedGroups;
    return sortedGroups;
  }

  final isBooked = false.obs;
  late String slotIdPraked = '';
  late String checkslotId = '';
  final isParked = false.obs;

  final activeReservedSlot = Rxn<CarModel>();
  List<String> _userCars = [];
  Timer? _localTimer;
  Timer? _debounceTimer;
  bool _hasSubscribed = false;
  Map<String, List<CarModel>>? _cachedGroupedSlots;

  StreamSubscription? _streamSubscription;

  // Helper to dynamically get table name for currently selected building
  String get currentTableName {
    return 'parking_slots_${selectedBuilding.value.toLowerCase()}';
  }

  @override
  void onInit() async {
    super.onInit();
    isParked.value = SharedPreference.getID() != null;

    // Check nightly reset (between 19:00 PM and 5:00 AM)
    final now = DateTime.now();
    if (now.hour > 19 || now.hour < 5) {
      resetAllSlotsAtNight();
    }
    
    // Delay non-critical initialization steps to allow app transition animation to run smoothly
    Future.delayed(const Duration(milliseconds: 400), () async {
      // 1. Load user's registered cars
      await _loadUserCars();

      // 2. Listen to building changes and re-subscribe
      ever(selectedBuilding, (_) {
        subscribeToSlots();
      });

      // 3. Find active reservation (may change selectedBuilding)
      await findUserActiveReservation();

      // 4. If we haven't subscribed yet (because selectedBuilding didn't change from 'A'), subscribe now
      if (!_hasSubscribed) {
        subscribeToSlots();
      }
    });
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    _localTimer?.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadUserCars() async {
    try {
      final email = _supabase.auth.currentUser?.email;
      if (email == null) return;
      final userRepo = Get.isRegistered<UserRepository>() 
          ? Get.find<UserRepository>() 
          : Get.put(UserRepository());
      final user = await userRepo.getUserDetails(email);
      _userCars = user.carRegistrations;
      print("Loaded user cars: $_userCars");
    } catch (e) {
      print("Error loading user cars: $e");
    }
  }

  Future<void> findUserActiveReservation() async {
    try {
      final email = _supabase.auth.currentUser?.email;
      if (email == null) return;
      
      // If we haven't loaded user cars yet, load them now
      if (_userCars.isEmpty) {
        await _loadUserCars();
      }
      
      final nonFilterCars = _userCars.where((car) => car.isNotEmpty).toList();
      if (nonFilterCars.isEmpty) return;

      final tables = ['parking_slots_a', 'parking_slots_b', 'parking_slots_c'];
      
      // Query all tables in parallel to minimize latency on startup
      final futures = tables.map((table) => _supabase
          .from(table)
          .select()
          .inFilter('car_registration', nonFilterCars)
          .or('booked.eq.true,isParked.eq.true')
          .maybeSingle()); // maybeSingle returns null if no rows match, or a single row if matched
          
      final results = await Future.wait(futures);

      for (int i = 0; i < tables.length; i++) {
        final row = results[i];
        if (row != null) {
          final table = tables[i];
          final slot = CarModel.fromJson(row);
          final buildingLetter = table.split('_').last.toUpperCase(); // 'a' -> 'A'
          
          // Set active booking info
          activeReservedSlot.value = slot;
          slotIdPraked = slot.id ?? '';
          checkslotId = slot.id ?? '';
          isBooked.value = slot.booked == true;
          isParked.value = slot.isParked == true;
          
          // Switch building (which triggers ever and re-subscribes)
          selectedBuilding.value = buildingLetter;
          
          print("Found active reservation in building $buildingLetter, slot: ${slot.slotName}");
          
          // Start local countdown
          startLocalCountdownTimer();
          return;
        }
      }
    } catch (e) {
      print("Error finding user active reservation: $e");
    }
  }

  void updateData(slotId) async {
    final now = DateTime.now().toUtc();
    final duration = Duration(minutes: parkingHours.value.toInt());
    final parkedFromStr = now.toIso8601String();
    final parkedToStr = now.add(duration).toIso8601String();

    await _supabase.from(currentTableName).update(
      {
        "car_registration": carRegistrationController.text,
        "parking_hours": parkingHours.toString(),
        "booked": true,
        "parked_from": parkedFromStr,
        "parked_to": parkedToStr,
        "isParked": false,
      },
    ).eq('id', slotId);

    slotIdPraked = slotId;
    isBooked.value = true;
    if (kDebugMode) {
      print("Data Updated");
    }
    Get.defaultDialog(
        barrierDismissible: false,
        title: "SLOT BOOKED",
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        content: Column(
          children: [
            Lottie.asset(
              'assets/animation/sloting_done.json',
              width: 100,
              height: 100,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Slot Booked",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(const Dashboard(),
                    transition: Transition.circularReveal);
              },
              child: const Text("Close"),
            )
          ],
        ));

    slotIdPraked = slotId;
    checkslotId = slotIdPraked;
  }

  checkoutupdate(slotIdPraked) async {
    await _supabase.from(currentTableName).update(
      {
        "isParked": true,
        "parking_hours": 0.0.toString(),
      },
    ).eq('id', slotIdPraked);
    isParked.value = true;
  }

  parkUpdate(checkslotId) async {
    await _supabase.from(currentTableName).update(
      {
        "isParked": false,
        "booked": false,
        "car_registration": "",
        "parked_from": null,
        "parked_to": null,
      },
    ).eq('id', checkslotId);
    isParked.value = false;
  }

  void subscribeToSlots() async {
    _hasSubscribed = true;
    _streamSubscription?.cancel();
    
    final tableName = currentTableName;
    print("Supabase Realtime: Subscribing to $tableName stream...");
    
    // 1. Fetch initial data immediately using standard select()
    try {
      final List<dynamic> response = await _supabase.from(tableName).select();
      final List<CarModel> slots = response.map((row) => CarModel.fromJson(row)).toList();
      slots.sort((a, b) => (a.slotName ?? '').compareTo(b.slotName ?? ''));
      parkingSlots.value = slots;
      print("Supabase Select: Successfully loaded ${slots.length} slots initially.");
      updateActiveReservationState();
    } catch (e) {
      print("Supabase Select: Error fetching initial slots: $e");
    }

    // 2. Stream for realtime updates (debounced to prevent rapid rebuilds)
    _streamSubscription = _supabase
        .from(tableName)
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      print("Supabase Realtime: Received ${data.length} slots from $tableName.");
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        try {
          final List<CarModel> slots = data.map((row) => CarModel.fromJson(row)).toList();
          slots.sort((a, b) => (a.slotName ?? '').compareTo(b.slotName ?? ''));
          _cachedGroupedSlots = null; // Invalidate cache
          parkingSlots.value = slots;
          print("Supabase Realtime: Successfully parsed and sorted ${slots.length} slots.");
          updateActiveReservationState();
        } catch (e, stack) {
          print("Supabase Realtime: Error parsing slots data: $e");
          print(stack);
        }
      });
    }, onError: (error) {
      print("Supabase Realtime: Stream encountered an error: $error");
    });
  }

  void addCar(CarModel car) async {
    await _supabase.from(currentTableName).insert(car.toJson());
  }

  void updateActiveReservationState() {
    if (_userCars.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        activeReservedSlot.value = null;
        isBooked.value = false;
        isParked.value = false;
      });
      _localTimer?.cancel();
      return;
    }

    final currentActiveSlot = parkingSlots.firstWhereOrNull((slot) =>
        _userCars.contains(slot.carRegistration) &&
        (slot.booked == true || slot.isParked == true));

    if (currentActiveSlot != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        activeReservedSlot.value = currentActiveSlot;
        slotIdPraked = currentActiveSlot.id ?? '';
        checkslotId = currentActiveSlot.id ?? '';
        isBooked.value = currentActiveSlot.booked == true;
        isParked.value = currentActiveSlot.isParked == true;
        
        startLocalCountdownTimer();
      });
    } else {
      final active = activeReservedSlot.value;
      if (active != null) {
        final activeBuildingTable = 'parking_slots_${active.building?.toLowerCase()}';
        if (currentTableName == activeBuildingTable) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            activeReservedSlot.value = null;
            isBooked.value = false;
            isParked.value = false;
          });
          _localTimer?.cancel();
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          isBooked.value = false;
          isParked.value = false;
        });
      }
    }
  }

  int getRemainingSecondsStatic() {
    if (isParked.value) {
      return 0;
    }
    final slot = activeReservedSlot.value;
    if (slot == null || slot.parkedTo == null) return 0;
    try {
      final parkedToDateTime = DateTime.parse(slot.parkedTo!).toUtc();
      final nowUtc = DateTime.now().toUtc();
      final difference = parkedToDateTime.difference(nowUtc).inSeconds;
      return difference > 0 ? difference : 0;
    } catch (e) {
      print("Error parsing parkedTo: $e");
      return 0;
    }
  }

  int getTotalReservationSeconds() {
    final slot = activeReservedSlot.value;
    if (slot == null || slot.parkedFrom == null || slot.parkedTo == null) {
      return parkingHours.value.toInt() * 60;
    }
    try {
      final from = DateTime.parse(slot.parkedFrom!).toUtc();
      final to = DateTime.parse(slot.parkedTo!).toUtc();
      return to.difference(from).inSeconds;
    } catch (e) {
      return parkingHours.value.toInt() * 60;
    }
  }

  int getInitialElapsedSeconds() {
    final total = getTotalReservationSeconds();
    final remaining = getRemainingSecondsStatic();
    final elapsed = total - remaining;
    return elapsed > 0 ? elapsed : 0;
  }

  void startLocalCountdownTimer() {
    _localTimer?.cancel();
    
    final seconds = getRemainingSecondsStatic();
    if (seconds <= 0) {
      if (isBooked.value && !isParked.value) {
        handleReservationExpired();
      }
      return;
    }

    _localTimer = Timer(Duration(seconds: seconds), () {
      if (isBooked.value && !isParked.value) {
        handleReservationExpired();
      }
    });
  }

  void handleReservationExpired() async {
    if (isBooked.value && !isParked.value) {
      final slot = activeReservedSlot.value;
      if (slot != null) {
        try {
          final activeBuildingTable = 'parking_slots_${slot.building?.toLowerCase()}';
          await _supabase.from(activeBuildingTable).update(
            {
              "booked": false,
              "isParked": false,
              "car_registration": "",
              "parking_hours": "0",
              "parked_from": null,
              "parked_to": null,
            },
          ).eq('id', slot.id ?? '');
          
          NotificationLocal().showNotification(
              title: 'Reservation Expired',
              body: 'Your parking reservation slot has been released.');
        } catch (e) {
          print("Error releasing expired slot: $e");
        }
      }
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isBooked.value = false;
        activeReservedSlot.value = null;
      });
    }
  }

  // Resets slots across all buildings at night (A, B, C)
  Future<void> resetAllSlotsAtNight() async {
    final tables = ['parking_slots_a', 'parking_slots_b', 'parking_slots_c'];
    for (var table in tables) {
      try {
        await _supabase.from(table).update({
          "isParked": false,
          "booked": false,
          "car_registration": "",
          "parking_hours": "0",
          "parked_from": null,
          "parked_to": null,
        }).not('id', 'is', null);
      } catch (e) {
        print("Error resetting $table: $e");
      }
    }
  }
}
