// * នាំចូល Dio សម្រាប់ HTTP requests និង Flutter foundation
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure.dart"; // ignore: unused_import

// * ការកំណត់ Dio client ជាមួយ base URL និង headers
Dio _dio = Dio(
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

// * ទទួលបាន Dio instance
Dio get __dio {
  // * បិទ CORS warning នៅលើ web
  if (kIsWeb) (_dio.httpClientAdapter as dynamic).enableCORSWarning = false;
  return _dio;
}

// * ចាប់កំហុស DioException ដើម្បីកុំឲ្យកម្មវិធី crash
class DioUtil {
  // * singleton instance
  static final DioUtil instance = DioUtil._();
  DioUtil._();

  // * កំណត់ Authorization token
  void set_token(String? token) {
    __dio.options.headers["Authorization"] = token == null ? "" : "Bearer $token";
  }

  // * លុប Authorization token
  void clear_token() {
    __dio.options.headers["Authorization"] = "";
  }

  // * ផ្ញើ POST request
  Future<Response<dynamic>?> post(String path, {dynamic data}) async {
    try {
      return await __dio.post(path, data: data);
    } catch (e) {
      return null;
    }
  }
}

// * instance សកលរបស់ DioUtil
DioUtil dio = DioUtil.instance;
