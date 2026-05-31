import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Setup.dart';
import 'Schema.g.dart';

void main() {
  runApp(Create_Select_Foreign());
}

class Create_Select_Foreign extends StatelessWidget {
  Create_Select_Foreign({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Create_Select_Foreign_(),
    );
  }
}

class Create_Select_Foreign_ extends StatefulWidget {
  Create_Select_Foreign_({
    super.key, //
  });

  @override
  State<Create_Select_Foreign_> createState() => _Create_Select_Foreign_State();
}

class _Create_Select_Foreign_State extends State<Create_Select_Foreign_> {
  TextEditingController controller_search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Select Foreign", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            tooltip: "Close",
          ),
          SizedBox(width: 4),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: Center(
        child: Container(
          width: 600,
          // alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(8),
          child: ListView(
            children: [
              //
              Text("This is a select foreign key page, you can search for the foreign key and select it to fill the primary key in the create form.", style: TextStyle(fontSize: 16)),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
