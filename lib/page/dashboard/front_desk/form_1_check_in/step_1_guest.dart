import "package:dio/dio.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";
// import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/__variable__.dart";
import "package:speanmeas/__config__.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

// import "package:speanmeas/page/guest/form_create.dart" as guest_create;

import "../__config__.dart";
import "../schema.w.dart" as schema_w;
import "widget/search_guest.dart" as search_guest;

import "package:speanmeas/page/guest/schema.r.dart" as guest_schema_r;

import "package:speanmeas/widget/show_data.dart" as show_data;

// import "step_2_stay.dart" as step_2;

class _Main_State extends State<Main_> {
  Map<String, dynamic> data = {};

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
                    data = v;
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
                  value: data[guest_schema_r.FULL_NAME]?.toString() ?? "",
                ),
              ),

              // guest phone number
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Phone Number", //
                  value: data[guest_schema_r.PHONE_NUMBER]?.toString() ?? "",
                ),
              ),

              // guest gender
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Gender", //
                  value: data[guest_schema_r.GENDER]?.toString() ?? "",
                ),
              ),

              // guest nationality
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Nationality", //
                  value: data[guest_schema_r.NATIONALITY_NAME]?.toString() ?? "",
                ),
              ),

              // guest note
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: show_data.Main_(
                  title: "Note", //
                  value: data[guest_schema_r.NOTE]?.toString() ?? "",
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
    try {
      //
      // Navigator.push(context, MaterialPageRoute(builder: (context) => step_2.Main_()));
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_add_new() async {
    try {
      //
      // final value = await Navigator.push(context, MaterialPageRoute(builder: (context) => guest_create.Main_()));
      // if (value == null) return;

      // schema_w.data[schema.GUEST_ID]?["value"] = value["_id"];
      // for (var e in value.entries) {
      //   if (e.key == "_id") continue;
      //   schema_w.data[e.key]?["value"] = e.value;
      // }

      // //
      // setState(() {});

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
      home: Main_(),
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
