import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:dio/dio.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "schema.w.dart" as user;

class _Main_State extends State<Main_> {
  String phone_number = user.data[user.PHONE_NUMBER]!["value"] ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update - Phone Number", //
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
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: phone_number),
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
                  decoration: InputDecoration(
                    labelText: "Phone Number:", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onChanged: (v) {
                    phone_number = v;
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
      //
      if (phone_number.trim().isEmpty) throw "Phone number cannot be empty.";

      //
      final r = await dio.post("/user/update", data: FormData.fromMap({"_id": user.data[user.ID]!["value"], user.PHONE_NUMBER: phone_number}));

      //
      user.data[user.PHONE_NUMBER]!["value"] = r.data[user.PHONE_NUMBER];

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
