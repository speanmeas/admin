import "package:flutter/material.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/room.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Change Room", //
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
  final c_from_room_status = TextEditingController();
  final c_to_room = TextEditingController();

  List<Map<String, dynamic>> rooms = [];

  void init() async {
    try {
      sm_room.clear();
      sm_front_desk.clear();

      //
      tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_front_desk.ID: widget.room_id});
      for (var e in sm_room.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: sm_room.data[sm_room.FRONT_DESK_ID]!["value"]});
      for (var e in sm_front_desk.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      tmp = await dio.post(endpoint.ROOM_READ);
      rooms = List<Map<String, dynamic>>.from(tmp.data);

      c_note.text = sm_front_desk.data[sm_front_desk.CHANGE_ROOM_NOTE]?["value"]?.toString() ?? "";

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
      //
      Select_Dynamic(
        controller: c_to_room,
        leading: "New Room Number:", //
        options: (() {
          var options = [];
          for (var r in rooms) {
            if (r[sm_room.STATUS] == "Available") {
              options.add(r[sm_room.NUMBER]?.toString() ?? "");
            }
          }
          return options;
        })(),
        onChanged: (value) => setState(() {}),
        prefixIcon: Icon(Icons.hotel_outlined), //
      ),

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
        icon: Icon(Icons.swap_horiz_outlined), //
        label: Text("Change"), //
        onPressed: can_change ? on_change_room : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  bool get can_change {
    // if (c_from_room_status.text.isEmpty) return false;
    if (c_to_room.text.isEmpty) return false;
    return true;
  }

  void on_change_room() async {
    try {
      //
      String? from_room_id = sm_front_desk.data[sm_front_desk.ROOM_ID]!["value"]?.toString();
      String? to_room_id;
      for (var r in rooms) {
        if (r[sm_room.NUMBER]?.toString() == c_to_room.text) {
          to_room_id = r[sm_room.ID]!.toString();
          break;
        }
      }

      // validation
      if (from_room_id == null) throw "From Room ID is null";
      if (to_room_id == null) throw "To Room ID is null";

      //
      await dio.post(
        endpoint.ROOM_UPDATE, //
        data: {
          sm_room.ID: from_room_id, //
          sm_room.STATUS: "Pending Clean", //
          sm_room.FRONT_DESK_ID: null, // * ចំណាំ៖ ការពារការកែប្រែថ្មី
        },
      );

      //
      await dio.post(
        endpoint.ROOM_UPDATE, //
        data: {
          sm_room.ID: to_room_id, //
          sm_room.STATUS: "Pending Pay", // * ចំណាំ៖ ត្រឡប់ទៅ Pending Pay ដើម្បីបង្ហាញថាអតិថិជនត្រូវបង់ប្រាក់សម្រាប់បន្ទប់ថ្មី
          sm_room.FRONT_DESK_ID: sm_front_desk.data[sm_front_desk.ID]!["value"], //
        },
      );

      //
      await dio.post(
        endpoint.FRONT_DESK_FORM_CHANGE_ROOM,
        data: {
          sm_front_desk.ID: sm_front_desk.data[sm_front_desk.ID]!["value"], //
          sm_front_desk.ROOM_ID: to_room_id, //
          sm_front_desk.CHANGE_ROOM_NOTE: c_note.text, //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Clean Successful", cl: Colors.green);

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
