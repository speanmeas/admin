import "package:speanmeas/Environment.dart";
import "package:speanmeas/utility/Dio.dart";

void main() async {
  print("Testing Dio...");

  print(API_HOST);

  await dio
      .post(
        "/template/data_read",
        data: form_data({
          //
        }),
      )
      .then((r) {
        print(r.data);
      })
      .catchError((error) {});
}
