import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:speanmeas/Environment.dart";

Dio dio = Dio(
  BaseOptions(
    baseUrl: API_HOST, //
    // connectTimeout: Duration(seconds: 10), //
    // sendTimeout: Duration(seconds: 10), //
    // receiveTimeout: Duration(seconds: 10), //
  ),
);
