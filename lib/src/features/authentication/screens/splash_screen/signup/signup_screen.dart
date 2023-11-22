import 'package:flutter/material.dart';

import '../../../../../common_widgets/constants/image_stritngs.dart';
import '../../../../../common_widgets/constants/sizes.dart';
import '../../../../../common_widgets/constants/text_string.dart';
import 'signup_footer_widget.dart';
import 'signup_form_widget.dart';
import 'signup_header_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                  imageHeight: 0.15,
                ),
                SignUpFormWidget(),
                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}