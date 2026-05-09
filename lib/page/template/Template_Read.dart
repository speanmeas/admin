import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() {
  runApp(Room_Read());
}

class Room_Read extends StatelessWidget {
  Room_Read({super.key});

  List<Map<String, dynamic>> schema = [
    {"alias": "_id", "title": "ID", "type": "string", "visible": 0},
    {"alias": "name", "title": "Room No.", "type": "string", "visible": 1},
    {"alias": "type", "title": "Room Type", "type": "string", "visible": 1},
    {"alias": "capacity", "title": "Capacity", "type": "number", "visible": 1},
    {"alias": "ac_or_fan", "title": "AC or Fan", "type": "string", "visible": 1},
    {"alias": "price", "title": "Price", "type": "number", "visible": 1},
    {"alias": "status", "title": "Status", "type": "string", "visible": 1},
    {"alias": "created_at", "title": "Created At", "type": "date-time", "visible": 0},
    {"alias": "updated_at", "title": "Updated At", "type": "date-time", "visible": 0},
    {"alias": "deleted_at", "title": "Deleted At", "type": "date-time", "visible": 0},
  ];

  Map<String, dynamic> input = {
    "_id": 1, //
    "name": "Room 1", //
    "type": null, //
    "capacity": 10,
    "ac_or_fan": "AC",
    "price": null,
    "status": "Active",
    "created_at": "2022-01-01 00:00:00",
    "updated_at": "2022-01-01 00:00:00",
    "deleted_at": null,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Room_Read_(schema: schema, input: input),
    );
  }
}

class Room_Read_ extends StatefulWidget {
  Room_Read_({
    super.key, //
    required this.schema,
    required this.input,
  });

  List<Map<String, dynamic>> schema;
  Map<String, dynamic> input;

  @override
  State<Room_Read_> createState() => _Room_Read_State();
}

class _Room_Read_State extends State<Room_Read_> {
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
          "View Room", //
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
              SizedBox(height: 16),

              Center(
                child: Container(
                  width: 200,
                  height: 200, //
                  child: Placeholder(),
                ),
              ),

              SizedBox(height: 16),

              ...widget.schema.map((e) {
                //
                if (["_id", "created_at", "updated_at", "deleted_at"].contains(e["alias"])) {
                  return SizedBox.shrink();
                }

                //
                if (e["type"] == "string") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: e['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
                    ),
                  );
                }

                //
                if (e["type"] == "number") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? '0'),
                      decoration: InputDecoration(
                        labelText: e['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
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
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
                    ),
                  );
                }

                //
                return SizedBox.shrink();
              }),

              SizedBox(height: 8),
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
