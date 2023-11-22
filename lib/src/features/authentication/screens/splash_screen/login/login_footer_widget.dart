import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/constants/text_string.dart';
import '../signup/signup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Text("OR"),
        // const SizedBox(height: tFormHeight - 10),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //     icon: const Image(image: AssetImage(tGoogleLogoImage), width: 20.0),
        //     onPressed: () {},
        //     label:  Text(tSignInWithGoogle.toUpperCase()),
        //   ),
        // ),
        //const SizedBox(height: tFormHeight - 10),
        const SizedBox(width: double.infinity,),
        TextButton(
          onPressed: () => Get.to(() => const SignUpScreen()),
          child: Text.rich(
            TextSpan(
                text: tDontHaveAnAccount,
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(text: tSignup.toUpperCase(), style: const TextStyle(color: Colors.blue))
                ]),
          ),
        ),
      ],
    );
  }
}