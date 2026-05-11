import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() {
  runApp(Room_Filter_String());
}

class Room_Filter_String extends StatelessWidget {
  Room_Filter_String({super.key});

  // List<Map<String, dynamic>> schema = [
  //   {"alias": "_id", "title": "ID", "type": "string", "visible": 0},
  //   {"alias": "name", "title": "Room No.", "type": "string", "visible": 1},
  //   {"alias": "type", "title": "Room Type", "type": "string", "visible": 1},
  //   {"alias": "capacity", "title": "Capacity", "type": "number", "visible": 1},
  //   {"alias": "ac_or_fan", "title": "AC or Fan", "type": "string", "visible": 1},
  //   {"alias": "price", "title": "Price", "type": "number", "visible": 1},
  //   {"alias": "status", "title": "Status", "type": "string", "visible": 1},
  //   {"alias": "created_at", "title": "Created At", "type": "datetime", "visible": 0},
  //   {"alias": "updated_at", "title": "Updated At", "type": "datetime", "visible": 0},
  //   {"alias": "deleted_at", "title": "Deleted At", "type": "datetime", "visible": 0},
  // ];

  // Map<String, dynamic> input = {
  //   "_id": 1, //
  //   "name": "Room 1", //
  //   "type": null, //
  //   "capacity": 10,
  //   "ac_or_fan": "AC",
  //   "price": null,
  //   "status": "Active",
  //   "created_at": "2022-01-01 00:00:00",
  //   "updated_at": "2022-01-01 00:00:00",
  //   "deleted_at": null,
  // };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Room_Filter_String_(),
    );
  }
}

class Room_Filter_String_ extends StatefulWidget {
  Room_Filter_String_({
    super.key, //
    // required this.schema,
    // required this.input,
  });

  // List<Map<String, dynamic>> schema;
  // Map<String, dynamic> input;

  @override
  State<Room_Filter_String_> createState() => _Room_Filter_String_State();
}

class _Room_Filter_String_State extends State<Room_Filter_String_> {
  TextEditingController controller_search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter", //
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
            tooltip: "Close",
          ),
          SizedBox(width: 4),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: Center(
        child: Container(
          width: 600,
          // alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(8),
          child: ListView(
            children: [
              //
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller_search,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Filter", //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {},
                      onSubmitted: (_) => on_apply_filter(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: "Apply filter",
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.filter_alt_outlined), //
                      label: Text("Apply"),
                      onPressed: on_apply_filter,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void on_apply_filter() {
    Navigator.pop(context, controller_search.text);
    show_snackbar(context: context, message: "Filter applied", color: Colors.green);
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
