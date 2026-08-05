import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:dio/dio.dart";
import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/dio.dart";

void main() async {
  print("Testing Dio...");

  print(API_HOST);

  await dio
      .post(
        "/template/read",
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
