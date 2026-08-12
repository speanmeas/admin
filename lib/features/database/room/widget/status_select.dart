import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Main_State extends State<Main_> {
  //
  final controller = TextEditingController();

  void init() {
    if (widget.initial != null) {
      controller.text = widget.initial!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: controller,
      suggestionsCallback: (query) => ["Available", "Pending Pay", "Pending Leave", "Pending Clean", "Pending Fix"],
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Select Status:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(Icons.verified_outlined, color: Colors.blue),
            suffixIcon: ExcludeFocus(
              child: Padding(
                padding: EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(Icons.clear, color: Colors.red),
                  onPressed: () {
                    controller.clear();
                    widget.onChanged?.call(null);
                    setState(() {});
                  },
                ), //
              ),
            ),
          ),
        );
      },
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      onSelected: (v) {
        controller.text = v;
        widget.onChanged?.call(v);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.initial,
    this.onChanged,
  });

  final String? initial;
  final ValueChanged<String?>? onChanged;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Center(
          child: Main_(
            initial: "Available",
            onChanged: (v) {
              print("Changed: $v");
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
