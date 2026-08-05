import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart" as sb;
import "package:speanmeas/core/widget/show_data.dart" as sd;

import "../__config__.dart";
import "../schema.g.dart" as sm;

class _Main_State extends State<Main_> {
  dynamic tmp;

  void init() async {
    //

    try {
      sm.clear();

      //
      tmp = await dio.post(
        ep.FRONT_DESK_READ_ID, //
        data: {
          sm.ID: widget.front_desk_id, //
        },
      );

      for (var e in sm.data.entries) e.value["value"] = tmp.data[0][e.key];

      setState(() {});

      //
    } catch (e) {
      print("Error: $e");
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return _layout([
      for (var e in sm.data.entries.where((e) => (!e.value["hide"] || kDebugMode))) //
        (() {
          //
          if (e.value["type"] == "id") {
            String value = "";
            if (e.value["value"] != null) value = e.value["value"].toString();
            return sd.Main_(
              title: e.value["title"]?.toString() ?? "", //
              value: value, //
            );
          }

          //
          if (e.value["type"] == "string") {
            String value = "";
            if (e.value["value"] != null) value = e.value["value"].toString();
            return sd.Main_(
              title: e.value["title"]?.toString() ?? "", //
              value: value, //
            );
          }

          //
          if (e.value["type"] == "number") {
            String value = "0";
            if (e.value["value"] != null) value = e.value["value"].toString();
            return sd.Main_(
              title: e.value["title"]?.toString() ?? "", //
              value: value, //
            );
          }

          //
          if (e.value["type"] == "date-time") {
            String value = "";
            if (e.value["value"] != null) {
              tmp = DateTime.tryParse(e.value["value"].toString());
              if (tmp != null) value = DateFormat(DATE_FORMAT).format(tmp);
            }
            return sd.Main_(
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
            return sd.Main_(
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
    ]);
  }

  String _dateValue(dynamic value) {
    if (value == null) return "";

    final dt = DateTime.tryParse(value.toString());
    if (dt == null) return value.toString();

    return DateFormat(DATE_FORMAT).format(dt);
  }

  // layout
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

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

class Main_ extends StatefulWidget {
  Main_({
    super.key, //
    this.front_desk_id,
  });

  final String? front_desk_id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme.data(), //
      home: Main_(
        //
        front_desk_id: "6a71dc186c013023294f6742",
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
