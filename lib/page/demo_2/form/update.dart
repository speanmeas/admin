import "dart:io";
import "package:dio/dio.dart";
import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/widget/show_data.dart" as show_data;

import "../__config__.dart";
import "../schema.g.dart" as schema;

import "package:speanmeas/page/nationality/schema.g.dart" as n_schema_r;
import "../widget/nationality_search.dart" as n_search;

class _Main_State extends State<Main_> {
  final c_nationality = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (schema.data[schema.NATIONALITY_NAME]!["value"] != null) //
      c_nationality.text = schema.data[schema.NATIONALITY_NAME]!["value"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              for (var e in schema.data.entries)
                (() {
                  // * search nationality
                  if (e.key == schema.NATIONALITY_ID) {
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: n_search.Main_(
                        controller: c_nationality,
                        onChanged: (v) {
                          e.value["value"] = v[n_schema_r.ID];
                          schema.data[schema.NATIONALITY_NAME]!["value"] = v[n_schema_r.NAME];
                          schema.data[schema.NATIONALITY_NOTE]!["value"] = v[n_schema_r.NOTE];
                          setState(() {});
                        },
                        onCleared: () {
                          e.value["value"] = null;
                          schema.data[schema.NATIONALITY_NAME]!["value"] = null;
                          schema.data[schema.NATIONALITY_NOTE]!["value"] = null;
                          clear_field(e.key);
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
                    if (e.key.contains("password")) value = "";
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TextField(
                        controller: TextEditingController(text: value.trim()),
                        maxLines: e.key.contains("note") ? 4 : 1,
                        decoration: InputDecoration(
                          hintText: e.key.contains("password") ? "New Password" : null, //
                          labelText: e.value["title"] + ":", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.text_fields), //
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.clear, color: Colors.red),
                              onPressed: () async {
                                if (!e.key.contains("password")) clear_field(e.key);
                                e.value["value"] = "";
                                setState(() {});
                              },
                            ), //
                          ),
                        ),
                        onChanged: (v) {
                          if (v.isEmpty) e.value["value"] = " ";
                          if (v.isNotEmpty) e.value["value"] = v.trim();
                        },
                      ),
                    );
                  }

                  // * លេខ
                  if (e.value["type"] == "number") {
                    String value = "";
                    if (e.value["value"] != null && e.value["value"] != 0) value = e.value["value"].toString();
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
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.clear, color: Colors.red),
                              onPressed: () async {
                                clear_field(e.key);
                                e.value["value"] = "";
                                setState(() {});
                              },
                            ), //
                          ),
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
                      if (tmp != null) value = DateFormat(DATE_FORMAT).format(tmp.toLocal());
                    }
                    DateTime init = DateTime.now();
                    if (DateTime.tryParse(value) != null) init = DateTime.tryParse(value)!;

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
                                clear_field(e.key);
                                e.value["value"] = "";
                                setState(() {});
                              },
                            ), //
                          ),
                        ),
                        onTap: () async {
                          DateTime? datetime = await datetime_picker(context, initial_datetime: init);
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
                    final controller_search = TextEditingController(text: value);
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
                                    clear_field(e.key);
                                    e.value["value"] = "";
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

              // button update
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.check), //
                  label: Text("Update"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: on_update,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clear_field(String key) async {
    try {
      final r = await dio.post(
        "$PATH/update_field",
        data: FormData.fromMap({
          "_id": schema.data["_id"]!["value"], //
          "key": key, //
          "value": null, //
        }),
      );
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_update() async {
    try {
      // * រៀបចំ payload
      Map<String, dynamic> payload = {};
      for (var e in schema.data.entries) payload[e.key] = e.value["value"];

      //
      final r = await dio.post("$PATH/update", data: FormData.fromMap({...payload}));

      //
      Navigator.pop(context, r.data);

      //
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
      title: HEADER, //
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
