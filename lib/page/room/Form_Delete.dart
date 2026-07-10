import "package:flutter/material.dart";
import "package:dio/dio.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/environment.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "_setup.dart";
import "schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delete - $HEADER", //
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
              // confirmation
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Text("Confirm to delete?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),

              // button delete
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
    //
    await dio
        .post("$PATH/data_delete", data: FormData.fromMap({"_id": schema.data["_id"]?["value"]}))
        .then((value) {
          Navigator.pop(context, true);
          snackbar_show(context: context, message: "Delete successfully", color: Colors.green);
        })
        .catchError((e) {
          snackbar_show(context: context, message: "Delete failed", color: Colors.red);
        });
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(MaterialApp(theme: Theme_Data(), debugShowCheckedModeBanner: false, home: const Main_()));
}
