// * នាំចូល Flutter foundation និង flutter_typeahead សម្រាប់ autocomplete
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/nationality.g.dart";
import "package:speanmeas/core/widget/show/show_text.dart";

import "package:speanmeas/features/database/guest/form/create.dart" as create_guest;

// * ថ្នាក់ state របស់ Search_Guest គ្រប់គ្រងការស្វែងរកភ្ញៀវ
class _Search_GuestState extends State<Search_Guest> {
  dynamic tmp;
  String? note;
  // * កំណត់ថាតើបានជ្រើសរើសហើយឬអត់
  bool is_selected = false;
  FocusNode focusNode = FocusNode();
  FocusNode clear_focus = FocusNode();

  // * ព័ត៌មានភ្ញៀវដែលបានជ្រើសរើស
  String? id;
  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality;

  final controller = TextEditingController();
  dynamic data;

  // * ចាប់ផ្តើមស្វែងរក
  void init() async {
    // * សម្អាតតម្លៃនៅពេលបាត់បង់ focus
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

    // * បើគ្មានតម្លៃដំបូង ឈប់
    if (widget.init == null || widget.init!.isEmpty) return;

    try {
      // * ទាញយកព័ត៌មានភ្ញៀវតាម id
      tmp = await dio.post(
        endpoint.GUEST_CRUD_READ_ID, //
        data: {sm_guest.ID: widget.init},
      );
      if (tmp.data.isEmpty) return;

      // * កំណត់ព័ត៌មានភ្ញៀវ
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
      // * បង្ហាញកំហុសប្រសិនបើមាន
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
              // * បង្កើត TypeAheadField សម្រាប់ស្វែងរកភ្ញៀវ
              child: TypeAheadField<String>(
                controller: controller,
                focusNode: focusNode,
                itemBuilder: (context, item) => ListTile(title: Text(item)),
                // * ស្វែងរកភ្ញៀវពី server
                suggestionsCallback: (q) async {
                  try {
                    tmp = await dio.post(endpoint.GUEST_SEARCH, data: {"query": q});
                    data = tmp.data;

                    // * បង្កើតបញ្ជីជម្រើស
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
                      // * ប៊ូតុងសម្អាតតម្លៃ
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

                  // * ស្វែងរកទិន្នន័យដែលត្រូវគ្នា
                  Map<String, dynamic> d = {};
                  for (var e in data) {
                    if ("${e[sm_guest.FULL_NAME] ?? ""} (${e[sm_guest.PHONE_NUMBER] ?? "N/A"})" == v) {
                      d = e;
                      break;
                    }
                  }

                  // * កំណត់ព័ត៌មានភ្ញៀវដែលបានជ្រើសរើស
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: MaterialApp(
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
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
