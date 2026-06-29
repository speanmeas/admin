import 'package:flutter/foundation.dart';
import 'package:speanmeas/Environment.dart';

class Global extends ChangeNotifier {
  // singleton instance
  static final Global variable = Global._();
  Global._();

  // constants
  String VERSION = '0.0.0+0';
  double RATE = 4000; // 1 USD = 4000 KHR

  // pages
  String body = "Front Desk";

  // credentials
  String user_id = "";
  String full_name = "";
  String phone_number = "";
  String email = "";
  String username = "";

  // positions
  bool is_admin = false;
  bool is_manager = false;
  bool is_receptionist = false;
  bool is_housekeeper = false;

  //

  void clear() {
    body = "Front Desk";
    user_id = "";
    full_name = "";
    phone_number = "";
    email = "";
    username = "";
    is_admin = false;
    is_manager = false;
    is_receptionist = false;
    is_housekeeper = false;
    notifyListeners();
  }
}
