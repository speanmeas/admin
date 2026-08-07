import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:flutter_typeahead/flutter_typeahead.dart";

//
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";

import "package:speanmeas/features/database/guest/form/create.dart" as g_create;
import "package:speanmeas/features/database/guest/schema.g.dart" as g_schema;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  FocusNode focusNode = FocusNode();
  bool is_selected = false;
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();

    //
    focusNode.addListener(() {
      if (!focusNode.hasFocus && !is_selected) {
        widget.controller.clear();
        widget.onChanged?.call({});
      }
    });

    //
    if (widget.controller.text.isNotEmpty) init(widget.controller.text);
  }

  void init(dynamic q) async {
    try {
      tmp = await dio.post(
        ep.GUEST_FORM_SEARCH, //
        data: {"query": q},
      );

      final items = List<Map<String, dynamic>>.from(tmp.data);
      if (items.isEmpty) {
        is_selected = false;
        widget.onChanged?.call({});
        return;
      }

      is_selected = true;
      widget.controller.text = items[0][g_schema.FULL_NAME];

      widget.onChanged?.call(items[0]);
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TypeAheadField<String>(
            controller: widget.controller,
            focusNode: focusNode,
            itemBuilder: (context, item) => ListTile(title: Text(item)),
            suggestionsCallback: (q) async => await search(q),
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: "Search Guest:",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onCleared?.call();
                        widget.onChanged?.call({});
                      },
                    ), //
                  ),
                ),
                onChanged: (v) => is_selected = false,
              );
            },
            onSelected: (v) {
              is_selected = true;

              // select from data list
              Map<String, dynamic> d = {};
              for (var e in data) {
                if ("${e[g_schema.FULL_NAME] ?? ""} (${e[g_schema.PHONE_NUMBER] ?? "N/A"})" == v) {
                  d = e;
                  break;
                }
              }

              widget.controller.text = d[g_schema.FULL_NAME] ?? "";

              widget.onChanged?.call(d);
            },
          ),
        ),

        //
        SizedBox(width: 4),

        //
        OutlinedButton.icon(
          icon: Icon(Icons.add_outlined),
          label: Text("New"),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            //
            g_schema.clear();

            //
            final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => g_create.Main_()));
            if (v == null) return;

            //
            select_by_id(v[g_schema.ID]);

            //
          },
        ),
      ],
    );
  }

  void select_by_id(dynamic id) async {
    try {
      tmp = await dio.post(
        ep.GUEST_READ_ID, //
        data: {"_id": id},
      );

      is_selected = true;
      widget.controller.text = tmp.data[0][g_schema.FULL_NAME];

      widget.onChanged?.call(tmp.data[0]);
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  Future<List<String>> search(dynamic q) async {
    try {
      //
      tmp = await dio.post(
        ep.GUEST_FORM_SEARCH, //
        data: {"query": q},
      );
      data = List<Map<String, dynamic>>.from(tmp.data);

      //
      List<String> options = [];
      for (var d in data) {
        final text = "${d[g_schema.FULL_NAME] ?? ""} (${d[g_schema.PHONE_NUMBER] ?? "N/A"})";
        options.add(text);
      }

      //
      return options;
      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
      return [];
    }
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
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final VoidCallback? onCleared;

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
            controller: TextEditingController(text: "Sengly"),
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
