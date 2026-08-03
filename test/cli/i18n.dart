import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class I18n extends ChangeNotifier {
  // singleton
  static final I18n instance = I18n._();
  I18n._();

  Map<String, String> data = {};

  Future<void> set_locale({String locale = "en_EN"}) async {
    try {
      final json = await rootBundle.loadString("assets/i18n/$locale.json");
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
}

I18n i18n = I18n.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await i18n.set_locale(locale: "en_EN");
  await i18n.set_locale(locale: "km_KH");
  print(i18n.tr("Spean Meas"));
  print(i18n.tr("Hello"));
}
