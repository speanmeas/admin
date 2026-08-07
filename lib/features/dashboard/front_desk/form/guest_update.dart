import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/show_data.dart";
import "package:speanmeas/core/endpoint.g.dart";

import "package:speanmeas/features/database/guest/schema.g.dart" as sm_g;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "../schema.g.dart" as sm_fd;
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
      sm_fd.clear();
      sm_r.clear();
      sm_g.clear();

      //
      tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
      for (var e in sm_r.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_fd.ID: sm_r.data[sm_r.FRONT_DESK_ID]!["value"]});
      for (var e in sm_fd.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      c_g_search.text = sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"]?.toString() ?? "";
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
          sm_fd.data[sm_fd.GUEST_ID]?["value"] = v[sm_g.ID];
          sm_fd.data[sm_fd.GUEST_FULL_NAME]?["value"] = v[sm_g.FULL_NAME];
          sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"] = v[sm_g.PHONE_NUMBER];
          sm_fd.data[sm_fd.GUEST_GENDER]?["value"] = v[sm_g.GENDER];
          sm_fd.data[sm_fd.GUEST_NATIONALITY]?["value"] = v[sm_g.NATIONALITY];
          setState(() {});
        },
        onCleared: () {
          sm_fd.data[sm_fd.GUEST_ID]?["value"] = null;
          sm_fd.data[sm_fd.GUEST_FULL_NAME]?["value"] = null;
          sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"] = null;
          sm_fd.data[sm_fd.GUEST_GENDER]?["value"] = null;
          sm_fd.data[sm_fd.GUEST_NATIONALITY]?["value"] = null;
          setState(() {});
        },
      ),

      (() {
        String value = "";
        if (sm_fd.data[sm_fd.GUEST_FULL_NAME]?["value"] != null) //
          value = sm_fd.data[sm_fd.GUEST_FULL_NAME]?["value"].toString() ?? "";
        return ShowData(
          title: sm_fd.data[sm_fd.GUEST_FULL_NAME]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"] != null) //
          value = sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
        return ShowData(
          title: sm_fd.data[sm_fd.GUEST_PHONE_NUMBER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_fd.data[sm_fd.GUEST_GENDER]?["value"] != null) //
          value = sm_fd.data[sm_fd.GUEST_GENDER]?["value"].toString() ?? "";
        return ShowData(
          title: sm_fd.data[sm_fd.GUEST_GENDER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm_fd.data[sm_fd.GUEST_NATIONALITY]?["value"] != null) //
          value = sm_fd.data[sm_fd.GUEST_NATIONALITY]?["value"].toString() ?? "";
        return ShowData(
          title: sm_fd.data[sm_fd.GUEST_NATIONALITY]?["title"] ?? "", //
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
          sm_fd.ID: sm_fd.data[sm_fd.ID]!["value"], //
          sm_fd.GUEST_ID: sm_fd.data[sm_fd.GUEST_ID]?["value"],
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
