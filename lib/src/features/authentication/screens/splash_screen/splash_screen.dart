import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tparking/src/common_widgets/constants/image_stritngs.dart';
import 'package:tparking/src/features/authentication/controllers/splash_screen_controllers.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.stratAnimation();
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 10000),
              bottom: splashController.animate.value ? 250 : -250,
              child: const Image(
                image: AssetImage(tWelcomeScreenImage),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
