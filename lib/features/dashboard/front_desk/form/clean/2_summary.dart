import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "package:speanmeas/features/database/room/schema.g.dart" as r_schema;

import "../../__config__.dart";
import "../../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "2. Summary", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          OutlinedButton.icon(
            icon: Icon(Icons.cleaning_services_outlined), //
            label: Text("Clean"), //
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            onPressed: on_check_in, //
          ),
          SizedBox(width: 8),
        ],

        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
        //
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2), //
          child: LinearProgressIndicator(value: 2 / 2),
        ),
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

  void on_check_in() async {
    try {
      //
      final payload = {};
      for (var e in schema.data.entries) //
        payload[e.key] = e.value["value"];

      //
      await dio.post("/front_desk/update", data: payload);

      await dio.post(
        "/room/update", //
        data: {
          r_schema.ID: schema.data[schema.ROOM_ID]?["value"], //
          r_schema.STATUS: "Available", //
          r_schema.FRONT_DESK_ID: null, //
        },
      );

      Navigator.pop(context);
      Navigator.pop(context, true);

      //
      snackbar.view(context: context, message: "Success", color: Colors.green);
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
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
