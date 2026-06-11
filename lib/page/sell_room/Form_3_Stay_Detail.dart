import 'dart:convert';

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

import 'Form_4_Payment.dart';

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
      home: Stay_Detail_(),
    );
  }
}

class Stay_Detail_ extends StatefulWidget {
  const Stay_Detail_({super.key});

  @override
  State<Stay_Detail_> createState() => _Stay_Detail_State();
}

class _Stay_Detail_State extends State<Stay_Detail_> {
  @override
  void initState() {
    super.initState();
  }

  Global global = Global();
  double screen_height = 0;

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    global = context.read<Global>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Form - Stay Detail", //
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
        child: Center(
          child: Column(
            children: [
              // button next
              Container(
                padding: EdgeInsets.all(8),
                child: OutlinedButton.icon(
                  label: Text("Next"), //
                  icon: Icon(Icons.arrow_forward, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context, //
                      MaterialPageRoute(builder: (_) => Payment_()),
                    );
                  },
                ),
              ),

              //
              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }
}
