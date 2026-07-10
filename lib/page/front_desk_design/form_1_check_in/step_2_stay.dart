import "package:dio/dio.dart";
import "package:flutter/material.dart";
// import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/environment.dart";
// import "package:speanmeas/global.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "package:speanmeas/page/auth/user.g.dart" as user;

import "../_setup.dart";
import "../schema.g.dart" as schema;

import "step_3_room_payment.dart" as step_3;

import "widget/select_number_of_guest.dart" as select_number_of_guest;
import "widget/select_stay_duration_days.dart" as select_stay_duration_days;
import "widget/select_stay_duration_hours.dart" as select_stay_duration_hours;
import "widget/input_note.dart" as input_note;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "2. Check In - Staying", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          if (can_next())
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: OutlinedButton.icon(
                icon: Icon(Icons.arrow_right_alt_outlined),
                label: Text("Next"),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                onPressed: on_next,
              ),
            ),
        ],

        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // number of guests
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: select_number_of_guest.Main_(
                  initialValue: schema.data[schema.STAY_NUMBER_OF_GUESTS]?["value"]?.toInt(),
                  onChanged: (v) {
                    schema.data[schema.STAY_NUMBER_OF_GUESTS]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),

              // stay duration days
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: select_stay_duration_days.Main_(
                  initialValue: schema.data[schema.STAY_DURATION_DAY]?["value"]?.toInt(),
                  onChanged: (v) {
                    schema.data[schema.STAY_DURATION_DAY]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),

              // stay duration hours
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: select_stay_duration_hours.Main_(
                  initialValue: schema.data[schema.STAY_DURATION_HOUR]?["value"]?.toInt(),
                  onChanged: (v) {
                    schema.data[schema.STAY_DURATION_HOUR]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: input_note.Main_(
                  initialValue: schema.data[schema.CHECK_IN_NOTE]?["value"]?.toString(),
                  onChanged: (v) {
                    schema.data[schema.CHECK_IN_NOTE]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool can_next() {
    double number_of_guests = double.tryParse(schema.data[schema.STAY_NUMBER_OF_GUESTS]?["value"]?.toString() ?? "0") ?? 0;
    if (number_of_guests == 0) return false;

    double stay_duration_days = double.tryParse(schema.data[schema.STAY_DURATION_DAY]?["value"]?.toString() ?? "0") ?? 0;
    double stay_duration_hours = double.tryParse(schema.data[schema.STAY_DURATION_HOUR]?["value"]?.toString() ?? "0") ?? 0;
    if (stay_duration_days == 0 && stay_duration_hours == 0) return false;

    return true;
  }

  void on_next() async {
    await dio
        .post("/variable/datetime_now")
        .then((r) {
          // DateTime? now = DateTime.tryParse(r.data.toString());

          double number_of_guests = double.tryParse(schema.data[schema.STAY_NUMBER_OF_GUESTS]?["value"]?.toString() ?? "0") ?? 0;
          double stay_duration_days = double.tryParse(schema.data[schema.STAY_DURATION_DAY]?["value"]?.toString() ?? "0") ?? 0;
          double stay_duration_hours = double.tryParse(schema.data[schema.STAY_DURATION_HOUR]?["value"]?.toString() ?? "0") ?? 0;

          DateTime? check_in_date = DateTime.tryParse(r.data.toString());
          DateTime? schedule_check_out = DateTime.tryParse(r.data.toString());

          if (stay_duration_days > 0) {
            schedule_check_out = schedule_check_out?.add(Duration(days: stay_duration_days.toInt()));
            schedule_check_out = DateTime(schedule_check_out!.year, schedule_check_out.month, schedule_check_out.day, 12, 0);
            schedule_check_out = schedule_check_out.add(Duration(hours: stay_duration_hours.toInt()));
          }

          if (stay_duration_days == 0) {
            schedule_check_out = schedule_check_out?.add(Duration(hours: stay_duration_hours.toInt()));
          }

          double room_price_per_day_usd = schema.data[schema.ROOM_PRICE_PER_DAY_USD]?["value"]?.toDouble() ?? 0;
          double room_price_per_3h_usd = schema.data[schema.ROOM_PRICE_PER_3H_USD]?["value"]?.toDouble() ?? 0;
          double room_price_total_usd = (stay_duration_days * room_price_per_day_usd) + ((stay_duration_hours / 3) * room_price_per_3h_usd);

          schema.data[schema.STAY_NUMBER_OF_GUESTS]?["value"] = number_of_guests;
          schema.data[schema.STAY_DURATION_HOUR]?["value"] = stay_duration_hours;
          schema.data[schema.STAY_DURATION_DAY]?["value"] = stay_duration_days;
          if (schedule_check_out != null) schema.data[schema.STAY_SCHEDULE_CHECK_OUT]?["value"] = DateFormat(DATE_FORMAT).format(schedule_check_out);
          if (check_in_date != null) schema.data[schema.CHECK_IN_AT]?["value"] = DateFormat(DATE_FORMAT).format(check_in_date);
          if (user.data[user.ID]!["value"] != null) schema.data[schema.CHECK_IN_BY_ID]?["value"] = user.data[user.ID]!["value"];
          if (user.data[user.USER_FULL_NAME]!["value"] != null) schema.data[schema.CHECK_IN_BY]?["value"] = user.data[user.USER_FULL_NAME]!["value"];
          schema.data[schema.ROOM_PRICE_TOTAL_USD]?["value"] = room_price_total_usd;

          // for (var e in schema.data.entries) print(e);

          Navigator.push(
            context, //
            MaterialPageRoute(builder: (context) => step_3.Main_()),
          );
        })
        .catchError((e) {
          snackbar_show(context: context, message: e.toString(), color: Colors.red);
        });
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
