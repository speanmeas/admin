import 'package:dio/dio.dart';

void main() {
  connect();
}

Future<void> connect() async {
  final dio = Dio();

  while (true) {
    try {
      final r = await dio.post(
        "http://localhost:8000/sse/event", //
        options: Options(responseType: ResponseType.stream),
        data: {},
      );

      final s = r.data as ResponseBody;

      await for (final data in s.stream) {
        print(String.fromCharCodes(data));
      }
    } catch (_) {
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
