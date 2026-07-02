import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/page/main/User.g.dart';
import 'package:speanmeas/theme/Theme_Data.dart';

import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  // String full_name = "Admin";

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

class _Main_State extends State<Main_> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = user["full_name"] ?? '';
  }

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
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Full Name :", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
    await dio
        .post(
          "/user/data_update",
          data: FormData.fromMap({
            "id": user["_id"]!["\$oid"], //
            "full_name": controller.text, //
          }),
        )
        .then((r) async {
          snackbar_show(context: context, message: "Update successful", color: Colors.green);
          Navigator.pop(context, controller.text);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "Update failed", color: Colors.red);
        });
  }
}
