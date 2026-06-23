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

import 'Step_5a_Invoice.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
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
      home: Step_5_Summary_(),
    );
  }
}

class Step_5_Summary_ extends StatefulWidget {
  const Step_5_Summary_({super.key});

  @override
  State<Step_5_Summary_> createState() => _Step_5_Summary_State();
}

class _Step_5_Summary_State extends State<Step_5_Summary_> {
  //

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Summary", //
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
              // button check in + print
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 80),

                    OutlinedButton.icon(
                      label: Text("Check In"), //
                      icon: Icon(Icons.login_outlined),
                      onPressed: on_check_in,
                    ),

                    OutlinedButton.icon(
                      label: Text("Print"),
                      icon: Icon(Icons.print_outlined),
                      onPressed: on_print, //
                    ),
                  ],
                ),
              ),

              // add bottom space
              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  void on_print() {
    //
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Step_5a_Invoice_()),
    );
  }

  void on_check_in() async {
    //
    // todo: save guest info + stay detail + payment to database
  }
}
