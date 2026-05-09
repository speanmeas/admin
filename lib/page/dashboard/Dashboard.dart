import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/Environment.dart';

void main() {
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
      appBar: AppBar(
        title: Row(
          children: [
            Text("Dashboard"), //
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
              Text("Dashboard"), //
            ],
          ),
        ),
      ),
    );
  }
}
