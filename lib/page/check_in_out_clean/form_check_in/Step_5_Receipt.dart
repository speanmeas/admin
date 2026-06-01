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
      create: (_) => Global(), //
      child: const Receipt(),
    ),
  );
}

class Receipt extends StatelessWidget {
  const Receipt({super.key});

  final id = "69f984897186bcf74f8a5dde"; //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Receipt_(id: id),
    );
  }
}

class Receipt_ extends StatefulWidget {
  const Receipt_({super.key, required this.id});

  final String id;

  @override
  State<Receipt_> createState() => _Receipt_State();
}

class _Receipt_State extends State<Receipt_> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: 300,
        padding: EdgeInsets.all(4),
        child: ListView(
          children: [
            // receipt header
            Text("Header"),

            const Divider(color: Colors.black),

            // receipt body
            Text("Body"),
            Text("Body"),
            Text("Body"),
            Text("Body"),

            const Divider(color: Colors.black),

            // receipt footer
            Text("Footer"),
          ],
        ),
      ),
    );
  }
}
