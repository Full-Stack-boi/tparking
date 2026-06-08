import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

import 'package:tparking/src/common_widgets/constants/colors.dart';
import 'package:tparking/src/common_widgets/constants/image_stritngs.dart';
import 'package:tparking/src/features/authentication/models/user_model.dart';
import 'package:tparking/src/features/controllers/parking_controllers.dart';
import 'package:tparking/src/features/core/controllers/car_register_list.dart';
import 'package:tparking/src/features/core/controllers/profile_controllers.dart';
import 'package:tparking/src/features/core/screens/dashboard/dashboard.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  double? distance;
  double tnilag = 100.6284;
  double tnilat = 13.7380;
  double? currentLat;
  double? currentLng;
  bool isWithinTni = false;
  bool locationServiceEnabled = false;
  PermissionStatus locationPermission = PermissionStatus.denied;
  late Future<dynamic> _userDataFuture;

  @override
  void initState() {
    super.initState();
    final profileController = Get.find<ProfileController>();
    _userDataFuture = profileController.getUserData();
    // Delay location initialization to allow screen transition to complete smoothly
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _initLocation();
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _initLocation() async {
    try {
      // Optimize GPS request parameters to lower main thread workload
      await location.changeSettings(
        accuracy: LocationAccuracy.balanced,
        interval: 3000,
        distanceFilter: 5,
      );
      
      locationServiceEnabled = await location.serviceEnabled();
      if (!locationServiceEnabled) {
        locationServiceEnabled = await location.requestService();
        if (!locationServiceEnabled) return;
      }

      locationPermission = await location.hasPermission();
      if (locationPermission == PermissionStatus.denied) {
        locationPermission = await location.requestPermission();
        if (locationPermission != PermissionStatus.granted) return;
      }

      final initialData = await location.getLocation();
      if (mounted) {
        setState(() {
          currentLat = initialData.latitude;
          currentLng = initialData.longitude;
          if (currentLat != null && currentLng != null) {
            distance =
                calculateDistance(currentLat!, currentLng!, tnilat, tnilag);
            isWithinTni = distance! <= 0.15;
          }
        });
      }

      _locationSubscription = location.onLocationChanged.listen((event) {
        if (mounted) {
          setState(() {
            currentLat = event.latitude;
            currentLng = event.longitude;
            if (currentLat != null && currentLng != null) {
              distance =
                  calculateDistance(currentLat!, currentLng!, tnilat, tnilag);
              isWithinTni = distance! <= 0.15;
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Error initializing location: $e");
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  String _getLocationSubtitle() {
    if (locationPermission != PermissionStatus.granted) {
      return "Permission denied. Please enable location permissions.";
    }
    if (currentLat == null || currentLng == null) {
      return "Locating your vehicle...";
    }
    if (isWithinTni) {
      return "Inside TNI bounds (~${(distance! * 1000).toStringAsFixed(0)} m)";
    } else {
      final distMeters = distance! * 1000;
      if (distMeters < 1000) {
        return "Outside TNI (~${distMeters.toStringAsFixed(0)} m away)";
      } else {
        return "Outside TNI (~${distance!.toStringAsFixed(1)} km away)";
      }
    }
  }

  Widget _buildActiveBookingCard(
      BuildContext context, bool isDark, ParkingController parkingController) {
    final isUserParked = parkingController.isParked.value == true;
    final slot = parkingController.activeReservedSlot.value;
    final slotName = slot?.slotName ?? parkingController.slotIdPraked.split('-').last.substring(
                          0,
                          min(
                              5,
                              parkingController.slotIdPraked
                                  .split('-')
                                  .last
                                  .length));
    final buildingName = slot?.building ?? parkingController.selectedBuilding.value;

    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : tPrimaryColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? Colors.grey[900] : Colors.white,
        ),
        child: Column(
          children: [
            if (isUserParked)
              Lottie.asset(
                'assets/animation/Parked_by.json',
                width: 130,
                height: 130,
              )
            else
              CircularCountDownTimer(
                width: 130,
                height: 130,
                duration: parkingController.getTotalReservationSeconds(),
                initialDuration: parkingController.getInitialElapsedSeconds(),
                fillColor: isDark ? tPrimaryColor : Colors.blueAccent,
                ringColor: isDark ? Colors.grey[800]! : Colors.blue[50]!,
                autoStart: true,
                isReverse: true,
                isReverseAnimation: true,
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : tDarkColor,
                ),
                onComplete: () {
                  parkingController.handleReservationExpired();
                },
              ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isUserParked 
                    ? Colors.blue.withOpacity(0.12)
                    : Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isUserParked ? Colors.blue : Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isUserParked ? 'Currently Parked' : 'Active Reservation',
                    style: TextStyle(
                      color: isUserParked ? Colors.blue : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Building",
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$buildingName Building",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Slot ID",
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slotName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Vehicle Plate",
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slot?.carRegistration ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, bool isDark,
      DashboardController dashboardController) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : tPrimaryColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? Colors.grey[900] : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark ? Colors.grey[800] : tPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_parking_rounded,
                size: 44,
                color: isDark ? tPrimaryColor : Colors.blue[700],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No Active Session",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : tDarkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ready to park? Reserve a parking space in advance to secure a slot.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                dashboardController.changeTab(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tPrimaryColor,
                foregroundColor: tDarkColor,
                elevation: 3,
                shadowColor: Colors.black26,
                side: BorderSide.none,
                minimumSize: const Size(180, 48),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                shape: const StadiumBorder(),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Book a Slot",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final parkingController = Get.find<ParkingController>();
    final dashboardController = Get.find<DashboardController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? tSecondaryColor : tPrimaryColor,
        elevation: 3.0,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        title: Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : tDarkColor,
              ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _userDataFuture,
                builder: (context, snapshot) {
                  String welcomeName = "User";
                  String? welcomeImg;
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final userData = snapshot.data as UserModel;
                    welcomeName = userData.fullName.split(' ').first;
                    welcomeImg = userData.imgaeLink;
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_getGreeting()},",
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              welcomeName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : tDarkColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFormattedDate(),
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.grey[500]
                                    : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            dashboardController.changeTab(3);
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? tPrimaryColor.withOpacity(0.5)
                                    : tPrimaryColor,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: welcomeImg != null && welcomeImg.isNotEmpty
                                  ? Image.network(
                                      welcomeImg,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Image(
                                              image: AssetImage(tProfileImage),
                                              fit: BoxFit.cover),
                                    )
                                  : const Image(
                                      image: AssetImage(tProfileImage),
                                      fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 0,
                color: isDark ? Colors.grey[900] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark
                        ? Colors.grey[800]!
                        : tPrimaryColor.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 14.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              (locationPermission != PermissionStatus.granted)
                                  ? Colors.red.withOpacity(0.1)
                                  : isWithinTni
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          (locationPermission != PermissionStatus.granted)
                              ? Icons.location_off_rounded
                              : isWithinTni
                                  ? Icons.location_on_rounded
                                  : Icons.location_searching_rounded,
                          color:
                              (locationPermission != PermissionStatus.granted)
                                  ? Colors.red
                                  : isWithinTni
                                      ? Colors.green
                                      : Colors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TNI Parking Boundary",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : tDarkColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getLocationSubtitle(),
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _initLocation,
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        tooltip: "Refresh Location",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                final isBooked = parkingController.isBooked.value == true;
                return isBooked
                    ? _buildActiveBookingCard(
                        context, isDark, parkingController)
                    : _buildEmptyStateCard(
                        context, isDark, dashboardController);
              }),
              Obx(() {
                final isBooked = parkingController.isBooked.value == true;
                final isParked = parkingController.isParked.value == true;

                if (!isBooked && !isParked) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isBooked && !isParked) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          if (distance == null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: const Text("Location Loading"),
                                content: const Text(
                                    "Still acquiring location coordinates. Please try again in a few seconds."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          if (distance! <= 0.15) {
                            SharedPreference.SetParking_id(
                                    parkingController.slotIdPraked)
                                .toString();
                            parkingController
                                  .checkoutupdate(SharedPreference.getID());
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: const Text("Success"),
                                content: const Text(
                                    "You have successfully Checked-in!"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: const Text("Location Error"),
                                content: Text(
                                    "You are outside TNI bounds (~${(distance! * 1000).toStringAsFixed(0)}m away). Please proceed to the parking zone to check-in."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.login_rounded, size: 20),
                        label: const Text(
                          'CHECK-IN',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          foregroundColor: tDarkColor,
                          elevation: 3,
                          shadowColor: Colors.black26,
                          side: BorderSide.none,
                          minimumSize: const Size(double.infinity, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          shape: const StadiumBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (isParked) ...[
                      OutlinedButton.icon(
                        onPressed: () {
                          if (SharedPreference.getID() == null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: const Text("Status Info"),
                                content: const Text(
                                    "You haven't checked into any slot yet."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            parkingController
                                .parkUpdate(SharedPreference.getID());
                            SharedPreference.ParkIDdelete();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: const Text("Checked Out"),
                                content: const Text(
                                    "You have successfully Checked-out."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: const Text(
                          'CHECK-OUT',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(
                              color: Colors.redAccent, width: 1.5),
                          minimumSize: const Size(double.infinity, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
