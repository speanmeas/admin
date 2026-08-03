import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

//
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";

//
import "package:speanmeas/features/database/room/form/create.dart" as r_create;
import "package:speanmeas/features/database/room/schema.g.dart" as r_schema;

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
        "/room/read_string", //
        data: FormData.fromMap({
          "key": r_schema.NUMBER, //
          "query": q, //
        }),
      );

      widget.onChanged?.call(List<Map<String, dynamic>>.from(r.data).first);
    } catch (e) {
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
                  "/room/read_string", //
                  data: FormData.fromMap({
                    "key": r_schema.NUMBER, //
                    "query": q, //
                    "order": 1, //
                    "limit": 100, //
                  }),
                );

                //
                List<String> options = [];
                for (var d in r.data) {
                  if (d[r_schema.NUMBER] == null) continue;
                  options.add(d[r_schema.NUMBER] ?? "");
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
                  labelText: "Search Room:",
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
            r_schema.clear();

            //
            final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => r_create.Main_()));
            if (v == null) return;

            //
            widget.controller.text = v[r_schema.NUMBER];

            //
            select(v[r_schema.NUMBER]);
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
      theme: data(), //
      home: Scaffold(
        body: Center(
          child: Main_(
            controller: TextEditingController(text: "201"),
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
