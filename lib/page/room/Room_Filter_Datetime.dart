import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() {
  runApp(Room_Filter_Datetime());
}

class Room_Filter_Datetime extends StatelessWidget {
  Room_Filter_Datetime({super.key});

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
      home: Room_Filter_Datetime_(schema: schema, input: input),
    );
  }
}

class Room_Filter_Datetime_ extends StatefulWidget {
  Room_Filter_Datetime_({
    super.key, //
    required this.schema,
    required this.input,
  });

  List<Map<String, dynamic>> schema;
  Map<String, dynamic> input;

  @override
  State<Room_Filter_Datetime_> createState() => _Room_Filter_Datetime_State();
}

class _Room_Filter_Datetime_State extends State<Room_Filter_Datetime_> {
  late Map<String, dynamic> output;

  @override
  void initState() {
    super.initState();

    output = Map.from(widget.input);

    print(output);

    // print(output);
    setState(() {});
  }

  String? start;
  String? end;

  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();

  TimeOfDay start_time = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay end_time = TimeOfDay(hour: 23, minute: 59);

  String format_date(DateTime date) {
    return date.toIso8601String().substring(0, 10);
  }

  String format_time(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  String format_date_time(DateTime date, TimeOfDay time) {
    return "${date.toIso8601String().substring(0, 10)} ${format_time(time)}";
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
          padding: EdgeInsets.all(8),
          child: ListView(
            children: [
              //
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Start Date-Time:", //
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(width: 8),

                  OutlinedButton.icon(
                    onPressed: () async {
                      final DateTime? date = await showDatePicker(
                        context: context, //
                        initialDate: start_date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          start_date = date;
                          print(format_date(date));
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text(format_date(start_date)),
                  ),

                  SizedBox(width: 16),

                  OutlinedButton.icon(
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context, //
                        initialTime: start_time,
                      );
                      if (time != null) {
                        setState(() {
                          start_time = time;
                          print(format_time(time));
                        });
                      }
                    },
                    icon: Icon(Icons.access_time),
                    label: Text(format_time(start_time)),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "End Date-Time:", //
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(width: 8),

                  OutlinedButton.icon(
                    onPressed: () async {
                      final DateTime? date = await showDatePicker(
                        context: context, //
                        initialDate: end_date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          end_date = date;
                          print(format_date(date));
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text(format_date(end_date)),
                  ),

                  SizedBox(width: 16),

                  OutlinedButton.icon(
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context, //
                        initialTime: end_time,
                      );
                      if (time != null) {
                        setState(() {
                          end_time = time;
                          print(format_time(time));
                        });
                      }
                    },
                    icon: Icon(Icons.access_time),
                    label: Text(format_time(end_time)),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(
                    message: "Apply filter",
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.filter_alt_outlined),
                      label: Text("Apply"), //
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
    print("Filter");
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
