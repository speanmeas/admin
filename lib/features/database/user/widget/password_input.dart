import "package:flutter/material.dart";
import "package:speanmeas/core/theme/light.dart" as theme;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter a new password", //
        labelText: "Password:", //
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.text_fields), //
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 4),
          child: IconButton(
            icon: Icon(Icons.clear, color: Colors.red),
            onPressed: () {
              widget.controller.clear();
              widget.onCleared.call();
              widget.onChanged.call(null);
            },
          ), //
        ),
      ),
      onChanged: (v) {
        widget.onChanged.call(v);
      },
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.controller,
    required this.onChanged,
    required this.onCleared,
  });

  final TextEditingController controller;
  final ValueChanged<String?> onChanged;
  final VoidCallback onCleared;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme.data(), //
      home: Scaffold(
        body: Center(
          child: Main_(
            controller: TextEditingController(),
            onChanged: (data) {
              print("Selected Data: $data");
            },
            onCleared: () {
              // print("Field cleared");
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
