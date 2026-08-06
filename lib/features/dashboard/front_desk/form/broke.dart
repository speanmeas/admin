import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/theme_light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as sb;

import "../schema.g.dart" as sm;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Broke", //
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

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  final c_note = TextEditingController();

  void init() async {
    sm.clear();

    c_note.text = sm.data[sm.BROKE_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // note
      TextField(
        autofocus: true,
        controller: c_note,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "Note:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      // additional information
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            icon: Icon(Icons.bug_report_outlined), //
            label: Text("Broke"), //
            onPressed: on_broke, //
          ),
        ],
      ),
    ]);
  }

  void on_broke() async {
    try {
      tmp = await dio.post(
        ep.FRONT_DESK_FORM_BROKE, // create
        data: {
          sm.ROOM_ID: widget.room_id, //
          sm.BROKE_NOTE: c_note.text,
        },
      );

      await dio.post(
        ep.ROOM_UPDATE, //
        data: {
          sm_r.ID: widget.room_id, //
          sm_r.STATUS: "Pending Fix", //
          sm_r.FRONT_DESK_ID: tmp.data[0][sm.ID], //
        },
      );

      Navigator.pop(context, true);

      sb.view(context: context, message: "Success", color: Colors.green);

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
