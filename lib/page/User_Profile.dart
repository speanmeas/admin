import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/Sing_In.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const User_Profile(),
    ),
  );
}

class User_Profile extends StatelessWidget {
  const User_Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const User_Profile_(),
    );
  }
}

class User_Profile_ extends StatefulWidget {
  const User_Profile_({super.key});

  @override
  State<User_Profile_> createState() => _User_Profile_State();
}

class _User_Profile_State extends State<User_Profile_> {
  bool is_password_visible = false;

  String? full_name = "Under development...";
  String? phone_number = "Under development...";
  String? email = "Under development...";
  String? username = "Under development...";
  String? password = "Under development...";

  final controller_full_name = TextEditingController();
  final controller_phone_number = TextEditingController();
  final controller_email = TextEditingController();
  final controller_username = TextEditingController();
  final controller_password = TextEditingController();

  @override
  void initState() {
    super.initState();

    // controller_full_name.text = full_name ?? "";
    // controller_phone_number.text = phone_number ?? "";
    // controller_email.text = email ?? "";
    // controller_username.text = username ?? "";
    // controller_password.text = password ?? "";

    read_access_token();
  }

  void read_access_token() async {
    await secure_storage
        .read(key: 'access_token') //
        .then((access_token) {
          if (access_token != null) {
            dio.options.headers['Authorization'] = 'Bearer $access_token';
            setState(() {});
            print("Access token found: $access_token");

            // try using access token to get user info
          } else {
            print("No access token found.");
          }
        })
        .catchError((e) {});
  }

  // todo: get user info
  void get_user_info() async {}

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
          ),
          SizedBox(width: 8),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              SizedBox(height: 16),

              //
              Stack(
                children: [
                  CircleAvatar(
                    radius: 80, //
                    backgroundColor: Colors.grey.shade200,
                    // backgroundImage: NetworkImage(""), // todo:
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                        onPressed: () {
                          print("Change profile picture");
                        },
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // textfield full name
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: controller_full_name..text = full_name ?? "",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        print("Edit full name");
                      },
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    labelText: "Full Name", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  // initial value
                ),
              ),

              // textfield phone
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: controller_phone_number..text = phone_number ?? "",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        print("Edit phone number");
                      },
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    labelText: "Phone Number", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // textfield email
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: controller_email..text = email ?? "",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        print("Edit email");
                      },
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    labelText: "Email", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // textfield username
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: controller_username..text = username ?? "",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        print("Edit username");
                      },
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    labelText: "Username", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // textfield password
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: controller_password..text = password ?? "",
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        print("Edit password");
                      },
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    labelText: "Password", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              SizedBox(height: 8),

              OutlinedButton.icon(
                icon: Icon(Icons.logout), //
                label: Text('Sign Out'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: sign_out_press,
              ),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  void sign_out_press() async {
    print("Sign out");

    // remove access token from secure storage and dio header
    await secure_storage.delete(key: 'access_token');
    dio.options.headers.remove('Authorization');
    snackbar_show(context: context, message: "Signed out successfully", color: Colors.green);

    // navigate to sign in page
    Navigator.pushReplacement(
      context, //
      MaterialPageRoute(builder: (_) => const Sign_In_()),
    );
  }
}
