import "dart:convert";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:dio/dio.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";

import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/utility/secure_storage.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/layout/layout.dart" as layout;

import "schema.w.dart" as user;

class _Main_State extends State<Main_> {
  bool is_password_visible = false;

  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    String VERSION = context.watch<Global>().VERSION;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 160, //
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Image.asset("asset/logo.png"),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Text(
                  "Welcome to Spean Meas Hotel", //
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                alignment: Alignment.center,
                child: Text(
                  VERSION,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                ), //
              ), //

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Username:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) => username = v,
                  onSubmitted: (_) => on_sign_in(),
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  // controller: controller_password,
                  decoration: InputDecoration(
                    labelText: "Password:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: InkWell(
                      child: Icon(!is_password_visible ? Icons.visibility : Icons.visibility_off),
                      onTap: password_visibility_toggle, //
                    ),
                  ),
                  obscureText: !is_password_visible,
                  onChanged: (v) => password = v,
                  onSubmitted: (_) => on_sign_in(),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.login), //
                  label: Text("Signin"),
                  onPressed: on_sign_in,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_sign_in() async {
    try {
      //

      //
      final r = await dio.post("/auth/sign_in", data: FormData.fromMap({"username": username, "password": password}));

      //
      await secure_storage.write(key: "access_token", value: r.data["access_token"]);
      dio.options.headers["Authorization"] = "Bearer ${r.data["access_token"]}";

      //
      for (var e in user.data.entries) user.data[e.key]!["value"] = r.data[e.key];

      //
      snackbar_show(context: context, message: "Sign in successful", color: Colors.green);

      //
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Layout_()));

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void password_visibility_toggle() {
    is_password_visible = !is_password_visible;
    setState(() {});
  }
}

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
      home: const Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}
