import "package:flutter/material.dart";

import "package:speanmeas/Global.dart";
import "package:speanmeas/Environment.dart";
import "package:speanmeas/theme/Theme_Data.dart";

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
                  child: TextField(
                    controller: TextEditingController(text: value),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    readOnly: true,
                    maxLines: e.key.contains("note") ? 4 : 1,
                    decoration: InputDecoration(
                      labelText: e.value["title"] + ": ", //
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: InputBorder.none,
                      prefix: SizedBox(width: 16),
                    ),
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
      theme: Theme_Data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
