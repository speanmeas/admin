import "package:dio/dio.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";
// import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/global.dart";
import "package:speanmeas/environment.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/widget/show_data.dart" as show_data;

import "package:speanmeas/page/guest/form_create.dart" as guest_create;
import "package:speanmeas/page/guest/schema.g.dart" as guest_schema;

import "../_setup.dart";
import "../schema.g.dart" as schema;

import "step_2_stay.dart" as step_2;

import "widget/search_guest.dart" as search_guest;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1. Check In - Guest", //
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
              // search
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: search_guest.Main_(
                  onChanged: (v) {
                    schema.data[schema.GUEST_ID]?["value"] = v["_id"];
                    for (var e in v.entries) {
                      if (e.key == "_id") continue;
                      schema.data[e.key]?["value"] = e.value;
                    }
                    setState(() {});
                  },
                ),
              ),

              // guest name
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Name", //
                  value: schema.data[schema.GUEST_NAME]?["value"]?.toString() ?? "",
                ),
              ),

              // guest phone number
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Phone Number", //
                  value: schema.data[schema.GUEST_PHONE]?["value"]?.toString() ?? "",
                ),
              ),

              // guest gender
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Gender", //
                  value: schema.data[schema.GUEST_GENDER]?["value"]?.toString() ?? "",
                ),
              ),

              // guest nationality
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Nationality", //
                  value: schema.data[schema.GUEST_NATIONALITY]?["value"]?.toString() ?? "",
                ),
              ),

              // guest note
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Note", //
                  value: schema.data[schema.GUEST_NOTE]?["value"]?.toString() ?? "",
                  max_lines: 4,
                ),
              ),

              // button add
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Create New"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: on_add_new,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_next() async {
    // for (var e in schema.data.entries) print(e);

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => step_2.Main_()),
    );
  }

  void on_add_new() async {
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => guest_create.Main_()),
    ).then((v) {
      schema.data[schema.GUEST_ID]?["value"] = v["_id"];
      for (var e in v.entries) {
        if (e.key == "_id") continue;
        schema.data[e.key]?["value"] = e.value;
      }
      setState(() {});
    });
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
