import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";

import "package:speanmeas/page/guest/schema.w.dart" as guest_schema_w;
import "package:speanmeas/widget/snackbar_show.dart";

class _Main_State extends State<Main_> {
  // * ប្រើសម្រាប់...
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller_search = TextEditingController();

  bool is_selected = false;
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (!focusNode.hasFocus && !is_selected) {
        controller_search.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: controller_search,
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
          onChanged: (v) {
            is_selected = false; //

            if (v.isEmpty) {
              widget.onChanged?.call({});
            }
          },
        );
      },
      onSelected: (v) {
        //
        controller_search.text = v;
        is_selected = true;

        Map<String, dynamic> data_selected = {};
        for (var d in data) {
          if (d[guest_schema_w.PHONE_NUMBER] == v) {
            data_selected = d;
            break;
          }
        }

        widget.onChanged?.call(data_selected);
      },
    );
  }

  Future<List<String>> on_search(String query) async {
    try {
      //

      List<String> options = [];
      final r = await dio.post(
        "/guest/read_string", //
        data: FormData.fromMap({
          "key": guest_schema_w.PHONE_NUMBER, //
          "query": query, //
          "order": 1, //
          "limit": 1000, //
        }),
      );

      data = List<Map<String, dynamic>>.from(r.data);

      for (var d in data) {
        if (d[guest_schema_w.PHONE_NUMBER] == null) continue;
        options.add(d[guest_schema_w.PHONE_NUMBER] ?? "");
      }

      return options;

      //
    } catch (e) {
      return [];
    }
  }
}

class Main_ extends StatefulWidget {
  Main_({
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
      home: Scaffold(
        body: Center(
          child: Main_(
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
