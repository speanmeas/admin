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
      home: const Dashboard_(), //
    );
  }
}

class Dashboard_ extends StatefulWidget {
  const Dashboard_({super.key});

  @override
  State<Dashboard_> createState() => _Dashboard_State();
}

class _Dashboard_State extends State<Dashboard_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            "Dashboard", //
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), //
          ), //
          Text("Welcome to the dashboard"),
        ],
      ),
    );
  }
}
