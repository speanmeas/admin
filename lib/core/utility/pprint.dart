// * នាំចូល dart:convert សម្រាប់ JSON encoding និង Flutter foundation
import 'dart:convert';
import 'package:flutter/foundation.dart';

// * កម្រិតជម្រៅអតិបរមា ដើម្បីការពារ stack overflow លើទិន្នន័យដាក់ជ្រៅ
const int _kMaxDepth = 100;

// * ទំហំប្លុកសម្រាប់បំបែកអត្ថបទ ដើម្បីកុំឲ្យ debugPrint កាត់អត្ថបទ
const int _kChunkSize = 800;

// * បោះពុម្ព value ក្នុងទម្រង់ JSON ដែលងាយអាន
// * អាចបង្ហាញអ្វីៗទាំងអស់៖ object, Map, List, Enum, Error, Exception, StackTrace, ...
void pprint(dynamic value, {String? label, int maxLength = 10000, bool pretty = true, StackTrace? stackTrace}) {
  try {
    // * បម្លែង value ទៅជាទម្រង់ដែលអាច JSON encode បាន
    final converted = _convert(value);

    // * បង្កើត JSON string ជាមួយ indent (ឬ compact បើ pretty = false)
    final encoder = pretty ? const JsonEncoder.withIndent('  ') : const JsonEncoder();
    final output = encoder.convert(converted);

    // * បន្ថែម stack trace បើមាន
    final body = stackTrace == null ? output : '$output\n\n$stackTrace';

    // * បោះពុម្ពលទ្ធផល
    _print(label == null ? body : '$label:\n$body', maxLength);
  } catch (e) {
    // * បើមានកំហុស បោះពុម្ព value ដើម និង stack trace
    final body = stackTrace == null ? '$value' : '$value\n\n$stackTrace';
    _print(label == null ? body : '$label:\n$body', maxLength);
  }
}

// * បោះពុម្ព Error / Exception ជាមួយ type, message និង stack trace
void pprintError(Object error, [StackTrace? stackTrace]) {
  pprint(error, label: 'ERROR (${error.runtimeType})', stackTrace: stackTrace ?? StackTrace.current);
}

// * បម្លែង value ទៅជាទម្រង់ដែលអាច JSON encode បាន
// * ការពារ circular reference និង deep nesting
dynamic _convert(dynamic value, {int depth = 0, Expando<bool>? seen}) {
  // * ការពារ stack overflow ពេលដាក់ជ្រៅពេក
  if (depth > _kMaxDepth) return '<max depth reached>';

  // * តម្លៃមូលដ្ឋានត្រឡប់ដូចដើម
  if (value == null || value is String || value is num || value is bool) //
    return value;

  // * បម្លែង DateTime ទៅជា ISO string
  if (value is DateTime) //
    return value.toIso8601String();

  // * បម្លែង Duration, Uri, StackTrace ទៅជា string
  if (value is Duration || value is Uri || value is StackTrace) //
    return value.toString();

  // * បម្លែង Enum ទៅជាឈ្មោះ
  if (value is Enum) //
    return value.name;

  // * បម្លែង Error / Exception ទៅជា Map ដែលមាន type និង message
  if (value is Error || value is Exception) {
    return {'type': value.runtimeType.toString(), 'message': value.toString()};
  }

  // * បង្កើត Expando សម្រាប់តាមដាន object ដែលបានឃើញរួច
  seen ??= Expando<bool>();

  // * បម្លែង Map ដោយបម្លែង key និង value
  if (value is Map) {
    // * រកឃើញ circular reference
    if (seen[value] == true) return '<circular reference: ${value.runtimeType}>';
    seen[value] = true;

    final result = <String, dynamic>{};
    value.forEach((key, v) {
      result[key.toString()] = _convert(v, depth: depth + 1, seen: seen);
    });
    return result;
  }

  // * បម្លែង Iterable (List, Set, generator, ...) ទៅជា List
  if (value is Iterable) {
    // * រកឃើញ circular reference
    if (seen[value] == true) return '<circular reference: ${value.runtimeType}>';
    seen[value] = true;

    return value.map((e) => _convert(e, depth: depth + 1, seen: seen)).toList();
  }

  // * ព្យាយាមបម្លែង object ដែលមាន toJson()
  try {
    final json = (value as dynamic).toJson();
    return _convert(json, depth: depth + 1, seen: seen);
  } catch (_) {
    return value.toString();
  }
}

// * បោះពុម្ពអត្ថបទជាមួយការកំណត់ប្រវែងអតិបរមា
// * បំបែកជាប្លុកតូចៗ ដើម្បីកុំឲ្យ debugPrint កាត់អត្ថបទ
void _print(String text, int maxLength) {
  // * កាត់អត្ថបទបើវែងជាង maxLength
  var content = text;
  var truncated = false;
  if (content.length > maxLength) {
    content = content.substring(0, maxLength);
    truncated = true;
  }

  // * បំបែកជាប្លុកតូចៗ ហើយបោះពុម្ពម្ដងមួយប្លុក
  for (var i = 0; i < content.length; i += _kChunkSize) {
    final end = (i + _kChunkSize < content.length) ? i + _kChunkSize : content.length;
    debugPrint(content.substring(i, end));
  }

  // * បង្ហាញសញ្ញាថាអត្ថបទត្រូវបានកាត់
  if (truncated) {
    debugPrint('... [truncated at $maxLength chars]');
  }
}
