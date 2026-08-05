import "package:flutter/foundation.dart";

class Global extends ChangeNotifier {
  // singleton
  static final Global instance = Global._();
  Global._();

  void init() {
    print("Global initialized.");
  }

  // constants
  String VERSION = "0.0.0+0";
  double RATE = 4000; // 1 USD = 4000 KHR
  String body = "Front Desk"; //

  void notify() {
    notifyListeners();
  }

  //
}

Global glob = Global.instance;
