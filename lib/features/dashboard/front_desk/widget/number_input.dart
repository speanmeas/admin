import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:speanmeas/core/theme/theme_light.dart" as theme;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  bool is_valid = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(widget.prefixIcon, size: 20, color: Colors.black),
        suffixText: widget.suffixText,
        errorText: is_valid ? null : "Invalid number.",
      ),

      onChanged: (v) {
        if (v.isEmpty) {
          is_valid = true;
          widget.onChanged?.call(null);
          setState(() {});
          return;
        }

        double? value = double.tryParse(v);
        if (value == null) {
          is_valid = false;
          widget.controller.clear();
          widget.onChanged?.call(null);
          setState(() {});
          return;
        }

        is_valid = true;
        widget.onChanged?.call(value);
        setState(() {});
      },
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.controller,
    required this.title,
    required this.prefixIcon,
    required this.suffixText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String title;
  final IconData prefixIcon;
  final String suffixText;
  final ValueChanged<double?>? onChanged;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  double? num = 100.0;

  final controller = TextEditingController(text: num.toString());

  runApp(
    MaterialApp(
      theme: theme.data(), //
      home: Scaffold(
        body: Center(
          child: Main_(
            controller: controller, //
            title: "Paid Bank USD:",
            prefixIcon: Icons.account_balance,
            suffixText: "\$",
            onChanged: (v) {
              print(v);
              num = v;
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
