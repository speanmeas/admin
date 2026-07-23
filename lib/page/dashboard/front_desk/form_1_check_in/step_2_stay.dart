import "package:dio/dio.dart";
import "package:flutter/material.dart";
// import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__config__.dart";
// import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

// import "package:speanmeas/page/auth/user.g.dart" as user;

import "../__config__.dart";
import "../schema.w.dart" as schema_w;
import "package:speanmeas/page/room/schema.r.dart" as r_schema_r;
import "package:speanmeas/page/guest/schema.r.dart" as g_schema_r;
import "package:speanmeas/page/auth/schema.r.dart" as user_r;

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
                  initialValue: schema_w.data[schema_w.NUMBER_OF_GUESTS]?["value"]?.toInt(),
                  onChanged: (v) {
                    schema_w.data[schema_w.NUMBER_OF_GUESTS]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),

              // stay duration days
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: select_stay_duration_days.Main_(
                  initialValue: schema_w.data[schema_w.STAY_DAY]?["value"]?.toInt(),
                  onChanged: (v) {
                    schema_w.data[schema_w.STAY_DAY]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),

              // stay duration hours
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: select_stay_duration_hours.Main_(
                  initialValue: schema_w.data[schema_w.STAY_HOUR]?["value"]?.toInt(),
                  onChanged: (v) {
                    schema_w.data[schema_w.STAY_HOUR]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: input_note.Main_(
                  initialValue: schema_w.data[schema_w.CHECK_IN_NOTE]?["value"]?.toString(),
                  onChanged: (v) {
                    schema_w.data[schema_w.CHECK_IN_NOTE]?["value"] = v;
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
    double number_of_guests = double.tryParse(schema_w.data[schema_w.NUMBER_OF_GUESTS]?["value"]?.toString() ?? "0") ?? 0;
    if (number_of_guests == 0) return false;

    double stay_duration_days = double.tryParse(schema_w.data[schema_w.STAY_DAY]?["value"]?.toString() ?? "0") ?? 0;
    double stay_duration_hours = double.tryParse(schema_w.data[schema_w.STAY_HOUR]?["value"]?.toString() ?? "0") ?? 0;
    if (stay_duration_days == 0 && stay_duration_hours == 0) return false;

    return true;
  }

  void on_next() async {
    try {
      //
      int stay_duration_days = schema_w.data[schema_w.STAY_DAY]?["value"]?.toInt() ?? 0;
      int stay_duration_hours = schema_w.data[schema_w.STAY_HOUR]?["value"]?.toInt() ?? 0;
      double room_price_per_day_usd = r_schema_r.data[r_schema_r.USD_PER_DAY]?["value"]?.toDouble() ?? 0;
      double room_price_per_3h_usd = r_schema_r.data[r_schema_r.USD_PER_3H]?["value"]?.toDouble() ?? 0;

      double room_price_total_usd = (stay_duration_days * room_price_per_day_usd) + ((stay_duration_hours / 3) * room_price_per_3h_usd);
      schema_w.data[schema_w.ROOM_PRICE_TOTAL_USD]?["value"] = room_price_total_usd;

      // schema_w.data[schema_w.STAY_SCHEDULE_CHECK_OUT]?["value"] = DateFormat(DATE_FORMAT).format(schedule_check_out);
      // schema_w.data[schema_w.CHECK_IN_AT]?["value"] = DateFormat(DATE_FORMAT).format(now);

      // todo: should it move to backend?
      var r = await dio.post("/setting/now");
      if (DateTime.tryParse(r.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(r.data.toString())!;
      schema_w.data[schema_w.CHECK_OUT_DATE]?["value"] = now.add(Duration(days: stay_duration_days, hours: stay_duration_hours));

      if (user_r.data[user_r.ID]!["value"] != null) //
        schema_w.data[schema_w.CHECK_IN_BY_LINK]?["value"] = user_r.data[user_r.ID]!["value"];

      schema_w.data[schema_w.CHECK_IN_AT]?["value"] = now.toLocal();

      for (var e in schema_w.data.entries) print(e);
      // if (user_r.data[user_r.FULL_NAME]!["value"] != null) //
      //   schema_w.data[schema_w.CHECK_IN_BY]?["value"] = user_r.data[user_r.FULL_NAME]!["value"];

      Navigator.push(context, MaterialPageRoute(builder: (context) => step_3.Main_()));

      //
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
      home: Main_(),
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
