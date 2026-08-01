import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "../../__config__.dart";

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => global, //
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
          snackbar.view(context: context, message: "Success", color: Colors.green);
        })
        .catchError((e) {
          snackbar.view(context: context, message: "Failed to delete room", color: Colors.red);
        });
  }
}
