import 'package:flutter/material.dart';
import 'package:tparking/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:tparking/src/utils/theme/widget_themes/outlined_botton_theme.dart';
import 'package:tparking/src/utils/theme/widget_themes/text_theme.dart';

class TAppTheme{

  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: TElevateButtonTheme.lightElevateButtonTheme,

    );

 static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: TElevateButtonTheme.darkElevateButtonTheme,
  );
}