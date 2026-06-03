import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Form_Check_Out(),
    ),
  );
}

class Form_Check_Out extends StatelessWidget {
  const Form_Check_Out({super.key});

  final id = "69f984897186bcf74f8a5dde"; //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Form_Check_Out_(id: id),
    );
  }
}

class Form_Check_Out_ extends StatefulWidget {
  const Form_Check_Out_({super.key, required this.id});

  final String id;

  @override
  State<Form_Check_Out_> createState() => _Form_Check_Out_State();
}

class _Form_Check_Out_State extends State<Form_Check_Out_> {
  //

  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();

    print(widget.id);

    init();
  }

  void init() async {}

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
              Text("Under Development..."),

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
            ],
          ),
        ),
      ),
    );
  }
}
