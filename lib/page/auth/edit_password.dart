import "dart:io";

import "package:flutter/material.dart";
import "package:dio/dio.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "schema.w.dart" as user_w;

class _Main_State extends State<Main_> {
  bool is_password_visible = false;
  bool is_confirm_password_visible = false;

  String password = "";
  String confirm_password = "";

  // TextEditingController controller_password = TextEditingController();
  // TextEditingController controller_confirm_password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update - Password", //
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
              // password
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: password),
                  autofocus: true,
                  obscureText: !is_password_visible,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Password:", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: Icon(is_password_visible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          is_password_visible = !is_password_visible;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  onChanged: (v) {
                    password = v;
                  },
                  onSubmitted: (v) => on_update(),
                ),
              ),

              // confirm password
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: confirm_password),
                  obscureText: !is_confirm_password_visible,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Confirm Password:", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: Icon(is_confirm_password_visible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          is_confirm_password_visible = !is_confirm_password_visible;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  onChanged: (v) {
                    confirm_password = v;
                  },
                  onSubmitted: (v) => on_update(),
                ),
              ),

              // button update
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.check), //
                  label: Text("Update"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: on_update,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_update() async {
    try {
      // if (password.length < 6) throw "Password must be at least 6 characters.";
      // if (password != confirm_password) throw "Passwords do not match.";

      //
      final r = await dio.post("/user/data_update", data: FormData.fromMap({"_id": user_w.data[user_w.ID]!["value"], user_w.PASSWORD: password}));

      //
      user_w.data[user_w.PASSWORD]!["value"] = r.data[user_w.PASSWORD];

      //
      snackbar_show(context: context, message: "Update successful.", color: Colors.green);

      //
      Navigator.pop(context, true);

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
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
