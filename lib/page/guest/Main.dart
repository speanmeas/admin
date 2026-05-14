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
      home: const Guest_(), //
    );
  }
}

class Guest_ extends StatefulWidget {
  const Guest_({super.key});

  @override
  State<Guest_> createState() => _Guest_State();
}

class _Guest_State extends State<Guest_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            "Guest", //
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), //
          ), //
          Text("Welcome to the guest page"),
        ],
      ),
    );
  }
}
