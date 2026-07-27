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
import "../../schema.w.dart" as fd_schema_w;
import "../../schema.r.dart" as fd_schema_r;

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
          OutlinedButton.icon(
            icon: Icon(Icons.login_outlined),
            label: Text("Check In"),
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
          child: LinearProgressIndicator(value: 4 / 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
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
                  title: "Room Price/Day (USD)", //
                  value: r_schema_r.data[r_schema_r.USD_PER_DAY]?["value"]?.toString() ?? "",
                ),

                // room price per 3h
                show_data.Main_(
                  title: "Room Price/3H (USD)", //
                  value: r_schema_r.data[r_schema_r.USD_PER_3H]?["value"]?.toString() ?? "",
                ),

                Divider(height: 8, color: Colors.grey),

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

                Divider(height: 8, color: Colors.grey),

                // stay duration (days)
                show_data.Main_(
                  title: "Stay Duration (Days)", //
                  value: fd_schema_w.data[fd_schema_w.STAY_DAY]?["value"]?.toString() ?? "",
                ),

                // stay duration (hours)
                show_data.Main_(
                  title: "Stay Duration (Hours)", //
                  value: fd_schema_w.data[fd_schema_w.STAY_HOUR]?["value"]?.toString() ?? "",
                ),

                // stay guest total
                show_data.Main_(
                  title: "Stay Guest Total", //
                  value: fd_schema_w.data[fd_schema_w.NUMBER_OF_GUESTS]?["value"]?.toString() ?? "",
                ),

                // check in note
                show_data.Main_(
                  title: "Check-In Note", //
                  value: fd_schema_w.data[fd_schema_w.CHECK_IN_NOTE]?["value"]?.toString() ?? "",
                ),

                // check in by
                show_data.Main_(
                  title: "Checked-In By", //
                  value: fd_schema_r.data[fd_schema_r.CHECK_IN_BY]?["value"]?.toString() ?? "",
                ),

                // check-in at
                show_data.Main_(
                  title: "Checked-In At", //
                  value: _dateValue(fd_schema_w.data[fd_schema_w.CHECK_IN_AT]?["value"]),
                ),

                // scheduled check-out date
                show_data.Main_(
                  title: "Scheduled to Check-Out", //
                  value: _dateValue(fd_schema_w.data[fd_schema_w.CHECK_OUT_DATE]?["value"]),
                ),

                Divider(height: 8, color: Colors.grey),

                // room price total
                show_data.Main_(
                  title: "Room Price Total (USD)", //
                  value: fd_schema_w.data[fd_schema_w.ROOM_PRICE_TOTAL_USD]?["value"]?.toString() ?? "",
                ),

                // room paid total
                show_data.Main_(
                  title: "Room Paid Total (USD)", //
                  value: fd_schema_w.data[fd_schema_w.ROOM_PAID_TOTAL_USD]?["value"]?.toString() ?? "",
                ),

                // room return total
                show_data.Main_(
                  title: "Room Returned Total (USD)", //
                  value: fd_schema_w.data[fd_schema_w.ROOM_RETURN_TOTAL_USD]?["value"]?.toString() ?? "",
                ),

                // room balance total
                show_data.Main_(
                  title: "Room Balanced Total (USD)", //
                  value: fd_schema_w.data[fd_schema_w.ROOM_BALANCE_TOTAL_USD]?["value"]?.toString() ?? "",
                ),

                // room paid note
                show_data.Main_(
                  title: "Room Paid Note", //
                  value: fd_schema_w.data[fd_schema_w.ROOM_PAID_NOTE]?["value"]?.toString() ?? "",
                ),

                // room paid by
                show_data.Main_(
                  title: "Received Room Payment By", //
                  value: fd_schema_r.data[fd_schema_r.ROOM_PAID_BY]?["value"]?.toString() ?? "",
                ),

                // check in note
                show_data.Main_(
                  title: "Received Room Payment At", //
                  value: _dateValue(fd_schema_w.data[fd_schema_w.ROOM_PAID_AT]?["value"]),
                ),

                Divider(height: 8, color: Colors.grey),

                // revenue price total
                show_data.Main_(
                  title: "Revenue Price Total (USD)", //
                  value: fd_schema_w.data[fd_schema_w.REVENUE_PRICE_TOTAL_USD]?["value"]?.toString() ?? "",
                ),

                // revenue paid total
                show_data.Main_(
                  title: "Revenue Paid Total (USD)", //
                  value: fd_schema_w.data[fd_schema_w.REVENUE_PAID_TOTAL_USD]?["value"]?.toString() ?? "",
                ),

                // revenue return total
                show_data.Main_(
                  title: "Revenue Returned Total (USD)", //
                  value: fd_schema_w.data[fd_schema_w.REVENUE_RETURN_TOTAL_USD]?["value"]?.toString() ?? "",
                ),

                // revenue balance total
                show_data.Main_(
                  title: "Revenue Balanced Total (USD)", //
                  value: fd_schema_w.data[fd_schema_w.REVENUE_BALANCE_TOTAL_USD]?["value"]?.toString() ?? "",
                ),

                // revenue note
                show_data.Main_(
                  title: "Revenue Note", //
                  value: fd_schema_w.data[fd_schema_w.REVENUE_PAID_NOTE]?["value"]?.toString() ?? "",
                ),

                // revenue paid by
                show_data.Main_(
                  title: "Received Revenue Payment By", //
                  value: fd_schema_r.data[fd_schema_r.REVENUE_PAID_BY]?["value"]?.toString() ?? "",
                ),

                // received revenue payment at
                show_data.Main_(
                  title: "Received Revenue Payment At", //
                  value: _dateValue(fd_schema_w.data[fd_schema_w.REVENUE_PAID_AT]?["value"]),
                ),

                Divider(height: 8, color: Colors.grey),

                // check-out note
                show_data.Main_(
                  title: "Checked-Out Note", //
                  value: fd_schema_w.data[fd_schema_w.CHECK_OUT_NOTE]?["value"]?.toString() ?? "",
                ),

                // check-out by
                show_data.Main_(
                  title: "Checked-Out By", //
                  value: fd_schema_r.data[fd_schema_r.CHECK_OUT_BY]?["value"]?.toString() ?? "",
                ),

                // check-out at
                show_data.Main_(
                  title: "Checked-Out At", //
                  value: _dateValue(fd_schema_w.data[fd_schema_w.CHECK_OUT_AT]?["value"]),
                ),

                Divider(height: 8, color: Colors.grey),

                // cleaned note
                show_data.Main_(
                  title: "Cleaned Note", //
                  value: fd_schema_w.data[fd_schema_w.CLEAN_NOTE]?["value"]?.toString() ?? "",
                ),

                // cleaned by
                show_data.Main_(
                  title: "Cleaned By", //
                  value: fd_schema_r.data[fd_schema_r.CLEAN_BY]?["value"]?.toString() ?? "",
                ),

                // cleaned at
                show_data.Main_(
                  title: "Cleaned At", //
                  value: _dateValue(fd_schema_w.data[fd_schema_w.CLEAN_AT]?["value"]),
                ),
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
      final output = {for (var e in fd_schema_w.data.entries) e.key: e.value["value"]};

      //
      final response = await dio.post("/front_desk/create", data: FormData.fromMap(output));

      //
      var status = "Pending Pay";
      if (output[fd_schema_w.ROOM_PAID_AT]?.isNotEmpty ?? false) status = "Pending Leave";

      //
      await dio.post(
        "/room/update", //
        data: FormData.fromMap({
          "_id": output[fd_schema_w.ROOM_LINK], //
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
