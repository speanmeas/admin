import "package:flutter/material.dart";
import "package:speanmeas/core/theme/theme_data.dart";

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Notification"), //
      //   centerTitle: false,
      //   toolbarHeight: 40,
      //   titleSpacing: 0,
      // ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: [
                Text("Report yearly is under development."), //
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    ),
  );
}
