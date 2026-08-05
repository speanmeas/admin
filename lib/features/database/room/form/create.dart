import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_light.dart" as theme;
import "package:speanmeas/core/dialog/datetime.dart" as datetime_picker;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "../config.dart";
import "../schema.g.dart" as schema;

import "../widget/status_select.dart" as s_select;
import "../widget/kind_select.dart" as k_select;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  final c_status = TextEditingController();
  final c_kind = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    schema.data[schema.STATUS]!["value"] = "Available";
    schema.data[schema.KIND]!["value"] = "Single";

    if (schema.data[schema.STATUS]!["value"] != null) //
      c_status.text = schema.data[schema.STATUS]!["value"];
    if (schema.data[schema.KIND]!["value"] != null) //
      c_kind.text = schema.data[schema.KIND]!["value"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
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
          child: Column(
            children: [
              for (var e in schema.data.entries)
                (() {
                  // * select status
                  if (e.key == schema.STATUS) {
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: s_select.Main_(
                        controller: c_status,
                        onChanged: (v) {
                          e.value["value"] = v;
                          setState(() {});
                        },
                        onCleared: () {
                          e.value["value"] = null;
                          setState(() {});
                        },
                      ),
                    );
                  }

                  // * select kind
                  if (e.key == schema.KIND) {
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: k_select.Main_(
                        controller: c_kind,
                        onChanged: (v) {
                          e.value["value"] = v;
                          setState(() {});
                        },
                        onCleared: () {
                          e.value["value"] = null;
                          setState(() {});
                        },
                      ),
                    );
                  }

                  // * lock
                  if (e.value["lock"] == true) {
                    String value = "";
                    if (e.value["value"] != null) value = e.value["value"]?.toString() ?? "";
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: show_data.Main_(
                        title: e.value["title"], //
                        value: value,
                      ),
                    );
                  }

                  // * អក្សរ
                  if (e.value["type"] == "string") {
                    String value = "";
                    if (e.value["value"] != null) value = e.value["value"]?.toString() ?? "";
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TextField(
                        controller: TextEditingController(text: value.trim()),
                        maxLines: e.key.contains("note") ? 4 : 1,
                        decoration: InputDecoration(
                          labelText: e.value["title"] + ":", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.text_fields), //
                        ),
                        onChanged: (v) {
                          if (v.isEmpty) e.value["value"] = " "; //
                          if (v.isNotEmpty) e.value["value"] = v.trim(); //
                        },
                      ),
                    );
                  }

                  // * លេខ
                  if (e.value["type"] == "number") {
                    String value = "";
                    if (e.value["value"] != null && e.value["value"] != 0) {
                      value = e.value["value"].toString();
                    }
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TextField(
                        controller: TextEditingController(text: value.trim()),
                        decoration: InputDecoration(
                          labelText: e.value["title"] + ":", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.numbers), //
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                        onChanged: (v) {
                          if (v.isEmpty) e.value["value"] = 0;
                          if (v.isNotEmpty) e.value["value"] = double.tryParse(v) ?? 0;
                        },
                      ),
                    );
                  }

                  // * ថ្ងៃខែឆ្នាំ និង ម៉ោង
                  // todo: clear date-time?
                  if (e.value["type"] == "date-time") {
                    String value = "";
                    if (e.value["value"] != null) {
                      DateTime? tmp = DateTime.tryParse(e.value["value"].toString());
                      if (tmp != null) {
                        value = DateFormat(DATE_FORMAT).format(tmp.toLocal());
                      }
                    }
                    DateTime init = DateTime.now();
                    if (DateTime.tryParse(value) != null) {
                      init = DateTime.tryParse(value)!;
                    }
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TextField(
                        controller: TextEditingController(text: value),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(), //
                          labelText: e.value["title"] + ":", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.calendar_month_outlined), //
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.clear, color: Colors.red),
                              onPressed: () async {
                                e.value["value"] = null;
                                setState(() {});
                              },
                            ), //
                          ),
                        ),
                        onTap: () async {
                          DateTime? datetime = await datetime_picker.view(context, initial_datetime: init);
                          if (datetime == null) return;
                          e.value["value"] = datetime.toIso8601String();
                          setState(() {});
                        }, //,
                      ),
                    );
                  }

                  // * តក្កវិទ្យា
                  if (e.value["type"] == "boolean") {
                    String? value;
                    if (e.value["value"] != null) {
                      if (e.value["value"] == true) value = "Yes";
                      if (e.value["value"] == false) value = "No";
                    }
                    final controller_search = TextEditingController(text: value ?? "");
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TypeAheadField<String>(
                        controller: controller_search,
                        suggestionsCallback: (query) => ["Yes", "No"],
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: e.value["title"] + ":", //
                              labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              prefixIcon: Icon(Icons.toggle_on_outlined), //
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: IconButton(
                                  icon: Icon(Icons.clear, color: Colors.red),
                                  onPressed: () async {
                                    e.value["value"] = null;
                                    setState(() {});
                                  },
                                ), //
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, item) => ListTile(title: Text(item)),
                        onSelected: (v) {
                          controller_search.text = v;
                          if (v == "Yes") e.value["value"] = true;
                          if (v == "No") e.value["value"] = false;
                          setState(() {});
                        },
                      ),
                    );
                  }

                  //
                  return SizedBox();
                })(),

              //
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text("Create"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: on_create,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_create() async {
    try {
      //
      var payload = {};
      for (var e in schema.data.entries) payload[e.key] = e.value["value"];

      // request
      final r = await dio.post("$PATH/create", data: payload);

      //
      Navigator.pop(context, r.data[0]);

      //
      snackbar.view(context: context, message: "Success", color: Colors.green);

      //
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: "Failed", color: Colors.red);
    }
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
