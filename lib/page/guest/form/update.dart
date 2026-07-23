import "dart:io";

import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:dio/dio.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "../__config__.dart";
import "../schema.w.dart" as schema_w;
import "../widget/select_gender.dart" as select_gender;
import "../widget/search_nationality.dart" as search_nation;
import "package:speanmeas/page/nationality/schema.r.dart" as nation_schema_r;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update $HEADER", //
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
              for (var e in schema_w.data.entries)
                (() {
                  if (e.key == schema_w.GENDER) {
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: select_gender.Main_(
                        initialValue: e.value["value"], //
                        onChanged: (v) {
                          e.value["value"] = v;
                        },
                      ),
                    );
                  }

                  if (e.key == schema_w.NATIONALITY_LINK) {
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: search_nation.Main_(
                        initialValue: e.value["value"] ?? "Cambodia", //
                        onChanged: (v) {
                          e.value["value"] = v[nation_schema_r.ID];
                        },
                      ),
                    );
                  }

                  // * អក្សរ
                  if (e.value["type"] == "string") {
                    String value = "";
                    if (e.value["value"] != null) {
                      value = e.value["value"]?.toString() ?? "";
                    }
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
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.clear, color: Colors.red),
                              onPressed: () {
                                e.value["value"] = " ";
                                setState(() {});
                              },
                            ), //
                          ),
                        ),
                        onChanged: (v) {
                          if (v.isEmpty)
                            e.value["value"] = " "; //
                          else
                            e.value["value"] = v.trim(); //
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
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.clear, color: Colors.red),
                              onPressed: () {
                                e.value["value"] = 0;
                                setState(() {});
                              },
                            ), //
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                        onChanged: (v) {
                          if (v.isEmpty)
                            e.value["value"] = 0;
                          else
                            e.value["value"] = double.tryParse(v) ?? 0;
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
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.calendar_today), //,
                          ), //
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
                  // todo: clear boolean?
                  if (e.value["type"] == "boolean") {
                    String? value;
                    if (e.value["value"] != null) {
                      if (e.value["value"] == true) value = "Yes";
                      if (e.value["value"] == false) value = "No";
                    }
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: DropdownButtonFormField<String>(
                        initialValue: value,
                        decoration: InputDecoration(
                          labelText: e.value["title"] + ":",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
                        items: ["Yes", "No"].map((i) {
                          return DropdownMenuItem<String>(value: i, child: Text(i));
                        }).toList(),
                        onChanged: (v) {
                          if (v == "Yes") e.value["value"] = true;
                          if (v == "No") e.value["value"] = false;
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
    // prepare payload
    Map<String, dynamic> payload = {};
    for (var e in schema_w.data.entries) {
      payload[e.key] = e.value["value"];
    }

    await dio
        .post("$PATH/update", data: FormData.fromMap({...payload}))
        .then((value) {
          snackbar_show(context: context, message: "$HEADER update successfully", color: Colors.green);
          Navigator.pop(context, payload);
        })
        .catchError((e) {
          snackbar_show(context: context, message: "$HEADER update failed", color: Colors.red);
        });
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
