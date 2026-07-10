import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/layout/Layout.dart";

import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/widget/show_data.dart" as show_data;

import "../_setup.dart";
import "../schema.g.dart" as schema;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "4. Check In - Summary", //
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

  void on_check_in() async {
    Map<String, dynamic> output = {for (var e in schema.data.entries) e.key: e.value["value"]};

    String? room_id = output[schema.ROOM_ID];
    String? payment_at = output[schema.ROOM_PAYMENT_AT];
    String? id = output[schema.ROOM_PAYMENT_BY_ID];
    if (payment_at != null && payment_at.isNotEmpty) {
      await dio.post(
        "/room/data_update",
        data: FormData.fromMap({
          "_id": room_id, //
          "room_status": "Pending Leave",
          // "front_desk_id": id, //
        }),
      );
    } else {
      await dio.post(
        "/room/data_update",
        data: FormData.fromMap({
          "_id": room_id, //
          "room_status": "Pending Pay",
          // "front_desk_id": id, //
        }),
      );
    }

    await dio
        .post("/front_desk/data_create", data: FormData.fromMap({...output}))
        .then((r) {
          snackbar_show(context: context, message: "Create successfully.", color: Colors.green);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context, true);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "Create failed.", color: Colors.red);
        });
  }
}
