import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tparking/src/common_widgets/constants/image_stritngs.dart';
import 'package:tparking/src/common_widgets/constants/sizes.dart';
import 'package:tparking/src/common_widgets/constants/text_string.dart';
import 'package:tparking/src/features/authentication/screens/splash_screen/signup/signup_screen.dart';

import '../../../../../common_widgets/constants/colors.dart';
import '../login/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? tSecondaryColor : tWhiteColor,
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
                image: const AssetImage(tWelcomeScreenImage),
                height: height * 0.6),
            Column(
              children: [
                Text(tWelcomeTitle,
                    style: Theme.of(context).textTheme.displaySmall),
                Text('Rev up Your Simplicity',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => const LoginScreen()),
                    child: Text(tLogin.toUpperCase()),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const SignUpScreen()),
                    child: Text(tSignup.toUpperCase()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
