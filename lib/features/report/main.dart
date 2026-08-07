// TODO: make report

import "dart:math";

import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep;

import "schema.g.dart" as sm;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  final c_start = TextEditingController();
  final c_end = TextEditingController();
  PlutoGridStateManager? state_manager;
  List<PlutoRow> rows = []; // * ជួរដេកទិន្នន័យ

  void init() async {
    try {
      //
      tmp = await dio.post(
        ep.REPORT,
        data: {
          "key": "check_in_at", //
          "start": "2026-01-01T00:00:00.000Z",
          "stop": "2026-12-30T23:59:59.000Z",
        },
      );

      print(tmp.data[0]);

      //
      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  Widget _layout(Widget child) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 34, //
            padding: EdgeInsets.all(1),
            child: Row(
              children: [
                //
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_month),
                  label: Text("Start Date"), //
                ),

                //
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_month),
                  label: Text("End Date"), //
                ),

                Spacer(),

                //
                Tooltip(
                  message: "Filter",
                  child: InkWell(
                    child: Container(
                      width: 32,
                      height: 32,
                      child: Icon(Icons.filter_alt_outlined, size: 24, color: Colors.blue), //
                    ), //
                    onTap: () {
                      // snackbar(ct: context, ms: "Development", cl: Colors.black);
                    },
                  ),
                ),

                //
                Tooltip(
                  message: "Refresh",
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.refresh, //
                        size: 24,
                        color: Colors.blue,
                      ), //
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: child), //

          Container(
            height: 34, //
            padding: EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                Text("ចំណូលសរុប: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                Text("100 \$", style: TextStyle(color: Colors.green)), //
              ],
            ),
          ),
        ], //
      ),
    );
  }

  // * បង្កើតតម្លៃចៃដន្យតាមប្រភេទទិន្នន័យរបស់សសរ
  String random_cell({
    required String key, //
    String? type, //
    required int index, //
    required Random random, //
    required DateTime now, //
    required List<String> first_names, //
    required List<String> last_names, //
    required List<String> staff_names, //
  }) {
    // * id
    if (type == "id") return "$index";

    // * string
    if (type == "string") {
      if (key == "room_number") return "${100 + index}";
      if (key == "guest_full_name") {
        return "${first_names[random.nextInt(first_names.length)]} ${last_names[random.nextInt(last_names.length)]}";
      }
      // check_in_by / check_out_by
      return staff_names[random.nextInt(staff_names.length)];
    }

    // * number
    if (type == "number") {
      if (key == "stay_n_guest") return "${random.nextInt(4) + 1}";
      return "${random.nextInt(200)}";
    }

    // * date-time
    if (type == "date-time") {
      final d = now.subtract(
        Duration(
          days: random.nextInt(30), //
          hours: random.nextInt(24), //
          minutes: random.nextInt(60), //
        ),
      );
      return d.toIso8601String();
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return _layout(
      PlutoGrid(
        rows: [], //
        columns: [
          PlutoColumn(
            field: "_id", //
            title: "ID",

            type: PlutoColumnType.number(),
            hide: true, //
          ),
          PlutoColumn(
            field: "no", //
            title: "ល.រ.",

            type: PlutoColumnType.number(),
          ),
          PlutoColumn(
            field: "room_number", //
            title: "បន្ទប់",

            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            field: "guest_full_name", //
            title: "ឈ្មោះភ្ញៀវ",

            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            field: "stay_n_guest", //
            title: "ចំនួនភ្ញៀវ",

            type: PlutoColumnType.number(),
          ),
          //
          PlutoColumn(
            field: "check_in_at", //
            title: "ពេលចូល",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "checkout", //
            title: "ពេលចេញ",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "stay_days", //
            title: "ចំនួនថ្ងៃ",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "stay_hours", //
            title: "ចំនួនម៉ោង",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "room_price", //
            title: "តម្លៃបន្ទប់",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "room_pay", //
            title: "ប្រាក់បង់",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "room_return", //
            title: "ប្រាប់អាប់",

            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            field: "room_pay_method", //
            title: "ទូទាត់តាម",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "revenue_price", //
            title: "តម្លៃចំណូល",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "revenue_pay", //
            title: "ប្រាក់បង់",

            type: PlutoColumnType.text(),
          ),
          //
          PlutoColumn(
            field: "revenue_return", //
            title: "ប្រាប់អាប់",

            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            field: "revenue_pay_method", //
            title: "ទូទាត់តាម",

            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            field: "checkinby", //
            title: "ចូលដោយ",

            type: PlutoColumnType.text(),
          ),
          PlutoColumn(
            field: "checkoutby", //
            title: "ចេញដោយ",

            type: PlutoColumnType.text(),
          ),
        ], //
        //
        configuration: PlutoGridConfiguration(
          scrollbar: PlutoGridScrollbarConfig(
            scrollbarThickness: 12, //
            scrollbarThicknessWhileDragging: 12,
            isAlwaysShown: true,
          ),
          style: PlutoGridStyleConfig(
            rowHeight: 28, //
            columnHeight: 32,
            columnFilterHeight: 36,
            defaultColumnTitlePadding: EdgeInsets.fromLTRB(8, 0, 24, 0),
          ),
        ),
        onLoaded: (event) {
          state_manager = event.stateManager;
          state_manager?.setColumnSizeConfig(PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale));
          state_manager?.notifyListeners();
          state_manager?.addListener(() => setState(() {}));
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    ),
  );
}
