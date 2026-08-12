import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:speanmeas/core/schema/nationality.g.dart";

import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";

import "package:speanmeas/features/database/nationality/form/create.dart" as nation_create;

class _Search_NationalityState extends State<Search_Nationality> {
  //
  bool is_selected = false;
  FocusNode focusNode = FocusNode();
  FocusNode clear_focus = FocusNode();

  final controller = TextEditingController();

  String? id;
  String? nationality;
  String? note;

  dynamic tmp;
  dynamic data;

  void init() async {
    //
    focusNode.addListener(() {
      if (!focusNode.hasFocus && !clear_focus.hasFocus && !is_selected && controller.text.isNotEmpty) {
        controller.clear();
        id = nationality = note = null;
        widget.onChanged?.call(id);
        setState(() {});
      }
    });

    if (widget.init == null || widget.init!.isEmpty) return;

    try {
      tmp = await dio.post(
        endpoint.NATIONALITY_CRUD_READ_STRING, //
        data: {
          "key": sm_nationality.NAME, //
          "query": widget.init, //
        },
      );
      if (tmp.data.isEmpty) return;

      final list = List<Map<String, dynamic>>.from(tmp.data);

      id = list.first[sm_nationality.ID]?.toString();
      nationality = list.first[sm_nationality.NAME]?.toString();
      note = list.first[sm_nationality.NOTE]?.toString();

      controller.text = nationality ?? "";
      widget.onChanged?.call(id);
      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: TypeAheadField<String>(
                controller: controller,
                focusNode: focusNode,
                itemBuilder: (context, item) => ListTile(title: Text(item)),
                suggestionsCallback: (q) async {
                  try {
                    //
                    tmp = await dio.post(
                      endpoint.NATIONALITY_CRUD_READ_STRING,
                      data: {
                        "key": sm_nationality.NAME, //
                        "query": q, //
                        "order": 1, //
                        "limit": 100, //
                      },
                    );

                    data = List<Map<String, dynamic>>.from(tmp.data);

                    //
                    final options = <String>[];
                    for (var d in data) {
                      final name = d[sm_nationality.NAME]?.toString() ?? "";
                      if (name.isEmpty || options.contains(name)) continue;
                      options.add(name);
                    }

                    //
                    return options;
                    //
                  } catch (e, st) {
                    print(st);
                    snackbar(ct: context, ms: e.toString(), cl: Colors.red);
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
                      suffixIcon: ExcludeFocus(
                        child: Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: IconButton(
                            focusNode: clear_focus,
                            icon: Icon(Icons.clear, color: Colors.red),
                            onPressed: () {
                              controller.clear();
                              id = nationality = note = null;
                              widget.onChanged?.call(id);
                              setState(() {});
                            },
                          ), //
                        ),
                      ),
                    ),
                    onChanged: (v) => is_selected = false,
                  );
                },
                onSelected: (v) {
                  is_selected = true;
                  controller.text = v;
                  for (final d in data) {
                    if (d[sm_nationality.NAME]?.toString() == v) {
                      id = d[sm_nationality.ID]?.toString();
                      nationality = d[sm_nationality.NAME]?.toString();
                      note = d[sm_nationality.NOTE]?.toString();
                      widget.onChanged?.call(id);
                      break;
                    }
                  }
                  setState(() {});
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
                // * បើកទម្រង់បង្កើតសញ្ជាតិថ្មី
                final v = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => nation_create.Main_(), //
                  ),
                );
                if (v == null) return;

                // * បង្ហាញឈ្មោះសញ្ជាតិថ្មី និងជ្រើសរើសភ្លាមៗ
                is_selected = true;
                id = v[sm_nationality.ID]?.toString();
                nationality = v[sm_nationality.NAME]?.toString();
                note = v[sm_nationality.NOTE]?.toString();

                controller.text = nationality ?? "";
                widget.onChanged?.call(id);
                setState(() {});
              },
            ),
          ],
        ),

        //
        if (kDebugMode)
          Show_Text(
            leading: "ID:", //
            value: id ?? "",
          ),

        //
        Show_Text(
          leading: "Nationality:", //
          value: nationality ?? "",
        ),

        //
        Show_Text(
          leading: "Note:", //
          value: note ?? "",
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

class Search_Nationality extends StatefulWidget {
  const Search_Nationality({
    super.key, //
    required this.onChanged,
    this.init,
  });

  final ValueChanged<String?>? onChanged; // * ត្រឡប់ id របស់សញ្ជាតិ
  final String? init; // * តម្លៃដំបូង (ឈ្មោះសញ្ជាតិ)

  @override
  State<Search_Nationality> createState() => _Search_NationalityState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Center(
          child: Search_Nationality(
            init: "Cambodian",
            onChanged: (v) {
              print("Changed: $v");
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
