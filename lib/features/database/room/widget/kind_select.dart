import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

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
      suggestionsCallback: (query) => ["Single", "Double", "VIP"],
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Select Type:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(Icons.king_bed_outlined, color: Colors.blue),
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
            initial: "Single",
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
