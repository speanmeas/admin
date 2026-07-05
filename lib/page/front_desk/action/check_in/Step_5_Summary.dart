import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/layout/Layout.dart";

import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "../../__Setup__.dart";
import "../../Schema.g.dart";

import "Step_5a_Receipt.dart" as receipt;

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
    List<Map<String, dynamic>> order = [
      {"key": "room_number", "type": "string", "title": "Room Number"},
      {"key": "room_type", "type": "string", "title": "Room Type"},
      {"key": "room_price_per_day_usd", "type": "number", "title": "Room Price/Day"},
      {"key": "room_price_per_3h_usd", "type": "number", "title": "Room Price/3H"},
      {"key": "room_status", "type": "string", "title": "Room Status"},
      {"key": "room_note", "type": "string", "title": "Room Note"},
      {"key": "stay_duration_day", "type": "number", "title": "Stay (Days)"},
      {"key": "stay_duration_hour", "type": "number", "title": "Stay (Hours)"},
      {"key": "number_of_guests", "type": "number", "title": "Number of Guests"},
      {"key": "schedule_check_out", "type": "date-time", "title": "Schedule Check-out"},
      {"key": "price_total_usd", "type": "number", "title": "Total Price (USD)"},
      {"key": "paid_bank_usd", "type": "number", "title": "Paid Bank (USD)"},
      {"key": "paid_bank_khr", "type": "number", "title": "Paid Bank (KHR)"},
      {"key": "paid_cash_usd", "type": "number", "title": "Paid Cash (USD)"},
      {"key": "paid_cash_khr", "type": "number", "title": "Paid Cash (KHR)"},
      {"key": "paid_total_usd", "type": "number", "title": "Total Paid (USD)"},
      {"key": "return_usd", "type": "number", "title": "Return (USD)"},
      {"key": "return_khr", "type": "number", "title": "Return (KHR)"},
      {"key": "return_total_usd", "type": "number", "title": "Total Return (USD)"},
      {"key": "balance_total_usd", "type": "number", "title": "Total Balance (USD)"},
      {"key": "check_in_at", "type": "date-time", "title": "Check-in At"},
      {"key": "check_in_by", "type": "string", "title": "Check-in By"},
      {"key": "check_in_note", "type": "string", "title": "Check-in Note"},
      {"key": "payment_at", "type": "date-time", "title": "Payment At"},
      {"key": "payment_by", "type": "string", "title": "Payment By"},
      {"key": "payment_note", "type": "string", "title": "Payment Note"},
      {"key": "check_out_at", "type": "date-time", "title": "Check-out At"},
      {"key": "check_out_by", "type": "string", "title": "Check-out By"},
      {"key": "check_out_note", "type": "string", "title": "Check-out Note"},
      {"key": "clean_at", "type": "date-time", "title": "Clean At"},
      {"key": "clean_by", "type": "string", "title": "Clean By"},
      {"key": "clean_note", "type": "string", "title": "Clean Note"},
      {"key": "guest_name", "type": "string", "title": "Guest Name"},
      {"key": "guest_phone", "type": "string", "title": "Guest Phone Number"},
      {"key": "guest_gender", "type": "string", "title": "Guest Gender"},
      {"key": "guest_nationality", "type": "string", "title": "Guest Nationality"},
      {"key": "guest_note", "type": "string", "title": "Guest Note"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "5. Check In - Summary", //
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
              // view search guest result
              ...schema.map((row) {
                //
                if (row["type"] == "string") {
                  // String value = "";
                  String value = row["value"]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row["title"] + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "number") {
                  // String value = "";
                  String value = row["value"]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "boolean") {
                  // String value = "";
                  String value = row["value"]?.toString() ?? "false";
                  value = value.toLowerCase() == "true" ? "Yes" : "No";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "date-time") {
                  // String value = "";
                  String value = row["value"]?.toString() ?? "";
                  if (value.isNotEmpty) {
                    DateTime? tmp = DateTime.tryParse(value);
                    if (tmp != null) {
                      value = DateFormat(DATE_FORMAT).format(tmp.toLocal());
                    }
                  }
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
              }),

              // button check in + print
              // if (can_print())
              //   Container(
              //     margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
              //     child: OutlinedButton.icon(
              //       label: Text("Print"),
              //       icon: Icon(Icons.print_outlined),
              //       onPressed: on_print, //
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  bool can_print() {
    for (var s in schema) {
      if (s["key"] == "ar_total_usd") {
        if (s["value"] != null) {
          if (s["value"] == 0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void on_print() {
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => receipt.Main_()),
    );
  }

  void on_check_in() async {
    // todo: save guest info + stay detail + payment to database

    Map<String, dynamic> output = {for (var s in schema) s["key"]: s["value"]};
    output.remove("_id"); // NOTE: remove id for create new record

    await dio
        .post("/front_desk/data_create", data: FormData.fromMap({...output}))
        .then((r) {
          output["id"] = r.data["id"]; // NOTE: support to main table
          snackbar_show(context: context, message: "Create successfully.", color: Colors.green);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context, output);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "Create failed.", color: Colors.red);
        });

    //
    String? room_id;
    String? get_paid_at;
    for (var s in schema) {
      if (s["key"] == "room_id") room_id = s["value"];
      if (s["key"] == "get_paid_at") get_paid_at = s["value"];
    }

    if (get_paid_at != null && get_paid_at.isNotEmpty) {
      await dio.post(
        "/room/data_update",
        data: FormData.fromMap({
          "id": room_id, //
          "room_status": "Pending Leave",
        }),
      );
    } else {
      await dio.post(
        "/room/data_update",
        data: FormData.fromMap({
          "id": room_id, //
          "room_status": "Pending Pay",
        }),
      );
    }
  }
}
