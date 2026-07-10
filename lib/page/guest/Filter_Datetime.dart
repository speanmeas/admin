import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "_setup.dart";

class _Main_State extends State<Main_> {
  String? start_datetime;
  String? end_datetime;

  DateTime? start_datetime_raw;
  DateTime? end_datetime_raw;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter Datetime", //
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
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: start_datetime ?? ""),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "Start Date-Time:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.calendar_today, size: 20), //
                  ),
                  onTap: () async {
                    final DateTime? datetime = await datetime_picker(context);
                    if (datetime == null) return;
                    start_datetime = DateFormat(DATE_FORMAT).format(datetime);
                    start_datetime_raw = datetime;
                    setState(() {});
                  }, //,
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: TextEditingController(text: end_datetime ?? ""),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "End Date-Time:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.calendar_today, size: 20), //
                  ),
                  onTap: () async {
                    final DateTime? datetime = await datetime_picker(context);
                    if (datetime == null) return;
                    end_datetime = DateFormat(DATE_FORMAT).format(datetime);
                    end_datetime_raw = datetime;
                    setState(() {});
                  }, //,
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.date_range),
                  label: Text("Apply"), //
                  onPressed: on_apply_filter,
                ),
              ),
              //
            ],
          ),
        ),
      ),
    );
  }

  void on_apply_filter() {
    // validate start and end datetime
    if (start_datetime_raw == null || end_datetime_raw == null) {
      snackbar_show(context: context, message: "Please select start and end date-time", color: Colors.red);
      return;
    }

    // please put end datetime after start datetime
    if (end_datetime_raw!.isBefore(start_datetime_raw!)) {
      snackbar_show(context: context, message: "End date-time must be after start date-time", color: Colors.red);
      return;
    }

    // print start and end datetime
    // print("Filter: $start_datetime to $end_datetime");

    Navigator.pop(context, {"start": start_datetime_raw, "end": end_datetime_raw});

    snackbar_show(context: context, message: "Filter applied", color: Colors.green);
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: HEADER, //
      theme: Theme_Data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
