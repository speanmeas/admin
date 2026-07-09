import "dart:io";

import "package:flutter/foundation.dart";

String TITLE = "Spean Meas";

bool is_local = false;

int MOBILE_SCREEN_WIDTH = 1000;

// const String LOCAL_ROUTER_HOST = String.fromEnvironment(
//   "LOCAL_ROUTER_HOST", //
//   defaultValue: "192.168.1.100",
// );

String get_api_host() {
  if (kDebugMode) {
    return "http://localhost:8000";
  }

  if (is_local) {
    return "http://192.168.1.100:8000"; // todo: need to config router
  }

  return "https://api.speanmeas.com";
}

String API_HOST = get_api_host();

String get_minio_public() {
  if (kDebugMode) {
    return "http://localhost:9000/public";
  }

  if (is_local) {
    return "http://192.168.1.100:9000/public"; // todo: need to config router
  }

  return "https://sss.speanmeas.com/public";
}

String MINIO_PUBLIC = get_minio_public();
