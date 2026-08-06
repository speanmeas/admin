import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as sb;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;
import "package:speanmeas/core/widget/select_dynamic.dart" as select_dnm;

import "../schema.g.dart" as sm_fd;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Update Stay", //
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

  final c_n_o_guest = TextEditingController();
  final c_d_day = TextEditingController();
  final c_d_hour = TextEditingController();
  final c_note = TextEditingController();

  void init() async {
    try {
      //
      sm_fd.clear();
      sm_r.clear();

      tmp = await dio.post(ep.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
      for (var e in sm_r.data.entries) e.value["value"] = tmp.data[0][e.key];

      tmp = await dio.post(ep.FRONT_DESK_READ_ID, data: {sm_fd.ID: sm_r.data[sm_r.FRONT_DESK_ID]!["value"]});
      for (var e in sm_fd.data.entries) e.value["value"] = tmp.data[0][e.key];

      c_n_o_guest.text = sm_fd.data[sm_fd.STAY_N_GUEST]?["value"]?.toString() ?? "";
      c_d_day.text = sm_fd.data[sm_fd.STAY_DAY]?["value"]?.toString() ?? "";
      c_d_hour.text = sm_fd.data[sm_fd.STAY_HOUR]?["value"]?.toString() ?? "";
      c_note.text = sm_fd.data[sm_fd.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

      setState(() {});
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // number of guests
      select_dnm.Main_(
        controller: c_n_o_guest,
        title: "Number of Guests:",
        options: List.generate(10, (index) => index + 1),
        onChanged: (v) => setState(() {}), //
      ),

      // stay duration days
      select_dnm.Main_(
        controller: c_d_day,
        title: "Stay Duration (Days):",
        options: List.generate(365, (index) => index),
        onChanged: (v) => setState(() {}), //
      ),

      // stay duration hours
      select_dnm.Main_(
        controller: c_d_hour,
        title: "Stay Duration (Hours):",
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        onChanged: (v) => setState(() {}), //
      ),

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
        onSubmitted: (v) => can_update ? on_update() : null, //
      ),

      // additional information
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            icon: Icon(Icons.check), //
            label: Text("Update"), //
            onPressed: can_update ? on_update : null, //
          ),
        ],
      ),
    ]);
  }

  bool get can_update {
    int n_guest = int.tryParse(c_n_o_guest.text) ?? 0;
    int n_day = int.tryParse(c_d_day.text) ?? 0;
    int n_hour = int.tryParse(c_d_hour.text) ?? 0;

    if (n_guest <= 0) return false;
    if (n_day <= 0 && n_hour <= 0) return false;

    return true;
  }

  void on_update() async {
    try {
      int stay_days = int.tryParse(c_d_day.text) ?? 0;
      int stay_hours = int.tryParse(c_d_hour.text) ?? 0;
      double price_day = double.tryParse(sm_r.data[sm_r.USD_PER_DAY]?["value"].toString() ?? "") ?? 0;
      double price_hour = double.tryParse(sm_r.data[sm_r.USD_PER_3H]?["value"].toString() ?? "") ?? 0;
      double room_paid = double.tryParse(sm_fd.data[sm_fd.ROOM_PAY]?["value"].toString() ?? "") ?? 0;
      double room_price = (price_day * stay_days) + (price_hour * stay_hours / 3);

      //
      await dio.post(
        ep.FRONT_DESK_FORM_CHECK_IN_UPDATE, //
        data: {
          sm_fd.ID: sm_fd.data[sm_fd.ID]!["value"], //
          sm_fd.STAY_N_GUEST: int.tryParse(c_n_o_guest.text), //
          sm_fd.STAY_DAY: int.tryParse(c_d_day.text), //
          sm_fd.STAY_HOUR: int.tryParse(c_d_hour.text), //
          sm_fd.ROOM_PRICE: room_price, //
          sm_fd.CHECK_IN_NOTE: c_note.text, //
        },
      );

      //
      if (room_paid != room_price)
        await dio.post(
          ep.ROOM_UPDATE, //
          data: {
            sm_r.ID: sm_r.data[sm_r.ID]!["value"], //
            sm_r.STATUS: "Pending Pay", //
          },
        );

      Navigator.pop(context, true);
      sb.view(context: context, message: "Update Successful", color: Colors.green);
      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
      title: "Development", //
      theme: theme.data(), //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
