import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Zetup.dart';
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
  double? select_min;
  double? select_max;

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
                        // suffixIcon: Icon(Icons.arrow_downward),
                      ),
                    ),
                  ),

                  SizedBox(width: 4),

                  Icon(Icons.arrow_right_alt_outlined),

                  SizedBox(width: 4),

                  Expanded(
                    child: TextField(
                      controller: controller_max,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Max", //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
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
    select_min = double.parse(controller_min.text);
    select_max = double.parse(controller_max.text);

    // check if min and max are valid numbers
    if (select_min == null || select_max == null) {
      snackbar_show(
        context: context, //
        message: "Please enter valid numbers",
        color: Colors.red,
      );
      return;
    }

    // validate min and max
    if (select_min! > select_max!) {
      snackbar_show(
        context: context, //
        message: "Min must be less or equal to max",
        color: Colors.red,
      );
      return;
    }

    Navigator.pop(context, {
      "min": select_min, //
      "max": select_max,
    });

    snackbar_show(
      context: context, //
      message: "Filter applied",
      color: Colors.green,
    );
  }
}
