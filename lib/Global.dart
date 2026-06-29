import 'package:flutter/foundation.dart';
import 'package:speanmeas/Environment.dart';

class Global extends ChangeNotifier {
  // singleton instance
  static final Global variable = Global._();
  Global._();

  //
  String VERSION = '0.0.0+0';
  double RATE = 4000; // 1 USD = 4000 KHR

  //

  String header = TITLE;

  String body = "Front Desk";
  //  String body = kDebugMode ? "Demo" : "Front Desk";

  String username = "";

  // foreign key
  bool is_admin = false;
  bool is_manager = false;
  bool is_receptionist = false;
  bool is_housekeeper = false;

  //

  void clear() {
    header = TITLE;
    username = "";
    is_admin = false;
    is_manager = false;
    is_receptionist = false;
    is_housekeeper = false;
    notifyListeners();
  }
}
