// * នាំចូល Flutter material សម្រាប់ UI components
import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

// * ការកំណត់ theme របស់កម្មវិធី
ThemeData theme_data = ThemeData(
  // * ពុម្ពអក្សរលំនាំដើម
  fontFamily: "Nokora",

  //
  // * ពណ៌ចម្បងរបស់កម្មវិធី
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, //
    brightness: Brightness.light,
  ),

  //
  // * ពណ៌ផ្ទៃខាងក្រោយរបស់ scaffold
  scaffoldBackgroundColor: Colors.white,

  //
  // * theme របស់ AppBar
  appBarTheme: AppBarTheme(
    titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    backgroundColor: Colors.white, //
  ),

  //
  // * theme របស់ OutlinedButton
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
  // * theme របស់ TextButton
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
  // * theme របស់ IconButton
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: Colors.blue, //
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), //
      ),
    ),
  ),

  //
  // * theme របស់ Dialog
  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0), //
    ),
  ),

  //
  // * theme របស់ Drawer
  drawerTheme: DrawerThemeData(
    width: 300,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0), //
    ),
  ),

  //
  // * theme របស់ input fields
  inputDecorationTheme: InputDecorationTheme(
    //
    border: const OutlineInputBorder(),
  ),

  //
  // * theme របស់ FloatingActionButton
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

  // * ពណ៌ divider
  dividerColor: Colors.transparent,

  //
  // * theme របស់ BottomNavigationBar
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

// usage: Themes_Data.theme
