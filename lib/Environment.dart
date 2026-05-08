import 'dart:io';

import 'package:flutter/foundation.dart';

int MOBILE_SCREEN_WIDTH = 1000;

String TITLE = 'Spean Meas Hotel';

String API_HOST = kReleaseMode ? 'https://dev_api.speanmeas.com' : 'http://127.0.0.1:8000';

String MINIO_PUBLIC = kReleaseMode ? 'https://dev_s3.speanmeas.com/public' : 'http://127.0.0.1:9000/public';
