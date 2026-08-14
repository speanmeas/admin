// * នាំចូល flutter_secure_storage សម្រាប់ផ្ទុកទិន្នន័យសម្ងាត់
import "package:flutter_secure_storage/flutter_secure_storage.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

// * instance សកលសម្រាប់ផ្ទុកទិន្នន័យសម្ងាត់ (token, password...)
final FlutterSecureStorage secure = FlutterSecureStorage();
