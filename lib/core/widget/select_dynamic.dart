import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:speanmeas/core/theme/theme_light.dart" as theme;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  //
  @override
  Widget build(BuildContext context) {
    return TypeAheadField<dynamic>(
      controller: widget.controller,
      itemBuilder: (context, i) => ListTile(title: Text(i.toString())),
      suggestionsCallback: (q) => widget.options.toList(),
      builder: (context, controller, focusNode) {
        return TextField(
          readOnly: true,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 4),
              child: IconButton(
                icon: Icon(Icons.clear, color: Colors.red),
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged.call(null);
                },
              ), //
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
  final List<dynamic> options;
  final ValueChanged<dynamic> onChanged;

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
