import "package:dio/dio.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "../../__config__.dart";
import "../../schema.w.dart" as schema_w;
import "widget/search_guest.dart" as search_guest;

import "package:speanmeas/page/guest/schema.r.dart" as g_schema_r;

import "package:speanmeas/widget/show_data.dart" as show_data;

import "2_staying.dart" as step_2;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1. Guest", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    for (var e in g_schema_r.data.entries) //
                      if (v[e.key] != null) //
                        g_schema_r.data[e.key]?["value"] = v[e.key];

                    setState(() {});
                  },
                ),
              ),

              for (var e in g_schema_r.data.entries)
                (() {
                  if (e.value["type"] == "string") {
                    String value = "";
                    if (e.value["value"] != null) value = e.value["value"].toString();
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                        max_lines: e.key.contains("note") ? 4 : 1,
                      ),
                    );
                  }

                  //
                  if (e.value["type"] == "number") {
                    String value = "";
                    if (e.value["value"] != null) value = e.value["value"].toString();
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                      ),
                    );
                  }

                  //
                  if (e.value["type"] == "date-time") {
                    String value = "";
                    if (e.value["value"] != null) {
                      final dt = e.value["value"];
                      value = DateFormat(DATE_FORMAT).format(dt);
                    }
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                      ),
                    );
                  }

                  //
                  if (e.value["type"] == "boolean") {
                    String value = "";
                    if (e.value["value"] != null) {
                      if (e.value["value"] == true) value = "Yes";
                      if (e.value["value"] == false) value = "No";
                    }
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                      ),
                    );
                  }
                  //
                  return SizedBox();
                })(),
            ],
          ),
        ),
      ),
    );
  }

  void on_next() async {
    try {
      //

      schema_w.data[schema_w.GUEST_LINK]?["value"] = g_schema_r.data[g_schema_r.ID]?["value"];

      //
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
      home: Main_(),
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
