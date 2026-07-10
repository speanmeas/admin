import "dart:convert";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/utility/Secure_Storage.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "Sign_In.dart" as sign_in;
import "edit_name.dart" as update_full_name;
import "edit_phone_number.dart" as update_phone_number;
import "edit_username.dart" as update_username;
import "edit_password.dart" as update_password;

import "package:speanmeas/layout/Layout.dart" as layout;

import "user.g.dart" as user;

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
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

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

                      if (user.data[user.IS_ADMIN] == true) return Text("Administrator", style: style);
                      if (user.data[user.IS_MANAGER] == true) return Text("Manager", style: style);
                      if (user.data[user.IS_RECEPTIONIST] == true) return Text("Receptionist", style: style);
                      if (user.data[user.IS_HOUSEKEEPER] == true) return Text("Housekeeper", style: style);

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
                  controller: TextEditingController(text: user.data[user.FULL_NAME] ?? ""),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Name:", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, //
                            MaterialPageRoute(builder: (_) => update_full_name.Main_()),
                          ).then((value) {
                            if (value == null) return;
                            user.data[user.FULL_NAME] = value;
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
                  controller: TextEditingController(text: user.data[user.PHONE_NUMBER] ?? ""),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Phone Number:", //
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, //
                            MaterialPageRoute(builder: (_) => update_phone_number.Main_()),
                          ).then((value) {
                            if (value == null) return;
                            user.data[user.PHONE_NUMBER] = value;
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
                  controller: TextEditingController(text: user.data["user_username"] ?? ""),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Username:", //
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, //
                            MaterialPageRoute(builder: (_) => update_username.Main_()),
                          ).then((value) {
                            if (value == null) return;
                            user.data["user_username"] = value;
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
                    labelText: "Password:", //
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
                label: Text("Sign Out"),
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
    //
    dio.options.headers.remove("Authorization");
    //
    await secure_storage.delete(key: "access_token");

    for (var key in user.data.keys) user.data[key] = null;

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
