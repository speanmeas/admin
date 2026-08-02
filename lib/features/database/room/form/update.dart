import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/datetime_picker.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "../__config__.dart";
import "../schema.g.dart" as schema;

import "../widget/status_select.dart" as s_select;
import "../widget/kind_select.dart" as k_select;

class _Main_State extends State<Main_> {
  final c_status = TextEditingController();
  final c_kind = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
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
                    if (e.value["value"] != null) //
                      value = e.value["value"].toString();
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
                    if (e.value["value"] != null) //
                      value = e.value["value"].toString();
                    if (e.key == "password") //
                      value = "";
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TextField(
                        controller: TextEditingController(text: value.trim()),
                        maxLines: e.key == "note" ? 4 : 1,
                        decoration: InputDecoration(
                          hintText: e.key == "password" ? "New Password" : null, //
                          labelText: e.value["title"] + ":", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.text_fields), //
                        ),
                        onChanged: (v) {
                          e.value["value"] = v.trim();
                        },
                      ),
                    );
                  }

                  // * លេខ
                  if (e.value["type"] == "number") {
                    String value = "";
                    if (e.value["value"] != null && e.value["value"] != 0) //
                      value = e.value["value"].toString();
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
                          e.value["value"] = double.tryParse(v) ?? 0;
                        },
                      ),
                    );
                  }

                  // * ថ្ងៃខែឆ្នាំ និង ម៉ោង
                  if (e.value["type"] == "date-time") {
                    final tmp = DateTime.tryParse(e.value["value"]?.toString() ?? "");
                    final value = tmp != null ? DateFormat(DATE_FORMAT).format(tmp.toLocal()) : "";
                    final init = tmp ?? DateTime.now();
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

  void on_update() async {
    try {
      // * រៀបចំ payload
      var payload = {};
      for (var e in schema.data.entries) payload[e.key] = e.value["value"];

      //
      final r = await dio.post(
        "$PATH/update", //
        data: {...payload},
      );

      //
      Navigator.pop(context, r.data);

      //
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
      title: "Development", //
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
