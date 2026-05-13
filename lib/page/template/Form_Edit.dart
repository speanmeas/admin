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

  Map<String, dynamic> input = {
    "_id": 1, //
    "string_1": "a", //
    "string_2": "aa", //
    "string_3": "aaa", //
    "number_1": 1,
    "number_2": 11,
    "number_3": 111,
    "datetime_1": "2022-01-01 00:00:00",
    "datetime_2": "2022-01-01 00:00:00",
    "datetime_3": "2022-01-01 00:00:00",
    "created_at": "2022-01-01 00:00:00",
    "updated_at": "2022-01-01 00:00:00",
    "deleted_at": null,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Edit_(input: input),
    );
  }
}

class Edit_ extends StatefulWidget {
  Edit_({
    super.key, //
    required this.input,
  });

  Map<String, dynamic> input;

  @override
  State<Edit_> createState() => _Edit_State();
}

class _Edit_State extends State<Edit_> {
  late Map<String, dynamic> output;

  @override
  void initState() {
    super.initState();

    output = Map.from(widget.input);

    // for (var e in widget.schema.sublist(0, widget.schema.length - 3)) {
    //   output[e["alias"]] = null;
    // }

    print(output);

    // print(output);
    setState(() {});
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
          child: ListView(
            children: [
              ...schema.where((e) => !["_id", "created_at", "updated_at", "deleted_at"].contains(e["alias"])).map((e) {
                // edit string
                if (e["type"] == "string") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? ''),
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

                // edit number
                if (e["type"] == "number") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? ''),
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

                // edit datetime
                if (e["type"] == "datetime") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: Row(
                      children: [
                        Text("${e['title'] ?? ""} : "),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final DateTime? datetime = await datetime_picker(context);

                            if (datetime == null) return;

                            output[e['alias']] = datetime_to_string(datetime);

                            setState(() {});
                          },
                          label: Text(output[e['alias']] == null ? "Select Datetime" : output[e['alias']]!),
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
              }),

              SizedBox(height: 8),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < 10; i++)
                      Container(
                        width: 100, //
                        height: 100,
                        margin: EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            // TODO: Handle image tap
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_outlined),
                                      title: Text('Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.upload_outlined),
                                      title: Text('Upload'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.delete_outlined),
                                      title: Text('Delete'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Placeholder(),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.edit_outlined),
                    label: Text("Update"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: () async {
                      // print(output);
                      await dio
                          .post(
                            '$PATH/update',
                            data: FormData.fromMap({
                              ...output, //
                            }),
                          )
                          .then((value) {
                            // print(value);
                            snackbar_show(
                              context: context, //
                              message: "Room update successfully",
                              color: Colors.green,
                            );
                            Navigator.pop(context, true);
                          })
                          .catchError((error) {
                            // print(error);
                            snackbar_show(
                              context: context, //
                              message: "Room update failed",
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
