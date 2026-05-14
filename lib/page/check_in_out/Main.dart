import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/Environment.dart';

void main() {
  runApp(const Template());
}

class Template extends StatelessWidget {
  const Template({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Check_In_Out_(), //
    );
  }
}

class Check_In_Out_ extends StatefulWidget {
  const Check_In_Out_({super.key});

  @override
  State<Check_In_Out_> createState() => _Check_In_Out_State();
}

class _Check_In_Out_State extends State<Check_In_Out_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            "Check In/Out", //
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), //
          ), //
          Text("Welcome to the check in/out page"),
        ],
      ),
    );
  }
}
