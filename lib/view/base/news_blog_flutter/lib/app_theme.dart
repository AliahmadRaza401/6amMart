import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Utils/Colors.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: white_color,
    primaryColor: primaryColor,
    primaryColorDark: primaryColor,
    errorColor: Colors.red,
    hoverColor: Colors.grey,
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
    appBarTheme: AppBarTheme(
      color: app_Background,
      iconTheme: IconThemeData(color: textColorPrimary),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: Colors.white),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.light(primary: primaryColor, primaryContainer: primaryColor),
    cardTheme: CardTheme(color: Colors.white),
    cardColor: scaffoldBackgroundLightColor,
    iconTheme: IconThemeData(color: textColorPrimary),
    dividerColor: Colors.grey.shade300,
    textTheme: TextTheme(
      button: TextStyle(color: primaryColor),
      headline6: TextStyle(color: textColorPrimary),
      subtitle2: TextStyle(color: textColorSecondary),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appBackGroundColor,
    highlightColor: app_background_black,
    errorColor: Color(0xFFCF6676),
    appBarTheme: AppBarTheme(
      color: app_background_black,
      iconTheme: IconThemeData(color: white_color),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: appBackGroundColor, statusBarBrightness: Brightness.light),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    primaryColor: color_primary_black,
    primaryColorDark: color_primary_black,
    hoverColor: Colors.black,
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
    colorScheme: ColorScheme.light(primary: app_background_black, onPrimary: card_background_black, primaryContainer: color_primary_black),
    cardTheme: CardTheme(color: scaffoldBackgroundDarkColor),
    cardColor: card_color_dark,
    iconTheme: IconThemeData(color: white_color),
    dividerColor: Colors.grey.shade800,
    textTheme: TextTheme(
      button: TextStyle(color: color_primary_black),
      headline6: TextStyle(color: white_color),
      subtitle2: TextStyle(color: Colors.white54),
      bodyText1: TextStyle(color: Colors.white54),
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
  );
}
