import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/Environment.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

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
      appBar: AppBar(
        title: Row(
          children: [
            Text("Login"), //
          ],
        ),
        toolbarHeight: 40,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          width: 800,
          child: ListView(
            children: [
              Text("Login"), //
            ],
          ),
        ),
      ),
    );
  }
}
