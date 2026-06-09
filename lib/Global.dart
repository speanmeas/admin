import 'package:flutter/material.dart';
import 'package:speanmeas/Environment.dart';

class Global extends ChangeNotifier {
  //

  String header = TITLE;

  // String body = "Dashboard";
  // String body = "Template";
  String body = "Front Desk";

  //

  //

  static double RATE = 4000; // 1 USD = 4000 KHR

  // foreign key
  static bool is_admin = false;
  static bool is_manager = false;
  static bool is_receptionist = false;
  static bool is_housekeeper = false;

  static void view() {
    print("is_admin: $is_admin");
    print("is_manager: $is_manager");
    print("is_receptionist: $is_receptionist");
    print("is_housekeeper: $is_housekeeper");
  }

  static void clear() {
    is_admin = false;
    is_manager = false;
    is_receptionist = false;
    is_housekeeper = false;
  }

  void reload() {
    notifyListeners();
  }

  //
}
