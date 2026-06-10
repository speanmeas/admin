import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '__Setup__.dart';
import 'Schema.g.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Filter_Number_(),
    );
  }
}

class Filter_Number_ extends StatefulWidget {
  Filter_Number_({super.key});

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
