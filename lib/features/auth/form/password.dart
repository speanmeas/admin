import "package:flutter/material.dart";
import "package:dio/dio.dart";

import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  bool is_password_visible = false;
  bool is_confirm_password_visible = false;

  final c_password = TextEditingController();
  final c_confirm_password = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {});
    //
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

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black),
        ),
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
                  controller: c_password,
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
                  onSubmitted: (v) => on_update(),
                ),
              ),

              // confirm password
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: c_confirm_password,
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
      if (c_password.text != c_confirm_password.text) throw "Passwords do not match.";

      //
      final r = await dio.post(
        "/user/update_field", //
        data: FormData.fromMap({
          "_id": schema.data[schema.ID]!["value"], //
          "key": schema.PASSWORD, //
          "value": c_password.text, //
        }),
      );

      //
      schema.data[schema.PASSWORD]!["value"] = r.data[schema.PASSWORD];
      Navigator.pop(context, true);

      //
      snackbar.view(context: context, message: "Success", color: Colors.green);

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
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
