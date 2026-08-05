import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "../config.dart";
import "../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delete", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // * បញ្ជាក់
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Text("Confirm to delete?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),

              // * ប៊ូតុង Delete
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  autofocus: true,
                  icon: Icon(Icons.delete_outlined),
                  label: Text("Delete"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: on_delete,
                  // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_delete() async {
    try {
      //
      print(schema.data[schema.ID]?["value"]);
      tmp = await dio.post(
        "$PATH/delete", //
        data: {
          schema.ID: schema.data[schema.ID]?["value"], //
        },
      );

      //
      snackbar.view(context: context, message: "Success", color: Colors.green);

      //
      Navigator.pop(context, tmp.data);

      //
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: "Failed", color: Colors.red);
    }
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
      title: "Development", //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
