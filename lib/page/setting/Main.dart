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
      child: const Setting(),
    ),
  );
}

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Setting_(),
    );
  }
}

class Setting_ extends StatefulWidget {
  const Setting_({super.key});

  @override
  State<Setting_> createState() => _Setting_State();
}

class _Setting_State extends State<Setting_> {
  @override
  void initState() {
    super.initState();
    init();
  }

  List<Map<String, dynamic>> data = [];

  void init() async {
    await dio
        .post("/setting/readAll")
        .then((r) {
          data = List<Map<String, dynamic>>.from(r.data);
          print(data);
          setState(() {});
        })
        .catchError((error) {
          //
        });
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Under Development...', //
              ),

              ...data.where((e) => e["Key"] == "Title").map((e) {
                final key = e["Key"].toString();
                final value = e["Value"].toString();
                return Container(
                  width: 600,
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: TextEditingController(text: value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), //
                      labelText: key,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                );
              }),

              ...data.where((e) => e["Key"] == "Subtitle").map((e) {
                final key = e["Key"].toString();
                final value = e["Value"].toString();
                return Container(
                  width: 600,
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: TextEditingController(text: value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), //
                      labelText: key,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                );
              }),

              ...data.where((e) => e["Key"] == "USD to KHR").map((e) {
                final key = e["Key"].toString();
                final value = e["Value"].toString();
                return Container(
                  width: 600,
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: TextEditingController(text: value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), //
                      labelText: key,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                );
              }),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }
}
