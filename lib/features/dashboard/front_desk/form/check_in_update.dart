import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/select_dynamic.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

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

      tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
      for (var e in sm_r.data.entries) e.value["value"] = tmp.data[0][e.key];

      tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_fd.ID: sm_r.data[sm_r.FRONT_DESK_ID]!["value"]});
      for (var e in sm_fd.data.entries) e.value["value"] = tmp.data[0][e.key];

      c_n_o_guest.text = sm_fd.data[sm_fd.STAY_N_GUEST]?["value"]?.toString() ?? "";
      c_d_day.text = sm_fd.data[sm_fd.STAY_DAY]?["value"]?.toString() ?? "";
      c_d_hour.text = sm_fd.data[sm_fd.STAY_HOUR]?["value"]?.toString() ?? "";
      c_note.text = sm_fd.data[sm_fd.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
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
          prefixIcon: Icon(Icons.note_alt_outlined),
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_update ? on_update() : null, //
      ),

      // additional information
      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text("Update"), //
        onPressed: can_update ? on_update : null, //
      ),

      SizedBox(height: height - 100),
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
      double price_3hours = double.tryParse(sm_r.data[sm_r.USD_PER_3H]?["value"].toString() ?? "") ?? 0;
      double room_paid = double.tryParse(sm_fd.data[sm_fd.ROOM_PAY_TOTAL]?["value"].toString() ?? "") ?? 0;
      double room_price = (price_day * stay_days) + (price_3hours * stay_hours / 3);

      // * ធ្វើការផ្លាស់ប្តូរទិន្នន័យនៅក្នុង Front Desk Table នៅលើ Database
      await dio.post(
        endpoint.FRONT_DESK_FORM_CHECK_IN_UPDATE, //
        data: {
          sm_fd.ID: sm_fd.data[sm_fd.ID]!["value"], //
          sm_fd.STAY_N_GUEST: int.tryParse(c_n_o_guest.text), //
          sm_fd.STAY_DAY: int.tryParse(c_d_day.text), //
          sm_fd.STAY_HOUR: int.tryParse(c_d_hour.text), //
          sm_fd.ROOM_PRICE: room_price, //
          sm_fd.CHECK_IN_NOTE: c_note.text, //
        },
      );

      // * ប្រៀបធៀបដោយ tolerance (0.00001$) ដើម្បីចៀសវាងបញ្ហា floating point
      const double epsilon = 0.00001;

      // * ត្រឡប់ទៅ Pending Pay តែពេលបង់មិនទាន់គ្រប់ (ចៀសវាងការធ្លាក់ពេលអតិថិជនបង់លើស)
      final bool is_underpaid = room_paid < room_price - epsilon;

      // * ប្រសិនបើលុយបានបង់គ្រប់ ឬ បង់លើស ត្រឡប់ទៅ Pending Leave វិញ
      if (is_underpaid)
        await dio.post(
          endpoint.ROOM_UPDATE, //
          data: {
            sm_r.ID: sm_r.data[sm_r.ID]!["value"], //
            sm_r.STATUS: "Pending Pay", //
          },
        );

      Navigator.pop(context, true); // * បិទ Form នេះ
      snackbar(ct: context, ms: "Update Successful", cl: Colors.green); // * បង្ហាញសារ Success
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
      title: "Development", //
      theme: theme_data, //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
