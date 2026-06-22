import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '__Setup__.dart';
import 'Schema.g.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  Map<String, dynamic> input = {
    "text_1": "a", //
    "text_2": "aa",
    "number_1": 1,
    "number_2": 11,
    "datetime_1": "2024-01-01T00:00:00Z",
    "datetime_2": "2024-02-02T00:00:00Z",
    "boolean_1": true,
    "boolean_2": false,
    "note": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Form_Update_(input: input),
    );
  }
}

class Form_Update_ extends StatefulWidget {
  Form_Update_({
    super.key, //
    required this.input,
  });

  Map<String, dynamic> input;

  @override
  State<Form_Update_> createState() => _Form_Update_State();
}

class _Form_Update_State extends State<Form_Update_> {
  Map<String, dynamic> output = {};

  @override
  void initState() {
    super.initState();
    output = widget.input;
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update $HEADER", //
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ...schema.map((row) {
                //
                //
                //
                if (row["key"] == "note") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]]?.toString() ?? ''),
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter text...", //
                        border: OutlineInputBorder(),
                        labelText: "Note:", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row["key"]] = value; //
                      },
                    ),
                  );
                }

                //
                if (row["key"] == "password") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: ''),
                      decoration: InputDecoration(
                        hintText: "Enter new password", //
                        labelText: row['title'], //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row["key"]] = value; //
                      },
                    ),
                  );
                }

                //
                //
                //

                //
                if (row["type"] == "string") {
                  String value = output[row["key"]]?.toString() ?? '';
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value),
                      decoration: InputDecoration(
                        hintText: "Input", //
                        labelText: row['title'] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row["key"]] = value; //
                      },
                    ),
                  );
                }

                // edit number
                if (row["type"] == "number") {
                  String? value = output[row["key"]]?.toString() ?? '';
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value),
                      decoration: InputDecoration(
                        hintText: "Input", //
                        labelText: row['title'] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                      onChanged: (value) {
                        output[row["key"]] = double.tryParse(value);
                      },
                    ),
                  );
                }

                if (row["type"] == "boolean") {
                  String? value;
                  if (output[row["key"]] == true) {
                    value = "Yes";
                  }
                  if (output[row["key"]] == false) {
                    value = "No";
                  }
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: DropdownButtonFormField<String>(
                      initialValue: value,
                      decoration: InputDecoration(
                        hintText: "Select", //
                        labelText: row['title'] + ":",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
                      items: ["Yes", "No"].map((i) {
                        return DropdownMenuItem<String>(value: i, child: Text(i));
                      }).toList(),
                      onChanged: (v) {
                        if (v == "Yes") {
                          output[row["key"]] = true;
                        } else {
                          output[row["key"]] = false;
                        }
                        setState(() {});
                      },
                    ),
                  );
                }

                if (row["type"] == "date-time") {
                  String? value = output[row["key"]]?.toString() ?? '';
                  if (value.isNotEmpty) {
                    DateTime? tmp = DateTime.tryParse(value);
                    if (tmp != null) {
                      value = DateFormat('yyyy-MM-dd HH:mm:ss').format(tmp.toLocal());
                    }
                  }
                  DateTime? initial_datetime = DateTime.tryParse(value);
                  if (initial_datetime != null) {
                    initial_datetime = DateTime.now();
                  }
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //
                        hintText: "Select",
                        labelText: row['title'] + ":", //
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
                        output[row["key"]] = datetime_to_string(datetime);
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

              // more space at the bottom
              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  void on_update() async {
    print("Output: $output");
    await dio
        .post('$PATH/data_update', data: FormData.fromMap({...output}))
        .then((value) {
          print(output);
          snackbar_show(context: context, message: "$HEADER update successfully", color: Colors.green);
          Navigator.pop(context, output);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "$HEADER update failed", color: Colors.red);
        });
  }
}
