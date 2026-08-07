import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/utility/secure_storage.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/layout/layout.dart" as layout;

import "schema.g.dart" as u_schema;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_password_visible = false;

  final c_username = TextEditingController();
  final c_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final VERSION = context.watch<Global>().VERSION;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 160, //
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Image.asset("assets/logo.png"),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Text(
                  "Spean Meas Hotel", //
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
                  controller: c_username,
                  decoration: InputDecoration(
                    labelText: "Username:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) => setState(() {}),
                  onSubmitted: (_) => on_sign_in(),
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: c_password,
                  decoration: InputDecoration(
                    labelText: "Password:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: InkWell(
                      onTap: password_visibility_toggle,
                      child: Icon(!is_password_visible ? Icons.visibility_outlined : Icons.visibility_off_outlined), //
                    ),
                  ),
                  obscureText: !is_password_visible,
                  onChanged: (v) => setState(() {}),
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

              SizedBox(height: height - 100),
            ],
          ),
        ),
      ),
    );
  }

  void on_sign_in() async {
    try {
      //
      tmp = await dio.post(
        ep.AUTH_SIGN_IN, //
        data: {"username": c_username.text, "password": c_password.text},
      );
      if (tmp == null) throw Exception("Invalid Username or Password");

      //
      await secure_storage.write(key: "access_token", value: tmp.data["access_token"]);
      await secure_storage.write(key: "_id", value: tmp.data["_id"]);
      dio.options.headers["Authorization"] = "Bearer ${tmp.data["access_token"]}";

      //
      for (var e in u_schema.data.entries) u_schema.data[e.key]!["value"] = tmp.data[e.key];

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
      await glob.init();

      //
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Main_()));

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void password_visibility_toggle() {
    is_password_visible = !is_password_visible;
    setState(() {});
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
