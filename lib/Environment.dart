import 'dart:io';

import 'package:flutter/foundation.dart';

String TITLE = 'Spean Meas HMS';

bool is_local = false;

int MOBILE_SCREEN_WIDTH = 1000;

String get_api_host() {
  if (kDebugMode) {
    return 'http://localhost:8000';
  }

  if (is_local) {
    return 'http://192.168.1.100:8000'; // todo: need to confix router
  }

  return 'https://api.speanmeas.com';
}

String API_HOST = get_api_host();

String get_minio_public() {
  if (kDebugMode) {
    return 'http://localhost:9000/public';
  }

  if (is_local) {
    return 'http://192.168.1.100:9000/public'; // todo: need to confix router
  }

  return 'https://sss.speanmeas.com/public';
}

String MINIO_PUBLIC = get_minio_public();

double HEADER_HEIGHT = 40.0;
double ROW_HEIGHT = 40.0;
double COLUMN_WIDTH = 120.0;
double NUMBER_COLUMN_WIDTH = 60.0;
