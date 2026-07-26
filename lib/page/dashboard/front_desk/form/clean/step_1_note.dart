import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/__config__.dart';
import 'package:speanmeas/__variable__.dart';
import 'package:speanmeas/theme/theme_data.dart';
import 'package:speanmeas/utility/dio.dart';
import 'package:speanmeas/widget/datetime_picker.dart';
import 'package:speanmeas/widget/snackbar_show.dart';
import 'package:speanmeas/page/auth/schema.r.dart' as user;

import '../../__config__.dart';
import '../../schema.w.dart' as schema;
import 'step_2_summary.dart' as step_2;
import "widget/input_note.dart" as input_note;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1. Clean - Note", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), //
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
                child: input_note.Main_(
                  initialValue: schema.data[schema.CLEAN_NOTE]?["value"]?.toString() ?? "",
                  onChanged: (v) {
                    schema.data[schema.CLEAN_NOTE]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_next() async {
    try {
      //
      final response = await dio.post("/variable/datetime_now");
      if (DateTime.tryParse(response.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(response.data.toString())!;

      //

      // timestamp
      schema.data[schema.CLEAN_AT]?["value"] = DateFormat(DATE_FORMAT).format(now);
      // if (user.data[user.ID]!["value"] != null) //
      //   schema.data[schema.CLEAN_BY_ID]?["value"] = user.data[user.ID]!["value"];
      // if (user.data[user.USER_FULL_NAME]!["value"] != null) //
      //   schema.data[schema.CLEAN_BY]?["value"] = user.data[user.USER_FULL_NAME]!["value"];

      // navigate to next screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => step_2.Main_()));

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
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
