import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

import "package:speanmeas/core/widget/input/input_text.dart";

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
  dynamic tmp;
  bool is_loading = true;

  final c_n_o_guest = TextEditingController();
  final c_d_day = TextEditingController();
  final c_d_hour = TextEditingController();
  final c_note = TextEditingController();

  String? front_desk_id;
  double last_price = 0;

  void init() async {
    tmp = await dio.post(
      endpoint.ROOM_CRUD_READ_ID, //
      data: {sm_room.ID: widget.room_id},
    );
    front_desk_id = tmp.data[0][sm_room.FRONT_DESK_ID];

    if (front_desk_id != null) {
      tmp = await dio.post(
        endpoint.FRONT_DESK_READ_ID, //
        data: {sm_front_desk.ID: front_desk_id},
      );

      c_n_o_guest.text = tmp.data[0][sm_front_desk.CHECK_IN_NUMBER]?.toString() ?? "";
      c_d_day.text = tmp.data[0][sm_front_desk.CHECK_IN_DAY]?.toString() ?? "";
      c_d_hour.text = tmp.data[0][sm_front_desk.CHECK_IN_HOUR]?.toString() ?? "";
      c_note.text = tmp.data[0][sm_front_desk.CHECK_IN_NOTE]?.toString() ?? "";

      final price_room_list = tmp.data[0]["price_room"];
      if (price_room_list is List && price_room_list.isNotEmpty) {
        last_price = double.tryParse(price_room_list.last["price"]?.toString() ?? "0") ?? 0;
      }
    }

    is_loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      Select_Dynamic(
        init: int.tryParse(c_n_o_guest.text),
        lead: "Number of Guests:",
        options: List.generate(10, (index) => index + 1),
        onChanged: (v) => setState(() {}), //
        prefixIcon: Icons.people_outline, //
      ),

      Select_Dynamic(
        init: int.tryParse(c_d_day.text),
        lead: "Stay Duration (Days):",
        options: List.generate(365, (index) => index),
        onChanged: (v) => setState(() {}), //
        prefixIcon: Icons.calendar_month_outlined,
      ),

      Select_Dynamic(
        init: int.tryParse(c_d_hour.text),
        lead: "Stay Duration (Hours):",
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        onChanged: (v) => setState(() {}), //
        prefixIcon: Icons.access_time_outlined,
      ),

      Input_Text(
        init: c_note.text, //
        lead: "Note:", //
        prefixIcon: Icons.note_alt_outlined, //
        maxLines: 4, //
        onChanged: (v) => setState(() {}), //
      ),

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
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_CHECK_IN, //
        data: {
          sm_front_desk.ID: front_desk_id, //
          sm_front_desk.CHECK_IN_NUMBER: int.tryParse(c_n_o_guest.text), //
          sm_front_desk.CHECK_IN_DAY: int.tryParse(c_d_day.text), //
          sm_front_desk.CHECK_IN_HOUR: int.tryParse(c_d_hour.text), //
          sm_front_desk.CHECK_IN_NOTE: c_note.text, //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Update Successful", cl: Colors.green);
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
