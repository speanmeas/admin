import "package:flutter/foundation.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

final TITLE = "Spean Meas";

final MOBILE_SCREEN_WIDTH = 1000;

// final DEFAULT_DATE_FORMAT = "EEEE dd-MM-yyyy h:mm a";
final DEFAULT_DATE_FORMAT = "yyyy-MM-dd HH:mm";
final DEFAULT_LIMIT_ROW = 1000;
final DEFAULT_KEY = "created_at";
final DEFAULT_ORDER = -1;

final is_local = false;
final is_github = false;

String get_api_host() {
  if (kDebugMode) return "http://localhost:8000";
  if (is_local) return "http://192.168.1.100:8000";
  if (is_github) return "https://muysengly.1riel.com";
  return "https://api.speanmeas.com";
}

final API_HOST = get_api_host();

// TODO: later
String get_minio_public() {
  if (kDebugMode) return "http://localhost:9000/public";
  if (is_local) return "http://192.168.1.100:9000/public";
  if (is_github) return "https://muysengly.1riel.com/public";
  return "https://sss.speanmeas.com/public";
}

final MINIO_PUBLIC = get_minio_public();
