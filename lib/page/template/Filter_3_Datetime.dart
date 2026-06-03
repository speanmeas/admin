import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Zetup.dart';
import 'Schema.g.dart';

void main() {
  runApp(Filter_Datetime());
}

class Filter_Datetime extends StatelessWidget {
  Filter_Datetime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Filter_Datetime_(),
    );
  }
}

class Filter_Datetime_ extends StatefulWidget {
  Filter_Datetime_({super.key});

  @override
  State<Filter_Datetime_> createState() => _Filter_Datetime_State();
}

class _Filter_Datetime_State extends State<Filter_Datetime_> {
  String? start_datetime;
  String? end_datetime;

  // DateTime start_date = DateTime.now();
  // DateTime end_date = DateTime.now();

  // TimeOfDay start_time = TimeOfDay(hour: 0, minute: 0);
  // TimeOfDay end_time = TimeOfDay(hour: 0, minute: 0);

  // String format_date(DateTime date) {
  //   return date.toIso8601String().substring(0, 10);
  // }

  // String format_time(TimeOfDay time) {
  //   return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  // }

  // String format_date_time(DateTime date, TimeOfDay time) {
  //   return "${date.toIso8601String().substring(0, 10)} ${format_time(time)}";
  // }

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
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final datetime = await datetime_picker(context);
                        print(datetime);
                        print(datetime_to_string(datetime));
                        setState(() {
                          start_datetime = datetime_to_string(datetime);
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(start_datetime ?? "Select Start Datetime"),
                    ),
                  ),

                  SizedBox(width: 4),

                  Icon(Icons.arrow_right_alt_outlined),

                  SizedBox(width: 4),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final datetime = await datetime_picker(context);
                        print(datetime);
                        print(datetime_to_string(datetime));
                        setState(() {
                          end_datetime = datetime_to_string(datetime);
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(end_datetime ?? "Select End Datetime"),
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
                      icon: Icon(Icons.filter_alt_outlined),
                      label: Text("Apply"), //
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
    // start = format_date_time(start_date, start_time);
    // end = format_date_time(end_date, end_time);

    // validate start and end datetime
    if (start_datetime == null || end_datetime == null) {
      snackbar_show(
        context: context, //
        message: "Please select start and end datetime",
        color: Colors.red,
      );
      return;
    }

    // please put end datetime after start datetime
    if (DateTime.parse(end_datetime!).isBefore(DateTime.parse(start_datetime!))) {
      snackbar_show(
        context: context, //
        message: "End datetime must be after start datetime",
        color: Colors.red,
      );
      return;
    }

    // print start and end datetime
    // print("Filter: $start_datetime to $end_datetime");

    Navigator.pop(context, {
      "start": start_datetime, //
      "end": end_datetime,
    });

    snackbar_show(
      context: context, //
      message: "Filter applied",
      color: Colors.green,
    );
  }
}
