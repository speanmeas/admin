import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_light.dart" as theme;

class Main_ extends StatelessWidget {
  const Main_({
    super.key, //
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.login_outlined, color: Colors.green), //
        SizedBox(width: 4), //
        Text(
          "Check In", //
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
        ), //
      ],
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      theme: theme.data(), //
      home: const Scaffold(
        body: Center(
          child: Main_(
            // //
            // title: "Hello",
            // value: "World",
            // suffix: "!",
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
