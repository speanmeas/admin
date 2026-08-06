import "package:flutter/material.dart";
import "package:speanmeas/core/theme/light.dart" as theme;
import "package:flutter_typeahead/flutter_typeahead.dart";

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: widget.controller,
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      suggestionsCallback: (q) async {
        return ["Available", "Pending Pay", "Pending Leave", "Pending Clean", "Pending Fix"];
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Select Status:",
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(Icons.verified_outlined, color: Colors.blue),
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
        );
      },
      onSelected: (v) {
        widget.controller.text = v;
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
            controller: TextEditingController(text: "Available"),
            onChanged: (data) {
              print("Selected Data: $data");
            },
            onCleared: () {
              print("Field cleared");
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
