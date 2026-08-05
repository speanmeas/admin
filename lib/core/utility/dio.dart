import "package:dio/dio.dart";
import "package:speanmeas/core/__config__.dart";

Dio dio = Dio(
  BaseOptions(
    baseUrl: API_HOST, //
    // connectTimeout: Duration(seconds: 10), //
    // sendTimeout: Duration(seconds: 10), //
    // receiveTimeout: Duration(seconds: 10), //
  ),
);
