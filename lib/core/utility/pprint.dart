// * នាំចូល dart:convert សម្រាប់ JSON encoding និង Flutter foundation
import 'dart:convert';
import 'package:flutter/foundation.dart';

// * បោះពុម្ព value ក្នុងទម្រង់ JSON ដែលងាយអាន
void pprint(dynamic value) {
  // * ប្រសិនបើ value គឺជា String, num, bool ឬ null បោះពុម្ពដោយផ្ទាល់
  if (value is String || value is num || value is bool || value == null) //
    return debugPrint(value);

  // * ប្រសិនបើ value គឺជា Map ឬ List, បំលែងវាទៅជា JSON string ដែលមាន indentation
  if (value is Map || value is List) //
    return debugPrint(JsonEncoder.withIndent('  ').convert(value));

  // * ទូទៅ
  debugPrint(value);
}
