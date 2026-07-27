import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/page/room/schema.r.dart" as r_schema_r;
import "package:speanmeas/page/guest/schema.r.dart" as g_schema_r;
import "package:speanmeas/page/auth/schema.r.dart" as user_r;

import "../../__config__.dart";
import "../../schema.w.dart" as fd_schema_w;
import "../../schema.r.dart" as fd_schema_r;

import "3_payment.dart" as step_3;

import "widget/select_number.dart" as select_number;

class _Main_State extends State<Main_> {
  final c_number_of_guests = TextEditingController();
  final c_stay_duration_days = TextEditingController();
  final c_stay_duration_hours = TextEditingController();
  final c_note = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    c_number_of_guests.text = fd_schema_w.data[fd_schema_w.NUMBER_OF_GUESTS]?["value"]?.toString() ?? "1";
    c_stay_duration_days.text = fd_schema_w.data[fd_schema_w.STAY_DAY]?["value"]?.toString() ?? "";
    c_stay_duration_hours.text = fd_schema_w.data[fd_schema_w.STAY_HOUR]?["value"]?.toString() ?? "";
    c_note.text = fd_schema_w.data[fd_schema_w.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "2. Staying", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: OutlinedButton.icon(
              icon: Icon(Icons.arrow_right_alt_outlined),
              label: Text("Next"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: can_next() ? on_next : null,
            ),
          ),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
        //
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2), //
          child: LinearProgressIndicator(value: 2 / 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                // number of guests
                SizedBox(height: 8),
                select_number.Main_(
                  controller: c_number_of_guests,
                  title: "Number of Guests:",
                  options: List.generate(10, (index) => index + 1),
                  onChanged: (v) => setState(() {}), //
                ),

                // stay duration days
                SizedBox(height: 8),
                select_number.Main_(
                  controller: c_stay_duration_days,
                  title: "Stay Duration (Days):",
                  options: List.generate(365, (index) => index),
                  onChanged: (v) => setState(() {}), //
                ),

                // stay duration hours
                SizedBox(height: 8),
                select_number.Main_(
                  controller: c_stay_duration_hours,
                  title: "Stay Duration (Hours):",
                  options: [0, 3, 6, 9, 12, 15, 18, 21],
                  onChanged: (v) => setState(() {}), //
                ),

                // note
                SizedBox(height: 8),
                TextField(
                  controller: c_note,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Note:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) => setState(() {}), //
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool can_next() {
    double number_of_guests = double.tryParse(c_number_of_guests.text.trim()) ?? 0;
    if (number_of_guests == 0) return false;

    double stay_duration_days = double.tryParse(c_stay_duration_days.text.trim()) ?? 0;
    double stay_duration_hours = double.tryParse(c_stay_duration_hours.text.trim()) ?? 0;
    if (stay_duration_days == 0 && stay_duration_hours == 0) return false;

    return true;
  }

  void on_next() async {
    try {
      //
      int stay_duration_days = int.tryParse(c_stay_duration_days.text.trim()) ?? 0;
      int stay_duration_hours = int.tryParse(c_stay_duration_hours.text.trim()) ?? 0;
      double room_price_per_day_usd = r_schema_r.data[r_schema_r.USD_PER_DAY]?["value"]?.toDouble() ?? 0;
      double room_price_per_3h_usd = r_schema_r.data[r_schema_r.USD_PER_3H]?["value"]?.toDouble() ?? 0;

      // calculate total price
      double room_price_total_usd = (stay_duration_days * room_price_per_day_usd) + ((stay_duration_hours / 3) * room_price_per_3h_usd);

      var r = await dio.post("/setting/now");
      if (DateTime.tryParse(r.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(r.data.toString())!;

      fd_schema_w.data[fd_schema_w.STAY_DAY]?["value"] = stay_duration_days;
      fd_schema_w.data[fd_schema_w.STAY_HOUR]?["value"] = stay_duration_hours;
      fd_schema_w.data[fd_schema_w.NUMBER_OF_GUESTS]?["value"] = double.tryParse(c_number_of_guests.text.trim());
      fd_schema_w.data[fd_schema_w.CHECK_IN_BY_ID]?["value"] = user_r.data[user_r.ID]?["value"]?.toString();
      fd_schema_r.data[fd_schema_r.CHECK_IN_BY]?["value"] = user_r.data[user_r.FULL_NAME]?["value"]?.toString();
      fd_schema_w.data[fd_schema_w.CHECK_IN_AT]?["value"] = now.toLocal();
      fd_schema_w.data[fd_schema_w.CHECK_OUT_DATE]?["value"] = now.add(Duration(days: stay_duration_days, hours: stay_duration_hours));

      fd_schema_w.data[fd_schema_w.ROOM_PRICE_TOTAL_USD]?["value"] = room_price_total_usd;

      //
      await Navigator.push(context, MaterialPageRoute(builder: (context) => step_3.Main_()));

      //
      init();

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
