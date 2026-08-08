import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/room.g.dart";

import "../schema.g.dart" as sm_fd;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Clean", //
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

  final c_note = TextEditingController();

  void init() async {
    try {
      sm_fd.clear();
      sm_room.clear();

      tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
      for (var e in sm_room.data.entries) e.value["value"] = tmp.data[0][e.key];

      if (sm_room.data[sm_room.FRONT_DESK_ID]!["value"] != null) {
        tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_fd.ID: sm_room.data[sm_room.FRONT_DESK_ID]!["value"]});
        for (var e in sm_fd.data.entries) e.value["value"] = tmp.data[0][e.key];
      }

      c_note.text = sm_fd.data[sm_fd.CLEAN_NOTE]?["value"]?.toString() ?? "";
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
        autofocus: true,
        icon: Icon(Icons.cleaning_services), //
        label: Text("Clean"), //
        onPressed: on_clean, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_clean() async {
    try {
      //

      await dio.post(
        endpoint.ROOM_UPDATE, //
        data: {
          sm_room.ID: sm_room.data[sm_room.ID]!["value"], //
          sm_room.STATUS: "Available", //
          sm_room.FRONT_DESK_ID: null, //
        },
      );

      if (sm_room.data[sm_room.FRONT_DESK_ID]!["value"] != null)
        await dio.post(
          endpoint.FRONT_DESK_FORM_CLEAN,
          data: {
            sm_fd.ID: sm_fd.data[sm_fd.ID]!["value"], //
            sm_fd.CLEAN_NOTE: c_note.text, //
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
