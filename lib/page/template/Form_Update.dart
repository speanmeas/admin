import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

import 'Initialize.dart';
import 'Schema.g.dart';

void main() {
  runApp(Update());
}

class Update extends StatelessWidget {
  Update({super.key});

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
      home: Update_(input: input),
    );
  }
}

class Update_ extends StatefulWidget {
  Update_({
    super.key, //
    required this.input,
  });

  Map<String, dynamic> input;

  @override
  State<Update_> createState() => _Update_State();
}

class _Update_State extends State<Update_> {
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
              ...schema.map((e) {
                if (["_id", "created_at", "updated_at", "deleted_at"].contains(e["alias"])) {
                  return SizedBox.shrink();
                }

                if (e["type"] == "string") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: e['title'], //
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
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: e['title'], //
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                      onChanged: (value) {
                        output[e['alias']] = double.tryParse(value);
                      },
                    ),
                  );
                }

                // TODO: later
                if (e["type"] == "date-time") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: e['title'], //
                      ),
                      keyboardType: TextInputType.datetime,
                      onChanged: (value) {
                        output[e['alias']] = value;
                      },
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
                            show_snackbar(context: context, message: "Room update successfully", color: Colors.green);
                            Navigator.pop(context, true);
                          })
                          .catchError((error) {
                            // print(error);
                            show_snackbar(context: context, message: "Room update failed", color: Colors.red);
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
