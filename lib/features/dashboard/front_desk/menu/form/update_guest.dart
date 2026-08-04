import "package:speanmeas/core/endpoint.g.dart" as ep;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/core/widget/show_data.dart" as show_data;
import "package:speanmeas/features/database/guest/schema.g.dart" as g_schema;

import "../../schema.g.dart" as schema;

import "../widget/guest_search.dart" as g_search;

class _Main_State extends State<Main_> {
  dynamic tmp;
  final c_g_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (schema.data[schema.GUEST_PHONE_NUMBER]?["value"] != null) //
      c_g_search.text = schema.data[schema.GUEST_PHONE_NUMBER]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),

            child: Column(
              children: [
                // guest search
                SizedBox(height: 8),
                g_search.Main_(controller: c_g_search, onChanged: (v) => _set_guest(v), onCleared: () => _set_guest({})),

                if (kDebugMode) _info_field(schema.ID),
                if (kDebugMode) _info_field(schema.GUEST_ID),
                _info_field(schema.GUEST_FULL_NAME),
                _info_field(schema.GUEST_PHONE_NUMBER),
                _info_field(schema.GUEST_GENDER),
                _info_field(schema.GUEST_NATIONALITY),

                // button update
                Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.check), //
                    label: Text("Update"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: on_update, //
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _set_guest(Map<String, dynamic> v) {
    schema.data[schema.GUEST_ID]?["value"] = v[g_schema.ID];
    schema.data[schema.GUEST_FULL_NAME]?["value"] = v[g_schema.FULL_NAME];
    schema.data[schema.GUEST_PHONE_NUMBER]?["value"] = v[g_schema.PHONE_NUMBER];
    schema.data[schema.GUEST_GENDER]?["value"] = v[g_schema.GENDER];
    schema.data[schema.GUEST_NATIONALITY]?["value"] = v[g_schema.NATIONALITY];
    setState(() {});
  }

  Widget _info_field(String key) {
    return show_data.Main_(
      title: schema.data[key]?["title"] ?? "", //
      value: schema.data[key]?["value"]?.toString() ?? "",
    );
  }

  void on_update() async {
    try {
      //
      await dio.post(
        "/front_desk/update", //
        data: {
          schema.ID: schema.data[schema.ID]!["value"], //
          schema.GUEST_ID: schema.data[schema.GUEST_ID]!["value"], //
        },
      );

      Navigator.pop(context, true);

      snackbar.view(context: context, message: "Success", color: Colors.green);
      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      home: Main_(),
      theme: theme.data(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
