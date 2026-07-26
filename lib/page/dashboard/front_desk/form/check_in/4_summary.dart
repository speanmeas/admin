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

import "package:speanmeas/page/auth/schema.r.dart" as user_r;

import "package:speanmeas/page/room/schema.r.dart" as r_schema_r;
import "package:speanmeas/page/guest/schema.r.dart" as g_schema_r;

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2), //
          child: LinearProgressIndicator(value: 4 / 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 600,
          alignment: Alignment.topCenter,
          margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            children: [
              // room number
              show_data.Main_(
                title: "Room Number", //
                value: r_schema_r.data[r_schema_r.NUMBER]?["value"]?.toString() ?? "",
              ),

              // room kind
              show_data.Main_(
                title: "Room Type", //
                value: r_schema_r.data[r_schema_r.KIND]?["value"]?.toString() ?? "",
              ),

              // room price per day
              show_data.Main_(
                title: "Room Per Day (USD)", //
                value: r_schema_r.data[r_schema_r.USD_PER_DAY]?["value"]?.toString() ?? "",
              ),

              // room price per 3h
              show_data.Main_(
                title: "Room Per 3H (USD)", //
                value: r_schema_r.data[r_schema_r.USD_PER_3H]?["value"]?.toString() ?? "",
              ),

              //
              show_data.Main_(
                title: "Guest Name", //
                value: g_schema_r.data[g_schema_r.FULL_NAME]?["value"]?.toString() ?? "",
              ),

              //
              show_data.Main_(
                title: "Guest Gender", //
                value: g_schema_r.data[g_schema_r.GENDER]?["value"]?.toString() ?? "",
              ),

              //
              show_data.Main_(
                title: "Guest Phone", //
                value: g_schema_r.data[g_schema_r.PHONE_NUMBER]?["value"]?.toString() ?? "",
              ),

              // guest nationality
              show_data.Main_(
                title: "Guest Nationality", //
                value: g_schema_r.data[g_schema_r.NATIONALITY_NAME]?["value"]?.toString() ?? "",
              ),

              // stay duration (days)
              show_data.Main_(
                title: "Stay Duration (Days)", //
                value: schema_w.data[schema_w.STAY_DAY]?["value"]?.toString() ?? "0",
              ),

              // stay duration (hours)
              show_data.Main_(
                title: "Stay Duration (Hours)", //
                value: schema_w.data[schema_w.STAY_HOUR]?["value"]?.toString() ?? "0",
              ),

              // stay guest total
              show_data.Main_(
                title: "Stay Guest Total", //
                value: schema_w.data[schema_w.NUMBER_OF_GUESTS]?["value"]?.toString() ?? "0",
              ),

              // scheduled check-out date
              show_data.Main_(
                title: "Scheduled to Check-Out", //
                value: _dateValue(schema_w.data[schema_w.CHECK_OUT_DATE]?["value"]),
              ),

              // room price total
              show_data.Main_(
                title: "Room Price Total (USD)", //
                value: schema_w.data[schema_w.ROOM_PRICE_TOTAL_USD]?["value"]?.toString() ?? "0",
              ),

              // room paid total
              show_data.Main_(
                title: "Room Paid Total (USD)", //
                value: schema_w.data[schema_w.ROOM_PAID_TOTAL_USD]?["value"]?.toString() ?? "0",
              ),

              // room return total
              show_data.Main_(
                title: "Room Returned Total (USD)", //
                value: schema_w.data[schema_w.ROOM_RETURN_TOTAL_USD]?["value"]?.toString() ?? "0",
              ),

              // room balance total
              show_data.Main_(
                title: "Room Balanced Total (USD)", //
                value: schema_w.data[schema_w.ROOM_BALANCE_TOTAL_USD]?["value"]?.toString() ?? "0",
              ),

              // check-in by
              show_data.Main_(
                title: "Check-In By", //
                value: user_r.data[user_r.FULL_NAME]?["value"]?.toString() ?? "System",
              ),

              // check-in at
              show_data.Main_(
                title: "Check-In At", //
                value: _dateValue(schema_w.data[schema_w.CHECK_IN_AT]?["value"]),
              ),

              // Get payment by
              if (schema_w.data[schema_w.ROOM_PAID_AT]?["value"] != null)
                show_data.Main_(
                  title: "Get Payment By", //
                  value: user_r.data[user_r.FULL_NAME]?["value"]?.toString() ?? "System",
                ),

              // get payment at
              if (schema_w.data[schema_w.ROOM_PAID_AT]?["value"] != null)
                show_data.Main_(
                  title: "Get Payment At", //
                  value: _dateValue(schema_w.data[schema_w.ROOM_PAID_AT]?["value"]),
                ),
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
      final response = await dio.post("/front_desk/create", data: FormData.fromMap(output));

      //
      var status = "Pending Pay";
      if (output[schema_w.ROOM_PAID_AT]?.isNotEmpty ?? false) status = "Pending Leave";

      //
      await dio.post(
        "/room/update", //
        data: FormData.fromMap({
          "_id": output[schema_w.ROOM_LINK], //
          r_schema_r.STATUS: status, //
          r_schema_r.FRONT_DESK_ID: response.data["_id"],
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
