import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/page/main/user.g.dart" as user;

import "../_setup.dart";
import "../schema.g.dart" as schema;

import "step_2_summary.dart" as step_2;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1. Payment - Room", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Container(
          //   margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
          //   child: OutlinedButton.icon(
          //     icon: Icon(Icons.arrow_right_alt_outlined),
          //     label: Text("Next"),
          //     style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          //     onPressed: on_next,
          //   ),
          // ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
