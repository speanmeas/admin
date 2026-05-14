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
      home: const Login_(), //
    );
  }
}

class Login_ extends StatefulWidget {
  const Login_({super.key});

  @override
  State<Login_> createState() => _Login_State();
}

class _Login_State extends State<Login_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            "Login", //
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), //
          ), //
          Text("Welcome to the login page"),
        ],
      ),
    );
  }
}
