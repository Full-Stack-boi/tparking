import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tparking/src/features/core/screens/forget_password/forget_password_button_widget.dart';
import 'package:tparking/src/features/core/screens/forget_password/forget_password_mail_screen.dart';

import '../../../../common_widgets/constants/sizes.dart';
import '../../../../common_widgets/constants/text_string.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tForgetPasswordTitle,
                style: Theme.of(context).textTheme.displayMedium),
            Text(tForgetPasswordSubTitle,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 30.0),
            ForgetPasswordBtnWidget(
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ForgetPasswordMailScreen());
              },
              title: tEmail,
              subTitle: tResetViaEMail,
              btnIcon: Icons.mail_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}