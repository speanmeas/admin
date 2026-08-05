import "package:flutter/material.dart";
import "package:dio/dio.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/utility/secure_storage.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as sb;
import "package:speanmeas/core/layout/layout.dart" as layout;

import "sign_in.dart" as form_si;
import "../schema.g.dart" as sm;

class _Main_State extends State<Main_> {
  dynamic tmp;
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
    try {
      //

      //
      String? access_token = await secure_storage.read(key: "access_token");

      //
      if (access_token == null) {
        Navigator.pushReplacement(
          context, //
          MaterialPageRoute(builder: (context) => form_si.Main_()),
        );
        return;
      }

      //
      final r = await dio.post(
        ep.AUTH_ACCESS_TOKEN, //
        data: {
          "access_token": access_token, //
        },
      );

      //
      for (var e in sm.data.entries) sm.data[e.key]!["value"] = r.data[e.key];

      //
      dio.options.headers["Authorization"] = "Bearer $access_token";

      //
      sb.view(context: context, message: "Success Sign-In", color: Colors.green);

      //
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Main_()));

      //
    } catch (e) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => form_si.Main_()));
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
