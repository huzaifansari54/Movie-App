import 'package:flutter/material.dart';
import 'package:movie_app/ThemeContentent/Colors.dart';

class Themes {
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: LightThemeColors.scaffoldColor,
      primaryColor: LightThemeColors.primaryColor,
      textTheme: const TextTheme(
          caption: TextStyle(color: LightThemeColors.textColor)),
      secondaryHeaderColor: DarkThemeColors.secondryColor);
  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DarkThemeColors.scaffoldColor,
      primaryColor: DarkThemeColors.primaryColor,
      textTheme:
          const TextTheme(caption: TextStyle(color: DarkThemeColors.textColor)),
      secondaryHeaderColor: DarkThemeColors.secondryColor);
}
