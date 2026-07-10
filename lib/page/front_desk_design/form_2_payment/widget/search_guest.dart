import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";

// import "../../nationality/_setup.dart";
// import "../../nationality/schema.g.dart" as schema;
import "../../../guest/schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController c_search = TextEditingController();

  bool is_selected = false;
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (!focusNode.hasFocus && !is_selected) {
        c_search.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: c_search,
      focusNode: focusNode,
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      suggestionsCallback: on_search,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: "Search:",
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => is_selected = false,
        );
      },
      onSelected: (v) {
        //
        c_search.text = v;
        is_selected = true;

        // print(v);

        Map<String, dynamic> data_selected = {};
        for (var e in data) {
          if (e[schema.GUEST_PHONE] == v) {
            data_selected = e;
            break;
          }
        }

        // print(data_selected);

        widget.onChanged?.call(data_selected);
      },
    );
  }

  Future<List<String>> on_search(String query) async {
    List<String> options = [];
    await dio
        .post(
          "/guest/data_read", //
          data: FormData.fromMap({
            "key": schema.GUEST_PHONE, //
            "query": query, //
            "order": 1, //
            "limit": 1000, //
          }),
        )
        .then((r) {
          data = List<Map<String, dynamic>>.from(r.data);

          for (var g in data) {
            if (g[schema.GUEST_PHONE] == null) continue;
            options.add(g[schema.GUEST_PHONE] ?? "");
          }
        })
        .catchError((_) {});

    return options;
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.onChanged,
  });

  final ValueChanged<Map<String, dynamic>>? onChanged;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: const Scaffold(body: Center(child: Main_())),
      debugShowCheckedModeBanner: false,
    ),
  );
}
