import "package:flutter/foundation.dart";

final TITLE = "Spean Meas";

final MOBILE_SCREEN_WIDTH = 1000;

final DEFAULT_DATE_FORMAT = "EE d-M-yy h:mm a";
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

// todo: later
String get_minio_public() {
  if (kDebugMode) return "http://localhost:9000/public";

  if (is_local) return "http://192.168.1.100:9000/public";

  if (is_github) return "https://muysengly.1riel.com/public";

  return "https://sss.speanmeas.com/public";
}

final MINIO_PUBLIC = get_minio_public();
