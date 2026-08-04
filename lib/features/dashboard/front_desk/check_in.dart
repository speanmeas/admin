import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "schema.g.dart" as schema;

import "package:speanmeas/features/database/guest/schema.g.dart" as g_schema;
import "package:speanmeas/features/database/room/schema.g.dart" as r_schema;

// import "2_staying.dart" as step_2;
import "widget/guest_search.dart" as g_search;

import "widget/number_select.dart" as n_select;

class _Main_State extends State<Main_> {
  final c_g_search = TextEditingController();

  final c_number_of_guests = TextEditingController();
  final c_stay_duration_days = TextEditingController();
  final c_stay_duration_hours = TextEditingController();
  final c_note = TextEditingController();

  void init() async {
    c_g_search.text = g_schema.data[g_schema.PHONE_NUMBER]?["value"]?.toString() ?? "";

    c_number_of_guests.text = schema.data[schema.STAY_N_GUEST]?["value"]?.toString() ?? "1";
    c_stay_duration_days.text = schema.data[schema.STAY_DAY]?["value"]?.toString() ?? "";
    c_stay_duration_hours.text = schema.data[schema.STAY_HOUR]?["value"]?.toString() ?? "";
    c_note.text = schema.data[schema.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // guest search
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Guest",
            style: TextStyle(
              fontSize: 20, //
              fontWeight: FontWeight.bold, //
            ),
          ), //
        ],
      ),

      SizedBox(height: 8),

      g_search.Main_(
        controller: c_g_search,
        onChanged: (v) {
          schema.data[schema.GUEST_ID]?["value"] = v[g_schema.ID];
          schema.data[schema.GUEST_FULL_NAME]?["value"] = v[g_schema.FULL_NAME];
          schema.data[schema.GUEST_PHONE_NUMBER]?["value"] = v[g_schema.PHONE_NUMBER];
          schema.data[schema.GUEST_GENDER]?["value"] = v[g_schema.GENDER];
          schema.data[schema.GUEST_NATIONALITY]?["value"] = v[g_schema.NATIONALITY];
          setState(() {});
        },
        onCleared: () {
          schema.data[schema.GUEST_ID]?["value"] = null;
          schema.data[schema.GUEST_FULL_NAME]?["value"] = null;
          schema.data[schema.GUEST_PHONE_NUMBER]?["value"] = null;
          schema.data[schema.GUEST_GENDER]?["value"] = null;
          schema.data[schema.GUEST_NATIONALITY]?["value"] = null;
          setState(() {});
        },
      ),

      (() {
        String value = "";
        if (schema.data[schema.GUEST_FULL_NAME]?["value"] != null) //
          value = schema.data[schema.GUEST_FULL_NAME]?["value"].toString() ?? "";

        return show_data.Main_(
          title: schema.data[schema.GUEST_FULL_NAME]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (schema.data[schema.GUEST_PHONE_NUMBER]?["value"] != null) //
          value = schema.data[schema.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
        return show_data.Main_(
          title: schema.data[schema.GUEST_PHONE_NUMBER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (schema.data[schema.GUEST_GENDER]?["value"] != null) //
          value = schema.data[schema.GUEST_GENDER]?["value"].toString() ?? "";
        return show_data.Main_(
          title: schema.data[schema.GUEST_GENDER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (schema.data[schema.GUEST_NATIONALITY]?["value"] != null) //
          value = schema.data[schema.GUEST_NATIONALITY]?["value"].toString() ?? "";
        return show_data.Main_(
          title: schema.data[schema.GUEST_NATIONALITY]?["title"] ?? "", //
          value: value,
        );
      })(),

      Divider(color: Colors.black),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Stay",
            style: TextStyle(
              fontSize: 20, //
              fontWeight: FontWeight.bold, //
            ),
          ), //
        ],
      ),

      SizedBox(height: 8),
      // number of guests
      n_select.Main_(
        controller: c_number_of_guests,
        title: "Number of Guests:",
        options: List.generate(10, (index) => index + 1),
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      // stay duration days
      n_select.Main_(
        controller: c_stay_duration_days,
        title: "Stay Duration (Days):",
        options: List.generate(365, (index) => index),
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      // stay duration hours
      n_select.Main_(
        controller: c_stay_duration_hours,
        title: "Stay Duration (Hours):",
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      // note
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

      SizedBox(height: 8),

      // additional information
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            icon: Icon(Icons.login_outlined), //
            label: Text("Check In"), //
            onPressed: on_check_in, //
          ),
        ],
      ),
    ]);
  }

  void on_check_in() async {
    int stay_days = int.tryParse(c_stay_duration_days.text) ?? 0;
    int stay_hours = int.tryParse(c_stay_duration_hours.text) ?? 0;
    double? room_price = (widget.price_day! * stay_days) + (widget.price_hour! * stay_hours);

    try {
      //
      final r = await dio.post(
        "/front_desk/form/check_in",
        data: {
          schema.ROOM_ID: widget.room_id,
          schema.GUEST_ID: schema.data[schema.GUEST_ID]?["value"],
          schema.STAY_N_GUEST: int.tryParse(c_number_of_guests.text),
          schema.STAY_DAY: int.tryParse(c_stay_duration_days.text),
          schema.STAY_HOUR: int.tryParse(c_stay_duration_hours.text),
          schema.CHECK_IN_NOTE: c_note.text,
          schema.ROOM_PRICE: room_price,
        },
      );

      await dio.post(
        "/room/update", //
        data: {
          r_schema.ID: widget.room_id, //
          r_schema.STATUS: "Pending Pay", //
          r_schema.FRONT_DESK_ID: r.data[0][g_schema.ID], //
        },
      );

      Navigator.pop(context, true);

      snackbar.view(context: context, message: "Check In Successful", color: Colors.green);

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Check In", //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      centerTitle: false,
      toolbarHeight: 40,
      titleSpacing: 0,

      // Add a divider at the bottom of the app bar
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1), //
        child: Divider(height: 1, color: Colors.black),
      ),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Container(
          width: 600,
          padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Column(
            children: children, //
          ),
        ),
      ),
    ),
  );
}

//
class Main_ extends StatefulWidget {
  Main_({
    super.key,
    this.room_id, //
    this.price_day, //
    this.price_hour, //
  });

  String? room_id;
  double? price_day;
  double? price_hour;

  @override
  State<Main_> createState() => _Main_State();
}

//
void main() {
  runApp(
    MaterialApp(
      title: "Check In", //
      theme: theme.data(), //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
