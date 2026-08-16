// * នាំចូល Flutter foundation និង flutter_typeahead សម្រាប់ autocomplete
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

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
  List<Guest> data = [];

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
        data: {Guest.ID: widget.init},
      );
      if (tmp.data.isEmpty) return;

      // * កំណត់ព័ត៌មានភ្ញៀវ
      final g = Guest.fromJson(tmp.data[0]);
      id = g.id;
      full_name = g.full_name;
      phone_number = g.phone_number;
      gender = g.gender;
      nationality = g.nationality_id?.name;
      note = g.note;

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
                    data = List<Guest>.from((tmp.data ?? const []).map((d) => Guest.fromJson(d)));

                    // * បង្កើតបញ្ជីជម្រើស
                    final options = <String>[];
                    for (var g in data) {
                      final text = "${g.full_name ?? ""} (${g.phone_number ?? "N/A"})";
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
                  Guest? g;
                  for (var e in data) {
                    if ("${e.full_name ?? ""} (${e.phone_number ?? "N/A"})" == v) {
                      g = e;
                      break;
                    }
                  }

                  // * កំណត់ព័ត៌មានភ្ញៀវដែលបានជ្រើសរើស
                  if (g != null) {
                    id = g.id;
                    full_name = g.full_name;
                    phone_number = g.phone_number;
                    gender = g.gender;
                    nationality = g.nationality_id?.name;
                    note = g.note;

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
                final v = await nav_push(context, create_guest.Main_());
                if (v == null) return;

                // * បង្ហាញឈ្មោះសញ្ជាតិថ្មី និងជ្រើសរើសភ្លាមៗ
                final g = Guest.fromJson(v);
                id = g.id;
                full_name = g.full_name;
                phone_number = g.phone_number;
                gender = g.gender;
                nationality = g.nationality_id?.name;
                note = g.note;

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
