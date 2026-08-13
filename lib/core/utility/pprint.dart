import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';

void pprint(dynamic value, {String? label, int maxLength = 10000}) {
  try {
    final converted = _convert(value);

    final output = const JsonEncoder.withIndent('  ').convert(converted);

    _print(label == null ? output : '$label:\n$output', maxLength);
  } catch (e) {
    // Never let debug printing break your application.
    _print(label == null ? '$value' : '$label:\n$value', maxLength);
  }
}

dynamic _convert(dynamic value) {
  if (value == null || value is String || value is num || value is bool) {
    return value;
  }

  if (value is DateTime) {
    return value.toIso8601String();
  }

  if (value is Enum) {
    return value.name;
  }

  if (value is List) {
    return value.map(_convert).toList();
  }

  if (value is Set) {
    return value.map(_convert).toList();
  }

  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), _convert(value)));
  }

  // Try model.toJson()
  try {
    final json = (value as dynamic).toJson();
    return _convert(json);
  } catch (_) {
    // Unknown object.
    return value.toString();
  }
}

void _print(String text, int maxLength) {
  if (text.length <= maxLength) {
    debugPrint(text);
    return;
  }

  debugPrint(text.substring(0, maxLength));
  debugPrint('... [truncated]');
}
