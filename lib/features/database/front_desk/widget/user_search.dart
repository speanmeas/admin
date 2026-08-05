import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

//
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;

//
import "package:speanmeas/features/database/user/schema.g.dart" as n_schema_r;
import "package:speanmeas/core/widget/snackbar.dart" as sb;

class _Main_State extends State<Main_> {
  dynamic tmp;
  FocusNode focusNode = FocusNode();
  bool is_selected = false;

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
    if (widget.controller.text.isNotEmpty) select(widget.controller.text);
  }

  void select(q) async {
    try {
      //
      final r = await dio.post(
        ep.USER_READ_STRING, //
        data: {
          "key": n_schema_r.FULL_NAME, //
          "query": q, //
        },
      );

      widget.onChanged?.call(List<Map<String, dynamic>>.from(r.data).first);
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: "Failed", color: Colors.red);
      widget.controller.clear();
      widget.onChanged?.call({});
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
            suggestionsCallback: (q) async {
              try {
                //
                final r = await dio.post(
                  ep.USER_READ_STRING, //
                  data: {
                    "key": n_schema_r.FULL_NAME, //
                    "query": q, //
                    "order": 1, //
                    "limit": 100, //
                  },
                );

                //
                List<String> options = [];
                for (var d in r.data) {
                  if (d[n_schema_r.FULL_NAME] == null) continue;
                  options.add(d[n_schema_r.FULL_NAME] ?? "");
                }

                //
                return options;
                //
              } catch (e, st) {
                print(st);
                sb.view(context: context, message: "Failed", color: Colors.red);
                return [];
              }
            },
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: "Search User:",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        //
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
              widget.controller.text = v;
              select(v);
            },
          ),
        ),
      ],
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({
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
      theme: theme.data(), //
      home: Scaffold(
        body: Center(
          child: Main_(
            controller: TextEditingController(text: "Cambodian"),
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
