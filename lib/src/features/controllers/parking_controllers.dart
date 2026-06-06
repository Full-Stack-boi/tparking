import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tparking/src/features/core/controllers/car_register_list.dart';
import 'package:tparking/src/features/core/screens/dashboard/dashboard.dart';
import '../models/car_model.dart';
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
    return sortedGroups;
  }

  final isBooked = false.obs;
  late String slotIdPraked = '';
  late String checkslotId = '';
  final isParked = false.obs;

  StreamSubscription? _streamSubscription;

  // Helper to dynamically get table name for currently selected building
  String get currentTableName {
    return 'parking_slots_${selectedBuilding.value.toLowerCase()}';
  }

  @override
  void onInit() {
    super.onInit();
    isParked.value = SharedPreference.getID() != null;
    
    // Subscribe to slots initially
    subscribeToSlots();

    // Listen to building changes and re-subscribe
    ever(selectedBuilding, (_) {
      subscribeToSlots();
    });
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }

  void updateData(slotId) async {
    await _supabase.from(currentTableName).update(
      {
        "car_registration": carRegistrationController.text,
        "parking_hours": parkingHours.toString(),
        "booked": true,
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

    startSlotTimer(slotId);
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
      {"isParked": false, "booked": false, "car_registration": ""},
    ).eq('id', checkslotId);
    isParked.value = false;
  }

  void subscribeToSlots() async {
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
    } catch (e) {
      print("Supabase Select: Error fetching initial slots: $e");
    }

    // 2. Stream for realtime updates
    _streamSubscription = _supabase
        .from(tableName)
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      print("Supabase Realtime: Received ${data.length} slots from $tableName.");
      try {
        final List<CarModel> slots = data.map((row) => CarModel.fromJson(row)).toList();
        slots.sort((a, b) => (a.slotName ?? '').compareTo(b.slotName ?? ''));
        parkingSlots.value = slots;
        print("Supabase Realtime: Successfully parsed and sorted ${slots.length} slots.");
      } catch (e, stack) {
        print("Supabase Realtime: Error parsing slots data: $e");
        print(stack);
      }
    }, onError: (error) {
      print("Supabase Realtime: Stream encountered an error: $error");
    });
  }

  void addCar(CarModel car) async {
    await _supabase.from(currentTableName).insert(car.toJson());
  }

  void startSlotTimer(String slotKey) async {
    final slot = parkingSlots.firstWhereOrNull((s) => s.id == slotKey);
    if (slot == null) return;
    
    double time = double.tryParse(slot.parkingHours?.toString() ?? '0') ?? 0;
    final tableName = currentTableName;

    while (time > 0) {
      await Future.delayed(const Duration(seconds: 1)); // for testing
      time--;
      await _supabase.from(tableName).update(
        {
          "parking_hours": time.toString(),
        },
      ).eq('id', slotKey);
    }

    if (isParked.value == false) {
      await _supabase.from(tableName).update(
        {"booked": false, "isParked": false, "car_registration": ""},
      ).eq('id', slotKey);
      NotificationLocal().showNotification(
          title: 'Alert', body: 'Your slot has been cancel');
    }

    isBooked.value = false;
  }

  // Resets slots across all buildings at night (A, B, C)
  Future<void> resetAllSlotsAtNight() async {
    final tables = ['parking_slots_a', 'parking_slots_b', 'parking_slots_c'];
    for (var table in tables) {
      try {
        await _supabase.from(table).update({
          "isParked": false,
          "booked": false,
          "car_registration": ""
        }).not('id', 'is', null);
      } catch (e) {
        print("Error resetting $table: $e");
      }
    }
  }
}
