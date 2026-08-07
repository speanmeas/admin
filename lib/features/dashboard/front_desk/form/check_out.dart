import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/light.dart" as theme;
import "package:speanmeas/core/widget/snackbar_new.dart";
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "../schema.g.dart" as sm_fd;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Check Out", //
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
      sm_fd.clear();
      sm_r.clear();

      tmp = await dio.post(ep.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
      for (var e in sm_r.data.entries) e.value["value"] = tmp.data[0][e.key];

      if (sm_r.data[sm_r.FRONT_DESK_ID]!["value"] != null) {
        tmp = await dio.post(ep.FRONT_DESK_READ_ID, data: {sm_fd.ID: sm_r.data[sm_r.FRONT_DESK_ID]!["value"]});
        for (var e in sm_fd.data.entries) e.value["value"] = tmp.data[0][e.key];
      }

      c_note.text = sm_fd.data[sm_fd.CHECK_OUT_NOTE]?["value"]?.toString() ?? "";
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
        decoration: InputDecoration(
          labelText: "Note:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        maxLines: 4,
        onChanged: (v) => setState(() {}), //
      ),

      // additional information
      OutlinedButton.icon(
        autofocus: true,
        icon: Icon(Icons.logout), //
        label: Text("Check Out"), //
        onPressed: on_check_out, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_check_out() async {
    try {
      //
      await dio.post(
        ep.ROOM_UPDATE, //
        data: {
          sm_r.ID: sm_r.data[sm_r.ID]!["value"], //
          sm_r.STATUS: "Pending Clean", //
        },
      );

      await dio.post(
        ep.FRONT_DESK_FORM_CHECK_OUT,
        data: {
          sm_fd.ID: sm_fd.data[sm_fd.ID]!["value"], //
          sm_fd.CHECK_OUT_NOTE: c_note.text, //
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
      theme: theme.data(), //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
