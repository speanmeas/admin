import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/select_dynamic.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/show_data.dart";
import "package:speanmeas/core/endpoint.g.dart";

import "package:speanmeas/features/database/guest/schema.g.dart" as sm_g;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "../schema.g.dart" as sm_fd;
import "../widget/guest_search.dart" as g_search;

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
            spacing: 8,
            children: children, //
          ),
        ),
      ),
    ),
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  final c_g_search = TextEditingController();
  final c_n_o_guest = TextEditingController();
  final c_d_day = TextEditingController();
  final c_d_hour = TextEditingController();
  final c_note = TextEditingController();

  void init() async {
    sm_fd.clear();
    sm_r.clear();

    tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
    for (var e in sm_r.data.entries) e.value["value"] = tmp.data[0][e.key];

    c_g_search.text = sm_g.data[sm_g.PHONE_NUMBER]?["value"]?.toString() ?? "";

    sm_fd.data[sm_fd.STAY_N_GUEST]?["value"] = 1;
    c_n_o_guest.text = sm_fd.data[sm_fd.STAY_N_GUEST]?["value"]?.toString() ?? "";
    c_d_day.text = sm_fd.data[sm_fd.STAY_DAY]?["value"]?.toString() ?? "";
    c_d_hour.text = sm_fd.data[sm_fd.STAY_HOUR]?["value"]?.toString() ?? "";
    c_note.text = sm_fd.data[sm_fd.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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

      // [x] update to search with phone and name
      g_search.Main_(
        controller: c_g_search,
        onChanged: (v) {
          sm_fd.data[sm_fd.GUEST_ID]?["value"] = v[sm_g.ID];
          sm_fd.data[sm_fd.GUEST_FULL_NAME]?["value"] = v[sm_g.FULL_NAME];
          sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"] = v[sm_g.PHONE_NUMBER];
          sm_fd.data[sm_fd.GUEST_GENDER]?["value"] = v[sm_g.GENDER];
          sm_fd.data[sm_fd.GUEST_NATIONALITY]?["value"] = v[sm_g.NATIONALITY];
          setState(() {});
        },
        onCleared: () {
          sm_fd.data[sm_fd.GUEST_ID]?["value"] = null;
          sm_fd.data[sm_fd.GUEST_FULL_NAME]?["value"] = null;
          sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"] = null;
          sm_fd.data[sm_fd.GUEST_GENDER]?["value"] = null;
          sm_fd.data[sm_fd.GUEST_NATIONALITY]?["value"] = null;
          setState(() {});
        },
      ),

      (() {
        String value = "";
        if (sm_fd.data[sm_fd.GUEST_FULL_NAME]?["value"] != null) //
          value = sm_fd.data[sm_fd.GUEST_FULL_NAME]?["value"].toString() ?? "";
        return ShowData(
          title: sm_fd.data[sm_fd.GUEST_FULL_NAME]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"] != null) //
          value = sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
        return ShowData(
          title: sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_fd.data[sm_fd.GUEST_GENDER]?["value"] != null) //
          value = sm_fd.data[sm_fd.GUEST_GENDER]?["value"].toString() ?? "";
        return ShowData(
          title: sm_fd.data[sm_fd.GUEST_GENDER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_fd.data[sm_fd.GUEST_NATIONALITY]?["value"] != null) //
          value = sm_fd.data[sm_fd.GUEST_NATIONALITY]?["value"].toString() ?? "";
        return ShowData(
          title: sm_fd.data[sm_fd.GUEST_NATIONALITY]?["title"] ?? "", //
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

      // number of guests
      SelectDynamic(
        controller: c_n_o_guest,
        title: "Number of Guests:",
        options: List.generate(10, (index) => index + 1),
        onChanged: (v) => setState(() {}), //
        prefixIcon: Icon(Icons.people_outline), //
      ),

      // stay duration days
      SelectDynamic(
        controller: c_d_day,
        title: "Stay Duration (Days):",
        options: List.generate(365, (index) => index),
        onChanged: (v) => setState(() {}), //
        prefixIcon: Icon(Icons.calendar_month_outlined),
      ),

      // stay duration hours
      SelectDynamic(
        controller: c_d_hour,
        title: "Stay Duration (Hours):",
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        onChanged: (v) => setState(() {}), //
        prefixIcon: Icon(Icons.access_time_outlined),
      ),

      // note
      TextField(
        controller: c_note,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "Note:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.note_alt_outlined), //
        ),
        onChanged: (v) => setState(() {}), //
      ),

      // additional information
      OutlinedButton.icon(
        icon: Icon(Icons.login_outlined), //
        label: Text("Check In"), //
        onPressed: can_check_in ? on_check_in : null, //
      ),

      SizedBox(height: height - 100),
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
    try {
      int stay_days = int.tryParse(c_d_day.text) ?? 0;
      int stay_hours = int.tryParse(c_d_hour.text) ?? 0;
      double price_day = double.tryParse(sm_r.data[sm_r.USD_PER_DAY]?["value"].toString() ?? "") ?? 0;
      double price_3hours = double.tryParse(sm_r.data[sm_r.USD_PER_3H]?["value"].toString() ?? "") ?? 0;
      double room_price = (price_day * stay_days) + (price_3hours * stay_hours / 3);

      //
      tmp = await dio.post(
        endpoint.FRONT_DESK_FORM_CHECK_IN, // create
        data: {
          sm_fd.ROOM_ID: widget.room_id, //
          sm_fd.GUEST_ID: sm_fd.data[sm_fd.GUEST_ID]?["value"],
          sm_fd.STAY_N_GUEST: int.tryParse(c_n_o_guest.text),
          sm_fd.STAY_DAY: int.tryParse(c_d_day.text),
          sm_fd.STAY_HOUR: int.tryParse(c_d_hour.text),
          sm_fd.CHECK_IN_NOTE: c_note.text,
          sm_fd.ROOM_PRICE: room_price,
        },
      );

      await dio.post(
        endpoint.ROOM_UPDATE, //
        data: {
          sm_r.ID: widget.room_id, //
          sm_r.STATUS: "Pending Pay", //
          sm_r.FRONT_DESK_ID: tmp.data[0][sm_g.ID], //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

//
class Main_ extends StatefulWidget {
  const Main_({
    super.key,
    this.room_id, //
  });

  final String? room_id;

  @override
  State<Main_> createState() => _Main_State();
}

//
void main() {
  runApp(
    MaterialApp(
      title: "Check In", //
      theme: theme_data, //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
