import "package:intl/intl.dart";
import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "../__config__.dart";
import "../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Read", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 8),
              for (var e in schema.data.entries)
                (() {
                  if (e.value["type"] == "string") {
                    String value = "";
                    if (e.value["value"] != null) value = e.value["value"].toString();
                    if (e.key.contains("password")) value = "**********";
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
      theme: data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
