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

import "package:speanmeas/page/auth/schema.g.dart" as u_schema;

import "package:speanmeas/page/room/schema.g.dart" as r_schema;
import "package:speanmeas/page/guest/schema.g.dart" as g_schema;

import "../../__config__.dart";
// import "../../schema.w.dart" as fd_schema_w;
import "../../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  String _dateValue(dynamic value) {
    if (value == null) return "";

    final dt = DateTime.tryParse(value.toString());
    if (dt == null) return value.toString();

    return DateFormat(DATE_FORMAT).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "3. Summary", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          OutlinedButton.icon(
            icon: Icon(Icons.logout_outlined),
            label: Text("Check Out"),
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
          child: LinearProgressIndicator(value: 3 / 3),
        ),
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

  void on_check_in() async {
    try {
      //
      final output = {for (var e in schema.data.entries) e.key: e.value["value"]};

      final response = await dio.post(
        "/front_desk/update", //
        data: FormData.fromMap(output),
      );

      await dio.post(
        "/room/update", //
        data: FormData.fromMap({
          "_id": schema.data[schema.ROOM_ID]?["value"], //
          r_schema.STATUS: "Pending Clean", //
        }),
      );

      //
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
