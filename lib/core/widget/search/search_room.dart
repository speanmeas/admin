// * នាំចូល Flutter foundation និង flutter_typeahead សម្រាប់ autocomplete
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/features/database/room/form/create.dart" as create_room;

// * ថ្នាក់ state របស់ Search_Room គ្រប់គ្រងការស្វែងរកបន្ទប់
class _Search_RoomState extends State<Search_Room> {
  dynamic tmp;
  String? note;
  // * កំណត់ថាតើបានជ្រើសរើសហើយឬអត់
  bool is_selected = false;
  FocusNode focusNode = FocusNode();
  FocusNode clear_focus = FocusNode();

  // * ព័ត៌មានបន្ទប់ដែលបានជ្រើសរើស
  String? id;
  String? number;
  String? kind;
  double? usd_per_day;
  double? usd_per_3h;

  final controller = TextEditingController();
  List<Room> data = [];

  // * ចាប់ផ្តើមស្វែងរក
  void init() async {
    // * សម្អាតតម្លៃនៅពេលបាត់បង់ focus
    focusNode.addListener(() {
      if (!focusNode.hasFocus && !clear_focus.hasFocus && !is_selected && controller.text.isNotEmpty) {
        id = null;
        number = null;
        kind = null;
        usd_per_day = null;
        usd_per_3h = null;
        note = null;
        controller.clear();
        widget.onChanged?.call(id);
        setState(() {});
      }
    });

    // * បើគ្មានតម្លៃដំបូង ឈប់
    if (widget.init == null || widget.init!.isEmpty) return;

    try {
      // * ទាញយកព័ត៌មានបន្ទប់តាម id
      tmp = await dio.post(
        endpoint.ROOM_READ_ID, //
        data: {Room.ID: widget.init},
      );
      if (tmp.data.isEmpty) return;

      // * កំណត់ព័ត៌មានបន្ទប់
      final r = Room.fromJson(tmp.data[0]);
      id = r.id;
      number = r.number;
      kind = r.kind;
      usd_per_day = r.price_per_day;
      usd_per_3h = r.price_per_3h;
      note = r.note;

      controller.text = "$number (${kind ?? "N/A"})";
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
              // * បង្កើត TypeAheadField សម្រាប់ស្វែងរកបន្ទប់
              child: TypeAheadField<String>(
                controller: controller,
                focusNode: focusNode,
                itemBuilder: (context, item) => ListTile(title: Text(item)),
                // * ស្វែងរកបន្ទប់ពី server
                suggestionsCallback: (q) async {
                  try {
                    tmp = await dio.post(
                      endpoint.ROOM_READ_STRING, //
                      data: {
                        "key": Room.NUMBER, //
                        "query": q, //
                        "order": 1, //
                        "limit": 100, //
                      },
                    );
                    data = List<Room>.from((tmp.data ?? const []).map((d) => Room.fromJson(d)));

                    // * បង្កើតបញ្ជីជម្រើស
                    final options = <String>[];
                    for (var r in data) {
                      final text = "${r.number ?? ""} (${r.kind ?? "N/A"})";
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
                      labelText: "Search Room:",
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
                              number = null;
                              kind = null;
                              usd_per_day = null;
                              usd_per_3h = null;
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
                  Room? r;
                  for (var e in data) {
                    if ("${e.number ?? ""} (${e.kind ?? "N/A"})" == v) {
                      r = e;
                      break;
                    }
                  }

                  // * កំណត់ព័ត៌មានបន្ទប់ដែលបានជ្រើសរើស
                  if (r != null) {
                    id = r.id;
                    number = r.number;
                    kind = r.kind;
                    usd_per_day = r.price_per_day;
                    usd_per_3h = r.price_per_3h;
                    note = r.note;

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
                // * បើកទម្រង់បង្កើតបន្ទប់ថ្មី
                final v = await nav_push(context, create_room.Main_());
                if (v == null) return;

                // * បង្ហាញលេខបន្ទប់ថ្មី និងជ្រើសរើសភ្លាមៗ
                final r = Room.fromJson(v);
                id = r.id;
                number = r.number;
                kind = r.kind;
                usd_per_day = r.price_per_day;
                usd_per_3h = r.price_per_3h;
                note = r.note;

                controller.text = number ?? "";
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
          lead: "Number:", //
          value: number ?? "",
        ),

        //
        Show_Text(
          lead: "Kind:", //
          value: kind ?? "",
        ),

        //
        Show_Text(
          lead: "USD / Day:", //
          value: format_double(usd_per_day, digits: 2),
        ),

        //
        Show_Text(
          lead: "USD / 3h:", //
          value: format_double(usd_per_3h, digits: 2),
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

class Search_Room extends StatefulWidget {
  const Search_Room({
    super.key, //
    this.init,
    required this.onChanged,
  });

  final String? init; // * តម្លៃដំបូង (លេខបន្ទប់)
  final ValueChanged<String?>? onChanged; // * ត្រឡប់ id របស់បន្ទប់

  @override
  State<Search_Room> createState() => _Search_RoomState();
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
            child: Search_Room(
              init: "6a6ec9d7599d64fa5d293fb9",
              onChanged: (v) {
                pprint("Changed: $v");
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
