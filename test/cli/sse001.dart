import 'dart:convert';

import 'package:http/http.dart' as http;

void main() {
  connect();
}

void connect() async {
  final request = http.Request("GET", Uri.parse("http://localhost:8000/events"));

  final response = await request.send();

  response.stream.transform(const Utf8Decoder()).listen((data) {
    print(data);
  });
}
