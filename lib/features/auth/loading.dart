import "package:flutter/material.dart";
import "package:speanmeas/core/global.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure_storage.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/layout/layout.dart" as layout;
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/widget/snackbar.dart";

import "sign_in.dart" as form_si;

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
      final ac_tk = await secure_storage.read(key: "access_token");

      if (ac_tk == null)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => form_si.Main_(), //
          ),
        );
      if (ac_tk == null) return;

      //
      tmp = await dio.post(
        endpoint.AUTH_ACCESS_TOKEN, //
        data: {"access_token": ac_tk},
      );
      if (tmp == null) throw Exception("Invalid Access Token");
      for (var e in sm_user.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      dio.options.headers["Authorization"] = "Bearer ${await secure_storage.read(key: "access_token")}";

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
      await glob.init();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Main_()));
    } catch (e, st) {
      print(st);
      await secure_storage.delete(key: "access_token");
      await secure_storage.delete(key: "_id");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => form_si.Main_(), //
        ),
      );
    }
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
