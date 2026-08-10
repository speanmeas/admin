import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/show_data.dart";
import "package:speanmeas/core/endpoint.g.dart";

import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

import "../widget/guest_search.dart" as g_search;

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
  //
  dynamic tmp;
  final c_g_search = TextEditingController();

  void init() async {
    try {
      sm_front_desk.clear();
      sm_room.clear();
      sm_guest.clear();

      //
      tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_front_desk.ID: widget.room_id});
      for (var e in sm_room.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: sm_room.data[sm_room.FRONT_DESK_ID]!["value"]});
      for (var e in sm_front_desk.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      c_g_search.text = sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"]?.toString() ?? "";
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
      g_search.Main_(
        controller: c_g_search,
        onChanged: (v) {
          sm_front_desk.data[sm_front_desk.GUEST_ID]?["value"] = v[sm_guest.ID];
          sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["value"] = v[sm_guest.FULL_NAME];
          sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"] = v[sm_guest.PHONE_NUMBER];
          sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["value"] = v[sm_guest.GENDER];
          sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["value"] = v[sm_guest.NATIONALITY];
          setState(() {});
        },
        onCleared: () {
          sm_front_desk.data[sm_front_desk.GUEST_ID]?["value"] = null;
          sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["value"] = null;
          sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"] = null;
          sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["value"] = null;
          sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["value"] = null;
          setState(() {});
        },
      ),

      (() {
        String value = "";
        if (sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["value"] != null) //
          value = sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["value"].toString() ?? "";
        return Show_Data(
          title: sm_front_desk.data[sm_front_desk.GUEST_FULL_NAME]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"] != null) //
          value = sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
        return Show_Data(
          title: sm_front_desk.data[sm_front_desk.GUEST_PHONE_NUMBER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["value"] != null) //
          value = sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["value"].toString() ?? "";
        return Show_Data(
          title: sm_front_desk.data[sm_front_desk.GUEST_GENDER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["value"] != null) //
          value = sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["value"].toString() ?? "";
        return Show_Data(
          title: sm_front_desk.data[sm_front_desk.GUEST_NATIONALITY]?["title"] ?? "", //
          value: value,
        );
      })(),

      //
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
      //
      await dio.post(
        endpoint.FRONT_DESK_UPDATE, //
        data: {
          sm_front_desk.ID: sm_front_desk.data[sm_front_desk.ID]!["value"], //
          sm_front_desk.GUEST_ID: sm_front_desk.data[sm_front_desk.GUEST_ID]?["value"],
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Update Successful", cl: Colors.green);
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
