import "dart:io";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/theme/Theme_Data.dart";

import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/widget/Datetime_Picker.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "__Setup__.dart";
import "Schema.g.dart";

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  @override
  void initState() {
    super.initState();
  }

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
              ...schema.map((s) {
                //
                //
                //
                if (s["key"] == "note") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: s["value"]?.toString() ?? ""),
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Note:", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        s["value"] = v; //
                      },
                    ),
                  );
                }

                //
                if (s["key"] == "password") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: ""),
                      decoration: InputDecoration(
                        labelText: s["title"], //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        s["value"] = v; //
                      },
                    ),
                  );
                }

                //
                //
                //

                //
                if (s["type"] == "string") {
                  String value = s["value"]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value),
                      decoration: InputDecoration(
                        labelText: s["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        s["value"] = v; //
                      },
                    ),
                  );
                }

                // edit number
                if (s["type"] == "number") {
                  String? value = s["value"]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value),
                      decoration: InputDecoration(
                        labelText: s["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                      onChanged: (v) {
                        s["value"] = v; //
                      },
                    ),
                  );
                }

                if (s["type"] == "boolean") {
                  String? value;
                  if (s["value"] == true) value = "Yes";
                  if (s["value"] == false) value = "No";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: DropdownButtonFormField<String>(
                      initialValue: value,
                      decoration: InputDecoration(
                        labelText: s["title"] + ":",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
                      items: ["Yes", "No"].map((i) {
                        return DropdownMenuItem<String>(value: i, child: Text(i));
                      }).toList(),
                      onChanged: (v) {
                        if (v == "Yes") {
                          s["value"] = true;
                        } else {
                          s["value"] = false;
                        }
                        setState(() {});
                      },
                    ),
                  );
                }

                if (s["type"] == "date-time") {
                  String? value = s["value"]?.toString() ?? "";
                  if (value.isNotEmpty) {
                    DateTime? tmp = DateTime.tryParse(value);
                    if (tmp != null) value = DateFormat("yyyy-MM-dd HH:mm:ss").format(tmp.toLocal());
                  }
                  //
                  DateTime? initial_datetime = DateTime.tryParse(value);
                  if (initial_datetime != null) initial_datetime = DateTime.now();
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //
                        labelText: s["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today, size: 20), //
                      ),
                      onTap: () async {
                        final DateTime? datetime = await datetime_picker(
                          context, //
                          initial_datetime: initial_datetime,
                        );
                        if (datetime == null) return;
                        s["value"] = DateFormat("yyyy-MM-dd HH:mm:ss").format(datetime);
                        setState(() {});
                      }, //,
                    ),
                  );
                }

                return SizedBox.shrink();
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
    // todo: validation

    // 0. debug
    // for (var s in schema) print(s);

    // 1. validate required fields
    for (var s in schema) {
      if (s["key"] == "_id") continue; // skip id field
      if (s["key"] == "note") continue; // skip note field
      if (s["value"] == null) {
        snackbar_show(context: context, message: "${s["title"]} is required.", color: Colors.red);
        return;
      }
    }

    // 2. validate number fields
    for (var s in schema) {
      if (s["type"] == "number") {
        final tmp = double.tryParse(s["value"].toString());
        if (tmp == null) {
          snackbar_show(context: context, message: "${s["title"]} must be a number.", color: Colors.red);
          return;
        }
      }
    }

    // prepare output
    Map<String, dynamic> output = {for (var s in schema) s["key"]: s["value"]};

    // request
    await dio
        .post("$PATH/data_update", data: FormData.fromMap({...output}))
        .then((value) {
          snackbar_show(context: context, message: "$HEADER update successfully", color: Colors.green);
          Navigator.pop(context, output);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "$HEADER update failed", color: Colors.red);
        });

    // clear schema values
    for (var s in schema) s["value"] = null;
  }
}
