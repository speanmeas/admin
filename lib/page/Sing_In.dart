import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Sign_In(),
    ),
  );
}

class Sign_In extends StatelessWidget {
  const Sign_In({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Sign_In_(),
    );
  }
}

class Sign_In_ extends StatefulWidget {
  const Sign_In_({super.key});

  @override
  State<Sign_In_> createState() => _Sign_In_State();
}

class _Sign_In_State extends State<Sign_In_> {
  bool is_password_visible = false;

  final controller_username = TextEditingController();
  final controller_password = TextEditingController();

  String VERSION = '0.0.0+0';

  @override
  void initState() {
    super.initState();

    read_version();
    read_access_token();
  }

  void read_version() async {
    final info = await PackageInfo.fromPlatform();
    VERSION = '${info.version}+${info.buildNumber}';
    setState(() {});
  }

  void read_access_token() async {
    await secure_storage
        .read(key: 'access_token') //
        .then((access_token) {
          if (access_token != null) {
            dio.options.headers['Authorization'] = 'Bearer $access_token';
            setState(() {});
            // print("Access token found: $access_token");
            // try using access token to get user info
            try_access_token(access_token);
          } else {
            print("No access token found.");
          }
        })
        .catchError((e) {});
  }

  void try_access_token(String access_token) async {
    await dio
        .post(
          "/auth/check", //
          data: FormData.fromMap({"access_token": access_token}),
        )
        .then((r) async {
          print(r.data);

          if (r.data["username"] != null) {
            global.username = r.data["username"];
          }

          if (r.data["is_admin"].isNotEmpty && r.data["is_admin"] == "1") {
            global.is_admin = true;
          }

          if (r.data["is_manager"].isNotEmpty && r.data["is_manager"] == "1") {
            global.is_manager = true;
          }

          if (r.data["is_receptionist"].isNotEmpty && r.data["is_receptionist"] == "1") {
            global.is_receptionist = true;
          }

          if (r.data["is_housekeeper"].isNotEmpty && r.data["is_housekeeper"] == "1") {
            global.is_housekeeper = true;
          }

          global.notifyListeners();

          Navigator.pushReplacement(
            context, //
            MaterialPageRoute(
              builder: (context) {
                return Layout_(); //
              },
            ),
          );
        })
        .catchError((e) {
          print("Access token is invalid.");
          secure_storage.delete(key: "access_token");
        });
  }

  Global global = Global();
  double screen_height = 0;

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    global = context.read<Global>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),

              Container(height: 160, child: Image.asset('asset/logo.png')),

              SizedBox(height: 8),

              Text(
                'Welcome to Spean Meas Hotel', //
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              Text(
                VERSION,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ), //

              SizedBox(height: 8),

              Container(
                width: 500,
                child: TextField(
                  controller: controller_username,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Username', //
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                  ),
                  onSubmitted: (_) => signin_press(),
                ),
              ),

              SizedBox(height: 8),

              Container(
                width: 500,
                child: TextField(
                  controller: controller_password,
                  decoration: InputDecoration(
                    labelText: 'Password', //
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: InkWell(
                      child: Icon(!is_password_visible ? Icons.visibility : Icons.visibility_off),
                      onTap: password_visibility_toggle, //
                    ),
                  ),
                  obscureText: !is_password_visible,
                  onSubmitted: (_) => signin_press(),
                ),
              ),

              SizedBox(height: 8),

              OutlinedButton.icon(
                icon: Icon(Icons.login), //
                label: Text('Signin'),
                onPressed: signin_press,
              ),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  void password_visibility_toggle() {
    setState(() {
      is_password_visible = !is_password_visible;
    });
  }

  void signin_press() async {
    await dio
        .post(
          "/auth/sign_in",
          data: FormData.fromMap({
            "username": controller_username.text, //
            "password": controller_password.text,
          }),
        )
        .then((r) async {
          print("Login successful");

          print("Response: ${r.data}");

          snackbar_show(context: context, message: "Login successful", color: Colors.green);

          await secure_storage.write(key: "access_token", value: r.data["access_token"]);

          if (r.data["username"] != null) {
            global.username = r.data["username"];
          }

          if (r.data["is_admin"].isNotEmpty && r.data["is_admin"] == "1") {
            global.is_admin = true;
          }

          if (r.data["is_manager"].isNotEmpty && r.data["is_manager"] == "1") {
            global.is_manager = true;
          }

          if (r.data["is_receptionist"].isNotEmpty && r.data["is_receptionist"] == "1") {
            global.is_receptionist = true;
          }

          if (r.data["is_housekeeper"].isNotEmpty && r.data["is_housekeeper"] == "1") {
            global.is_housekeeper = true;
          }

          global.notifyListeners();

          Navigator.pushReplacement(
            context, //
            MaterialPageRoute(
              builder: (context) {
                return Layout_(); //
              },
            ),
          );
        })
        .catchError((e) {
          snackbar_show(context: context, message: "Login failed", color: Colors.red);
        });

    // final access_token = await secure_storage.read(key: "access_token");
    // print("Access token: $access_token");
  }
}
