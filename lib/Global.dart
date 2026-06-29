import 'package:flutter/foundation.dart';
import 'package:speanmeas/Environment.dart';

class Global extends ChangeNotifier {
  //
  static String VERSION = '0.0.0+0';
  static double RATE = 4000; // 1 USD = 4000 KHR

  //

  static String header = TITLE;

  static String body = "Front Desk";
  // static String body = kDebugMode ? "Demo" : "Front Desk";

  static String username = "";

  // foreign key
  static bool is_admin = false;
  static bool is_manager = false;
  static bool is_receptionist = false;
  static bool is_housekeeper = false;

  //

  static void clear() {
    header = TITLE;
    body = kDebugMode ? "Template" : "Front Desk";
    username = "";
    is_admin = false;
    is_manager = false;
    is_receptionist = false;
    is_housekeeper = false;
  }
}
