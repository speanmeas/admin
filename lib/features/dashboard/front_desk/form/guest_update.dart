import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/search/search_guest.dart";
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
        "Update Guest", //
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

  String? front_desk_id;
  String? guest_id;
  String? guest_full_name;
  String? guest_phone_number;
  String? guest_gender;
  String? guest_nationality;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.ROOM_CRUD_READ_ID, //
        data: {sm_room.ID: widget.room_id},
      );
      front_desk_id = tmp.data[0][sm_room.FRONT_DESK_ID];

      if (front_desk_id != null) {
        tmp = await dio.post(
          endpoint.FRONT_DESK_READ_ID, //
          data: {sm_front_desk.ID: front_desk_id},
        );

        guest_id = tmp.data[0][sm_front_desk.GUEST_ID]?.toString();
        guest_full_name = tmp.data[0]["guest_full_name"]?.toString();
        guest_phone_number = tmp.data[0]["guest_phone_number"]?.toString();
        guest_gender = tmp.data[0]["guest_gender"]?.toString();
        guest_nationality = tmp.data[0]["guest_nationality"]?.toString();
      }

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void _on_guest_selected(String? id) async {
    if (id == null) {
      guest_id = null;
      guest_full_name = null;
      guest_phone_number = null;
      guest_gender = null;
      guest_nationality = null;
      setState(() {});
      return;
    }

    try {
      tmp = await dio.post(
        endpoint.GUEST_CRUD_READ_ID, //
        data: {sm_guest.ID: id},
      );

      guest_id = id;
      guest_full_name = tmp.data[0][sm_guest.FULL_NAME]?.toString();
      guest_phone_number = tmp.data[0][sm_guest.PHONE_NUMBER]?.toString();
      guest_gender = tmp.data[0][sm_guest.GENDER]?.toString();
      guest_nationality = tmp.data[0][sm_guest.NATIONALITY_ID]?["name"]?.toString();
      setState(() {});
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
      Search_Guest(
        initial: guest_full_name, //
        onChanged: _on_guest_selected,
      ),

      Show_Text(leading: "Name:", value: guest_full_name ?? ""),
      Show_Text(leading: "Phone:", value: guest_phone_number ?? ""),
      Show_Text(leading: "Gender:", value: guest_gender ?? ""),
      Show_Text(leading: "Nationality:", value: guest_nationality ?? ""),

      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text("Update"), //
        onPressed: on_update, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_update() async {
    try {
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_GUEST, //
        data: {
          sm_front_desk.ID: front_desk_id, //
          sm_front_desk.GUEST_ID: guest_id,
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Update Successful", cl: Colors.green);
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
      home: Main_(
        room_id: "6a6ec9d7599d64fa5d293fb9", //
      ), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
