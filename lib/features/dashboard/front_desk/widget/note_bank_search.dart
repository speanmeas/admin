import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _NoteBankSearchState extends State<NoteBankSearch> {
  dynamic tmp;
  dynamic data;

  List<String> options = [];

  void init() async {
    try {
      tmp = await dio.post(endpoint.BANK_CRUD_READ);
      data = tmp.data as List<dynamic>;

      for (var to in [" to ABA Bank", " to ACLEDA Bank"])
        for (var from in data.map((e) => e["name"])) //
          if (from.isNotEmpty) options.add("$from$to");
    } catch (e, st) {
      pprint(st);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<dynamic>(
      controller: widget.controller,
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      suggestionsCallback: (q) {
        List<dynamic> opts = [];
        for (var e in options) {
          final tmp = e.split(" to ")[0];
          if (tmp.toLowerCase().contains(q.toLowerCase())) //
            opts.add(e);
        }
        return opts;
      },
      builder: (context, controller, focusNode) {
        return TextField(
          maxLines: 4,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Note:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(Icons.note_alt_outlined, color: Colors.blue),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.arrow_drop_down, color: Colors.blue),
            ),
          ),
          onChanged: (v) {
            //
          },
        );
      },
      onSelected: (v) {
        widget.controller.text = v.toString();
        widget.onChanged?.call(v);
      },
    );
  }

  @override
  initState() {
    super.initState();
    init();
  }
}

class NoteBankSearch extends StatefulWidget {
  const NoteBankSearch({
    super.key, //
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final Function(dynamic)? onChanged;

  @override
  State<NoteBankSearch> createState() => _NoteBankSearchState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Center(
          child: NoteBankSearch(
            controller: TextEditingController(text: ""),
            onChanged: (data) {
              print("Selected Data: $data");
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}