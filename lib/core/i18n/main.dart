import "package:flutter/foundation.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/i18n/en_EN.dart";
import "package:speanmeas/core/i18n/km_KH.dart";

class I18N extends ChangeNotifier {
  // singleton
  static final I18N instance = I18N._();
  I18N._();

  Map<String, String> data = {};

  final ENGLISH = "en_EN";
  final KHMER = "km_KH";

  void init() async {
    print("I18N initialized.");
    // await set_locale(ENGLISH);
    await set_locale(KHMER);
  }

  Future<void> set_locale(String locale) async {
    if (locale == ENGLISH) data = en_EN;
    if (locale == KHMER) data = km_KH;

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
