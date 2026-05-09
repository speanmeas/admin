import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speanmeas/page/room/Schema.g.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() {
  runApp(Room_Create());
}

class Room_Create extends StatelessWidget {
  Room_Create({super.key});

  List<Map<String, dynamic>> schema = [
    {"alias": "_id", "title": "ID", "type": "string", "visible": 0},
    {"alias": "name", "title": "Room No.", "type": "string", "visible": 1},
    {"alias": "type", "title": "Room Type", "type": "string", "visible": 1},
    {"alias": "capacity", "title": "Capacity", "type": "number", "visible": 1},
    {"alias": "ac_or_fan", "title": "AC or Fan", "type": "string", "visible": 1},
    {"alias": "price", "title": "Price", "type": "number", "visible": 1},
    {"alias": "status", "title": "Status", "type": "string", "visible": 1},
    //
    {"alias": "created_at", "title": "Created At", "type": "date-time", "visible": 1},
    {"alias": "updated_at", "title": "Updated At", "type": "date-time", "visible": 0},
    {"alias": "deleted_at", "title": "Deleted At", "type": "date-time", "visible": 0},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Room_Create_(schema: schema),
    );
  }
}

class Room_Create_ extends StatefulWidget {
  Room_Create_({
    super.key, //
    required this.schema,
  });

  List<Map<String, dynamic>> schema;

  @override
  State<Room_Create_> createState() => _Room_Create_State();
}

class _Room_Create_State extends State<Room_Create_> {
  Map<String, dynamic> output = {};

  @override
  void initState() {
    super.initState();

    for (var e in widget.schema.sublist(0, widget.schema.length - 3)) {
      output[e["alias"]] = null;
    }

    print(output);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Room", //
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
              ...widget.schema.map((e) {
                // print(e);
                if (["_id", "created_at", "updated_at", "deleted_at"].contains(e["alias"])) {
                  return SizedBox.shrink();
                }

                if (e["type"] == "string") {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
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
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
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

                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: TextField(
                    decoration: InputDecoration(labelText: e["title"]),
                    onChanged: (value) {
                      output[e["alias"]] = value;
                    },
                  ),
                );
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
                            '/room/create',
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
