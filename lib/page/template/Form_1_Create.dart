import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speanmeas/Environment.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '__Setup__.dart';
import 'Schema.g.dart';

void main() {
  runApp(Form_Create());
}

class Form_Create extends StatelessWidget {
  Form_Create({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Form_Create_(),
    );
  }
}

class Form_Create_ extends StatefulWidget {
  Form_Create_({
    super.key, //
  });

  @override
  State<Form_Create_> createState() => _Form_Create_State();
}

class _Form_Create_State extends State<Form_Create_> {
  Map<String, dynamic> output = {};

  @override
  void initState() {
    super.initState();

    for (var e in schema) {
      output[e["key"]] = null;
    }
  }

  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ...schema.map((row) {
                // print(row);

                // todo: handle foreign key

                if (row["kind"] == "text") {
                  return Container(
                    width: 600,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      decoration: InputDecoration(
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
                if (row["kind"] == "number") {
                  return Container(
                    width: 600,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: row['title'], //
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

                if (row["kind"] == "boolean") {
                  return Container(
                    width: 600,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      children: [
                        // is_admin
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                              text: output[row["key"]] == "1"
                                  ? "Yes"
                                  : (output[row["key"]] == "0"
                                        ? "No" //
                                        : (output[row["key"]] ?? "")),
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(), //
                              labelText: "${row['title'] as String? ?? ""}:",
                              labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),

                        // bank
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.check_circle_outline), //
                            label: Text("Yes"), //
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
                            onPressed: () {
                              output[row["key"]] = "1";
                              setState(() {});
                            }, //
                          ),
                        ),

                        // cash
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.cancel_outlined), //
                            label: Text("No"), //
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                            onPressed: () {
                              output[row["key"]] = "0";
                              setState(() {});
                            }, //
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //
                if (row["kind"] == "datetime") {
                  return Container(
                    width: 600,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: output[row["key"]] ?? ""),
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(), //
                              labelText: row['title'], //
                              labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final DateTime? datetime = await datetime_picker(context);
                              if (datetime == null) return;
                              output[row["key"]] = datetime_to_string(datetime);
                              setState(() {});
                            }, //
                            label: Text("Select"),
                            icon: const Icon(Icons.calendar_today),
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                          ),
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
                    onPressed: create_pressed,
                  ),
                ],
              ),

              SizedBox(height: screen_height - 120),
            ],
          ),
        ),
      ),
    );
  }

  void create_pressed() async {
    //
    print(output);

    await dio
        .post(
          '$PATH/data_create',
          data: FormData.fromMap({
            ...output, //
          }),
        )
        .then((value) {
          print(value);
          snackbar_show(
            context: context, //
            message: "$HEADER create successfully.",
            color: Colors.green,
          );
          Navigator.pop(context, true);
        })
        .catchError((error) {
          print(error);
          snackbar_show(
            context: context, //
            message: "$HEADER create failed.",
            color: Colors.red,
          );
        });
  }
}
