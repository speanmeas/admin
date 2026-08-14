// * នាំចូល Flutter foundation និង package_info_plus សម្រាប់ព័ត៌មានកម្មវិធី
import "package:flutter/foundation.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

// * ថ្នាក់ Global គ្រប់គ្រង state សកលរបស់កម្មវិធី
class Global extends ChangeNotifier {
  // * singleton instance
  static final Global instance = Global._();
  Global._();

  // * ចាប់ផ្តើម global state
  Future<void> init() async {
    // * កំណត់ body លំនាំដើមក្នុង debug mode
    if (kDebugMode) body = "Front Desk";
    // if (kDebugMode) body = "Data Front Desk";

    // * ទទួលបានព័ត៌មានកំណែរបស់កម្មវិធី
    final info = await PackageInfo.fromPlatform();
    glob.VERSION = "${info.version}+${info.buildNumber}";

    // * ជូនដំណឹងដល់ listeners ថា state បានផ្លាស់ប្តូរ
    notifyListeners();
    print("Global initialized.");
  }

  // * ឈ្មោះ body បច្ចុប្បន្ន
  String body = "Front Desk";

  // * ថេររបស់កម្មវិធី
  String VERSION = "0.0.0+0";
  double RATE = 4000; // 1 USD = 4000 KHR

  // * ជូនដំណឹងដល់ listeners
  void notify() {
    notifyListeners();
  }

  //
}

// * instance សកលរបស់ Global
Global glob = Global.instance;
