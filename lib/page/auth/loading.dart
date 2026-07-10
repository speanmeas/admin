import "dart:convert";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:dio/dio.dart";

import "package:speanmeas/environment.dart";
import "package:speanmeas/global.dart";

import "package:speanmeas/layout/layout.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/utility/secure_storage.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/page/auth/user.g.dart" as user;
import "package:speanmeas/page/auth/sign_in.dart" as sign_in;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Loading_(),
    );
  }
}

class Loading_ extends StatefulWidget {
  const Loading_({super.key});

  @override
  State<Loading_> createState() => _Loading_State();
}

class _Loading_State extends State<Loading_> {
  @override
  void initState() {
    super.initState();
    try_access_token();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Colors.blue, //
          strokeWidth: 4,
        ),
      ),
    );
  }

  void try_access_token() async {
    String? access_token = await secure_storage.read(key: "access_token");
    // print(access_token);

    if (access_token == null) {
      Navigator.pushReplacement(
        context, //
        MaterialPageRoute(builder: (context) => sign_in.Main_()),
      );
      return;
    }

    dio.options.headers["Authorization"] = "Bearer $access_token";

    await dio
        .post(
          "/user/data_read", //
          data: FormData.fromMap({
            "key": user.USER_ACCESS_TOKEN, //
            "query": access_token, //
          }),
        )
        .then((r) async {
          //

          // print(r.data);

          for (var e in user.data.entries) user.data[e.key]!["value"] = r.data[0][e.key];

          // print(user.data);

          snackbar_show(context: context, message: "Login successful", color: Colors.green);

          Navigator.pushReplacement(
            context, //
            MaterialPageRoute(builder: (context) => Layout_()),
          );
        })
        .catchError((e) async {
          await secure_storage.delete(key: "access_token");
          Navigator.pushReplacement(
            context, //
            MaterialPageRoute(builder: (context) => sign_in.Main_()),
          );
        });
  }
}
