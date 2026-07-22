import 'package:dio/dio.dart';
import 'package:speanmeas/utility/dio.dart';

class Nationality {
  List<Map<String, dynamic>> data = [];

  Nationality() {
    init();
  }

  Future<void> init() async {
    try {
      //
      final r = await dio.post("/nationality/read_all", data: FormData.fromMap({}));

      //
      data = List<Map<String, dynamic>>.from(r.data);
      print(data);

      //
    } catch (e) {
      print(e.toString());
    }
  }
}

Nationality nationality = Nationality();

// List<Map<String, dynamic>> data = [];

// Future<void> init() async {
//   try {
//     //
//     final r = await dio.post("/nationality/read_all", data: FormData.fromMap({}));

//     //
//     data = List<Map<String, dynamic>>.from(r.data);

//     //
//   } catch (e) {
//     print(e.toString());
//   }
// }
