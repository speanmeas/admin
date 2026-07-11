import "package:flutter/material.dart";

import "package:speanmeas/theme/theme_data.dart";

class _Main_State extends State<Main_> {
  //
  var controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) controller.text = widget.initialValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: "Note:",
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (v) {
        widget.onChanged?.call(v);
      },
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.initialValue,
    this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: const Scaffold(
        body: Center(
          child: Main_(
            //
            initialValue: "Hello World",
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
