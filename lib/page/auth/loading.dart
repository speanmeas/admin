import "dart:convert";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:dio/dio.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";

import "package:speanmeas/layout/layout.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/utility/secure_storage.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "sign_in.dart" as sign_in;
import "schema.w.dart" as schema_w;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => global, //
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
      for (var e in schema_w.data.entries) schema_w.data[e.key]!["value"] = r.data[e.key];

      //
      dio.options.headers["Authorization"] = "Bearer $access_token";

      //
      snackbar_show(context: context, message: "Login successful", color: Colors.green);

      //
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Layout_()));

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }
}
