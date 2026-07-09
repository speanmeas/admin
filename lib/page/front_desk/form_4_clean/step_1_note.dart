import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';
import 'package:speanmeas/page/main/_User.dart' as user;

import '../_setup.dart';
import '../schema.g.dart' as schema;

import 'step_2_summary.dart' as step_2;

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
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  TextEditingController controller_note = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "2. Check Out - Note", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: OutlinedButton.icon(
              icon: Icon(Icons.arrow_right_alt_outlined),
              label: Text("Next"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: on_next,
            ),
          ),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // note
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_note,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Note:", //
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_next() async {
    for (var s in schema.data) {
      if (s["key"] == schema.CLEAN_BY_ID) s["value"] = user.data[user.ID];
      if (s["key"] == schema.CLEAN_BY) s["value"] = user.data[user.FULL_NAME];
      if (s["key"] == schema.CLEAN_AT) s["value"] = DateTime.now().toIso8601String();
      if (s["key"] == schema.CLEAN_NOTE) s["value"] = controller_note.text;
    }

    for (var s in schema.data) print(s);

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => step_2.Main_()),
    );
  }
}
