import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:package_info_plus/package_info_plus.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";

import "package:speanmeas/layout/Layout.dart";
import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/utility/Secure_Storage.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "Sign_In.dart" as sign_in;
import "User.g.dart";

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
            "key": "access_token", //
            "query": access_token, //
          }),
        )
        .then((r) async {
          //
          for (var k in user.keys) user[k] = r.data[0][k];

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
