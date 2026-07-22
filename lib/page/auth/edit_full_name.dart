import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:dio/dio.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/utility/secure_storage.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "schema.w.dart" as user;

class _Main_State extends State<Main_> {
  String full_name = user.data[user.FULL_NAME]!["value"] ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update - Full Name", //
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
                  controller: TextEditingController(text: full_name),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Name:", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onChanged: (v) {
                    //
                    full_name = v;
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

      final r = await dio.post(
        "/user/update",
        data: FormData.fromMap({
          "_id": user.data[user.ID]!["value"], //
          user.FULL_NAME: full_name, //
        }),
      );

      user.data[user.FULL_NAME]!["value"] = r.data[user.FULL_NAME];
      snackbar_show(context: context, message: "Update successful", color: Colors.green);
      Navigator.pop(context, true);
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => global, //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}
