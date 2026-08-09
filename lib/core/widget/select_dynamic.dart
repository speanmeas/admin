import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:speanmeas/core/theme/theme_data.dart";

class _SelectDynamicState extends State<SelectDynamic> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadField<dynamic>(
      controller: widget.controller,
      itemBuilder: (context, i) => ListTile(title: Text(i.toString())),
      suggestionsCallback: (q) => widget.options?.toList(),
      builder: (context, controller, focusNode) {
        return TextField(
          readOnly: true,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: widget.prefixIcon,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 4),
              child: IconButton(
                icon: Icon(Icons.clear, color: Colors.red),
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged?.call(null);
                },
              ), //
            ),
          ),
        );
      },
      onSelected: (value) {
        widget.controller.text = value.toString();
        widget.onChanged?.call(value);
      },
    );
  }
}

class SelectDynamic extends StatefulWidget {
  const SelectDynamic({
    super.key, //
    required this.controller,
    this.title,
    this.options,
    this.onChanged,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String? title;
  final List<dynamic>? options;
  final Function(dynamic)? onChanged;
  final Widget? prefixIcon;

  @override
  State<SelectDynamic> createState() => _SelectDynamicState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Center(
          child: SelectDynamic(
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
