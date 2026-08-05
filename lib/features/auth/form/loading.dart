import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure_storage.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart" as sb; // ignore: unused_import
import "package:speanmeas/core/theme/theme_light.dart" as theme; // ignore: unused_import
import "package:speanmeas/core/layout/layout.dart" as layout;

import "sign_in.dart" as form_si;
import "../schema.g.dart" as sm;

class _Main_State extends State<Main_> {
  //
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
      if (await ss.read(key: "access_token") == null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => form_si.Main_()));
      if (await ss.read(key: "access_token") == null) throw Exception("Access Token Not Found");

      //
      tmp = await dio.post(
        ep.AUTH_ACCESS_TOKEN, //
        data: {"access_token": await ss.read(key: "access_token")},
      );
      if (tmp == null) throw Exception("Invalid Access Token");
      for (var e in sm.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      dio.options.headers["Authorization"] = "Bearer ${await ss.read(key: "access_token")}";

      //
      sb.view(context: context, message: "Success", color: Colors.green);

      //
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Main_()));

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: "Failed", color: Colors.red);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => form_si.Main_()));
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
