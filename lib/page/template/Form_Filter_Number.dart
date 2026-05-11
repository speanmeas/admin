import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

import 'Initialize.dart';
import 'Schema.g.dart';

void main() {
  runApp(Filter_Number());
}

class Filter_Number extends StatelessWidget {
  Filter_Number({super.key});

  String key_ = "capacity";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Filter_Number_(key_: key_),
    );
  }
}

class Filter_Number_ extends StatefulWidget {
  Filter_Number_({
    super.key, //

    required this.key_,
  });

  String key_;

  @override
  State<Filter_Number_> createState() => _Filter_Number_State();
}

class _Filter_Number_State extends State<Filter_Number_> {
  double lower_bound = -1000000; // todo: need to query follow key_
  double upper_bound = 1000000; // todo: need to query

  late double select_min = lower_bound;
  late double select_max = upper_bound;

  // late RangeValues range;

  bool is_min_changed = false;
  bool is_max_changed = false;

  @override
  void initState() {
    super.initState();
    // range = RangeValues(lower_bound, upper_bound);
  }

  TextEditingController controller_min = TextEditingController();
  TextEditingController controller_max = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter $HEADER", //
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
                      controller: controller_min,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Min", //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: is_min_changed
                            ? IconButton(
                                onPressed: () {
                                  // range = RangeValues(double.parse(controller_min.text), range.end);
                                  select_min = double.parse(controller_min.text);
                                  is_min_changed = false;
                                  setState(() {});
                                },
                                icon: Icon(Icons.check),
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        is_min_changed = true;
                        setState(() {});
                      },
                      onSubmitted: (value) {
                        // range = RangeValues(double.parse(value), range.end);
                        select_min = double.parse(value);
                        is_min_changed = false;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller_max,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Max", //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: is_max_changed
                            ? IconButton(
                                onPressed: () {
                                  select_max = double.parse(controller_max.text);
                                  is_max_changed = false;
                                  setState(() {});
                                },
                                icon: Icon(Icons.check),
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        is_max_changed = true;
                        setState(() {});
                      },
                      onSubmitted: (value) {
                        // range = RangeValues(range.start, double.parse(value));
                        select_max = double.parse(value);
                        is_max_changed = false;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 40),

              // RangeSlider(
              //   values: range,
              //   min: min,
              //   max: max,
              //   divisions: 1000,
              //   labels: RangeLabels(
              //     range.start.toStringAsFixed(2), //
              //     range.end.toStringAsFixed(2),
              //   ),
              //   onChanged: (RangeValues values) {
              //     setState(() {
              //       range = values;
              //     });
              //   },
              // ),
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
            ],
          ),
        ),
      ),
    );
  }

  void on_apply_filter() {
    // double select_min = double.parse(range.start.toStringAsFixed(2));
    // double select_max = double.parse(range.end.toStringAsFixed(2));
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
