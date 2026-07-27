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

import 'package:speanmeas/page/auth/schema.r.dart' as user_r;

import '../../__config__.dart';
import '../../schema.w.dart' as fd_schema_w;
import '../../schema.r.dart' as fd_schema_r;
import '3_summary.dart' as step_3;

class _Main_State extends State<Main_> {
  final c_note = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    c_note.text = fd_schema_w.data[fd_schema_w.CHECK_OUT_NOTE]?["value"]?.toString() ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "2. Note", //
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
        //
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2), //
          child: LinearProgressIndicator(value: 2 / 3),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: [
                // note
                TextField(
                  controller: c_note,
                  decoration: InputDecoration(
                    labelText: "Note:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: 4,
                  onChanged: (v) => setState(() {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void on_next() async {
    try {
      //
      final response = await dio.post("/setting/now");
      if (DateTime.tryParse(response.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(response.data.toString())!;

      //
      fd_schema_w.data[fd_schema_w.CHECK_OUT_NOTE]?["value"] = c_note.text.trim();
      fd_schema_w.data[fd_schema_w.CHECK_OUT_BY_LINK]?["value"] = user_r.data[user_r.ID]?["value"]?.toString();
      fd_schema_w.data[fd_schema_w.CHECK_OUT_AT]?["value"] = DateFormat(DATE_FORMAT).format(now);

      // navigate to next screen
      await Navigator.push(context, MaterialPageRoute(builder: (context) => step_3.Main_()));

      //
      init();

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
