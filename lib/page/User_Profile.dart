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
  String? access_token;

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

  bool confirm_full_name = false;
  bool confirm_phone_number = false;
  bool confirm_email = false;

  bool confirm_username = false;
  bool confirm_password = false;

  @override
  void initState() {
    super.initState();

    read_access_token();
    get_user_info();
  }

  void read_access_token() async {
    await secure_storage
        .read(key: 'access_token') //
        .then((r) {
          if (r != null) {
            access_token = r;
            dio.options.headers['Authorization'] = 'Bearer $access_token';
            setState(() {});
          } else {}
        })
        .catchError((e) {});
  }

  dynamic data;

  // todo: get user info
  void get_user_info() async {
    //
    await dio
        .post(
          '/auth/data_read', //
          data: FormData.fromMap({}),
        ) //
        .then((r) {
          print("User info: ${r.data}");
          data = r.data;

          // print("User info: $data");

          controller_full_name.text = data['full_name'] ?? "";
          controller_phone_number.text = data['phone'] ?? "";
          controller_email.text = data['email'] ?? "";

          controller_username.text = data['username'] ?? "";
          // controller_password.text = "**********"; // do not show real password

          setState(() {});
        })
        .catchError((e) {
          print("Failed to get user info: $e");
        });
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

              // * profile picture with upload button
              // Stack(
              //   children: [
              //     CircleAvatar(
              //       radius: 80, //
              //       backgroundColor: Colors.grey.shade200,
              //       // backgroundImage: NetworkImage(""), // todo:
              //     ),
              //     Positioned(
              //       bottom: 0,
              //       right: 0,
              //       child: IconButton(
              //         icon: Icon(Icons.camera_alt_outlined),
              //         onPressed: () {
              //           print("Change profile picture");
              //         },
              //       ),
              //     ),
              //   ],
              // ),

              // Position
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Position: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                    if (Global.variable.is_admin)
                      Text(
                        "Administrator", //
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    if (Global.variable.is_manager)
                      Text(
                        "Manager", //
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    if (Global.variable.is_receptionist)
                      Text(
                        "Receptionist", //
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    if (Global.variable.is_housekeeper)
                      Text(
                        "Housekeeper", //
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                  ],
                ),
              ),

              // textfield full name
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_full_name,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    suffixIcon: confirm_full_name
                        ? IconButton(
                            onPressed: () {
                              print("Edit full name");
                            },
                            icon: Icon(Icons.check, color: Colors.blue),
                          )
                        : null,

                    labelText: "Full Name", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  // initial value
                  onChanged: (value) {
                    confirm_full_name = value != "";
                    setState(() {});
                  },
                ),
              ),

              // textfield phone
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_phone_number,
                  readOnly: true,

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Colors.grey),
                    suffixIcon: confirm_phone_number
                        ? IconButton(
                            onPressed: () {
                              print("Edit phone number");
                            },
                            icon: Icon(Icons.check, color: Colors.blue),
                          )
                        : null,
                    labelText: "Phone Number", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    confirm_phone_number = value != "";
                    setState(() {});
                  },
                ),
              ),

              // textfield email
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_email,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    suffixIcon: confirm_email
                        ? IconButton(
                            onPressed: () {
                              print("Edit email");
                            },
                            icon: Icon(Icons.check, color: Colors.blue),
                          )
                        : null,
                    labelText: "Email", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    confirm_email = value != "";
                    setState(() {});
                  },
                ),
              ),

              // textfield username
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_username,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    suffixIcon: confirm_username
                        ? IconButton(
                            onPressed: () async {
                              final new_username = controller_username.text;

                              print(new_username);

                              await dio
                                  .post(
                                    "/auth/update",
                                    data: FormData.fromMap({
                                      "new_username": new_username, //
                                    }),
                                  )
                                  .then((r) {
                                    print("Username updated: ${r.data}");
                                    snackbar_show(
                                      context: context, //
                                      message: "Username updated successfully",
                                      color: Colors.green,
                                    );
                                    setState(() {
                                      confirm_username = false;
                                    });
                                  })
                                  .catchError((e) {
                                    print("Failed to update username: $e");
                                    snackbar_show(
                                      context: context, //
                                      message: "Failed to update username",
                                      color: Colors.red,
                                    );
                                  });
                            },
                            icon: Icon(Icons.check, color: Colors.blue),
                          )
                        : null,
                    labelText: "Username", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    confirm_username = value != "";
                    setState(() {});
                  },
                ),
              ),

              // textfield password
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_password,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    hintText: "Enter New Password",
                    suffixIcon: confirm_password
                        ? IconButton(
                            onPressed: () async {
                              final new_password = controller_password.text;

                              print(new_password);

                              await dio
                                  .post(
                                    "/auth/update",
                                    data: FormData.fromMap({
                                      "new_password": new_password, //
                                    }),
                                  )
                                  .then((r) {
                                    print("Password updated: ${r.data}");
                                    snackbar_show(context: context, message: "Password updated successfully", color: Colors.green);
                                    setState(() {
                                      confirm_password = false;
                                      controller_password.text = "";
                                    });
                                  })
                                  .catchError((e) {
                                    print("Failed to update password: $e");
                                    snackbar_show(context: context, message: "Failed to update password", color: Colors.red);
                                  });
                            },
                            icon: Icon(Icons.check, color: Colors.blue),
                          )
                        : null,
                    labelText: "Password", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    confirm_password = value != "";
                    setState(() {});
                  },
                ),
              ),

              SizedBox(height: 8),

              OutlinedButton.icon(
                icon: Icon(Icons.logout), //
                label: Text('Sign Out'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: sign_out_press,
              ),
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

    Global.variable.clear();

    Navigator.pop(context);
    Navigator.pop(context);

    // navigate to sign in page
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => const Sign_In_()),
    );
  }
}
