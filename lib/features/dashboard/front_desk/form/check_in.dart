// * OK

import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/search/search_guest.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

import "package:speanmeas/core/schema/front_desk.g.dart";
// import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

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
  dynamic tmp;
  dynamic map_r;
  bool is_loading = true;
  bool is_submitting = false;

  String? room_number;
  double? price_per_day;
  double? price_per_3hours;

  String? guest_id;
  int? number_of_guest;
  int? stay_days;
  int? stay_hours;
  String? note;

  void init() async {
    try {
      tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
      map_r = tmp.data[0] as Map<String, dynamic>;
      // pprint(map_r);

      room_number = map_r[sm_room.NUMBER] ?? "";
      price_per_day = map_r[sm_room.USD_PER_DAY] ?? 0;
      price_per_3hours = map_r[sm_room.USD_PER_3H] ?? 0;

      number_of_guest = 1;
      stay_days = 0;
      stay_hours = 0;

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
      is_loading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Room: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            room_number ?? "Unknown",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Divider(height: 1, color: Colors.black),

      Select_Dynamic(
        lead: "Number of Guests:",
        init: number_of_guest, //
        options: List.generate(10, (index) => index + 1),
        prefixIcon: Icons.people_outline, //
        onChanged: (v) {
          number_of_guest = v;
          setState(() {});
        },
      ),

      Select_Dynamic(
        lead: "Stay Duration (Days):",
        init: stay_days, //
        options: List.generate(365, (index) => index),
        prefixIcon: Icons.calendar_month_outlined,
        onChanged: (v) {
          stay_days = v;
          setState(() {});
        },
      ),

      Select_Dynamic(
        lead: "Stay Duration (Hours):",
        init: stay_hours,
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        prefixIcon: Icons.access_time_outlined,
        onChanged: (v) {
          stay_hours = v;
          setState(() {});
        },
      ),

      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      Search_Guest(
        onChanged: (v) {
          guest_id = v;
          setState(() {});
        },
      ),

      OutlinedButton.icon(
        icon: Icon(Icons.login_outlined), //
        label: Text(is_submitting ? "Checking In..." : "Check In"), //
        onPressed: (can_check_in && !is_submitting) ? on_check_in : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  double get room_price {
    return ((price_per_day ?? 0) * (stay_days ?? 0)) + ((price_per_3hours ?? 0) * (stay_hours ?? 0) / 3);
  }

  bool get can_check_in {
    if ((number_of_guest ?? 0) <= 0) return false;
    if ((stay_days ?? 0) <= 0 && (stay_hours ?? 0) <= 0) return false;
    return true;
  }

  void on_check_in() async {
    if (is_submitting) return; // double-submit guard
    is_submitting = true;
    setState(() {});

    dynamic front_desk_id; // track created record for rollback
    try {
      tmp = await dio.post(
        endpoint.FRONT_DESK_CHECK_IN, // create
        data: {
          sm_front_desk.ROOM_ID: widget.room_id, //
          sm_front_desk.GUEST_ID: guest_id, //
          sm_front_desk.CHECK_IN_NUMBER: number_of_guest, //
          sm_front_desk.CHECK_IN_DAY: stay_days, //
          sm_front_desk.CHECK_IN_HOUR: stay_hours, //
          sm_front_desk.CHECK_IN_NOTE: note, //
        },
      );

      front_desk_id = tmp.data[0][sm_front_desk.ID];

      await dio.post(
        endpoint.FRONT_DESK_ADD_PAY_ROOM, // update
        data: {
          sm_front_desk.ID: front_desk_id, //
          "pay_price": room_price, //
        },
      );

      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Pending Pay", //
          sm_room.FRONT_DESK_ID: front_desk_id, //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      // compensating rollback: undo the created front_desk record
      if (front_desk_id != null) {
        try {
          await dio.post(
            endpoint.FRONT_DESK_DELETE,
            data: {
              sm_front_desk.ID: front_desk_id, //
            },
          );
        } catch (e2, st2) {
          pprint(st2);
        }
      }
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    } finally {
      is_submitting = false;
      if (mounted) setState(() {});
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
    super.key, //
    this.room_id,
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
      home: Main_(
        room_id: "6a6ec9d7599d64fa5d293fb9", //
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
