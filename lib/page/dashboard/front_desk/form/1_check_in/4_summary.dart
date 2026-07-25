import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/layout/layout.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/widget/show_data.dart" as show_data;

import "package:speanmeas/page/room/schema.w.dart" as r_schema_w;

import "../../__config__.dart";
import "../../schema.w.dart" as schema_w;

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
          "4. Summary", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          // if (can_next())
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: OutlinedButton.icon(
              icon: Icon(Icons.login_outlined),
              label: Text("Check In"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: on_check_in, //
            ),
          ),
        ],

        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              // ! use schema_r to show data
              ...schema_w.data.entries.where((e) => !e.key.contains("_id")).map((e) {
                String value = e.value["value"]?.toString() ?? "";
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: show_data.Main_(
                    title: e.value["title"], //
                    value: value,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void on_check_in() async {
    try {
      //
      final output = {for (var e in schema_w.data.entries) e.key: e.value["value"]};

      //
      final response = await dio.post(
        "/front_desk/create", //
        data: FormData.fromMap(output),
      );

      //
      var status = "Pending Pay";
      if (output[schema_w.ROOM_PAID_AT]?.isNotEmpty ?? false) status = "Pending Leave";

      //
      await dio.post(
        "/room/update", //
        data: FormData.fromMap({
          "_id": output[schema_w.ROOM_LINK], //
          r_schema_w.STATUS: status, //
          r_schema_w.FRONT_DESK_ID: response.data["_id"],
        }),
      );

      //
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context, true);

      //
      snackbar_show(context: context, message: "Create successfully.", color: Colors.green);
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
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
