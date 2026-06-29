import 'dart:convert';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      create: (_) => Global.variable, //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Step_5a_Receipt_(),
    );
  }
}

class Step_5a_Receipt_ extends StatefulWidget {
  const Step_5a_Receipt_({super.key});

  @override
  State<Step_5a_Receipt_> createState() => _Step_5a_Receipt_State();
}

class _Step_5a_Receipt_State extends State<Step_5a_Receipt_> {
  //

  @override
  void initState() {
    super.initState();
    //
    if (!kDebugMode) {
      Future.delayed(const Duration(milliseconds: 300), () {
        html.window.print();
      }).whenComplete(() {
        Navigator.pop(context);
      });
    }
  }

  double PAPER_WIDTH = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: PAPER_WIDTH,
        padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: ListView(
          children: [
            // receipt header
            Container(
              alignment: Alignment.center, //
              child: Text("Spean Meas Hotel"),
            ),

            Container(
              alignment: Alignment.center, //
              child: Text("Invoice"),
            ),

            Text("Invoice"),
            Text("Invoice No: 123456"),
            Text("Spean Meas Hotel"),
            Text("Check-in: 2024-06-01 14:00"),
            Text("Spean Meas Hotel"),

            Text("Guest: John Doe"),

            Divider(color: Colors.black),

            // receipt body
            Text("Room No: 101"),
            Text("Room Type: Single"),
            Text("Body"),
            Text("Body"),
            Text("Body"),
            Text("Body"),

            Divider(color: Colors.black),
            Text("Total Price: \$100.00"),

            Divider(color: Colors.black),
            Text("Paid: \$100.00"),

            Divider(color: Colors.black),
            // receipt footer
            Text("Footer"),
            Text("1Riel Technology"),
          ],
        ),
      ),
    );
  }
}
