import "package:flutter/foundation.dart";
import "package:speanmeas/__config__.dart";

class Global extends ChangeNotifier {
  // singleton
  static final Global instance = Global._();
  Global._();

  // constants
  String VERSION = "0.0.0+0";
  double RATE = 4000; // 1 USD = 4000 KHR

  // pages
  String body = "Dashboard - Front Desk"; //
  // String body = "Database - Nationality"; //

  //

  void clear() {
    body = "Database - Nationality"; //
    notifyListeners();
  }
}

Global global = Global.instance;
