import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/Global.dart";

import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "_Setup.dart";

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
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
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //
  bool? filter_value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter Logical", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

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
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: (() {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Logical:", //
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
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

              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.toggle_on_outlined),
                  label: Text("Apply"), //
                  onPressed: on_apply_filter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_apply_filter() {
    // validate

    if (filter_value == null) {
      snackbar_show(context: context, message: "Please select a value", color: Colors.red);
      return;
    }

    filter_value ??= false;

    Navigator.pop(context, filter_value);

    snackbar_show(context: context, message: "Filter applied", color: Colors.green);
  }
}
