import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:speanmeas/core/theme/theme_data.dart";

class _Select_DynamicState extends State<Select_Dynamic> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.init != null) {
      controller.text = widget.init.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<dynamic>(
      controller: controller,
      itemBuilder: (context, i) => ListTile(title: Text(i.toString())),
      suggestionsCallback: (q) => widget.options?.toList() ?? <dynamic>[],
      builder: (context, controller, focusNode) {
        return TextField(
          readOnly: true,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.lead,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(widget.prefixIcon),
            suffixIcon: Padding(
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
        );
      },
      onSelected: (value) {
        controller.text = value.toString();
        widget.onChanged?.call(value);
      },
    );
  }
}

class Select_Dynamic extends StatefulWidget {
  const Select_Dynamic({
    super.key, //
    required this.options,
    required this.onChanged,
    this.lead,
    this.init,
    this.prefixIcon,
  });

  final String? lead;
  final dynamic init;
  final List<dynamic>? options;
  final Function(dynamic)? onChanged;
  final IconData? prefixIcon;

  @override
  State<Select_Dynamic> createState() => _Select_DynamicState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Center(
          child: Select_Dynamic(
            lead: "Number of Guests:",
            init: 5,
            options: List.generate(100, (index) => index),
            prefixIcon: Icons.people_alt_outlined, //
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
