import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/guest.g.dart";

// import "package:speanmeas/features/database/nationality/form/create.dart" as n_f_create;

class _Search_NationalityState extends State<Search_Nationality> {
  //
  bool is_selected = false;
  FocusNode focusNode = FocusNode();
  FocusNode clear_focus = FocusNode();

  final controller = TextEditingController();

  String? id;
  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality;
  String? note;

  dynamic tmp;
  dynamic data;

  void init() async {
    //
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

    try {
      tmp = await dio.post(
        endpoint.GUEST_SEARCH, //
        data: {"query": widget.initial},
      );
      if (tmp.data.isEmpty) return;

      final list = List<Map<String, dynamic>>.from(tmp.data);

      id = list.first[sm_guest.ID]?.toString();
      full_name = list.first[sm_guest.FULL_NAME]?.toString();
      note = list.first[sm_guest.NOTE]?.toString();

      controller.text = full_name ?? "";
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
                      endpoint.GUEST_SEARCH,
                      data: {"query": q}, //
                    );
                    data = List<Map<String, dynamic>>.from(tmp.data);

                    //
                    final options = <String>[];
                    for (var d in data) {
                      final text = "${d[sm_guest.FULL_NAME] ?? ""} (${d[sm_guest.PHONE_NUMBER] ?? "N/A"})";
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
                    nationality = d[sm_guest.NATIONALITY_ID]["name"]?.toString();
                    note = d[sm_guest.NOTE]?.toString();
                    widget.onChanged?.call(id);
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
                // final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => n_f_create.Main_()));
                // if (v == null) return;

                // // * បង្ហាញឈ្មោះសញ្ជាតិថ្មី និងជ្រើសរើសភ្លាមៗ
                // controller.text = v[sm_nationality.NAME]?.toString() ?? "";
                // is_selected = true;
                // select(controller.text);
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
          leading: "Full Name:", //
          value: full_name ?? "",
        ),

        //
        Show_Text(
          leading: "Phone Number:", //
          value: phone_number ?? "",
        ),

        //
        Show_Text(
          leading: "Gender:", //
          value: gender ?? "",
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
    this.initial,
  });

  final ValueChanged<String?>? onChanged; // * ត្រឡប់ id របស់សញ្ជាតិ
  final String? initial; // * តម្លៃដំបូង (ឈ្មោះសញ្ជាតិ)

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
            initial: "Cambodian",
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
