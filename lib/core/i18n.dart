import "dart:convert";

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

class I18N extends ChangeNotifier {
  // singleton
  static final I18N instance = I18N._();
  I18N._();

  void init() async {
    print("I18N initialized.");
    await set_locale("en_EN");
    // await set_locale("km_KH");
  }

  Map<String, String> data = {};

  Future<void> set_locale(String locale) async {
    final String path = "assets/i18n/$locale.json";

    try {
      final json = await rootBundle.loadString(path);
      final map = jsonDecode(json) as Map<String, dynamic>;
      data = map.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      data = {};
    }
    notifyListeners();
  }

  String tr(String input) {
    return data[input] ?? input;
  }

  //
}

I18N lang = I18N.instance;
