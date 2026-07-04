import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Global.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "__Setup__.dart";

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
  Main_({
    super.key, //
  });

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //
  final controller_search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter Text", //
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
                child: TextField(
                  controller: controller_search,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "Search:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (value) {},
                  onSubmitted: (_) => on_apply_filter(),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.filter_alt_outlined),
                  label: Text("Apply"), //
                  onPressed: on_apply_filter,
                ),
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
    if (controller_search.text.isEmpty) {
      snackbar_show(
        context: context, //
        message: "Please enter a filter",
        color: Colors.red,
      );
      return;
    }

    Navigator.pop(context, controller_search.text.trim());

    snackbar_show(context: context, message: "Filter applied", color: Colors.green);
  }
}
