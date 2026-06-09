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
      child: const Invoice(),
    ),
  );
}

class Invoice extends StatelessWidget {
  const Invoice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Invoice_(),
    );
  }
}

class Invoice_ extends StatefulWidget {
  const Invoice_({super.key});

  @override
  State<Invoice_> createState() => _Invoice_State();
}

class _Invoice_State extends State<Invoice_> {
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
