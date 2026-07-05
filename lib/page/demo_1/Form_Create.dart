import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
  Main_({
    super.key, //
  });

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //

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
              ...schema.map((row) {
                //
                //
                //

                // note
                if (row["key"] == "note") {
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
                        row["value"] = v;
                      },
                    ),
                  );
                }

                //
                //
                //

                // string
                if (row["type"] == "string") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: row["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        row["value"] = v; //
                      },
                    ),
                  );
                }

                // number
                if (row["type"] == "number") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                      decoration: InputDecoration(
                        labelText: row["title"] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (v) {
                        row["value"] = v; //
                      },
                    ),
                  );
                }

                if (row["type"] == "boolean") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: row["title"] + ":",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
                      items: ["Yes", "No"].map((i) {
                        return DropdownMenuItem<String>(value: i, child: Text(i));
                      }).toList(),
                      onChanged: (v) {
                        if (v == "Yes") row["value"] = true;
                        if (v == "No") row["value"] = false;
                        setState(() {});
                      },
                    ),
                  );
                }

                if (row["type"] == "date-time") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: row["value"] ?? ""),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: row["title"] + ":", //
                        border: OutlineInputBorder(), //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today, size: 20), //
                      ),
                      onTap: () async {
                        final DateTime? datetime = await datetime_picker(context);
                        if (datetime == null) return;
                        row["value"] = DateFormat(DATE_FORMAT).format(datetime);
                        setState(() {});
                      }, //,
                    ),
                  );
                }

                return SizedBox.shrink();
              }),

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
        if (double.tryParse(s["value"]) == null) {
          snackbar_show(context: context, message: "${s["title"]} must be a number.", color: Colors.red);
          return;
        }
      }
    }

    // prepare output
    Map<String, dynamic> output = {for (var s in schema) s["key"]: s["value"]};

    // request
    await dio
        .post("$PATH/data_create", data: FormData.fromMap({...output}))
        .then((r) {
          print(r.data);
          output["_id"] = r.data["_id"]; // NOTE: support to update and delete
          snackbar_show(context: context, message: "$HEADER create successfully.", color: Colors.green);
          Navigator.pop(context, output);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "$HEADER create failed.", color: Colors.red);
        });

    // clear input values
    for (var s in schema) s["value"] = null;
  }
}
