import "package:flutter/material.dart";

import "package:speanmeas/global.dart";
import "package:speanmeas/environment.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/show_data.dart" as show_data;

import "_setup.dart";
import "schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Read - $HEADER", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ...schema.data.entries.where((e) => !e.key.contains("_id")).map((e) {
                String value = e.value["value"]?.toString() ?? "";
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: show_data.Main_(
                    title: e.value["title"], //
                    value: value,
                    max_lines: e.key.contains("note") ? 4 : 1,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
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
