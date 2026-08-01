import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "../__config__.dart";
import "../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Summary", //
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
          child: Container(
            width: 600,
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: [
                for (var e in schema.data.entries) //
                  (() {
                    //
                    if (kDebugMode && e.value["type"]?.toString() == "id") {
                      return show_data.Main_(
                        title: e.value["title"]?.toString() ?? "", //
                        value: e.value["value"]?.toString() ?? "",
                      );
                    }

                    //
                    if (e.value["type"]?.toString() == "string") {
                      var value = "";
                      if (e.value["value"] != null) value = e.value["value"].toString();
                      return show_data.Main_(
                        title: e.value["title"]?.toString() ?? "", //
                        value: value,
                      );
                    }

                    //
                    if (e.value["type"]?.toString() == "number") {
                      var value = "";
                      if (e.value["value"] != null) value = e.value["value"].toString();
                      return show_data.Main_(
                        title: e.value["title"]?.toString() ?? "", //
                        value: value,
                      );
                    }

                    //
                    if (e.value["type"]?.toString() == "date-time") {
                      var value = "";
                      if (e.value["value"] != null) {
                        final dt = DateTime.tryParse(e.value["value"].toString());
                        if (dt != null) value = DateFormat(DATE_FORMAT).format(dt);
                      }
                      return show_data.Main_(
                        title: e.value["title"]?.toString() ?? "", //
                        value: value,
                      );
                    }

                    //
                    if (e.value["type"]?.toString() == "boolean") {
                      var value = "";
                      if (e.value["value"] != null) {
                        if (e.value["value"] == true) value = "Yes";
                        if (e.value["value"] == false) value = "No";
                      }
                      return show_data.Main_(
                        title: e.value["title"]?.toString() ?? "", //
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

  String date_to_string(dynamic value) {
    if (value == null) return "";

    final dt = DateTime.tryParse(value.toString());
    if (dt == null) return value.toString();

    return DateFormat(DATE_FORMAT).format(dt);
  }

  //
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
