import 'package:dio/dio.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() async {
  print('Testing Dio...');

  print(API_HOST);

  await dio
      .post(
        '/template/data_read',
        data: FormData.fromMap({
          //
        }),
      )
      .then((r) {
        print(r.data);
      })
      .catchError((error) {});
}
