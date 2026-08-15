// * នាំចូល Dio សម្រាប់ HTTP requests និង Flutter foundation
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure.dart"; // ignore: unused_import

// * ការកំណត់ Dio client ជាមួយ base URL និង headers
Dio tmpe = Dio(
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
Dio get dio_ {
  // * បិទ CORS warning នៅលើ web
  if (kIsWeb) (tmpe.httpClientAdapter as dynamic).enableCORSWarning = false;
  return tmpe;
}

// * ថ្នាក់ DioUtil គ្រប់គ្រង HTTP requests ដោយសុវត្ថិភាព
// * ចាប់កំហុស DioException ដើម្បីកុំឲ្យកម្មវិធី crash
class DioUtil {
  // * singleton instance
  static final DioUtil instance = DioUtil._();
  DioUtil._();

  // * ទទួលបាន Dio instance
  Dio get client => dio_;

  // * កំណត់ Authorization token
  void setToken(String? token) {
    dio_.options.headers["Authorization"] = token == null ? "" : "Bearer $token";
  }

  // * លុប Authorization token
  void clearToken() {
    dio_.options.headers["Authorization"] = "";
  }

  // * លុប Authorization header ចេញទាំងស្រុង
  void delToken() {
    dio_.options.headers.remove("Authorization");
  }

  // * ផ្ញើ GET request
  Future<Response<dynamic>?> get(String path, {Map<String, dynamic>? query, Options? options}) async {
    try {
      return await dio_.get(path, queryParameters: query, options: options);
    } catch (e) {
      _logError("GET", path, e);
      return null;
    }
  }

  // * ផ្ញើ POST request
  Future<Response<dynamic>?> post(String path, {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    try {
      return await dio_.post(path, data: data, queryParameters: query, options: options);
    } catch (e) {
      _logError("POST", path, e);
      return null;
    }
  }

  // * ផ្ញើ PUT request
  Future<Response<dynamic>?> put(String path, {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    try {
      return await dio_.put(path, data: data, queryParameters: query, options: options);
    } catch (e) {
      _logError("PUT", path, e);
      return null;
    }
  }

  // * ផ្ញើ DELETE request
  Future<Response<dynamic>?> delete(String path, {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    try {
      return await dio_.delete(path, data: data, queryParameters: query, options: options);
    } catch (e) {
      _logError("DELETE", path, e);
      return null;
    }
  }

  // * ផ្ញើ PATCH request
  Future<Response<dynamic>?> patch(String path, {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    try {
      return await dio_.patch(path, data: data, queryParameters: query, options: options);
    } catch (e) {
      _logError("PATCH", path, e);
      return null;
    }
  }

  // * ទទួលបាន data ពី response (null បើ request បរាជ័យ)
  Future<dynamic> getData(String path, {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    final res = await post(path, data: data, query: query, options: options);
    return res?.data;
  }

  // * ទទួលបាន data ជា List
  Future<List<dynamic>?> getList(String path, {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    final d = await getData(path, data: data, query: query, options: options);
    return d is List ? d : null;
  }

  // * ទទួលបាន data ជា Map
  Future<Map<String, dynamic>?> getMap(String path, {dynamic data, Map<String, dynamic>? query, Options? options}) async {
    final d = await getData(path, data: data, query: query, options: options);
    return d is Map<String, dynamic> ? d : null;
  }

  // * បោះពុម្ពកំហុស DioException
  void _logError(String method, String path, Object e) {
    if (e is DioException) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      debugPrint("Dio $method $path failed (status: $status): ${e.message}");
      if (body != null) pprint(body, label: "Response body");
    } else {
      debugPrint("Dio $method $path failed: $e");
    }
  }
}

// * instance សកលរបស់ DioUtil
DioUtil dio = DioUtil.instance;
