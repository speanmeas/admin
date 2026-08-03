import "dart:convert";

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

class Global extends ChangeNotifier {
  // singleton
  static final Global instance = Global._();
  Global._();

  init() {
    print("Global initialized.");
  }

  // constants
  String VERSION = "0.0.0+0";
  double RATE = 4000; // 1 USD = 4000 KHR
  String body = "Front Desk"; //

  //
}

Global glob = Global.instance;
