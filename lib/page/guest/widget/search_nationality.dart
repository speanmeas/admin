import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

//
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";

//
import "package:speanmeas/page/nationality/form/create.dart" as n_form_create;
import "package:speanmeas/page/nationality/schema.w.dart" as n_schema_w;

class _Main_State extends State<Main_> {
  // * ប្រើសម្រាប់...
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller_search = TextEditingController();

  // *
  bool is_selected = false;
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();

    //
    focusNode.addListener(() {
      if (!focusNode.hasFocus && !is_selected) {
        controller_search.clear();
        widget.onChanged?.call({});
      }
    });

    //
    if (widget.initialValue != null) {
      controller_search.text = widget.initialValue ?? "";
      init(widget.initialValue ?? "");
    }
  }

  init(String q) async {
    try {
      //
      final r = await dio.post(
        "/nationality/read_string", //
        data: FormData.fromMap({
          "key": n_schema_w.NAME, //
          "query": q, //
          "order": 1, //
          "limit": 1000, //
        }),
      );

      //
      final data = List<Map<String, dynamic>>.from(r.data).first;
      widget.onChanged?.call(data);

      //
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
                  if (v.isEmpty) widget.onChanged?.call({});
                },
              );
            },
            onSelected: (v) {
              //
              controller_search.text = v;
              is_selected = true;

              //
              Map<String, dynamic> data_selected = {};
              for (var d in data) {
                if (d[n_schema_w.NAME] == v) {
                  data_selected = d;
                  break;
                }
              }

              //
              widget.onChanged?.call(data_selected);
            },
          ),
        ),

        //
        SizedBox(width: 4),

        //
        OutlinedButton.icon(
          icon: Icon(Icons.add),
          label: Text("Create"),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            //
            final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => n_form_create.Main_()));
            if (v == null) return;

            //
            controller_search.text = v[n_schema_w.NAME] ?? "";
            is_selected = true;
            widget.onChanged?.call(v);
          },
        ),
      ],
    );
  }

  Future<List<String>> on_search(String q) async {
    try {
      //

      List<String> options = [];
      final r = await dio.post(
        "/nationality/read_string", //
        data: FormData.fromMap({
          "key": n_schema_w.NAME, //
          "query": q, //
          "order": 1, //
          "limit": 1000, //
        }),
      );

      //
      data = List<Map<String, dynamic>>.from(r.data);

      //
      for (var d in data) {
        if (d[n_schema_w.NAME] == null) continue;
        options.add(d[n_schema_w.NAME] ?? "");
      }

      //
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
    this.initialValue, //
    required this.onChanged,
    // required this.onCreate, //
  });

  final String? initialValue;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  // final VoidCallback? onCreate;

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
            initialValue: "Cambodian",
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
