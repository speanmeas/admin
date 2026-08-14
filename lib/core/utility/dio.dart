// * នាំចូល Dio សម្រាប់ HTTP requests និង Flutter foundation
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

// * ការកំណត់ Dio client ជាមួយ base URL និង headers
Dio dio_ = Dio(
  BaseOptions(
    baseUrl: API_HOST, //
    // connectTimeout: Duration(seconds: 10),
    // sendTimeout: Duration(seconds: 10),
    // receiveTimeout: Duration(seconds: 10),
    // headers: {
    //   "Accept": "application/json", //
    //   "Content-Type": "application/json",
    // },
    headers: {
      "Accept": "application/json", //
      "Content-Type": "application/json",
      // * កំណត់ Authorization token ក្នុង debug mode
      "Authorization": kDebugMode ? "Bearer 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567" : "",
    },
  ),
);

// * ទទួលបាន Dio instance សម្រាប់ប្រើប្រាស់
Dio get dio {
  // * បិទ CORS warning នៅលើ web
  if (kIsWeb) (dio_.httpClientAdapter as dynamic).enableCORSWarning = false;
  return dio_;
}
