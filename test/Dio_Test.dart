import 'package:dio/dio.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() async {
  print('Testing Dio...');

  print(API_HOST);

  await dio
      .post(
        '/template/create',
        data: FormData.fromMap({
          "aaa": "aaa", //
          "bbb": "bbb", //
        }),
      )
      .then((response) {
        print("Ok!");
      })
      .catchError((error) {
        print("Error!");
      });
  // try {
  //   final response = await dio.get('/api/v1/hello');
  //   print(response.data);
  // } catch (e) {
  //   print('Error: $e');
  // }
}
