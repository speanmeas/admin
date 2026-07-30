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
import "package:speanmeas/widget/show_data.dart" as show_data;

import "../../__config__.dart";
import "../../schema.g.dart" as schema;

import "package:speanmeas/page/guest/schema.g.dart" as g_schema;

import "2_staying.dart" as step_2;
import "widget/guest_search.dart" as g_search;

class _Main_State extends State<Main_> {
  final c_g_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    c_g_search.text = g_schema.data[g_schema.PHONE_NUMBER]?["value"]?.toString() ?? "";

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
                // guest search
                SizedBox(height: 8),
                g_search.Main_(
                  controller: c_g_search,
                  onChanged: (v) {
                    schema.data[schema.GUEST_ID]?["value"] = v[g_schema.ID];
                    schema.data[schema.GUEST_FULL_NAME]?["value"] = v[g_schema.FULL_NAME];
                    schema.data[schema.GUEST_PHONE_NUMBER]?["value"] = v[g_schema.PHONE_NUMBER];
                    schema.data[schema.GUEST_GENDER]?["value"] = v[g_schema.GENDER];
                    schema.data[schema.GUEST_NATIONALITY]?["value"] = v[g_schema.NATIONALITY];
                    setState(() {});
                  },
                  onCleared: () {
                    schema.data[schema.GUEST_ID]?["value"] = null;
                    schema.data[schema.GUEST_FULL_NAME]?["value"] = null;
                    schema.data[schema.GUEST_PHONE_NUMBER]?["value"] = null;
                    schema.data[schema.GUEST_GENDER]?["value"] = null;
                    schema.data[schema.GUEST_NATIONALITY]?["value"] = null;
                    setState(() {});
                  },
                ),

                (() {
                  String value = "";
                  if (schema.data[schema.GUEST_FULL_NAME]?["value"] != null) {
                    value = schema.data[schema.GUEST_FULL_NAME]?["value"].toString() ?? "";
                  }
                  return show_data.Main_(
                    title: schema.data[schema.GUEST_FULL_NAME]?["title"] ?? "", //
                    value: value,
                  );
                })(),

                (() {
                  String value = "";
                  if (schema.data[schema.GUEST_PHONE_NUMBER]?["value"] != null) {
                    value = schema.data[schema.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
                  }
                  return show_data.Main_(
                    title: schema.data[schema.GUEST_PHONE_NUMBER]?["title"] ?? "", //
                    value: value,
                  );
                })(),

                (() {
                  String value = "";
                  if (schema.data[schema.GUEST_GENDER]?["value"] != null) {
                    value = schema.data[schema.GUEST_GENDER]?["value"].toString() ?? "";
                  }
                  return show_data.Main_(
                    title: schema.data[schema.GUEST_GENDER]?["title"] ?? "", //
                    value: value,
                  );
                })(),

                (() {
                  String value = "";
                  if (schema.data[schema.GUEST_NATIONALITY]?["value"] != null) {
                    value = schema.data[schema.GUEST_NATIONALITY]?["value"].toString() ?? "";
                  }
                  return show_data.Main_(
                    title: schema.data[schema.GUEST_NATIONALITY]?["title"] ?? "", //
                    value: value,
                  );
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
