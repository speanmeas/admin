// * នាំចូល Flutter foundation និង flutter_typeahead សម្រាប់ autocomplete
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/features/database/demo_2_2/dialog/create.dart" as create_demo_2_2;

// * ថ្នាក់ state របស់ Search_Demo_2_2 គ្រប់គ្រងការស្វែងរក Demo 2-2
class _Search_Demo_2_2State extends State<Search_Demo_2_2> {
  //
  // * កំណត់ថាតើបានជ្រើសរើសហើយឬអត់
  bool is_selected = false;
  FocusNode focusNode = FocusNode();
  FocusNode clear_focus = FocusNode();

  final controller = TextEditingController();

  // * ព័ត៌មាន Demo 2-2 ដែលបានជ្រើសរើស
  String? id;
  String? text;
  int? number;

  dynamic tmp;
  List<Demo_2_2> data = [];

  // * ចាប់ផ្តើមស្វែងរក
  void init() async {
    //
    // * សម្អាតតម្លៃនៅពេលបាត់បង់ focus
    focusNode.addListener(() {
      if (!focusNode.hasFocus && !clear_focus.hasFocus && !is_selected && controller.text.isNotEmpty) {
        controller.clear();
        id = text = null;
        number = null;
        widget.onChanged?.call(id);
        setState(() {});
      }
    });

    // * បើគ្មានតម្លៃដំបូង ឈប់
    if (widget.init == null || widget.init!.isEmpty) return;

    try {
      // * ទាញយកព័ត៌មាន Demo 2-2 តាមអត្ថបទ
      tmp = await dio.post(
        endpoint.DEMO_2_2_READ_STRING, //
        data: {
          "key": Demo_2_2.TEXT, //
          "query": widget.init, //
        },
      );
      if (tmp.data.isEmpty) return;

      final list = List<Demo_2_2>.from((tmp.data ?? const []).map((d) => Demo_2_2.fromJson(d)));

      // * កំណត់ព័ត៌មាន Demo 2-2
      id = list.first.id;
      text = list.first.text;
      number = list.first.number;

      controller.text = text ?? "";
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
              // * បង្កើត TypeAheadField សម្រាប់ស្វែងរក Demo 2-2
              child: TypeAheadField<String>(
                controller: controller,
                focusNode: focusNode,
                itemBuilder: (context, item) => ListTile(title: Text(item)),
                // * ស្វែងរក Demo 2-2 ពី server
                suggestionsCallback: (q) async {
                  try {
                    //
                    tmp = await dio.post(
                      endpoint.DEMO_2_2_READ_STRING,
                      data: {
                        "key": Demo_2_2.TEXT, //
                        "query": q, //
                        "order": 1, //
                        "limit": 100, //
                      },
                    );

                    data = List<Demo_2_2>.from((tmp.data ?? const []).map((d) => Demo_2_2.fromJson(d)));

                    // * បង្កើតបញ្ជីជម្រើសដោយគ្មានអត្ថបទស្ទួន
                    final options = <String>[];
                    for (var n in data) {
                      final v = n.text ?? "";
                      if (v.isEmpty || options.contains(v)) continue;
                      options.add(v);
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
                      labelText: "Search Demo 2-2:",
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
                              id = text = null;
                              number = null;
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
                  // * កំណត់ព័ត៌មាន Demo 2-2 ដែលបានជ្រើសរើស
                  for (final n in data) {
                    if (n.text == v) {
                      id = n.id;
                      text = n.text;
                      number = n.number;
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
                // * បើកទម្រង់បង្កើត Demo 2-2 ថ្មី
                final v = await create_demo_2_2.dialog_create_demo_2_2(context: context);
                if (v == null) return;

                // * បង្ហាញអត្ថបទ Demo 2-2 ថ្មី និងជ្រើសរើសភ្លាមៗ
                is_selected = true;
                final n = Demo_2_2.fromJson(v);
                id = n.id;
                text = n.text;
                number = n.number;

                controller.text = text ?? "";
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
          lead: "Text:", //
          value: text ?? "",
        ),

        //
        Show_Text(
          lead: "Number:", //
          value: format_int(number),
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

class Search_Demo_2_2 extends StatefulWidget {
  const Search_Demo_2_2({
    super.key, //
    required this.onChanged,
    this.init,
  });

  final ValueChanged<String?>? onChanged; // * ត្រឡប់ id របស់ Demo 2-2
  final String? init; // * តម្លៃដំបូង (អត្ថបទ Demo 2-2)

  @override
  State<Search_Demo_2_2> createState() => _Search_Demo_2_2State();
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
            child: Search_Demo_2_2(
              init: "Test",
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
