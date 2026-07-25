import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:speanmeas/theme/theme_data.dart";

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadField<int>(
      controller: widget.controller,
      itemBuilder: (context, item) => ListTile(title: Text(item.toString())),
      suggestionsCallback: (q) => widget.options.toList(),
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 8), //
              child: Icon(Icons.arrow_drop_down),
            ),
          ),
        );
      },
      onSelected: (value) {
        widget.controller.text = value.toString();
        widget.onChanged.call(value);
      },
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.controller,
    required this.title,
    required this.options,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String title;
  final List<int> options;
  final ValueChanged<int?> onChanged;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: Scaffold(
        body: Center(
          child: Main_(
            controller: TextEditingController(text: "1"),
            title: "Number of Guests:",
            options: List.generate(100, (index) => index),
            onChanged: (value) {
              print("Selected value: $value");
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
