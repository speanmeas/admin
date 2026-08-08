import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Fix", //
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

  final c_note = TextEditingController();

  void init() async {
    try {
      sm_front_desk.clear();
      sm_room.clear();

      tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_front_desk.ID: widget.room_id});
      for (var e in sm_room.data.entries) e.value["value"] = tmp.data[0][e.key];

      if (sm_room.data[sm_room.FRONT_DESK_ID]!["value"] != null) {
        tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: sm_room.data[sm_room.FRONT_DESK_ID]!["value"]});
        for (var e in sm_front_desk.data.entries) e.value["value"] = tmp.data[0][e.key];
      }

      c_note.text = sm_front_desk.data[sm_front_desk.FIX_NOTE]?["value"]?.toString() ?? "";
      setState(() {});
      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // note
      TextField(
        autofocus: true,
        controller: c_note,
        decoration: InputDecoration(
          labelText: "Note:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.note_alt_outlined), //
        ),
        maxLines: 4,
        onChanged: (v) => setState(() {}), //
      ),

      //
      OutlinedButton.icon(
        autofocus: true,
        icon: Icon(Icons.build_outlined), //
        label: Text("Fix"), //
        onPressed: on_fix, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_fix() async {
    try {
      await dio.post(
        endpoint.FRONT_DESK_FORM_FIX,
        data: {
          sm_front_desk.ID: sm_front_desk.data[sm_front_desk.ID]!["value"], //
          sm_front_desk.FIX_NOTE: c_note.text, //
        },
      );

      await dio.post(
        endpoint.ROOM_UPDATE, //
        data: {
          sm_room.ID: sm_room.data[sm_room.ID]!["value"], //
          sm_room.STATUS: "Available", //
          sm_room.FRONT_DESK_ID: null, //
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
      title: "Development", //
      theme: theme_data, //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
