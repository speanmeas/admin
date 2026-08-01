import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:dio/dio.dart";

import "package:speanmeas/core/global.dart";

import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/utility/secure_storage.dart";
import "package:speanmeas/core/widget/snackbar_show.dart";
import "package:speanmeas/core/layout/layout.dart" as layout;

import "schema.g.dart" as u_schema;

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
      for (var e in u_schema.data.entries) u_schema.data[e.key]!["value"] = r.data[e.key];

      //
      snackbar_show(context: context, message: "Success Sign-In", color: Colors.green);

      //
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Main_()));

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
