import "package:dio/dio.dart";
import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Global.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/Environment.dart";
import "package:speanmeas/theme/theme_data.dart";

import "../_setup.dart";
import "../schema.g.dart" as schema;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(input: {}),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key, required this.input});

  final Map<String, dynamic> input;

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //

  Map<String, dynamic> output = {};

  @override
  void initState() {
    super.initState();
    output = Map<String, dynamic>.from(widget.input);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Read - $HEADER", //
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
            ],
          ),
        ),
      ),
    );
  }
}
