import "package:flutter/foundation.dart";

final TITLE = "Spean Meas";

final MOBILE_SCREEN_WIDTH = 1000;

final is_local = false;
final is_github = false;
String get_api_host() {
  if (kDebugMode) {
    return "http://localhost:8000";
  }

  // todo: need to config router
  if (is_local) {
    return "http://192.168.1.100:8000";
  }

  if (is_github) {
    return "https://muysengly.1riel.com";
  }

  return "https://api.speanmeas.com";
}

final API_HOST = get_api_host();

// todo: later
String get_minio_public() {
  if (kDebugMode) {
    return "http://localhost:9000/public";
  }

  // todo: need to config router
  if (is_local) {
    return "http://192.168.1.100:9000/public";
  }

  // todo: need to config router
  if (is_github) {
    return "https://muysengly.1riel.com/public";
  }

  return "https://sss.speanmeas.com/public";
}

final MINIO_PUBLIC = get_minio_public();
