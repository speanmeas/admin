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
import "widget/search_guest.dart" as search_guest;

import "../../schema.w.dart" as fd_schema_w;
import "../../schema.r.dart" as fd_schema_r;
import "package:speanmeas/page/guest/schema.r.dart" as g_schema_r;

import "package:speanmeas/widget/show_data.dart" as show_data;

import "2_staying.dart" as step_2;

class _Main_State extends State<Main_> {
  final c_search_guest = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    c_search_guest.text = g_schema_r.data[g_schema_r.PHONE_NUMBER]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1. Guest", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          OutlinedButton.icon(
            icon: Icon(Icons.arrow_right_alt_outlined),
            label: Text("Next"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            onPressed: on_next,
          ),
          SizedBox(width: 8),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,

        //
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2), //
          child: LinearProgressIndicator(value: 1 / 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),

            child: Column(
              children: [
                // search
                SizedBox(height: 8),
                search_guest.Main_(
                  controller: c_search_guest,
                  onChanged: (v) {
                    for (var e in g_schema_r.data.entries) //
                      g_schema_r.data[e.key]?["value"] = v[e.key];
                    setState(() {});
                  },
                ),

                for (var e in g_schema_r.data.entries)
                  (() {
                    if (e.value["type"] == "string") {
                      String value = "";
                      if (e.value["value"] != null) value = e.value["value"].toString();
                      return show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                        max_lines: e.key.contains("note") ? 4 : 1,
                      );
                    }

                    //
                    if (e.value["type"] == "number") {
                      String value = "";
                      if (e.value["value"] != null) value = e.value["value"].toString();
                      return show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                      );
                    }

                    //
                    if (e.value["type"] == "date-time") {
                      String value = "";
                      if (e.value["value"] != null) {
                        final dt = e.value["value"];
                        value = DateFormat(DATE_FORMAT).format(dt);
                      }
                      return show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                      );
                    }

                    //
                    if (e.value["type"] == "boolean") {
                      String value = "";
                      if (e.value["value"] != null) {
                        if (e.value["value"] == true) value = "Yes";
                        if (e.value["value"] == false) value = "No";
                      }
                      return show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                      );
                    }
                    //
                    return SizedBox();
                  })(),
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
      fd_schema_w.data[fd_schema_w.GUEST_LINK]?["value"] = g_schema_r.data[g_schema_r.ID]?["value"];

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
