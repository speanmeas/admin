import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '__Setup__.dart';

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
          "Filter Number", //
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
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_min,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    hintText: "Input", //
                    labelText: "Min value:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    if (v.isEmpty) {
                      select_min = 0;
                      setState(() {});
                      return;
                    }

                    if (double.tryParse(v) == null) {
                      controller_min.text = v.substring(0, v.length - 1);
                      controller_min.selection = TextSelection.collapsed(offset: controller_min.text.length);
                    }

                    select_min = double.tryParse(v) ?? 0;
                    setState(() {});
                  }, //,
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_max,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    hintText: "Input", //
                    labelText: "Max value:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    if (v.isEmpty) {
                      select_max = 0;
                      setState(() {});
                      return;
                    }

                    if (double.tryParse(v) == null) {
                      controller_max.text = v.substring(0, v.length - 1);
                      controller_max.selection = TextSelection.collapsed(offset: controller_max.text.length);
                    }

                    select_max = double.tryParse(v) ?? 0;
                    setState(() {});
                  }, //,
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.tune),
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
