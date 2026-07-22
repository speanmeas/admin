import "package:dio/dio.dart";
import "package:speanmeas/__config__.dart";
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
      .catchError((e) {
        print(e.toString());
      });
}
