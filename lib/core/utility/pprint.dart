// * នាំចូល dart:convert សម្រាប់ JSON encoding និង Flutter material
import 'dart:convert';
import 'package:flutter/material.dart';

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

// * បោះពុម្ព value ក្នុងទម្រង់ JSON ដែលងាយអាន
void pprint(dynamic value, {String? label, int maxLength = 10000}) {
  try {
    // * បម្លែង value ទៅជាទម្រង់ដែលអាច JSON encode បាន
    final converted = _convert(value);

    // * បង្កើត JSON string ជាមួយ indent
    final output = const JsonEncoder.withIndent('  ').convert(converted);

    // * បោះពុម្ពលទ្ធផល
    _print(label == null ? output : '$label:\n$output', maxLength);
  } catch (e) {
    // * បើមានកំហុស បោះពុម្ព value ដើម
    _print(label == null ? '$value' : '$label:\n$value', maxLength);
  }
}

// * បម្លែង value ទៅជាទម្រង់ដែលអាច JSON encode បាន
dynamic _convert(dynamic value) {
  // * តម្លៃមូលដ្ឋានត្រឡប់ដូចដើម
  if (value == null || value is String || value is num || value is bool) //
    return value;

  // * បម្លែង DateTime ទៅជា ISO string
  if (value is DateTime) //
    return value.toIso8601String();

  // * បម្លែង Enum ទៅជាឈ្មោះ
  if (value is Enum) //
    return value.name;

  // * បម្លែង List ដោយបម្លែងធាតុនីមួយៗ
  if (value is List) //
    return value.map(_convert).toList();

  // * បម្លែង Set ទៅជា List
  if (value is Set) //
    return value.map(_convert).toList();

  // * បម្លែង Map ដោយបម្លែង key និង value
  if (value is Map) //
    return value.map((key, value) => MapEntry(key.toString(), _convert(value)));

  // * ព្យាយាមបម្លែង object ដែលមាន toJson()
  try {
    final json = (value as dynamic).toJson();
    return _convert(json);
  } catch (_) {
    return value.toString();
  }
}

// * បោះពុម្ពអត្ថបទជាមួយការកំណត់ប្រវែងអតិបរមា
void _print(String text, int maxLength) {
  // * បើអត្ថបទខ្លីជាង maxLength បោះពុម្ពទាំងស្រុង
  if (text.length <= maxLength) {
    debugPrint(text);
    return;
  }

  // * បើវែង កាត់អត្ថបទ និងបង្ហាញសញ្ញា truncated
  debugPrint(text.substring(0, maxLength));
  debugPrint('... [truncated]');
}
