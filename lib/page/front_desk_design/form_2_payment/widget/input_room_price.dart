import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";

class _Main_State extends State<Main_> {
  //
  var controller = TextEditingController();

  bool is_valid = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) controller.text = widget.initialValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
      decoration: InputDecoration(
        labelText: "Room Price (USD):",
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.bed_outlined, size: 20, color: Colors.black),
        suffixText: "\$",
        errorText: is_valid ? null : "Invalid number",
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
          controller.clear();
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
    this.initialValue,
    this.onChanged,
  });

  final double? initialValue;
  final ValueChanged<double?>? onChanged;

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
            initialValue: 100.0,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
