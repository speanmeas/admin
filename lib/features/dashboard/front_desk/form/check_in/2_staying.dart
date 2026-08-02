import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/features/auth/schema.g.dart" as u_schema;

import "../../__config__.dart";
import "../../schema.g.dart" as schema;

import "3_payment.dart" as step_3;

import "widget/number_select.dart" as n_select;

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
    c_number_of_guests.text = schema.data[schema.NUMBER_OF_GUESTS]?["value"]?.toString() ?? "1";
    c_stay_duration_days.text = schema.data[schema.STAY_DAY]?["value"]?.toString() ?? "";
    c_stay_duration_hours.text = schema.data[schema.STAY_HOUR]?["value"]?.toString() ?? "";
    c_note.text = schema.data[schema.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

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
                n_select.Main_(
                  controller: c_number_of_guests,
                  title: "Number of Guests:",
                  options: List.generate(10, (index) => index + 1),
                  onChanged: (v) => setState(() {}), //
                ),

                // stay duration days
                SizedBox(height: 8),
                n_select.Main_(
                  controller: c_stay_duration_days,
                  title: "Stay Duration (Days):",
                  options: List.generate(365, (index) => index),
                  onChanged: (v) => setState(() {}), //
                ),

                // stay duration hours
                SizedBox(height: 8),
                n_select.Main_(
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
    int number_of_guests = int.tryParse(c_number_of_guests.text.trim()) ?? 0;
    if (number_of_guests == 0) return false;

    int stay_duration_days = int.tryParse(c_stay_duration_days.text.trim()) ?? 0;
    int stay_duration_hours = int.tryParse(c_stay_duration_hours.text.trim()) ?? 0;
    if (stay_duration_days == 0 && stay_duration_hours == 0) return false;

    return true;
  }

  void on_next() async {
    try {
      //
      int stay_duration_days = int.tryParse(c_stay_duration_days.text.trim()) ?? 0;
      int stay_duration_hours = int.tryParse(c_stay_duration_hours.text.trim()) ?? 0;
      double room_price_per_day_usd = schema.data[schema.ROOM_USD_PER_DAY]?["value"]?.toDouble() ?? 0;
      double room_price_per_3h_usd = schema.data[schema.ROOM_USD_PER_3H]?["value"]?.toDouble() ?? 0;

      // calculate total price
      double room_price_total_usd = (stay_duration_days * room_price_per_day_usd) + ((stay_duration_hours / 3) * room_price_per_3h_usd);

      var r = await dio.post(
        "/setting/now", //
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      if (DateTime.tryParse(r.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(r.data.toString())!;

      // Set the values in the working schema
      schema.data[schema.STAY_DAY]?["value"] = stay_duration_days;
      schema.data[schema.STAY_HOUR]?["value"] = stay_duration_hours;
      schema.data[schema.NUMBER_OF_GUESTS]?["value"] = int.tryParse(c_number_of_guests.text.trim());
      schema.data[schema.CHECK_IN_BY_ID]?["value"] = u_schema.data[u_schema.ID]?["value"]?.toString();
      schema.data[schema.CHECK_IN_BY]?["value"] = u_schema.data[u_schema.FULL_NAME]?["value"]?.toString();
      schema.data[schema.CHECK_IN_AT]?["value"] = DateFormat(DATE_FORMAT).format(now.toLocal());
      schema.data[schema.CHECK_OUT_DATE]?["value"] = DateFormat(DATE_FORMAT).format(now.add(Duration(days: stay_duration_days, hours: stay_duration_hours)));

      schema.data[schema.ROOM_PRICE_TOTAL_USD]?["value"] = room_price_total_usd;

      // for (var e in fd_schema_r.data.entries) print(e);

      //
      if (!mounted) return;
      await Navigator.push(context, MaterialPageRoute(builder: (context) => step_3.Main_()));

      //
      init();

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
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
