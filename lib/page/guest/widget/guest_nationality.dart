import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/theme_data.dart";

import "../../nationality/_setup.dart";
import "../../nationality/schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  final TextEditingController c_search = TextEditingController();
  final FocusNode focusNode = FocusNode();

  List<Map<String, dynamic>> data = [];
  bool is_selected = false;
  List<String> options = [];

  @override
  void initState() {
    super.initState();

    c_search.text = widget.initialValue ?? "";

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        if (!options.contains(c_search.text.trim())) {
          c_search.clear();
        }
      }
    });

    init();
  }

  Future<void> init() async {
    await dio
        .post("$PATH/data_read", data: FormData.fromMap({}))
        .then((r) {
          data = List<Map<String, dynamic>>.from(r.data);
          options = List<String>.from(data.map((e) => e[schema.NATIONALITY]).toList());
          options.sort((a, b) => a.compareTo(b));
          setState(() {});
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: c_search,
      focusNode: focusNode,
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      suggestionsCallback: (q) {
        return options.where((o) => o.toLowerCase().contains(q.trim().toLowerCase())).toList();
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: "Nationality:",
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => is_selected = false,
        );
      },
      onSelected: (v) {
        c_search.text = v;
        is_selected = true;
        widget.onChanged?.call(v);
      },
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key, this.initialValue, this.onChanged});

  final String? initialValue;
  final ValueChanged<String>? onChanged;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(),
      home: const Scaffold(
        body: Center(child: Main_(initialValue: "Cambodian")),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
