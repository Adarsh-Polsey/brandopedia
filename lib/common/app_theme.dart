import 'package:flutter/material.dart';

class AppTheme {
  static final themeData=ThemeData.light().copyWith(
    primaryColor: AppColorpallete.primaryColor,
    scaffoldBackgroundColor: AppColorpallete.secondaryColor,
    iconTheme: IconThemeData(color: AppColorpallete.primaryColor),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(AppColorpallete.primaryColor),
      ),
    )
  );
}
class AppColorpallete {
  static const Color primaryColor=Color(0xFF4E29AC);
  static const Color secondaryColor=Color(0xFFF7F7F9);
  static const Color sideColor1=Color(0xFFCD5000);
  static const Color sideColor2=Color(0xFF003271);
  static const Color sideColor3=Color(0xFF9F4C00);
}