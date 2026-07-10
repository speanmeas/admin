import "dart:io";

import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:dio/dio.dart";

import "package:speanmeas/environment.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "_setup.dart";
import "schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  // need id
  Map<String, dynamic> output = {};

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
              ...schema.data.entries.where((e) => !e.key.contains("_id")).map((e) {
                //
                //
                //

                //
                if (e.value["type"] == "string") {
                  String value = "";
                  if (!e.key.contains("password")) value = e.value["value"]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value),
                      maxLines: e.key.contains("note") ? 4 : 1,
                      decoration: InputDecoration(
                        hintText: e.key.contains("password") ? "New Password" : null, //
                        labelText: e.value["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        output[e.key] = v; //
                      },
                    ),
                  );
                }

                // edit number
                if (e.value["type"] == "number") {
                  String value = "";
                  if (e.value["value"] != null) value = e.value["value"].toString();
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value),
                      decoration: InputDecoration(
                        labelText: e.value["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                      onChanged: (v) {
                        output[e.key] = v; //
                      },
                    ),
                  );
                }

                if (e.value["type"] == "boolean") {
                  String value = "";
                  if (e.value["value"] != null) {
                    value = e.value["value"].toString();
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
                        if (v == "Yes") output[e.key] = true;
                        if (v == "No") output[e.key] = false;
                      },
                    ),
                  );
                }

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
                        suffixIcon: Icon(Icons.calendar_today, size: 20), //
                      ),
                      onTap: () async {
                        DateTime? datetime = await datetime_picker(context, initial_datetime: init);
                        if (datetime == null) return;
                        output[e.key] = datetime.toIso8601String();
                        setState(() {});
                      }, //,
                    ),
                  );
                }

                return SizedBox();
              }),

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
    // 0. debug
    // for (var s in schema) print(s);

    // 1. validate required fields
    // for (var s in schema) {
    //   if (s["key"] == "_id") continue; // skip id field
    //   if (s["key"].toString().contains("note")) continue; // skip note field
    //   if (s["value"] == null) {
    //     snackbar_show(context: context, message: "${s["title"]} is required.", color: Colors.red);
    //     return;
    //   }
    // }

    // 2. validate number fields
    // for (var s in schema) {
    //   if (s["type"] == "number") {
    //     final tmp = double.tryParse(s["value"].toString());
    //     if (tmp == null) {
    //       snackbar_show(context: context, message: "${s["title"]} must be a number.", color: Colors.red);
    //       return;
    //     }
    //   }
    // }

    // request
    output["_id"] = schema.data["_id"]?["value"];

    await dio
        .post("$PATH/data_update", data: FormData.fromMap({...output}))
        .then((value) {
          snackbar_show(context: context, message: "$HEADER update successfully", color: Colors.green);
          Navigator.pop(context, output);
        })
        .catchError((e) {
          snackbar_show(context: context, message: "$HEADER update failed", color: Colors.red);
        });
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
      title: HEADER, //
      theme: Theme_Data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
