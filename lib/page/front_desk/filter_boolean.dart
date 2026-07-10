import "package:flutter/material.dart";

import "package:speanmeas/environment.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "_setup.dart";

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

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: HEADER, //
      theme: Theme_Data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
