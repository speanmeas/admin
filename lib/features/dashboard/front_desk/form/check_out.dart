import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/theme_light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as sb;

import "../schema.g.dart" as sm;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  final c_note = TextEditingController();

  void init() async {
    try {
      sm.clear();
      sm_r.clear();

      tmp = await dio.post(
        ep.FRONT_DESK_READ_ID,
        data: {
          sm.ID: widget.front_desk_id, //
        },
      );

      sm.clear();
      for (var e in sm.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }

    c_note.text = sm.data[sm.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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

      SizedBox(height: 8),

      // additional information
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            autofocus: true,
            icon: Icon(Icons.logout), //
            label: Text("Check Out"), //
            onPressed: on_check_out, //
          ),
        ],
      ),
    ]);
  }

  void on_check_out() async {
    try {
      //
      await dio.post(
        ep.FRONT_DESK_FORM_CHECK_OUT,
        data: {
          sm.ID: widget.front_desk_id, //
          sm.CHECK_OUT_NOTE: c_note.text, //
        },
      );

      await dio.post(
        ep.ROOM_UPDATE, //
        data: {
          sm_r.ID: sm.data[sm.ROOM_ID]!["value"], //
          sm_r.STATUS: "Pending Clean", //
        },
      );

      Navigator.pop(context, true);

      sb.view(context: context, message: "Check Out Successful", color: Colors.green);

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
            children: children, //
          ),
        ),
      ),
    ),
  );
}

//
class Main_ extends StatefulWidget {
  const Main_({
    super.key,
    this.front_desk_id, //
  });

  final String? front_desk_id;

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
