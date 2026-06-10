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
      home: Filter_Boolean_(),
    );
  }
}

class Filter_Boolean_ extends StatefulWidget {
  Filter_Boolean_({super.key});

  @override
  State<Filter_Boolean_> createState() => _Filter_Boolean_State();
}

class _Filter_Boolean_State extends State<Filter_Boolean_> {
  bool filter_value = false;

  double screen_height = 0;

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: (() {
                  return DropdownButtonFormField<String>(
                    initialValue: "No",
                    decoration: InputDecoration(
                      labelText: "Filter", //
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
                    ),
                    items: ["Yes", "No"].map((i) {
                      return DropdownMenuItem<String>(value: i, child: Text(i));
                    }).toList(),
                    onChanged: (v) {
                      if (v == "Yes") {
                        filter_value = true;
                      } else {
                        filter_value = false;
                      }
                      setState(() {});
                    },
                  );
                })(),
              ),

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
            ],
          ),
        ),
      ),
    );
  }

  void on_apply_filter() {
    // validate

    Navigator.pop(context, filter_value);

    snackbar_show(context: context, message: "Filter applied", color: Colors.green);
  }
}
