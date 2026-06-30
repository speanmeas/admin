import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
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

  String phone_number = "Admin";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Update_Phone_Number_(phone_number: phone_number),
    );
  }
}

class Update_Phone_Number_ extends StatefulWidget {
  Update_Phone_Number_({
    super.key, //
    required this.phone_number,
  });

  String phone_number = "";

  @override
  State<Update_Phone_Number_> createState() => _Update_Phone_Number_State();
}

class _Update_Phone_Number_State extends State<Update_Phone_Number_> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.phone_number;
  }

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
                  controller: controller,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  decoration: InputDecoration(
                    labelText: "Phone Number :", //
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
    String phone_number = controller.text.trim();

    String id = await secure_storage.read(key: "id") ?? "";

    if (id.isEmpty) {
      snackbar_show(context: context, message: "ID not found", color: Colors.red);
      return;
    }

    await dio
        .post(
          "/user/data_update",
          data: FormData.fromMap({
            "id": id, //
            "phone_number": phone_number, //
          }),
        )
        .then((r) async {
          await secure_storage.write(key: "phone_number", value: phone_number);
          Navigator.pop(context, phone_number);
          snackbar_show(context: context, message: "Update successful", color: Colors.green);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "Update failed", color: Colors.red);
        });
  }
}
