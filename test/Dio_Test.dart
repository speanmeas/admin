import "package:dio/dio.dart";
import "package:speanmeas/environment.dart";
import "package:speanmeas/utility/dio.dart";

void main() async {
  print("Testing Dio...");

  print(API_HOST);

  await dio
      .post(
        "/template/data_read",
        data: FormData.fromMap({
          //
        }),
      )
      .then((r) {
        print(r.data);
      })
      .catchError((error) {});
}
