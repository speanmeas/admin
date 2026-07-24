import 'package:dio/dio.dart';

void main() {
  connect();
}

void connect() async {
  final dio = Dio();

  final r = await dio.get(
    "http://localhost:8000/events", //
    options: Options(responseType: ResponseType.stream),
  );

  final s = r.data as ResponseBody;

  s.stream.listen((data) {
    print(String.fromCharCodes(data));
  });
}
