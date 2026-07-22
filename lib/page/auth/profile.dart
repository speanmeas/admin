import "dart:convert";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/utility/secure_storage.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "edit_full_name.dart" as update_full_name;
import "edit_phone_number.dart" as update_phone_number;
import "edit_username.dart" as update_username;
import "edit_password.dart" as update_password;

import "schema.w.dart" as user;
import "sign_in.dart" as sign_in;

class _User_Profile_State extends State<User_Profile_> {
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

                      if (user.data[user.IS_ADMIN]!["value"] == true) return Text("Administrator", style: style);
                      if (user.data[user.IS_MANAGER]!["value"] == true) return Text("Manager", style: style);
                      if (user.data[user.IS_RECEPTIONIST]!["value"] == true) return Text("Receptionist", style: style);
                      if (user.data[user.IS_HOUSEKEEPER]!["value"] == true) return Text("Housekeeper", style: style);

                      return const SizedBox.shrink();
                    })(),
                  ],
                ),
              ),

              // textfield full name
              (() {
                String value = "";
                if (user.data[user.FULL_NAME]!["value"] != null) {
                  value = user.data[user.FULL_NAME]!["value"].toString().trim();
                }
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: TextField(
                    controller: TextEditingController(text: value),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Name:", //
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: IconButton(
                          onPressed: () async {
                            final v = await Navigator.push(context, MaterialPageRoute(builder: (_) => update_full_name.Main_()));
                            if (v == null) return;
                            setState(() {});
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                );
              })(),

              // textfield phone
              (() {
                String value = "";
                if (user.data[user.PHONE_NUMBER]!["value"] != null) {
                  value = user.data[user.PHONE_NUMBER]!["value"].toString().trim();
                }
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: TextField(
                    controller: TextEditingController(text: value),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Phone Number:", //
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: IconButton(
                          onPressed: () async {
                            final v = await Navigator.push(context, MaterialPageRoute(builder: (_) => update_phone_number.Main_()));
                            if (v == null) return;
                            setState(() {});
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                );
              })(),

              // textfield username
              (() {
                String value = "";
                if (user.data[user.USERNAME]!["value"] != null) {
                  value = user.data[user.USERNAME]!["value"].toString().trim();
                }
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: TextField(
                    controller: TextEditingController(text: value),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Username:", //
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: IconButton(
                          onPressed: () async {
                            final v = await Navigator.push(context, MaterialPageRoute(builder: (_) => update_username.Main_()));
                            if (v == null) return;
                            setState(() {});
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                );
              })(),

              // textfield password
              (() {
                return Container(
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
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => update_password.Main_()));
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                );
              })(),

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
    try {
      //
      dio.options.headers.remove("Authorization");

      //
      await secure_storage.delete(key: "access_token");

      //
      user.clear();

      // goto to sign in
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => const sign_in.Main_()));

      //
      snackbar_show(context: context, message: "Signed out successfully", color: Colors.green);
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }
}

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
