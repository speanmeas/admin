import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import

import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/nationality.g.dart";
import "package:speanmeas/core/widget/show/show_text.dart";

import "package:speanmeas/features/database/guest/form/create.dart" as create_guest;

class _Search_GuestState extends State<Search_Guest> {
  dynamic tmp;
  String? note;
  bool is_selected = false;
  FocusNode focusNode = FocusNode();
  FocusNode clear_focus = FocusNode();

  String? id;
  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality;

  final controller = TextEditingController();
  dynamic data;

  void init() async {
    focusNode.addListener(() {
      if (!focusNode.hasFocus && !clear_focus.hasFocus && !is_selected && controller.text.isNotEmpty) {
        id = null;
        full_name = null;
        phone_number = null;
        gender = null;
        nationality = null;
        note = null;
        controller.clear();
        widget.onChanged?.call(id);
        setState(() {});
      }
    });

    if (widget.init == null || widget.init!.isEmpty) return;

    try {
      tmp = await dio.post(
        endpoint.GUEST_CRUD_READ_ID, //
        data: {sm_guest.ID: widget.init},
      );
      if (tmp.data.isEmpty) return;

      id = tmp.data[0][sm_guest.ID]?.toString();
      full_name = tmp.data[0][sm_guest.FULL_NAME]?.toString();
      phone_number = tmp.data[0][sm_guest.PHONE_NUMBER]?.toString();
      gender = tmp.data[0][sm_guest.GENDER]?.toString();
      nationality = tmp.data[0][sm_guest.NATIONALITY_ID]?[sm_nationality.NAME]?.toString();
      note = tmp.data[0][sm_guest.NOTE]?.toString();

      controller.text = "$full_name (${phone_number ?? 'N/A'})";
      widget.onChanged?.call(id);
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    tmp = await dio.post(endpoint.GUEST_SEARCH, data: {"query": q});
                    data = tmp.data;

                    final options = <String>[];
                    for (var d in data) {
                      final text = "${d[sm_guest.FULL_NAME] ?? ""} (${d[sm_guest.PHONE_NUMBER] ?? "N/A"})";
                      options.add(text);
                    }

                    return options;
                  } catch (e, st) {
                    pprint(st);
                    snackbar(ct: context, ms: e.toString(), cl: Colors.red);
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
                      suffixIcon: ExcludeFocus(
                        child: Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: IconButton(
                            focusNode: clear_focus,
                            icon: Icon(Icons.clear, color: Colors.red),
                            onPressed: () {
                              id = null;
                              full_name = null;
                              phone_number = null;
                              gender = null;
                              nationality = null;
                              note = null;
                              controller.clear();
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

                  Map<String, dynamic> d = {};
                  for (var e in data) {
                    if ("${e[sm_guest.FULL_NAME] ?? ""} (${e[sm_guest.PHONE_NUMBER] ?? "N/A"})" == v) {
                      d = e;
                      break;
                    }
                  }

                  if (d.isNotEmpty) {
                    id = d[sm_guest.ID]?.toString();
                    full_name = d[sm_guest.FULL_NAME]?.toString();
                    phone_number = d[sm_guest.PHONE_NUMBER]?.toString();
                    gender = d[sm_guest.GENDER]?.toString();
                    nationality = d[sm_guest.NATIONALITY_ID]?[sm_nationality.NAME]?.toString();
                    note = d[sm_guest.NOTE]?.toString();

                    widget.onChanged?.call(id);
                  }

                  is_selected = true;
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
                final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => create_guest.Main_()));
                if (v == null) return;

                // * បង្ហាញឈ្មោះសញ្ជាតិថ្មី និងជ្រើសរើសភ្លាមៗ
                id = v[sm_guest.ID]?.toString();
                full_name = v[sm_guest.FULL_NAME]?.toString();
                phone_number = v[sm_guest.PHONE_NUMBER]?.toString();
                gender = v[sm_guest.GENDER]?.toString();
                nationality = (v[sm_guest.NATIONALITY_ID] as Map<String, dynamic>?)?["name"]?.toString();
                note = v[sm_guest.NOTE]?.toString();

                controller.text = full_name ?? "";
                widget.onChanged?.call(id);
                is_selected = true;
                setState(() {});
              },
            ),
          ],
        ),

        //
        if (kDebugMode)
          Show_Text(
            lead: "ID:", //
            value: id ?? "",
          ),

        //
        Show_Text(
          lead: "Full Name:", //
          value: full_name ?? "",
        ),

        //
        Show_Text(
          lead: "Phone Number:", //
          value: phone_number ?? "",
        ),

        //
        Show_Text(
          lead: "Gender:", //
          value: gender ?? "",
        ),

        //
        Show_Text(
          lead: "Nationality:", //
          value: nationality ?? "",
        ),

        //
        Show_Text(
          lead: "Note:", //
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

class Search_Guest extends StatefulWidget {
  const Search_Guest({
    super.key, //
    this.init,
    required this.onChanged,
  });

  final String? init; // * តម្លៃដំបូង (ឈ្មោះសញ្ជាតិ)
  final ValueChanged<String?>? onChanged; // * ត្រឡប់ id របស់សញ្ជាតិ

  @override
  State<Search_Guest> createState() => _Search_GuestState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Center(
          child: Search_Guest(
            init: "6a61bba1315df99f851bbf74",
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
