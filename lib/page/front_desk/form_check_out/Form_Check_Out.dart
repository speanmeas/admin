import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/front_desk/form_check_out/__Model__.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(const Form_Check_Out());
}

class Form_Check_Out extends StatelessWidget {
  const Form_Check_Out({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Form_Check_Out_(),
    );
  }
}

class Form_Check_Out_ extends StatefulWidget {
  const Form_Check_Out_({super.key});

  @override
  State<Form_Check_Out_> createState() => _Form_Check_Out_State();
}

class _Form_Check_Out_State extends State<Form_Check_Out_> {
  //

  List<Map<String, dynamic>> rooms = [];

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Form Check Out", //
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
            tooltip: "Close",
          ),
          SizedBox(width: 4),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Row(
                  children: [
                    Text("Room Number: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      Model_Check_Out.room_number ?? "",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Row(
                  children: [
                    Text("Remaining Balance: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      "${Model_Check_Out.account_receivable ?? "0"} USD",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    // hintText: "Enter text...", //
                    border: OutlineInputBorder(),
                    labelText: "Note:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              OutlinedButton.icon(
                onPressed: () async {
                  //
                  print("Confirm Check Out");

                  // todo: save data to backend

                  await dio
                      .post(
                        "/room/data_update",
                        data: FormData.fromMap({
                          "id": Model_Check_Out.room_id, //
                          "account_receivable": 0,
                          "status": "Dirty", //
                        }),
                      )
                      .then((r) {
                        print(r.data);
                        Navigator.pop(context, true);
                      })
                      .catchError((e) {
                        print(e);
                      });
                },
                icon: const Icon(Icons.check),
                label: const Text("Confirm Check Out"), //
              ),
            ],
          ),
        ),
      ),
    );
  }
}
