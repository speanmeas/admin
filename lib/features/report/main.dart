// TODO: make report

import "dart:math";

import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/endpoint.g.dart";

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_filter = false;
  bool is_loading = false;
  final c_start = TextEditingController();
  final c_end = TextEditingController();
  PlutoGridStateManager? state_manager;
  List<PlutoRow> rows = []; // * ជួរដេកទិន្នន័យ

  void init() async {
    setState(() => is_loading = true);
    try {
      //
      tmp = await dio.post(
        endpoint.REPORT,
        data: {
          "key": "check_in_at", //
          "start": "2026-01-01T00:00:00.000Z",
          "stop": "2026-12-30T23:59:59.000Z",
        },
      );

      // print(tmp.data[0]);

      //
      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    } finally {
      setState(() => is_loading = false);
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
                  label: Text("Datetime Start"), //
                ),

                //
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_month),
                  label: Text("Datetime Stop"), //
                ),

                Spacer(),

                // filter
                Tooltip(
                  message: is_filter ? "Hide Filter" : "Show Filter",
                  child: InkWell(
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(
                        is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, //
                        size: 24,
                        color: Colors.blue,
                      ), //
                    ), //
                    onTap: () {
                      is_filter = !is_filter; // *
                      state_manager?.setShowColumnFilter(is_filter);
                      if (!is_filter) state_manager?.setFilterWithFilterRows([]);
                      setState(() {});
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

          if (is_loading) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: child), //

          Container(
            height: 34, //
            padding: EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                //
                Text(
                  "ចំណូលសរុប: ", //
                  style: TextStyle(
                    fontSize: 20, //
                    fontWeight: FontWeight.bold,
                  ),
                ), //
                Text(
                  "100 \$",
                  style: TextStyle(
                    fontSize: 18, //
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                Spacer(),

                //
                Tooltip(
                  message: "Export to PDF",
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(Icons.picture_as_pdf_outlined, color: Colors.blue), //
                    ),
                  ),
                ),

                //
                Tooltip(
                  message: "Export to Excel",
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(Icons.table_chart_outlined, color: Colors.blue), //
                    ),
                  ),
                ),

                SizedBox(width: 8),
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

  final WIDTH = 120.0; // * ទទឹងស្តង់ដាររបស់ជួរឈរទិន្នន័យ

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
            width: WIDTH,
            hide: true, //
          ),
          PlutoColumn(
            field: "index", //
            title: "ល.រ.",
            type: PlutoColumnType.number(),
            width: WIDTH,
          ),
          PlutoColumn(
            field: "room_number", //
            title: "បន្ទប់",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          PlutoColumn(
            field: "guest_full_name", //
            title: "ឈ្មោះភ្ញៀវ",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          PlutoColumn(
            field: "stay_number_of_guest", //
            title: "ចំនួនភ្ញៀវ",
            type: PlutoColumnType.number(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "check_in_at", //
            title: "ពេលចូល",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "checkout", //
            title: "ពេលចេញ",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "stay_days", //
            title: "ចំនួនថ្ងៃ",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "stay_hours", //
            title: "ចំនួនម៉ោង",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "room_price", //
            title: "តម្លៃបន្ទប់",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "room_pay_cash", //
            title: "បង់តាមសាច់ប្រាក់",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "room_pay_bank", //
            title: "បង់តាមធនាគារ",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "room_return", //
            title: "ប្រាប់អាប់",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "revenue_price", //
            title: "តម្លៃចំណូល",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "revenue_pay_cash", //
            title: "បង់តាមសាច់ប្រាក់",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "revenue_pay_bank", //
            title: "បង់តាមធនាគារ",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "revenue_return", //
            title: "ប្រាប់អាប់",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "check_in_by", //
            title: "ឲចូលដោយ",
            type: PlutoColumnType.text(),
            width: WIDTH,
          ),
          //
          PlutoColumn(
            field: "check_out_by", //
            title: "ឲចេញដោយ",
            type: PlutoColumnType.text(),
            width: WIDTH,
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
            defaultColumnFilterPadding: EdgeInsets.fromLTRB(1, 1, 1, 1),
          ),
        ),
        onLoaded: (event) {
          state_manager = event.stateManager;
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

  //
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
