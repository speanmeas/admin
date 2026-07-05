import "package:flutter/foundation.dart";
import "package:speanmeas/Environment.dart";

class Global extends ChangeNotifier {
  // singleton instance
  static final Global variable = Global._();
  Global._();

  // constants
  String VERSION = "0.0.0+0";
  double RATE = 4000; // 1 USD = 4000 KHR

  // pages
  String body = "Front Desk";

  //

  void clear() {
    body = "Front Desk";
    notifyListeners();
  }
}
