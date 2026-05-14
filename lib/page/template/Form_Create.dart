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

    for (var e in schema) {
      output[e["alias"]] = null;
    }

    print(output);
  }

  DateTime? selectedDateTime;

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
              ...schema.map((row) {
                // print(row);

                if (row["hide"] == 1) {
                  return SizedBox.shrink();
                }

                if (row["type"] == "text") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row['alias']] = value; //
                      },
                    ),
                  );
                }

                //
                if (row["type"] == "number") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                      onChanged: (value) {
                        output[row['alias']] = double.tryParse(value);
                      },
                    ),
                  );
                }

                //
                if (row["type"] == "datetime") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: Row(
                      children: [
                        Text("${row['title'] as String? ?? ""} : "),

                        OutlinedButton.icon(
                          onPressed: () async {
                            final DateTime? datetime = await datetime_picker(context);

                            if (datetime == null) return;

                            output[row['alias']] = datetime_to_string(datetime);

                            setState(() {});
                          }, //
                          // label: Text("Select Datetime"),
                          label: Text(output[row['alias']] == null ? "Select Datetime" : output[row['alias']]!),
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
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
