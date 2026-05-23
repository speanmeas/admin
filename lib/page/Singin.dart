import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      child: const Signin(),
    ),
  );
}

class Signin extends StatelessWidget {
  const Signin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Signin_(),
    );
  }
}

class Signin_ extends StatefulWidget {
  const Signin_({super.key});

  @override
  State<Signin_> createState() => _Signin_State();
}

class _Signin_State extends State<Signin_> {
  bool is_password_visible = false;

  final controller_username = TextEditingController();
  final controller_password = TextEditingController();

  @override
  void dispose() {
    controller_password.dispose();
    controller_username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

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
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Container(
                width: 500,
                child: TextField(
                  controller: controller_username,
                  decoration: InputDecoration(
                    labelText: 'Username', //
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                  ),
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
                      onTap: () {
                        setState(() {
                          is_password_visible = !is_password_visible;
                        });
                      },
                    ),
                  ),
                  obscureText: !is_password_visible,
                ),
              ),

              SizedBox(height: 8),

              OutlinedButton.icon(
                icon: Icon(Icons.login), //
                label: Text('Signin'),
                onPressed: () async {
                  print("Signin");
                  print("Username: ${controller_username.text}");
                  print("Password: ${controller_password.text}");

                  await dio
                      .post(
                        "/auth/signin",
                        data: FormData.fromMap({
                          "username": controller_username.text, //
                          "password": controller_password.text,
                        }),
                      )
                      .then((r) async {
                        print("Login successful");
                        print("Response: ${r.data}");
                        snackbar_show(context: context, message: "Login successful", color: Colors.green);

                        await secure_storage.write(key: "username", value: controller_username.text);
                        await secure_storage.write(key: "access_token", value: r.data["access_token"]);

                        Navigator.pushReplacement(
                          context, //
                          MaterialPageRoute(
                            builder: (context) {
                              return Layout_Dashboard_(); //
                            },
                          ),
                        );
                      })
                      .catchError((e) {
                        // print("Login failed");
                        // print("Error: ${error.toString()}");
                        snackbar_show(context: context, message: "Login failed", color: Colors.red);
                      });

                  // final access_token = await secure_storage.read(key: "access_token");
                  // print("Access token: $access_token");
                },
              ),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }
}
