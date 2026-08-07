import "package:flutter/foundation.dart";
import "package:package_info_plus/package_info_plus.dart";

class Global extends ChangeNotifier {
  // singleton
  static final Global instance = Global._();
  Global._();

  Future<void> init() async {
    if (kDebugMode) body = "Data Front Desk";

    final info = await PackageInfo.fromPlatform();
    glob.VERSION = "${info.version}+${info.buildNumber}";

    notifyListeners();
    print("Global initialized.");
  }

  String body = "Front Desk";

  // constants
  String VERSION = "0.0.0+0";
  double RATE = 4000; // 1 USD = 4000 KHR

  void notify() {
    notifyListeners();
  }

  //
}

Global glob = Global.instance;
