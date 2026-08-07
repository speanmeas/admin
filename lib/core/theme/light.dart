import "package:flutter/material.dart";

ThemeData data() {
  return ThemeData(
    fontFamily: "Nokora",

    //
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white, //
      brightness: Brightness.light,
    ),

    //
    scaffoldBackgroundColor: Colors.white,

    //
    appBarTheme: AppBarTheme(
      titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      backgroundColor: Colors.white, //
    ),

    //
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16.0), //
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), //
        ),
        minimumSize: Size(0, 40),
        // maximumSize: Size(double.infinity, 40),
        padding: EdgeInsets.symmetric(horizontal: 8),
      ),
    ),

    //
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 16.0), //
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), //
        ),
      ),
    ),

    //
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.blue, //
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), //
        ),
      ),
    ),

    //
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), //
      ),
    ),

    //
    drawerTheme: DrawerThemeData(
      width: 300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), //
      ),
    ),

    //
    inputDecorationTheme: InputDecorationTheme(
      //
      border: const OutlineInputBorder(),
    ),

    //
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue), //
        borderRadius: BorderRadius.circular(0), //
      ),
      sizeConstraints: const BoxConstraints.tightFor(width: 40, height: 40),
    ),

    dividerColor: Colors.transparent,

    //
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      // backgroundColor: Colors.blue, //
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
      // set border around
    ),

    // platform: TargetPlatform.iOS,
    useMaterial3: true,
  );
}

// usage: Themes_Data.theme
