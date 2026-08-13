import "dart:convert";

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import

final ENGLISH = "en_EN";
final KHMER = "km_KH";

class I18N extends ChangeNotifier {
  // singleton
  static final I18N instance = I18N._();
  I18N._();

  void init() async {
    print("I18N initialized.");
    // await set_locale(ENGLISH);
    await set_locale(KHMER);
  }

  Map<String, String> data = {};

  Future<void> set_locale(String locale) async {
    final String path = "assets/i18n/$locale.json";

    try {
      final json = await rootBundle.loadString(path);
      final map = jsonDecode(json) as Map<String, dynamic>;
      data = map.map((k, v) => MapEntry(k, v.toString()));
    } catch (e, st) {
      pprint(st);
      data = {};
    }
    notifyListeners();
  }

  String translate(String input) {
    return data[input] ?? input;
  }

  //
}

//
I18N lang = I18N.instance;

// make it short to use
String t(String input) {
  return lang.translate(input);
}