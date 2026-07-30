import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/widget/show_data.dart" as show_data;
import "package:speanmeas/page/guest/schema.g.dart" as g_schema;

import "../schema.g.dart" as schema;

import "widget/guest_search.dart" as g_search;

class _Main_State extends State<Main_> {
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
                g_search.Main_(
                  controller: c_g_search,
                  onChanged: (v) {
                    schema.data[schema.GUEST_ID]?["value"] = v[g_schema.ID];
                    schema.data[schema.GUEST_FULL_NAME]?["value"] = v[g_schema.FULL_NAME];
                    schema.data[schema.GUEST_PHONE_NUMBER]?["value"] = v[g_schema.PHONE_NUMBER];
                    schema.data[schema.GUEST_GENDER]?["value"] = v[g_schema.GENDER];
                    schema.data[schema.GUEST_NATIONALITY]?["value"] = v[g_schema.NATIONALITY];
                    setState(() {});
                  },
                  onCleared: () {
                    schema.data[schema.GUEST_ID]?["value"] = null;
                    schema.data[schema.GUEST_FULL_NAME]?["value"] = null;
                    schema.data[schema.GUEST_PHONE_NUMBER]?["value"] = null;
                    schema.data[schema.GUEST_GENDER]?["value"] = null;
                    schema.data[schema.GUEST_NATIONALITY]?["value"] = null;
                    setState(() {});
                  },
                ),

                if (kDebugMode)
                  (() {
                    String value = "";
                    if (schema.data[schema.ID]?["value"] != null) {
                      value = schema.data[schema.ID]?["value"].toString() ?? "";
                    }
                    return show_data.Main_(
                      title: schema.data[schema.ID]?["title"] ?? "", //
                      value: value,
                    );
                  })(),

                if (kDebugMode)
                  (() {
                    String value = "";
                    if (schema.data[schema.GUEST_ID]?["value"] != null) {
                      value = schema.data[schema.GUEST_ID]?["value"].toString() ?? "";
                    }
                    return show_data.Main_(
                      title: schema.data[schema.GUEST_ID]?["title"] ?? "", //
                      value: value,
                    );
                  })(),

                (() {
                  String value = "";
                  if (schema.data[schema.GUEST_FULL_NAME]?["value"] != null) {
                    value = schema.data[schema.GUEST_FULL_NAME]?["value"].toString() ?? "";
                  }
                  return show_data.Main_(
                    title: schema.data[schema.GUEST_FULL_NAME]?["title"] ?? "", //
                    value: value,
                  );
                })(),

                (() {
                  String value = "";
                  if (schema.data[schema.GUEST_PHONE_NUMBER]?["value"] != null) {
                    value = schema.data[schema.GUEST_PHONE_NUMBER]?["value"].toString() ?? "";
                  }
                  return show_data.Main_(
                    title: schema.data[schema.GUEST_PHONE_NUMBER]?["title"] ?? "", //
                    value: value,
                  );
                })(),

                (() {
                  String value = "";
                  if (schema.data[schema.GUEST_GENDER]?["value"] != null) {
                    value = schema.data[schema.GUEST_GENDER]?["value"].toString() ?? "";
                  }
                  return show_data.Main_(
                    title: schema.data[schema.GUEST_GENDER]?["title"] ?? "", //
                    value: value,
                  );
                })(),

                (() {
                  String value = "";
                  if (schema.data[schema.GUEST_NATIONALITY]?["value"] != null) {
                    value = schema.data[schema.GUEST_NATIONALITY]?["value"].toString() ?? "";
                  }
                  return show_data.Main_(
                    title: schema.data[schema.GUEST_NATIONALITY]?["title"] ?? "", //
                    value: value,
                  );
                })(),

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

  void on_update() async {
    try {
      //
      final r = await dio.post(
        "/front_desk/update_field", //
        data: FormData.fromMap({
          "_id": schema.data[schema.ID]!["value"], //
          "key": schema.GUEST_ID, //
          "value": schema.data[schema.GUEST_ID]!["value"], //
        }),
      );

      Navigator.pop(context, true);

      snackbar_show(context: context, message: "Success", color: Colors.green);
      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
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
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
