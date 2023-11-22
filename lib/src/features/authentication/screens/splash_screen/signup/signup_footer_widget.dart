import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/constants/text_string.dart';
import '../login/login_screen.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        // child: Text("OR"),),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //     onPressed: () {},
        //     icon: const Image(
        //       image: AssetImage(tGoogleLogoImage),
        //       width: 20.0,
        //     ),
        //     label: Text(tSignInWithGoogle.toUpperCase()),
        //   ),
        // ),
        // const SizedBox(),
        TextButton(
          onPressed: () => Get.to(() => const LoginScreen()),
          child: Text.rich(TextSpan
          (children: [
            TextSpan(
              text: tAlreadyHaveAnAccount,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextSpan(text: tLogin.toUpperCase())
          ])
          ),
        )
      ],
    );
  }
}