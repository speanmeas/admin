import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:speanmeas/core/config.dart";

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
  ),
);

Dio get dio {
  if (kIsWeb) (dio_.httpClientAdapter as dynamic).enableCORSWarning = false;
  return dio_;
}
