// * នាំចូល Flutter foundation សម្រាប់ kDebugMode
import "package:flutter/foundation.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

// * ចំណងជើងរបស់កម្មវិធី
final TITLE = "Spean Meas";

// * ទទឹងអេក្រង់សម្រាប់ឧបករណ៍ចល័ត
final MOBILE_SCREEN_WIDTH = 1000;

// * ទម្រង់កាលបរិច្ឆេទលំនាំដើម
// final DEFAULT_DATE_FORMAT = "EEEE dd-MM-yyyy h:mm a";
final DEFAULT_DATE_FORMAT = "yyyy-MM-dd HH:mm";
// * ចំនួនជួរដេកលំនាំដើមសម្រាប់ការទាញទិន្នន័យ
final DEFAULT_LIMIT_ROW = 1000;
// * ឈ្នះដែលប្រើសម្រាប់តម្រៀបលំនាំដើម
final DEFAULT_KEY = "created_at";
// * លំដាប់តម្រៀបលំនាំដើម (ចុះ)
final DEFAULT_ORDER = -1;

// * ការកំណត់បរិស្ថាន
final is_local = false;
final is_github = false;

// * ទទួលបាន API host អាស្រ័យលើបរិស្ថាន
String get_api_host() {
  if (kDebugMode) return "http://localhost:8000";
  if (is_local) return "http://192.168.1.100:8000";
  if (is_github) return "https://muysengly.1riel.com";
  return "https://api.speanmeas.com";
}

// * API host ដែលបានកំណត់
final API_HOST = get_api_host();

// TODO: later
// * ទទួលបាន MinIO public URL សម្រាប់ផ្ទុកឯកសារ
String get_minio_public() {
  if (kDebugMode) return "http://localhost:9000/public";
  if (is_local) return "http://192.168.1.100:9000/public";
  if (is_github) return "https://muysengly.1riel.com/public";
  return "https://sss.speanmeas.com/public";
}

// * MinIO public URL ដែលបានកំណត់
final MINIO_PUBLIC = get_minio_public();
