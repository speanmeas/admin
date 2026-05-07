import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() {
  runApp(Room_Filter_Number());
}

class Room_Filter_Number extends StatelessWidget {
  Room_Filter_Number({super.key});

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
      home: Room_Filter_Number_(schema: schema, input: input),
    );
  }
}

class Room_Filter_Number_ extends StatefulWidget {
  Room_Filter_Number_({
    super.key, //
    required this.schema,
    required this.input,
  });

  List<Map<String, dynamic>> schema;
  Map<String, dynamic> input;

  @override
  State<Room_Filter_Number_> createState() => _Room_Filter_Number_State();
}

class _Room_Filter_Number_State extends State<Room_Filter_Number_> {
  late Map<String, dynamic> output;

  double min = 0.0;
  double max = 100.0;

  late double select_min = min;
  late double select_max = max;

  RangeValues _rangeValues = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();
    output = Map.from(widget.input);
    print(output);
    setState(() {});
  }

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
                      controller: TextEditingController(text: _rangeValues.start.toStringAsFixed(2)),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Min", //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: _rangeValues.end.toStringAsFixed(2)),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Max", //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              RangeSlider(
                values: _rangeValues,
                min: min,
                max: max,
                divisions: 1000,
                labels: RangeLabels(
                  _rangeValues.start.toStringAsFixed(2), //
                  _rangeValues.end.toStringAsFixed(2),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _rangeValues = values;
                  });
                },
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: "Apply filter",
                    child: OutlinedButton.icon(icon: Icon(Icons.filter_alt_outlined), label: Text("Apply"), onPressed: on_apply_filter),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_apply_filter() {
    final select_min = double.parse(_rangeValues.start.toStringAsFixed(2));
    final select_max = double.parse(_rangeValues.end.toStringAsFixed(2));
    print(select_min);
    print(select_max);
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
