import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "../../__config__.dart";
import "../../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
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
                for (var e in schema.data.entries)
                  if (!e.value["hide"] || kDebugMode) _field(e.value),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(Map<String, dynamic> field) {
    return show_data.Main_(
      title: field["title"]?.toString() ?? "", //
      value: _dateValue(field["value"]),
    );
  }

  String _dateValue(dynamic value) {
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
