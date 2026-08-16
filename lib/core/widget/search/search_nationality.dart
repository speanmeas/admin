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

import "package:speanmeas/core/schema.g.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/features/database/nationality/form/create.dart" as create_nationality;

// * ថ្នាក់ state របស់ Search_Nationality គ្រប់គ្រងការស្វែងរកសញ្ជាតិ
class _Search_NationalityState extends State<Search_Nationality> {
  //
  // * កំណត់ថាតើបានជ្រើសរើសហើយឬអត់
  bool is_selected = false;
  FocusNode focusNode = FocusNode();
  FocusNode clear_focus = FocusNode();

  final controller = TextEditingController();

  // * ព័ត៌មានសញ្ជាតិដែលបានជ្រើសរើស
  String? id;
  String? nationality;
  String? note;

  dynamic tmp;
  List<Nationality> data = [];

  // * ចាប់ផ្តើមស្វែងរក
  void init() async {
    //
    // * សម្អាតតម្លៃនៅពេលបាត់បង់ focus
    focusNode.addListener(() {
      if (!focusNode.hasFocus && !clear_focus.hasFocus && !is_selected && controller.text.isNotEmpty) {
        controller.clear();
        id = nationality = note = null;
        widget.onChanged?.call(id);
        setState(() {});
      }
    });

    // * បើគ្មានតម្លៃដំបូង ឈប់
    if (widget.init == null || widget.init!.isEmpty) return;

    try {
      // * ទាញយកព័ត៌មានសញ្ជាតិតាមឈ្មោះ
      tmp = await dio.post(
        endpoint.NATIONALITY_CRUD_READ_STRING, //
        data: {
          "key": Nationality.NAME, //
          "query": widget.init, //
        },
      );
      if (tmp.data.isEmpty) return;

      final list = List<Nationality>.from((tmp.data ?? const []).map((d) => Nationality.fromJson(d)));

      // * កំណត់ព័ត៌មានសញ្ជាតិ
      id = list.first.id;
      nationality = list.first.name;
      note = list.first.note;

      controller.text = nationality ?? "";
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
              // * បង្កើត TypeAheadField សម្រាប់ស្វែងរកសញ្ជាតិ
              child: TypeAheadField<String>(
                controller: controller,
                focusNode: focusNode,
                itemBuilder: (context, item) => ListTile(title: Text(item)),
                // * ស្វែងរកសញ្ជាតិពី server
                suggestionsCallback: (q) async {
                  try {
                    //
                    tmp = await dio.post(
                      endpoint.NATIONALITY_CRUD_READ_STRING,
                      data: {
                        "key": Nationality.NAME, //
                        "query": q, //
                        "order": 1, //
                        "limit": 100, //
                      },
                    );

                    data = List<Nationality>.from((tmp.data ?? const []).map((d) => Nationality.fromJson(d)));

                    // * បង្កើតបញ្ជីជម្រើសដោយគ្មានឈ្មោះស្ទួន
                    final options = <String>[];
                    for (var n in data) {
                      final name = n.name ?? "";
                      if (name.isEmpty || options.contains(name)) continue;
                      options.add(name);
                    }

                    //
                    return options;
                    //
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
                      labelText: "Search Nationality:",
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
                  // * កំណត់ព័ត៌មានសញ្ជាតិដែលបានជ្រើសរើស
                  for (final n in data) {
                    if (n.name == v) {
                      id = n.id;
                      nationality = n.name;
                      note = n.note;
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
                    builder: (context) => create_nationality.Main_(), //
                  ),
                );
                if (v == null) return;

                // * បង្ហាញឈ្មោះសញ្ជាតិថ្មី និងជ្រើសរើសភ្លាមៗ
                is_selected = true;
                final n = Nationality.fromJson(v);
                id = n.id;
                nationality = n.name;
                note = n.note;

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
            lead: "ID:", //
            value: id ?? "",
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
            child: Search_Nationality(
              init: "Cambodian",
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
