import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Global.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "_Setup.dart";
import "schema.g.dart";

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
      home: Main_(id: ""),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key, required this.id});

  final String id;

  @override
  State<Main_> createState() => _Main_State();
}

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
        .post("$PATH/data_delete", data: FormData.fromMap({"_id": widget.id}))
        .then((value) {
          Navigator.pop(context, true);
          snackbar_show(context: context, message: "Delete successfully", color: Colors.green);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "Delete failed", color: Colors.red);
        });
  }
}
