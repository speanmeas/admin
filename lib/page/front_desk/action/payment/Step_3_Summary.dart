import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/layout/Layout.dart";
import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "../../Setup.dart";
import "../../Schema.g.dart" as schema;

import "Step_3a_Receipt.dart" as step_3a;

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "3. Payment - Summary", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          // if (can_next())
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: OutlinedButton.icon(
              icon: Icon(Icons.payment_outlined),
              label: Text("Paid"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: on_paid, //
            ),
          ),
        ],

        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              // view search guest result
              ...schema.data.map((row) {
                //
                if (row["type"] == "string") {
                  // String value = "";
                  String value = row["value"]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row["title"] + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "number") {
                  // String value = "";
                  String value = row["value"]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "boolean") {
                  // String value = "";
                  String value = row["value"]?.toString() ?? "false";
                  value = value.toLowerCase() == "true" ? "Yes" : "No";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["type"] == "date-time") {
                  // String value = "";
                  String value = row["value"]?.toString() ?? "";
                  if (value.isNotEmpty) {
                    DateTime? tmp = DateTime.tryParse(value);
                    if (tmp != null) {
                      value = DateFormat(DATE_FORMAT).format(tmp.toLocal());
                    }
                  }
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
              }),

              // button check in + print
              // if (can_print())
              //   Container(
              //     margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
              //     child: OutlinedButton.icon(
              //       label: Text("Print"),
              //       icon: Icon(Icons.print_outlined),
              //       onPressed: on_print, //
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  void on_paid() async {
    //
    Map<String, dynamic> output = {for (var s in schema.data) s["key"]: s["value"]};

    //
    await dio
        .post("/front_desk/data_update", data: FormData.fromMap({...output}))
        .then((r) {
          snackbar_show(context: context, message: "Update successfully.", color: Colors.green);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context, output);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "Update failed.", color: Colors.red);
        });

    //
    String? room_id = output[schema.ROOM_ID];
    await dio.post(
      "/room/data_update",
      data: FormData.fromMap({
        "_id": room_id, //
        "room_status": "Pending Leave",
      }),
    );
  }
}
