import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

import 'Initialize.dart';
import 'Schema.g.dart';

void main() {
  runApp(Create());
}

class Create extends StatelessWidget {
  Create({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Create_(),
    );
  }
}

class Create_ extends StatefulWidget {
  Create_({
    super.key, //
  });

  @override
  State<Create_> createState() => _Create_State();
}

class _Create_State extends State<Create_> {
  Map<String, dynamic> output = {};

  @override
  void initState() {
    super.initState();

    for (var e in schema.sublist(0, schema.length - 3)) {
      output[e["alias"]] = null;
    }

    print(output);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create $HEADER", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
          ),
          SizedBox(width: 8),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: Center(
        child: Container(
          width: 600,
          // alignment: Alignment.bottomCenter,
          // padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: ListView(
            children: [
              ...schema.map((e) {
                // print(e);
                if (["_id", "created_at", "updated_at", "deleted_at"].contains(e["alias"])) {
                  return SizedBox.shrink();
                }

                if (e["type"] == "string") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: e['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[e['alias']] = value; //
                      },
                    ),
                  );
                }

                if (e["type"] == "number") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: e['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                      onChanged: (value) {
                        output[e['alias']] = double.tryParse(value);
                      },
                    ),
                  );
                }
                if (e["type"] == "date-time") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: Row(
                      children: [
                        Text("${e['title'] as String? ?? ""} : "),

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              //   final DateTime? date = await showDatePicker(
                              //     context: context, //
                              //     initialDate: start_date,
                              //     firstDate: DateTime(2000),
                              //     lastDate: DateTime(2100),
                              //   );
                              //   if (date != null) {
                              //     setState(() {
                              //       start_date = date;
                              //       print(format_date(date));
                              //     });
                              //   }
                            },
                            icon: Icon(Icons.calendar_today),
                            label: Text("Select Date"),
                          ),
                        ),
                        Text(" - "), //

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              // final TimeOfDay? time = await showTimePicker(
                              //   context: context, //
                              //   initialTime: start_time,
                              // );
                              // if (time != null) {
                              //   setState(() {
                              //     start_time = time;
                              //     print(format_time(time));
                              //   });
                              // }
                            },
                            icon: Icon(Icons.access_time),
                            label: Text("Select Time"),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();

                // return Padding(
                //   padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       labelText: e["title"], //
                //       floatingLabelBehavior: FloatingLabelBehavior.always,
                //     ),
                //     onChanged: (value) {
                //       output[e["alias"]] = value;
                //     },
                //   ),
                // );
              }),

              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.add_task),
                    label: Text("Create"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: () async {
                      await dio
                          .post(
                            '$PATH/create',
                            data: FormData.fromMap({
                              ...output, //
                            }),
                          )
                          .then((value) {
                            print(value);
                            show_snackbar(context: context, message: "Room create successfully", color: Colors.green);
                            Navigator.pop(context, true);
                          })
                          .catchError((error) {
                            print(error);
                            show_snackbar(context: context, message: "Room create failed", color: Colors.red);
                          });
                    },
                  ),
                ],
              ),

              SizedBox(height: 800),
            ],
          ),
        ),
      ),
    );
  }
}

void show_snackbar({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
