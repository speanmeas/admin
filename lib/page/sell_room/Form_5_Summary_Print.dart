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
import 'package:speanmeas/page/front_desk/form_check_in/Invoice.dart';
import 'package:speanmeas/page/front_desk/form_check_in/__Model__.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

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
      home: Summary_(),
    );
  }
}

class Summary_ extends StatefulWidget {
  const Summary_({super.key});

  @override
  State<Summary_> createState() => _Summary_State();
}

class _Summary_State extends State<Summary_> {
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
          "Form - Summary", //
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
                      onPressed: () {},
                    ),

                    OutlinedButton.icon(
                      label: Text("Print"),
                      icon: Icon(Icons.print_outlined),
                      onPressed: () {
                        Navigator.push(
                          context, //
                          MaterialPageRoute(builder: (_) => Print_()),
                        );
                      }, //
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
}

class Print_ extends StatefulWidget {
  const Print_({super.key});

  @override
  State<Print_> createState() => _Print_State();
}

class _Print_State extends State<Print_> {
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
