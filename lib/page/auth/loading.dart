///
///
///
///

import "dart:convert";

import "package:flutter/material.dart";
import "package:dio/dio.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";

import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/utility/secure_storage.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/layout/layout.dart" as layout;

import "sign_in.dart" as sign_in;
import "schema.g.dart" as schema;

class _Main_State extends State<Main_> {
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => sign_in.Main_()));
        return;
      }

      //
      final r = await dio.post("/auth/access_token", data: FormData.fromMap({"access_token": access_token}));

      //
      for (var e in schema.data.entries) schema.data[e.key]!["value"] = r.data[e.key];

      //
      dio.options.headers["Authorization"] = "Bearer $access_token";

      //
      snackbar_show(context: context, message: "Login successful", color: Colors.green);

      //
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Main_()));

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
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
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
