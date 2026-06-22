import 'package:flutter/foundation.dart';
import 'package:speanmeas/Environment.dart';

class Global extends ChangeNotifier {
  //

  String header = TITLE;

  String body = kDebugMode ? "Demo" : "Front Desk";

  String username = "";

  // foreign key
  bool is_admin = false;
  bool is_manager = false;
  bool is_receptionist = false;
  bool is_housekeeper = false;

  //

  double RATE = 4000; // 1 USD = 4000 KHR

  void clear() {
    header = TITLE;
    body = kDebugMode ? "Template" : "Front Desk";
    username = "";
    is_admin = false;
    is_manager = false;
    is_receptionist = false;
    is_housekeeper = false;
    notifyListeners();
  }
}
