import "dart:convert";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:dio/dio.dart";

import "package:speanmeas/environment.dart";
import "package:speanmeas/global.dart";

import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/utility/secure_storage.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/layout/layout.dart" as layout;
import "package:speanmeas/page/auth/user.g.dart" as user;

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
      home: const Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  bool is_password_visible = false;

  final controller_username = TextEditingController();
  final controller_password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
                  controller: controller_username,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Username:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onSubmitted: (_) => on_sign_in(),
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_password,
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
    String username = controller_username.text;
    String password = controller_password.text;

    await dio
        .post(
          "/auth/sign_in",
          data: FormData.fromMap({
            "username": username, //
            "password": password,
          }),
        )
        .then((r) async {
          //
          // print(r.data);

          await secure_storage.write(key: "access_token", value: r.data[0][user.USER_ACCESS_TOKEN]);
          dio.options.headers["Authorization"] = "Bearer ${r.data[0][user.USER_ACCESS_TOKEN]}";

          for (var e in user.data.entries) user.data[e.key]!["value"] = r.data[0][e.key];
          // for (var e in user.data.entries) print(e);

          snackbar_show(context: context, message: "Sign in successful", color: Colors.green);

          Navigator.pushReplacement(
            context, //
            MaterialPageRoute(builder: (context) => layout.Layout_()),
          );
        })
        .catchError((e) async {
          snackbar_show(context: context, message: "Sign in failed", color: Colors.red);
        });
  }

  void password_visibility_toggle() {
    is_password_visible = !is_password_visible;
    setState(() {});
  }
}
