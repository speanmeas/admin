import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '__Setup__.dart';
import 'Schema.g.dart';

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

  String id = "69f984897186bcf74f8a5dde";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Form_Delete_(id: id),
    );
  }
}

class Form_Delete_ extends StatefulWidget {
  Form_Delete_({super.key, required this.id});

  final String id;

  @override
  State<Form_Delete_> createState() => _Form_Delete_State();
}

class _Form_Delete_State extends State<Form_Delete_> {
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
                child: Text(
                  "Confirm to delete?", //
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
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
        .post(
          '$PATH/data_delete',
          data: FormData.fromMap({
            "id": widget.id, //
          }),
        )
        .then((value) {
          print(value);
          snackbar_show(
            context: context, //
            message: "Room deleted successfully",
            color: Colors.green,
          );
          Navigator.pop(context, true);
        })
        .catchError((error) {
          print(error);
          snackbar_show(
            context: context, //
            message: "Failed to delete room",
            color: Colors.red,
          );
        });
  }
}
