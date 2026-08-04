import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep;
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "../schema.g.dart" as sm;
import "package:speanmeas/features/database/guest/schema.g.dart" as sm_g;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "../widget/guest_search.dart" as g_search;
import "../widget/number_select.dart" as n_select;

class _Main_State extends State<Main_> {
  dynamic tmp;

  final c_g_search = TextEditingController();
  final c_n_o_guest = TextEditingController();
  final c_d_day = TextEditingController();
  final c_d_hour = TextEditingController();
  final c_note = TextEditingController();

  void init() async {
    sm.clear();
    sm_g.clear();
    sm_r.clear();

    sm.data[sm.STAY_N_GUEST]?["value"] = 1;

    c_g_search.text = sm_g.data[sm_g.PHONE_NUMBER]?["value"]?.toString() ?? "";
    c_n_o_guest.text = sm.data[sm.STAY_N_GUEST]?["value"]?.toString() ?? "";
    c_d_day.text = sm.data[sm.STAY_DAY]?["value"]?.toString() ?? "";
    c_d_hour.text = sm.data[sm.STAY_HOUR]?["value"]?.toString() ?? "";
    c_note.text = sm.data[sm.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

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
          sm.data[sm.GUEST_ID]?["value"] = v[sm_g.ID];
          sm.data[sm.GUEST_FULL_NAME]?["value"] = v[sm_g.FULL_NAME];
          sm.data[sm.GUEST_PHONE_NUMBER]?["value"] = v[sm_g.PHONE_NUMBER];
          sm.data[sm.GUEST_GENDER]?["value"] = v[sm_g.GENDER];
          sm.data[sm.GUEST_NATIONALITY]?["value"] = v[sm_g.NATIONALITY];
          setState(() {});
        },
        onCleared: () {
          sm.data[sm.GUEST_ID]?["value"] = null;
          sm.data[sm.GUEST_FULL_NAME]?["value"] = null;
          sm.data[sm.GUEST_PHONE_NUMBER]?["value"] = null;
          sm.data[sm.GUEST_GENDER]?["value"] = null;
          sm.data[sm.GUEST_NATIONALITY]?["value"] = null;
          setState(() {});
        },
      ),

      (() {
        String value = "";
        if (sm.data[sm.GUEST_FULL_NAME]?["value"] != null) //
          value = sm.data[sm.GUEST_FULL_NAME]?["value"].toString() ?? "";

        return show_data.Main_(
          title: sm.data[sm.GUEST_FULL_NAME]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm.data[sm.GUEST_PHONE_NUMBER]?["value"] != null) //
          value = sm.data[sm.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
        return show_data.Main_(
          title: sm.data[sm.GUEST_PHONE_NUMBER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm.data[sm.GUEST_GENDER]?["value"] != null) //
          value = sm.data[sm.GUEST_GENDER]?["value"].toString() ?? "";
        return show_data.Main_(
          title: sm.data[sm.GUEST_GENDER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm.data[sm.GUEST_NATIONALITY]?["value"] != null) //
          value = sm.data[sm.GUEST_NATIONALITY]?["value"].toString() ?? "";
        return show_data.Main_(
          title: sm.data[sm.GUEST_NATIONALITY]?["title"] ?? "", //
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
        controller: c_n_o_guest,
        title: "Number of Guests:",
        options: List.generate(10, (index) => index + 1),
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      // stay duration days
      n_select.Main_(
        controller: c_d_day,
        title: "Stay Duration (Days):",
        options: List.generate(365, (index) => index),
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      // stay duration hours
      n_select.Main_(
        controller: c_d_hour,
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
            onPressed: can_check_in ? on_check_in : null, //
          ),
        ],
      ),
    ]);
  }

  bool get can_check_in {
    int n_guest = int.tryParse(c_n_o_guest.text) ?? 0;
    int n_day = int.tryParse(c_d_day.text) ?? 0;
    int n_hour = int.tryParse(c_d_hour.text) ?? 0;

    if (n_guest <= 0) //
      return false;

    if (n_day <= 0 && n_hour <= 0) //
      return false;

    return true;
  }

  void on_check_in() async {
    int stay_days = int.tryParse(c_d_day.text) ?? 0;
    int stay_hours = int.tryParse(c_d_hour.text) ?? 0;
    double? room_price = (widget.price_day! * stay_days) + (widget.price_hour! * stay_hours / 3);

    try {
      //
      final r = await dio.post(
        ep.FRONT_DESK_FORM_CHECK_IN,
        data: {
          sm.ROOM_ID: widget.room_id,
          sm.GUEST_ID: sm.data[sm.GUEST_ID]?["value"],
          sm.STAY_N_GUEST: int.tryParse(c_n_o_guest.text),
          sm.STAY_DAY: int.tryParse(c_d_day.text),
          sm.STAY_HOUR: int.tryParse(c_d_hour.text),
          sm.CHECK_IN_NOTE: c_note.text,
          sm.ROOM_PRICE: room_price,
        },
      );

      await dio.post(
        ep.ROOM_UPDATE, //
        data: {
          sm_r.ID: widget.room_id, //
          sm_r.STATUS: "Pending Pay", //
          sm_r.FRONT_DESK_ID: r.data[0][sm_g.ID], //
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
        "Room Payment", //
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

  final String? room_id;
  final double? price_day;
  final double? price_hour;

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
