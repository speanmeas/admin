import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/select_dynamic.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/showdata.dart";
import "package:speanmeas/core/endpoint.g.dart";

import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

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
    sm_front_desk.clear();
    sm_room.clear();

    tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_front_desk.ID: widget.room_id});
    for (var e in sm_room.data.entries) e.value["value"] = tmp.data[0][e.key];

    c_g_search.text = sm_guest.data[sm_guest.PHONE_NUMBER]?["value"]?.toString() ?? "";

    sm_front_desk.data[sm_front_desk.STAY_N_GUEST]?["value"] = 1;
    c_n_o_guest.text = sm_front_desk.data[sm_front_desk.STAY_N_GUEST]?["value"]?.toString() ?? "";
    c_d_day.text = sm_front_desk.data[sm_front_desk.STAY_DAY]?["value"]?.toString() ?? "";
    c_d_hour.text = sm_front_desk.data[sm_front_desk.STAY_HOUR]?["value"]?.toString() ?? "";
    c_note.text = sm_front_desk.data[sm_front_desk.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

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
          sm_front_desk.data[sm_front_desk.GUEST_ID]?["value"] = v[sm_guest.ID];
          sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["value"] = v[sm_guest.FULL_NAME];
          sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"] = v[sm_guest.PHONE_NUMBER];
          sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["value"] = v[sm_guest.GENDER];
          sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["value"] = v[sm_guest.NATIONALITY];
          setState(() {});
        },
        onCleared: () {
          sm_front_desk.data[sm_front_desk.GUEST_ID]?["value"] = null;
          sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["value"] = null;
          sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"] = null;
          sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["value"] = null;
          sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["value"] = null;
          setState(() {});
        },
      ),

      (() {
        String value = "";
        if (sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["value"] != null) //
          value = sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["value"].toString() ?? "";
        return Show_Data(
          title: sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"] != null) //
          value = sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
        return Show_Data(
          title: sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["value"] != null) //
          value = sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["value"].toString() ?? "";
        return Show_Data(
          title: sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["value"] != null) //
          value = sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["value"].toString() ?? "";
        return Show_Data(
          title: sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["title"] ?? "", //
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

      Divider(color: Colors.black),

      // * បង្ហាញតម្លៃបន្ទប់ដែលគណនាដោយស្វ័យប្រវត្តិ
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Room Price: ", //
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          Text(
            "${room_price.toStringAsFixed(2)} \$", //
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
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

  // * គណនាតម្លៃបន្ទប់ (ថ្ងៃ x តម្លៃថ្ងៃ + ម៉ោង x តម្លៃ 3 ម៉ោង)
  double get room_price {
    int stay_days = int.tryParse(c_d_day.text) ?? 0;
    int stay_hours = int.tryParse(c_d_hour.text) ?? 0;
    double price_day = double.tryParse(sm_room.data[sm_room.USD_PER_DAY]?["value"].toString() ?? "") ?? 0;
    double price_3hours = double.tryParse(sm_room.data[sm_room.USD_PER_3H]?["value"].toString() ?? "") ?? 0;
    return (price_day * stay_days) + (price_3hours * stay_hours / 3);
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
      double room_price = this.room_price;

      //
      tmp = await dio.post(
        endpoint.FRONT_DESK_FORM_CHECK_IN, // create
        data: {
          sm_front_desk.ROOM_ID: widget.room_id, //
          sm_front_desk.GUEST_ID: sm_front_desk.data[sm_front_desk.GUEST_ID]?["value"],
          sm_front_desk.STAY_N_GUEST: int.tryParse(c_n_o_guest.text),
          sm_front_desk.STAY_DAY: int.tryParse(c_d_day.text),
          sm_front_desk.STAY_HOUR: int.tryParse(c_d_hour.text),
          sm_front_desk.CHECK_IN_NOTE: c_note.text,
          sm_front_desk.ROOM_PRICE: room_price,
        },
      );

      await dio.post(
        endpoint.ROOM_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Pending Pay", //
          sm_room.FRONT_DESK_ID: tmp.data[0][sm_guest.ID], //
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
