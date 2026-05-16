import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/Global_Variable.dart';

import 'Setup.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Variable(), //
      child: const Body(),
    ),
  );
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body',
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: const Panel_Body_()),
    );
  }
}

class Panel_Body_ extends StatefulWidget {
  const Panel_Body_({super.key});

  @override
  State<Panel_Body_> createState() => _Panel_Body_State();
}

class _Panel_Body_State extends State<Panel_Body_> {
  //
  String body = "Dashboard";

  @override
  Widget build(BuildContext context) {
    final v = context.watch<Variable>();

    // validate body
    if (pages.containsKey(v.body)) {
      body = v.body;
    }

    return IndexedStack(
      index: pages.keys.toList().indexOf(body), //
      children: pages.values.toList(), //
    );
  }
}
