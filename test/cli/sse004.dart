// import 'dart:convert';
// import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
// import 'package:flutter_client_sse/flutter_client_sse.dart';
// import 'package:dio/dio.dart';

// void main() {
//   connect();
// }

// void connect() {
//   SSEClient.subscribeToSSE(
//     method: SSERequestType.POST, //
//     url: 'http://localhost:8000/events',
//     header: {},
//     body: {},
//   ).listen((event) {
//     print('Id: ' + event.id!);
//     print('Event: ' + event.event!);
//     print('Data: ' + event.data!);
//   });
// }
