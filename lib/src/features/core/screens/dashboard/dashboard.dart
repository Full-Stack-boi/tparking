import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tparking/src/common_widgets/constants/colors.dart';

import '../homepage.dart';
import '../car_registion.dart';
import '../profiles/profile.dart';
import '../reserves/reserve.dart';

import '../../controllers/profile_controllers.dart';
import '../../../controllers/parking_controllers.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(ProfileController());
    Get.put(ParkingController());
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    final List pages = [
      const Homepage(),
      const Reserve(),
      const CarRegistion(),
      const ProfileScreen()
    ];

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: Obx(
        () => PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
              FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child),
          child: pages[controller.currentIndex.value],
        ),
      ),
      bottomNavigationBar: Obx(
        () => SalomonBottomBar(
            backgroundColor: isDark ? Colors.black87 : tWhiteColor,
            onTap: controller.changeTab,
            currentIndex: controller.currentIndex.value,
            selectedItemColor: isDark ? tPrimaryColor : Colors.black,
            unselectedItemColor: Colors.grey,
            items: [
              SalomonBottomBarItem(
                  title: const Text("Home"), icon: const Icon(Icons.home)),
              SalomonBottomBarItem(
                  title: const Text("Reserve"),
                  icon: const Icon(Icons.car_rental),
                  selectedColor: Colors.blueAccent),
              SalomonBottomBarItem(
                  title: const Text("Registion"),
                  icon: const Icon(Icons.pageview)),
              SalomonBottomBarItem(
                  title: const Text("Profile"),
                  icon: const Icon(Icons.person),
                  selectedColor: Colors.red),
            ]),
      ),
    );
  }
}
