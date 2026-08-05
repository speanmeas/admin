import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

//
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;

//
import "package:speanmeas/features/database/nationality/form/create.dart"
    as n_f_create;
import "package:speanmeas/features/database/nationality/schema.g.dart"
    as n_schema_r;
import "package:speanmeas/core/widget/snackbar.dart" as sb;

class _Main_State extends State<Main_> {
  dynamic tmp;
  FocusNode focusNode = FocusNode();
  FocusNode clear_focus = FocusNode();
  bool is_selected = false;
  int selection_request_id = 0;

  @override
  void initState() {
    super.initState();

    //
    focusNode.addListener(() {
      if (!focusNode.hasFocus &&
          !clear_focus.hasFocus &&
          !is_selected &&
          widget.controller.text.isNotEmpty) {
        clear_field();
      }
    });

    //
    if (widget.controller.text.isNotEmpty) select(widget.controller.text);
  }

  @override
  void dispose() {
    focusNode.dispose();
    clear_focus.dispose();
    super.dispose();
  }

  void clear_field() {
    selection_request_id++;
    is_selected = false;
    widget.controller.clear();
    widget.onCleared?.call();
  }

  void select(q) async {
    final request_id = ++selection_request_id;

    try {
      //
      final r = await dio.post(
        "/nationality/read_string", //
        data: {
          "key": n_schema_r.NAME, //
          "query": q, //
        },
      );

      if (request_id != selection_request_id || !mounted) return;
      widget.onChanged?.call(List<Map<String, dynamic>>.from(r.data).first);
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: "Failed", color: Colors.red);
      clear_field();
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
                  "/nationality/read_string", //
                  data: {
                    "key": n_schema_r.NAME, //
                    "query": q, //
                    "order": 1, //
                    "limit": 100, //
                  },
                );

                //
                List<String> options = [];
                for (var d in r.data) {
                  if (d[n_schema_r.NAME] == null) continue;
                  options.add(d[n_schema_r.NAME] ?? "");
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
                  labelText: "Search Nationality:",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: IconButton(
                      focusNode: clear_focus,
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        //
                        clear_field();
                      },
                    ), //
                  ),
                ),
                onChanged: (v) {
                  selection_request_id++;
                  is_selected = false;
                },
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
            n_schema_r.clear();

            //
            final v = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => n_f_create.Main_()),
            );
            if (v == null) return;

            //
            widget.controller.text = v[n_schema_r.NAME];

            //
            select(v[n_schema_r.NAME]);
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
