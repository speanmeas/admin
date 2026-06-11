import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Form_5_Summary_Print.dart';
import '__Model__.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Payment(),
    ),
  );
}

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Payment_(),
    );
  }
}

class Payment_ extends StatefulWidget {
  const Payment_({super.key});

  @override
  State<Payment_> createState() => _Payment_State();
}

class _Payment_State extends State<Payment_> {
  @override
  initState() {
    super.initState();
  }

  double screen_height = 0;
  Global global = Global();

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    global = context.read<Global>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Form - Payment", //
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
              //
              Container(
                padding: EdgeInsets.all(8),
                child: OutlinedButton.icon(
                  label: Text("Next"), //
                  icon: Icon(Icons.arrow_forward, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context, //
                      MaterialPageRoute(builder: (_) => Summary_()),
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
