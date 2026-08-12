import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Select_StringState extends State<Select_String> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      controller.text = widget.initial.toString();
      widget.onChanged?.call(widget.initial.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: controller,
      itemBuilder: (context, i) => ListTile(title: Text(i)),
      suggestionsCallback: (q) => widget.options ?? [],
      builder: (context, controller, focusNode) {
        return TextField(
          readOnly: true,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.leading,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: widget.prefixIcon,
            suffixIcon: ExcludeFocus(
              child: Padding(
                padding: EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(Icons.clear, color: Colors.red),
                  onPressed: () {
                    controller.clear();
                    widget.onChanged?.call(null);
                  },
                ), //
              ),
            ),
          ),
        );
      },
      onSelected: (v) {
        controller.text = v.toString();
        widget.onChanged?.call(v);
      },
    );
  }
}

class Select_String extends StatefulWidget {
  const Select_String({
    super.key, //
    this.leading,
    this.initial,
    required this.options,
    required this.onChanged,
    this.prefixIcon,
  });

  final String? leading;
  final String? initial;
  final List<String>? options;
  final Function(String?)? onChanged;
  final Widget? prefixIcon;

  @override
  State<Select_String> createState() => _Select_StringState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Center(
          child: Select_String(
            leading: "Number of Guests:",
            initial: "5",
            options: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
            prefixIcon: Icon(Icons.people_alt_outlined), //
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
