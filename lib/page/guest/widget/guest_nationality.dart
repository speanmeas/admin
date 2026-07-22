import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";

class _Main_State extends State<Main_> {
  final TextEditingController c_search = TextEditingController();
  final FocusNode focusNode = FocusNode();

  List<Map<String, dynamic>> data = [];
  bool is_selected = false;
  List<String> options = [];

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) c_search.text = widget.initialValue!;

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
    try {
      //
      final r = await dio.post("/nationality/read_all", data: FormData.fromMap({}));

      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(r.data);
      options = List<String>.from(data.map((e) => e["name"]).toList());
      options.sort((a, b) => a.compareTo(b));

      //
      if (widget.initialValue != null) {
        var id;
        for (var d in data) {
          if (d["name"] == widget.initialValue) {
            id = d["_id"];
            break;
          }
        }
        widget.onChanged?.call(id);
      }

      setState(() {});
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TypeAheadField<String>(
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
              var id;
              for (var d in data) {
                if (d["name"] == v) {
                  id = d["_id"];
                  break;
                }
              }
              widget.onChanged?.call(id);
            },
          ),
        ),

        SizedBox(width: 8),

        OutlinedButton.icon(
          icon: Icon(Icons.add),
          label: Text("Create New"),
          onPressed: widget.onCreate, //
        ),
      ],
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({
    super.key, //
    this.data,
    this.initialValue,
    this.onChanged,
    this.onCreate,
  });

  final List<Map<String, dynamic>>? data;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCreate;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(),
      home: Scaffold(
        body: Center(
          child: Container(
            width: 600,
            child: Main_(
              initialValue: "Cambodian", //
              onChanged: (v) => print("onChanged: $v"), //
              onCreate: () => print("onCreate"), //
            ), //
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
