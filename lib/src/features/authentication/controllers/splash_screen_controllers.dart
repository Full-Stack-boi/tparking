import 'package:get/get.dart';

import '../screens/splash_screen/welcome/welcome_screen.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();
  RxBool animate = false.obs;

  Future stratAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 3000));
    Get.to(const WelcomeScreen());
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
  }
}
