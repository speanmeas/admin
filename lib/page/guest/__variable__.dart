import 'package:dio/dio.dart';
import 'package:speanmeas/utility/dio.dart';

class Nationality {
  //
  static List<Map<String, dynamic>> data = [];

  //
  static Future<void> init() async {
    try {
      //
      final r = await dio.post("/nationality/read_all", data: FormData.fromMap({}));

      //
      data = List<Map<String, dynamic>>.from(r.data);

      //
    } catch (e) {
      print(e.toString());
    }
  }
}
