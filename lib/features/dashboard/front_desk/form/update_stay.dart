// * OK

import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/select/select_dynamic.dart";
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

  dynamic map_r;
  dynamic map_fd;

  String? front_desk_id;
  String? room_number;

  int? number_of_guest;
  int? stay_days;
  int? stay_hours;
  String? note;

  double? price_per_day;
  double? price_per_3hours;

  double? last_paid;

  void init() async {
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
    map_r = tmp.data[0] as Map<String, dynamic>;

    if (map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID] != null) throw Exception("Front desk ID is null");

    tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
    map_fd = tmp.data[0] as Map<String, dynamic>;

    front_desk_id = map_fd[sm_front_desk.ID];
    room_number = map_r[sm_room.NUMBER];

    room_number = map_r[sm_room.NUMBER] ?? "";
    price_per_day = map_r[sm_room.USD_PER_DAY] ?? 0;
    price_per_3hours = map_r[sm_room.USD_PER_3H] ?? 0;

    number_of_guest = map_fd[sm_front_desk.CHECK_IN_NUMBER] ?? 1;
    stay_days = map_fd[sm_front_desk.CHECK_IN_DAY] ?? 0;
    stay_hours = map_fd[sm_front_desk.CHECK_IN_HOUR] ?? 0;
    note = map_fd[sm_front_desk.CHECK_IN_NOTE] ?? "";

    tmp = map_fd[sm_front_desk.PAY_ROOM] as List<dynamic>? ?? [];
    for (var l in tmp) {
      last_paid = (last_paid ?? 0) + (double.tryParse(l["pay_cash"].toString()) ?? 0);
      last_paid = (last_paid ?? 0) + (double.tryParse(l["pay_bank"].toString()) ?? 0);
      last_paid = (last_paid ?? 0) - (double.tryParse(l["pay_return"].toString()) ?? 0);
    }

    pprint(last_paid);

    is_loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Room ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            room_number ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Divider(height: 1, color: Colors.black),

      Select_Dynamic(
        init: number_of_guest ?? 0, //
        lead: "Number of Guests:",
        options: List.generate(10, (index) => index + 1),
        prefixIcon: Icons.people_outline, //
        onChanged: (v) {
          number_of_guest = v;
          setState(() {});
        },
      ),

      Select_Dynamic(
        init: stay_days ?? 0, //
        lead: "Stay Duration (Days):",
        options: List.generate(365, (index) => index),
        prefixIcon: Icons.calendar_month_outlined,
        onChanged: (v) {
          stay_days = v;
          setState(() {});
        },
      ),

      Select_Dynamic(
        init: stay_hours ?? 0, //
        lead: "Stay Duration (Hours):",
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        prefixIcon: Icons.access_time_outlined,
        onChanged: (v) {
          stay_hours = v;
          setState(() {});
        },
      ),

      Input_Text(
        init: note ?? "", //
        lead: "Note:", //
        prefixIcon: Icons.note_alt_outlined, //
        maxLines: 4, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
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
    if ((number_of_guest ?? 0) <= 0) return false;
    if ((stay_days ?? 0) <= 0 && (stay_hours ?? 0) <= 0) return false;

    return true;
  }

  double get room_price {
    return ((price_per_day ?? 0) * (stay_days ?? 0)) + ((price_per_3hours ?? 0) * (stay_hours ?? 0) / 3);
  }

  void on_update() async {
    try {
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_CHECK_IN, //
        data: {
          sm_front_desk.ID: front_desk_id, //
          sm_front_desk.CHECK_IN_NUMBER: number_of_guest, //
          sm_front_desk.CHECK_IN_DAY: stay_days, //
          sm_front_desk.CHECK_IN_HOUR: stay_hours, //
          sm_front_desk.CHECK_IN_NOTE: note, //
        },
      );

      pprint("room_price: $room_price");

      await dio.post(
        endpoint.FRONT_DESK_ADD_PAY_ROOM, // update
        data: {
          sm_front_desk.ID: front_desk_id, //
          "pay_price": room_price, //
        },
      );

      if (last_paid == room_price)
        await dio.post(
          endpoint.ROOM_CRUD_UPDATE, //
          data: {
            sm_room.ID: widget.room_id, //
            sm_room.STATUS: "Pending Leave", //
          },
        );
      else
        await dio.post(
          endpoint.ROOM_CRUD_UPDATE, //
          data: {
            sm_room.ID: widget.room_id, //
            sm_room.STATUS: "Pending Pay", //
          },
        );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
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
