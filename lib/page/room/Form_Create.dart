import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Setup.dart';
import 'Schema.g.dart';

void main() {
  runApp(Template());
}

class Template extends StatelessWidget {
  Template({super.key});

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

  DateTime? selectedDateTime;

  Future<void> pickDateTime() async {
    // Select Date
    final DateTime? pickedDate = await showDatePicker(
      context: context, //
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // Select Time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context, //
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    // Combine Date + Time
    final DateTime finalDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

    setState(() {
      selectedDateTime = finalDateTime;
    });

    print(finalDateTime);
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
              ...schema
                  .where(
                    (e) =>
                        !["_id", "created_at", "updated_at", "deleted_at"] //
                            .contains(e["alias"]),
                  )
                  .map((e) {
                    // print(e);`

                    if (e["type"] == "string") {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
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

                    //
                    if (e["type"] == "number") {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
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

                    //
                    if (e["type"] == "datetime") {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                        child: Row(
                          children: [
                            Text("${e['title'] as String? ?? ""} : "),

                            OutlinedButton.icon(
                              onPressed: () async {
                                final DateTime? datetime = await datetime_picker(context);

                                if (datetime == null) return;

                                output[e['alias']] = datetime_to_string(datetime);

                                setState(() {});
                              }, //
                              // label: Text("Select Datetime"),
                              label: Text(output[e['alias']] == null ? "Select Datetime" : output[e['alias']]!),
                              icon: const Icon(Icons.calendar_today),
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
                      print(output);
                      await dio
                          .post(
                            '$PATH/create',
                            data: FormData.fromMap({
                              ...output, //
                            }),
                          )
                          .then((value) {
                            print(value);
                            snackbar_show(
                              context: context, //
                              message: "Room create successfully",
                              color: Colors.green,
                            );
                            Navigator.pop(context, true);
                          })
                          .catchError((error) {
                            print(error);
                            snackbar_show(
                              context: context, //
                              message: "Room create failed",
                              color: Colors.red,
                            );
                          });
                    },
                  ),
                ],
              ),

              SizedBox(height: 1000),
            ],
          ),
        ),
      ),
    );
  }
}
