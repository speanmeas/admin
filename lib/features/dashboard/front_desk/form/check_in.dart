import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/search/search_guest.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/endpoint.g.dart";

import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/guest.g.dart";
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
  //
  dynamic tmp;
  bool is_loading = true;

  String? room_number;
  double? price_per_day;
  double? price_per_3hours;

  String? guest_id;
  int? number_of_guest;
  int? stay_days;
  int? stay_hours;
  String? note;

  void init() async {
    tmp = await dio.post(
      endpoint.ROOM_CRUD_READ_ID, //
      data: {
        sm_front_desk.ID: widget.room_id, //
      },
    );

    room_number = tmp.data[0][sm_room.NUMBER] ?? "Unknown";
    price_per_day = tmp.data[0][sm_room.USD_PER_DAY] ?? 0;
    price_per_3hours = tmp.data[0][sm_room.USD_PER_3H] ?? 0;

    number_of_guest = 1;
    stay_days = 0;
    stay_hours = 0;

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
          Text(
            "Room: ", //
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            room_number!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Divider(height: 1, color: Colors.black),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Guest", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
        ],
      ),

      Search_Guest(
        onChanged: (v) {
          guest_id = v;
          setState(() {});
        },
      ),

      Divider(height: 1, color: Colors.black),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Stay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
        ],
      ),

      Select_Dynamic(
        lead: "Number of Guests:",
        initial: number_of_guest, //
        options: List.generate(10, (index) => index + 1),
        prefixIcon: Icon(Icons.people_outline), //
        onChanged: (v) {
          number_of_guest = v;
          setState(() {});
        },
      ),

      Select_Dynamic(
        lead: "Stay Duration (Days):",
        initial: stay_days, //
        options: List.generate(365, (index) => index),
        prefixIcon: Icon(Icons.calendar_month_outlined),
        onChanged: (v) {
          stay_days = v;
          setState(() {});
        },
      ),

      Select_Dynamic(
        lead: "Stay Duration (Hours):",
        initial: stay_hours,
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        prefixIcon: Icon(Icons.access_time_outlined),
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

      Divider(height: 1, color: Colors.black),

      if (kDebugMode)
        Show_Text(
          leading: "Room Price:", //
          value: room_price.toStringAsFixed(2),
        ),

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
    return (price_per_day! * stay_days!) + (price_per_3hours! * stay_hours! / 3);
  }

  bool get can_check_in {
    if (number_of_guest! <= 0) return false;
    if (stay_days! <= 0 && stay_hours! <= 0) return false;
    return true;
  }

  void on_check_in() async {
    try {
      //
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

      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
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
      home: Main_(
        room_id: "6a6ec9d7599d64fa5d293fb9", //
      ), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
