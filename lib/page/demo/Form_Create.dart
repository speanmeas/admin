import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:intl/intl.dart";

import "package:speanmeas/Global.dart";
import "package:speanmeas/Environment.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/widget/Datetime_Picker.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "_Setup.dart";
import "schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  Map<String, dynamic> output = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create - $HEADER", //
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
              ...schema.data.entries.where((e) => e.value["hide"] == false).map((e) {
                //
                //
                //

                // note
                if (e.key.contains("note")) {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Note:", //
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        output[e.key] = v;
                      },
                    ),
                  );
                }

                //
                //
                //

                // string
                if (e.value["type"] == "string") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: e.value["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        output[e.key] = v;
                      },
                    ),
                  );
                }

                // number
                if (e.value["type"] == "number") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                      decoration: InputDecoration(
                        labelText: e.value["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        output[e.key] = v;
                      },
                    ),
                  );
                }

                if (e.value["type"] == "boolean") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: DropdownButtonFormField<String>(
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
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(
                        text: (() {
                          final value = output[e.key]?.toString() ?? "";
                          final dt = DateTime.tryParse(value);
                          if (dt == null) return value;
                          return DateFormat(DATE_FORMAT).format(dt.toLocal());
                        })(),
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: e.value["title"] + ":", //
                        border: OutlineInputBorder(), //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today, size: 20), //
                      ),
                      onTap: () async {
                        final DateTime? datetime = await datetime_picker(context);
                        if (datetime == null) return;
                        output[e.key] = datetime.toIso8601String();
                        setState(() {});
                      }, //,
                    ),
                  );
                }

                return SizedBox();
              }),

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
    //     if (double.tryParse(s["value"]) == null) {
    //       snackbar_show(context: context, message: "${s["title"]} must be a number.", color: Colors.red);
    //       return;
    //     }
    //   }
    // }

    // request
    await dio
        .post("$PATH/data_create", data: FormData.fromMap({...output}))
        .then((r) {
          output["_id"] = r.data["_id"];
          Navigator.pop(context, output);
          snackbar_show(context: context, message: "$HEADER create successfully.", color: Colors.green);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "$HEADER create failed.", color: Colors.red);
        });
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(MaterialApp(title: TITLE, theme: Theme_Data(), debugShowCheckedModeBanner: false, home: const Main_()));
}
