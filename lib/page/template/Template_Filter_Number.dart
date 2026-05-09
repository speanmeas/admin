import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

void main() {
  runApp(Room_Filter_Number());
}

class Room_Filter_Number extends StatelessWidget {
  Room_Filter_Number({super.key});

  String key_ = "capacity";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Room_Filter_Number_(key_: key_),
    );
  }
}

class Room_Filter_Number_ extends StatefulWidget {
  Room_Filter_Number_({
    super.key, //

    required this.key_,
  });

  String key_;

  @override
  State<Room_Filter_Number_> createState() => _Room_Filter_Number_State();
}

class _Room_Filter_Number_State extends State<Room_Filter_Number_> {
  double min = 0.0; // need to query follow key_
  double max = 100.0; // need to query

  late double select_min = min;
  late double select_max = max;

  late RangeValues range;

  @override
  void initState() {
    super.initState();
    range = RangeValues(min, max);
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
                      controller: TextEditingController(text: range.start.toStringAsFixed(2)),
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
                      controller: TextEditingController(text: range.end.toStringAsFixed(2)),
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
                values: range,
                min: min,
                max: max,
                divisions: 1000,
                labels: RangeLabels(
                  range.start.toStringAsFixed(2), //
                  range.end.toStringAsFixed(2),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    range = values;
                  });
                },
              ),

              SizedBox(height: 20),

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
            ],
          ),
        ),
      ),
    );
  }

  void on_apply_filter() {
    double select_min = double.parse(range.start.toStringAsFixed(2));
    double select_max = double.parse(range.end.toStringAsFixed(2));
    print(select_min);
    print(select_max);

    Navigator.pop(context, {
      "min": select_min, //
      "max": select_max,
    });
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
