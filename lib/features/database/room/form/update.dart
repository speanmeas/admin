import "package:flutter/material.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/room.g.dart";

import "../widget/kind_select.dart" as k_select;
import "../widget/status_select.dart" as s_select;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Update", //
        style: TextStyle(
          fontSize: 20, //
          fontWeight: FontWeight.bold,
        ),
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
          padding: EdgeInsets.all(8),
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
  dynamic tmp; // ignore: unused
  bool is_loading = true;

  String? number;
  double? usd_per_day;
  double? usd_per_3h;
  String? kind;
  String? status;
  String? note;

  void init() async {
    //
    try {
      //
      tmp = await dio.post(
        endpoint.ROOM_CRUD_READ_ID, //
        data: {sm_room.ID: widget.id},
      );

      number = tmp.data[0][sm_room.NUMBER];
      usd_per_day = tmp.data[0][sm_room.USD_PER_DAY];
      usd_per_3h = tmp.data[0][sm_room.USD_PER_3H];
      kind = tmp.data[0][sm_room.KIND];
      status = tmp.data[0][sm_room.STATUS];
      note = tmp.data[0][sm_room.NOTE];

      setState(() => is_loading = false);
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      //
      Input_Text(
        initial: number, //
        title: "Number:", //
        onChanged: (v) {
          number = v;
          setState(() {});
        },
      ),

      //
      Input_Number(
        initial: usd_per_day, //
        title: "USD/Day:", //
        onChanged: (v) {
          usd_per_day = v;
          setState(() {});
        },
      ),

      //
      Input_Number(
        initial: usd_per_3h, //
        title: "USD/3H:", //
        onChanged: (v) {
          usd_per_3h = v;
          setState(() {});
        },
      ),

      //
      k_select.Main_(
        initial: kind, //
        onChanged: (v) {
          kind = v;
          setState(() {});
        },
      ),

      //
      s_select.Main_(
        initial: status, //
        onChanged: (v) {
          status = v;
          setState(() {});
        },
      ),

      Input_Text(
        initial: note, //
        title: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v ?? "";
          setState(() {});
        },
      ),

      //
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  void on_update() async {
    try {
      //
      tmp = await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.id,
          sm_room.NUMBER: number,
          sm_room.USD_PER_DAY: usd_per_day,
          sm_room.USD_PER_3H: usd_per_3h,
          sm_room.KIND: kind,
          sm_room.STATUS: status,
          sm_room.NOTE: note, //
        },
      );

      //
      Navigator.pop(context, tmp.data[0]);

      //
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

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id, //
  });

  final String id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(id: "1"),
      debugShowCheckedModeBanner: false,
    ),
  );
}
