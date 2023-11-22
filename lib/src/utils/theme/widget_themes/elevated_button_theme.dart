
import 'package:flutter/material.dart';

import '../../../common_widgets/constants/colors.dart';
import '../../../common_widgets/constants/sizes.dart';

class TElevateButtonTheme {
  TElevateButtonTheme._();

//-- Light Theme --//
static final lightElevateButtonTheme = ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              foregroundColor: tWhiteColor,
              side: const BorderSide(color: tSecondaryColor),
              padding: const EdgeInsets.symmetric(vertical: tButtonHeight)
              ));

//-- Dark Theme --//
static final  darkElevateButtonTheme = ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                foregroundColor: tWhiteColor,
                side: const BorderSide(color: tSecondaryColor),
                padding: const EdgeInsets.symmetric(vertical: tButtonHeight)
                ),
);

}