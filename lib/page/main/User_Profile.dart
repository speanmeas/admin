import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Sign_In.dart' as sign_in;
import 'Update_Full_Name.dart' as update_full_name;
import 'Update_Phone_Number.dart' as update_phone_number;
import 'Update_Username.dart' as update_username;
import 'Update_Password.dart' as update_password;

import 'package:speanmeas/layout/Layout.dart' as layout;

void main() {
  runApp(User_Profile());
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
  String full_name = "";
  String phone_number = "";
  String username = "";

  bool is_admin = false;
  bool is_manager = false;
  bool is_receptionist = false;
  bool is_housekeeper = false;

  bool is_password_visible = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    is_admin = await secure_storage.read(key: "is_admin") == "true";
    is_manager = await secure_storage.read(key: "is_manager") == "true";
    is_receptionist = await secure_storage.read(key: "is_receptionist") == "true";
    is_housekeeper = await secure_storage.read(key: "is_housekeeper") == "true";

    full_name = await secure_storage.read(key: "full_name") ?? "";
    phone_number = await secure_storage.read(key: "phone_number") ?? "";

    username = await secure_storage.read(key: "username") ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              //

              // Position
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Position: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                    (() {
                      var style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue);

                      if (is_admin) return Text("Administrator", style: style);
                      if (is_manager) return Text("Manager", style: style);
                      if (is_receptionist) return Text("Receptionist", style: style);
                      if (is_housekeeper) return Text("Housekeeper", style: style);

                      return const SizedBox.shrink();
                    })(),
                  ],
                ),
              ),

              // textfield full name
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: full_name),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Full Name :", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, //
                            MaterialPageRoute(builder: (_) => update_full_name.Main_(full_name: full_name)),
                          ).then((value) {
                            if (value == null) return;
                            full_name = value;
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
              ),

              // textfield phone
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: phone_number),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Phone Number :", //
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, //
                            MaterialPageRoute(builder: (_) => update_phone_number.Main_(phone_number: phone_number)),
                          ).then((value) {
                            if (value == null) return;
                            phone_number = value;
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
              ),

              // textfield username
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: username),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Username :", //
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, //
                            MaterialPageRoute(builder: (_) => update_username.Main_(username: username)),
                          ).then((value) {
                            if (value == null) return;
                            username = value;
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
              ),

              // textfield password
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: "**********"),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Password :", //
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, //
                            MaterialPageRoute(builder: (_) => update_password.Main_()),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8),

              OutlinedButton.icon(
                icon: Icon(Icons.logout), //
                label: Text('Sign Out'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: on_sign_out,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_sign_out() async {
    dio.options.headers.remove('Authorization');

    await secure_storage.delete(key: 'id');
    await secure_storage.delete(key: 'access_token');
    await secure_storage.delete(key: 'full_name');
    await secure_storage.delete(key: 'phone_number');
    await secure_storage.delete(key: 'username');
    await secure_storage.delete(key: 'is_admin');
    await secure_storage.delete(key: 'is_manager');
    await secure_storage.delete(key: 'is_receptionist');
    await secure_storage.delete(key: 'is_housekeeper');

    snackbar_show(context: context, message: "Signed out successfully", color: Colors.green);

    Navigator.pop(context);
    Navigator.pop(context);

    // navigate to sign in page
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => const sign_in.Main_()),
    );
  }
}
