import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "../schema.g.dart" as sm;
import "package:speanmeas/features/database/guest/schema.g.dart" as sm_g;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "../widget/guest_search.dart" as g_search;

class _Main_State extends State<Main_> {
  dynamic tmp;

  final c_g_search = TextEditingController();

  void init() async {
    sm.clear();
    sm_g.clear();
    sm_r.clear();

    sm.data[sm.STAY_N_GUEST]?["value"] = 1;

    c_g_search.text = sm_g.data[sm_g.PHONE_NUMBER]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      g_search.Main_(
        controller: c_g_search,
        onChanged: (v) {
          sm.data[sm.GUEST_ID]?["value"] = v[sm_g.ID];
          sm.data[sm.GUEST_FULL_NAME]?["value"] = v[sm_g.FULL_NAME];
          sm.data[sm.GUEST_PHONE_NUMBER]?["value"] = v[sm_g.PHONE_NUMBER];
          sm.data[sm.GUEST_GENDER]?["value"] = v[sm_g.GENDER];
          sm.data[sm.GUEST_NATIONALITY]?["value"] = v[sm_g.NATIONALITY];
          setState(() {});
        },
        onCleared: () {
          sm.data[sm.GUEST_ID]?["value"] = null;
          sm.data[sm.GUEST_FULL_NAME]?["value"] = null;
          sm.data[sm.GUEST_PHONE_NUMBER]?["value"] = null;
          sm.data[sm.GUEST_GENDER]?["value"] = null;
          sm.data[sm.GUEST_NATIONALITY]?["value"] = null;
          setState(() {});
        },
      ),

      (() {
        String value = "";
        if (sm.data[sm.GUEST_FULL_NAME]?["value"] != null) //
          value = sm.data[sm.GUEST_FULL_NAME]?["value"].toString() ?? "";

        return show_data.Main_(
          title: sm.data[sm.GUEST_FULL_NAME]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm.data[sm.GUEST_PHONE_NUMBER]?["value"] != null) //
          value = sm.data[sm.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
        return show_data.Main_(
          title: sm.data[sm.GUEST_PHONE_NUMBER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm.data[sm.GUEST_GENDER]?["value"] != null) //
          value = sm.data[sm.GUEST_GENDER]?["value"].toString() ?? "";
        return show_data.Main_(
          title: sm.data[sm.GUEST_GENDER]?["title"] ?? "", //
          value: value,
        );
      })(),

      (() {
        String value = "";
        if (sm.data[sm.GUEST_NATIONALITY]?["value"] != null) //
          value = sm.data[sm.GUEST_NATIONALITY]?["value"].toString() ?? "";
        return show_data.Main_(
          title: sm.data[sm.GUEST_NATIONALITY]?["title"] ?? "", //
          value: value,
        );
      })(),

      SizedBox(height: 8),

      // additional information
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            icon: Icon(Icons.check), //
            label: Text("Update"), //
            onPressed: on_update, //
          ),
        ],
      ),
    ]);
  }

  void on_update() async {
    try {
      //
      tmp = await dio.post(
        ep.FRONT_DESK_UPDATE, //
        data: {
          sm.ID: widget.front_desk_id, //
          sm.GUEST_ID: sm.data[sm.GUEST_ID]?["value"],
        },
      );

      Navigator.pop(context, true);

      snackbar.view(context: context, message: "Update Successful", color: Colors.green);

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
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
        "Update Guest", //
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
  Main_({
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
