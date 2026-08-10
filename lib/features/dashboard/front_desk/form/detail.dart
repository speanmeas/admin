import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/show_data.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

//
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Detail", //
        style: TextStyle(
          fontSize: 20, //
          fontWeight: FontWeight.bold,
        ),
      ),

      centerTitle: false,
      toolbarHeight: 40,
      titleSpacing: 0,
      //
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1), //
        child: Divider(height: 1, color: Colors.black), //
      ),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Container(
          width: 600,
          margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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

  void init() async {
    //

    try {
      sm_front_desk.clear();
      sm_room.clear();

      tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_front_desk.ID: widget.room_id});
      for (var e in sm_room.data.entries) e.value["value"] = tmp.data[0][e.key];

      if (sm_room.data[sm_room.FRONT_DESK_ID]!["value"] != null) {
        tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: sm_room.data[sm_room.FRONT_DESK_ID]!["value"]});
        for (var e in sm_front_desk.data.entries) e.value["value"] = tmp.data[0][e.key];
      }

      setState(() {});

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return _layout([
      for (var e in sm_front_desk.data.entries.where((e) => (!e.value["hide"] || kDebugMode))) //
        (() {
          //
          if (e.value["type"] == "id") {
            String value = "";
            if (e.value["value"] != null) value = e.value["value"].toString();
            return Show_Data(
              title: e.value["title"]?.toString() ?? "", //
              value: value, //
            );
          }

          //
          if (e.value["type"] == "string") {
            String value = "";
            if (e.value["value"] != null) value = e.value["value"].toString();
            return Show_Data(
              title: e.value["title"]?.toString() ?? "", //
              value: value, //
            );
          }

          //
          if (e.value["type"] == "number") {
            String value = "0";
            if (e.value["value"] != null) value = e.value["value"].toStringAsFixed(2);
            return Show_Data(
              title: e.value["title"]?.toStringAsFixed(2) ?? "", //
              value: value, //
            );
          }

          //
          if (e.value["type"] == "date-time") {
            String value = "";
            if (e.value["value"] != null) {
              tmp = DateTime.tryParse(e.value["value"].toString());
              if (tmp != null) value = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
            }
            return Show_Data(
              title: e.value["title"]?.toString() ?? "", //
              value: value, //
            );
          }

          //
          if (e.value["type"] == "boolean") {
            String value = "";
            if (e.value["value"] != null) {
              if (e.value["value"] == true) value = "Yes";
              if (e.value["value"] == false) value = "No";
            }
            return Show_Data(
              title: e.value["title"]?.toString() ?? "", //
              value: value, //
            );
          }

          //
          return SizedBox();
        })(),

      OutlinedButton.icon(
        autofocus: true,
        label: Text("OK"),
        icon: Icon(Icons.check), //
        onPressed: () => Navigator.pop(context), //
      ),

      SizedBox(height: height - 100),
    ]);
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
    this.room_id,
  });

  final String? room_id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Main_(
        room_id: "6a71dc186c013023294f6742", //
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
