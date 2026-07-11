import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/environment.dart";
import "package:speanmeas/global.dart";
import "package:speanmeas/layout/layout.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/widget/show_data.dart" as show_data;
import "package:speanmeas/page/room/schema.g.dart" as room_schema;

import "../_setup.dart";
import "../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "2. Check Out - Summary", //
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
              icon: Icon(Icons.logout_outlined),
              label: Text("Check Out"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: on_check_out, //
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
              ...schema.data.entries.where((e) => !e.key.contains("_id")).map((e) {
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

  void on_check_out() async {
    try {
      //
      final output = {for (var e in schema.data.entries) e.key: e.value["value"]};

      //
      await dio.post(
        "/front_desk/data_update", //
        data: FormData.fromMap({...output}),
      );

      //
      await dio.post(
        "/room/data_update",
        data: FormData.fromMap({
          "_id": output[schema.ROOM_ID], //
          room_schema.ROOM_STATUS: "Pending Clean",
        }),
      );

      //
      Navigator.pop(context);
      Navigator.pop(context, true);

      //
      snackbar_show(context: context, message: "Updated successfully.", color: Colors.green);
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
