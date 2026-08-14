// * នាំចូល Flutter foundation និងឯកសារភាសា
import "package:flutter/foundation.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/i18n/en_EN.dart";
import "package:speanmeas/core/i18n/km_KH.dart";

// * ថ្នាក់ I18N គ្រប់គ្រងការបកប្រែភាសា
class I18N extends ChangeNotifier {
  // * singleton instance
  static final I18N instance = I18N._();
  I18N._();

  // * ទិន្នន័យបកប្រែបច្ចុប្បន្ន
  Map<String, String> data = {};

  // * ឈ្មោះភាសាដែលគាំទ្រ
  final ENGLISH = "en_EN";
  final KHMER = "km_KH";

  // * ចាប់ផ្តើមភាសាលំនាំដើម
  void init() async {
    print("I18N initialized.");
    await set_locale(ENGLISH);
    // await set_locale(KHMER);
  }

  // * កំណត់ភាសាបច្ចុប្បន្ន
  Future<void> set_locale(String locale) async {
    // * ជ្រើសរើសទិន្នន័យភាសាដែលត្រូវគ្នា
    if (locale == ENGLISH) data = en_EN;
    if (locale == KHMER) data = km_KH;

    // * ជូនដំណឹងដល់ listeners
    notifyListeners();
  }

  // * បកប្រែអត្ថបទ
  String translate(String input) {
    return data[input] ?? input;
  }

  //
}

//
// * instance សកលរបស់ I18N
I18N lang = I18N.instance;

// * អនុគមន៍ខ្លីសម្រាប់បកប្រែ
String t(String input) {
  return lang.translate(input);
}
