// * នាំចូល dart:convert សម្រាប់ JSON encoding
import 'dart:convert';
import 'package:speanmeas/core/utility/parse.dart';

// * បោះពុម្ព value ក្នុងទម្រង់ JSON ដែលងាយអាន
void pprint(dynamic value) {
  // * ប្រសិនបើ value គឺជា String, num, bool ឬ null បោះពុម្ពដោយផ្ទាល់
  if (value is String || value is num || value is bool || value == null) //
    return print(value.toString());

  // * ប្រសិនបើ value គឺជា DateTime, បោះពុម្ពតាមទម្រង់កាលបរិច្ឆេទ
  if (value is DateTime) //
    return print(format_datetime(value));

  // * ប្រសិនបើ value គឺជា Map ឬ List, បំលែងវាទៅជា JSON string ដែលមាន indentation
  if (value is Map || value is List) //
    return print(JsonEncoder.withIndent('  ').convert(value));

  // * ប្រសិនបើ value គឺជា object នៃ schema model (មាន toJson()), បំលែងវាទៅជា JSON
  if (value is Object && value is! Iterable) {
    // * ព្យាយាមហៅ toJson() ប្រសិនបើ object មាន method នេះ
    try {
      final json = (value as dynamic).toJson();
      if (json is Map<String, dynamic>) //
        return print(JsonEncoder.withIndent('  ').convert(json));
    } catch (_) {
      // * បើ object គ្មាន toJson(), បន្តទៅបោះពុម្ពដោយផ្ទាល់
    }
  }

  // * ទូទៅ
  print(value);
}
