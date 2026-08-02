import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

//
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";

//
import "package:speanmeas/features/database/guest/form/create.dart" as g_create;
import "package:speanmeas/features/database/guest/schema.g.dart" as g_schema;

class _Main_State extends State<Main_> {
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
      "/guest/read_string", //
      data: {
        "key": g_schema.PHONE_NUMBER, //
        "query": q, //
      },
      options: Options(headers: {"Content-Type": "application/json"}),
    );

      final items = List<Map<String, dynamic>>.from(r.data is List ? r.data : [r.data]);
      if (items.isEmpty) return;
      widget.onChanged?.call(items.first);
    } catch (e) {
      print(e.toString());
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
                  "/guest/read_string", //
                  data: {
                    "key": g_schema.PHONE_NUMBER, //
                    "query": q, //
                    "order": 1, //
                    "limit": 100, //
                  },
                  options: Options(headers: {"Content-Type": "application/json"}),
                );

                //
                List<String> options = [];
                final data_list = r.data is List ? r.data : [r.data];
                for (var d in data_list) {
                  if (d[g_schema.PHONE_NUMBER] == null) continue;
                  options.add(d[g_schema.PHONE_NUMBER] ?? "");
                }

                //
                return options;
                //
              } catch (e) {
                return [];
              }
            },
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
            widget.controller.text = v[g_schema.PHONE_NUMBER];

            //
            select(v[g_schema.PHONE_NUMBER]);
          },
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
      theme: Theme_Data(), //
      home: Scaffold(
        body: Center(
          child: Main_(
            controller: TextEditingController(text: "011358858"),
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
