import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/page/main/User.g.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '../../__Setup__.dart';
import '../../Schema.g.dart';

import 'Step_4_Payment_Info.dart' as step_4;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  // keys
  var STAY_DAYS = "stay_day";
  var STAY_HOURS = "stay_hour";
  var STAY_NUM_GUESTS = "number_of_guests";
  var CHECK_OUT_DATE = "schedule_check_out";
  var CHECK_IN_DATE = "check_in_date";
  var CHECK_IN_BY = "check_in_by";
  var CHECK_IN_BY_ID = "check_in_by_id";
  var CHECK_IN_NOTE = "check_in_note";

  var PRICE_TOTAL = "price_total_usd";
  var PRICE_DAY = "room_price_per_day_usd";
  var PRICE_3H = "room_price_per_3h_usd";

  // options
  var NUM_GUESTS = List.generate(10, (index) => (index + 1));
  var DAYS = List.generate(31, (index) => index);
  var HOURS = [0, 3, 6, 9, 12];

  // controllers
  var controller_num_guests = TextEditingController();
  var controller_days = TextEditingController();
  var controller_hours = TextEditingController();
  var controller_note = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    for (var s in schema) {
      if (s["key"] == STAY_NUM_GUESTS) controller_num_guests.text = (s["value"] ?? "").toString();
      if (s["key"] == STAY_DAYS) controller_days.text = (s["value"] ?? "").toString();
      if (s["key"] == STAY_HOURS) controller_hours.text = (s["value"] ?? "").toString();
      if (s["key"] == CHECK_IN_NOTE) controller_note.text = (s["value"] ?? "").toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "3. Check In - Staying", //
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
                child: TypeAheadField<String>(
                  controller: controller_num_guests,
                  suggestionsCallback: (q) {
                    return NUM_GUESTS.map((o) => o.toString()).where((o) => o.contains(q)).toList();
                  },
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                      decoration: InputDecoration(
                        labelText: "Number of Guests:", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.arrow_drop_down), //
                      ),
                      onChanged: (_) => setState(() {}),
                    );
                  },
                  itemBuilder: (context, item) {
                    return ListTile(title: Text(item));
                  },
                  onSelected: (selected) {
                    controller_num_guests.text = selected;
                    setState(() {});
                  },
                ),
              ),

              // stay duration days
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TypeAheadField<String>(
                  controller: controller_days,
                  suggestionsCallback: (q) {
                    return DAYS.map((o) => o.toString()).where((o) => o.contains(q)).toList();
                  },
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                      decoration: InputDecoration(
                        labelText: "Stay Duration (Days):", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.arrow_drop_down), //
                      ),
                      onChanged: (_) => setState(() {}),
                    );
                  },
                  itemBuilder: (context, item) {
                    return ListTile(title: Text(item));
                  },
                  onSelected: (selected) {
                    controller_days.text = selected;
                    setState(() {});
                  },
                ),
              ),

              // stay duration hour
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TypeAheadField<String>(
                  controller: controller_hours,
                  suggestionsCallback: (q) {
                    return HOURS.map((o) => o.toString()).where((o) => o.contains(q)).toList();
                  },
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                      decoration: InputDecoration(
                        labelText: "Stay Duration (Hours):", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.arrow_drop_down), //
                      ),
                      onChanged: (_) => setState(() {}),
                    );
                  },
                  itemBuilder: (context, item) {
                    return ListTile(title: Text(item));
                  },
                  onSelected: (selected) {
                    controller_hours.text = selected;
                    setState(() {});
                  },
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_note,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Note:", //
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool can_next() {
    double stay_duration_days = double.tryParse(controller_days.text) ?? 0;
    double stay_duration_hours = double.tryParse(controller_hours.text) ?? 0;
    double number_of_guests = double.tryParse(controller_num_guests.text) ?? 0;

    if (stay_duration_days == 0 && stay_duration_hours == 0) return false;
    if (number_of_guests == 0) return false;

    return true;
  }

  void on_next() async {
    //
    // double stay_duration_days = double.tryParse(controller_days.text) ?? 0;
    // double stay_duration_hours = double.tryParse(controller_hours.text) ?? 0;
    // double number_of_guests = double.tryParse(controller_num_guests.text) ?? 0;

    // DateTime check_in_date = DateTime.now();
    // DateTime schedule_check_out = DateTime.now();

    // if (stay_duration_days > 0) {
    //   schedule_check_out = schedule_check_out.add(Duration(days: stay_duration_days.toInt()));
    //   schedule_check_out = DateTime(schedule_check_out.year, schedule_check_out.month, schedule_check_out.day, 12, 0);
    //   schedule_check_out = schedule_check_out.add(Duration(hours: stay_duration_hours.toInt()));
    //   // print("schedule_check_out: $schedule_check_out");
    // }

    // if (stay_duration_days == 0) {
    //   schedule_check_out = schedule_check_out.add(Duration(hours: stay_duration_hours.toInt()));
    //   // print("schedule_check_out: $schedule_check_out");
    // }

    // double price_total_usd = 0;
    // double price_per_day_usd = 0;
    // double price_per_3h_usd = 0;

    // for (var s in schema) {
    //   if (s["key"] == PRICE_DAY) price_per_day_usd = s["value"] ?? 0;
    //   if (s["key"] == PRICE_3H) price_per_3h_usd = s["value"] ?? 0;
    // }

    // print("price_per_day_usd: $price_per_day_usd");
    // print("price_per_3h_usd: $price_per_3h_usd");
    // print("stay_duration_days: $stay_duration_days");
    // print("stay_duration_hours: $stay_duration_hours");

    // price_total_usd = (stay_duration_days * price_per_day_usd) + ((stay_duration_hours / 3) * price_per_3h_usd);

    // print(price_total_usd);

    // for (var s in schema) {
    //   if (s["key"] == STAY_DAYS) s["value"] = stay_duration_days;
    //   if (s["key"] == STAY_HOURS) s["value"] = stay_duration_hours;
    //   if (s["key"] == STAY_NUM_GUESTS) s["value"] = number_of_guests;
    //   if (s["key"] == CHECK_OUT_DATE) s["value"] = schedule_check_out.toIso8601String();
    //   if (s["key"] == PRICE_TOTAL) s["value"] = price_total_usd;
    //   if (s["key"] == CHECK_IN_NOTE) s["value"] = controller_note.text;
    //   if (s["key"] == CHECK_IN_DATE) s["value"] = check_in_date.toIso8601String();
    //   if (s["key"] == CHECK_IN_BY) s["value"] = user["full_name"]!;
    //   if (s["key"] == CHECK_IN_BY_ID) s["value"] = user["_id"]!;
    // }

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => step_4.Main_()),
    );
  }
}
