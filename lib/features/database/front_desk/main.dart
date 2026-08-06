import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "config.dart";
import "schema.g.dart" as schema;

import "form/create.dart" as create;
import "form/read.dart" as read;
import "form/update.dart" as update;
import "form/delete.dart" as delete;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  //

  int page = 1;
  int row_total = 0;

  bool is_loading = true;
  bool is_filter = false;
  PlutoGridStateManager? state_manager;
  int load_request_id = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  //
  void init() async {
    try {
      //
      final r = await dio.post(
        ep.FRONT_DESK_READ_COUNT, //
        data: {
          "count": true, //
        },
      );
      row_total = int.parse(r.data.toString());

      //
      load_page(page);

      //
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void load_page(int p) async {
    final request_id = ++load_request_id;

    try {
      //
      is_loading = true;
      setState(() {});

      //
      final r = await dio.post(
        "$PATH/read",
        data: {
          "key": KEY, //
          "order": ORDER, //
          "offset": (p - 1) * LIMIT, //
          "limit": LIMIT, //
        },
      );

      final data = List<Map<String, dynamic>>.from(r.data);

      // Ignore a response from an earlier page request.
      if (request_id != load_request_id) return;

      // keep sort + filter
      final sorted_column = state_manager?.getSortedColumn;
      final filter_rows = List<PlutoRow>.from(state_manager?.filterRows ?? const <PlutoRow>[]);

      // add data to row
      state_manager?.removeAllRows();
      state_manager?.appendRows([
        for (var d in data)
          PlutoRow(
            cells: {
              for (var e in schema.data.entries) //
                e.key: PlutoCell(
                  value: e.key.contains("password")
                      ? "**********" //
                      : data_to_cell(data: d[e.key], type: e.value["type"]),
                ),
            },
          ),
      ]);

      // reuse sort + filter
      if (sorted_column != null) state_manager?.sortBySortIdx(sorted_column);
      state_manager?.setFilterWithFilterRows(filter_rows);

      //
      is_loading = false;
      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
      if (request_id == load_request_id) {
        is_loading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Wrap(
                  children: [
                    // create
                    // Container(
                    //   height: 32,
                    //   margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                    //   child: OutlinedButton.icon(
                    //     icon: Icon(Icons.add), //
                    //     label: Text("Create"),
                    //     onPressed: on_create,
                    //   ),
                    // ),

                    // read
                    Container(
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.visibility_outlined), //
                        label: Text("Read"),
                        onPressed: on_read,
                      ),
                    ),

                    // update
                    Container(
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.edit_outlined), //
                        label: Text("Update"),
                        onPressed: on_update,
                      ),
                    ),

                    // delete
                    // Container(
                    //   height: 32,
                    //   margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                    //   child: OutlinedButton.icon(
                    //     icon: Icon(Icons.delete_outline, color: Colors.red), //
                    //     label: Text("Delete", style: TextStyle(color: Colors.red)),
                    //     onPressed: on_delete,
                    //   ),
                    // ),
                  ],
                ),
              ),

              // refresh
              InkWell(
                child: Container(
                  height: 32,
                  width: 32,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 2, 2, 2),
                  child: Icon(
                    is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, //
                    size: 24,
                    color: Colors.blue,
                  ), //
                ),
                onTap: () {
                  is_filter = !is_filter;
                  state_manager?.setShowColumnFilter(is_filter);
                  setState(() {});
                },
              ),
            ],
          ),

          // pluto table
          Expanded(
            child: PlutoGrid(
              rows: [],
              columns: [
                for (var e in schema.data.entries)
                  PlutoColumn(
                    field: e.key, //
                    title: e.value["title"]!,
                    type: e.value["type"] == "number"
                        ? PlutoColumnType.number() //
                        : PlutoColumnType.text(),
                    hide: e.value["hide"]!,
                    width: 160,
                    enableEditingMode: false,
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
                ),
              ),
              onLoaded: (event) {
                state_manager = event.stateManager;
              },
            ),
          ),

          if (is_loading) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          // pagination
          (() {
            double HEIGHT = 32;
            return Container(
              height: HEIGHT, //
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // * ត្រលប់ទៅទំព័រដំបូង
                  InkWell(
                    child: Container(
                      width: 32,
                      height: HEIGHT,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.first_page, //
                        size: 24,
                        color: Colors.blue,
                      ), //
                    ), //
                    onTap: () {
                      if (page == 1) return;
                      page = 1;
                      load_page(page);
                    },
                  ),

                  SizedBox(width: 4),

                  //
                  InkWell(
                    child: Container(
                      width: 32,
                      height: HEIGHT,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.navigate_before, //
                        size: 24,
                        color: Colors.blue,
                      ), //
                    ), //
                    onTap: () {
                      if (page == 1) return;
                      page = page - 1;
                      load_page(page);
                    },
                  ),

                  SizedBox(width: 4),

                  //
                  InkWell(
                    child: Container(
                      height: HEIGHT,
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      alignment: Alignment.center,
                      child: Text(
                        "$page / ${(row_total / LIMIT).floor() + 1} Pages", //
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                      ), //
                    ), //
                    onTap: () async {
                      final v = await select_page();
                      if (v == null) return;
                      page = v;
                      load_page(page);
                    }, //
                  ),

                  SizedBox(width: 4),

                  //
                  InkWell(
                    child: Container(
                      width: 32,
                      height: HEIGHT,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.navigate_next, //
                        size: 24,
                        color: Colors.blue,
                      ), //
                    ), //
                    onTap: () {
                      if (page == (row_total / LIMIT).floor() + 1) return;
                      page = page + 1;
                      load_page(page);
                    },
                  ),

                  SizedBox(width: 4),

                  //
                  InkWell(
                    child: Container(
                      width: 32,
                      height: HEIGHT,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.last_page, //
                        size: 24,
                        color: Colors.blue,
                      ), //
                    ), //
                    onTap: () {
                      if (page == (row_total / LIMIT).floor() + 1) return;
                      page = (row_total / LIMIT).floor() + 1;
                      load_page(page);
                    },
                  ),
                ],
              ),
            );
          })(),
        ],
      ),
    );
  }

  void on_create() async {
    try {
      //
      schema.clear();

      //
      final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => create.Main_()));
      if (v == null) return;

      // * លុប sort + filter
      final sorted_column = state_manager?.getSortedColumn;
      if (sorted_column != null) state_manager?.sortBySortIdx(sorted_column);
      state_manager?.setFilterWithFilterRows([]);

      //
      row_total = row_total + 1;
      page = 1;
      load_page(page);

      state_manager?.scroll.vertical?.jumpTo(0);

      //
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_read() async {
    try {
      //
      schema.clear();

      //
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar.view(context: context, message: "Please select a row.", color: Colors.red);
        return;
      }

      //
      for (var e in schema.data.entries) {
        e.value["value"] = cell_to_data(data: row.cells[e.key]?.value, type: e.value["type"]);
      }

      //
      Navigator.push(context, MaterialPageRoute(builder: (context) => read.Main_()));

      //
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_update() async {
    try {
      //
      schema.clear();

      //
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar.view(context: context, message: "Please select a row.", color: Colors.red);
        return;
      }

      //
      for (var e in schema.data.entries) {
        e.value["value"] = cell_to_data(data: row.cells[e.key]?.value, type: e.value["type"]);
      }

      //
      final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => update.Main_()));
      if (v == null) return;

      //
      load_page(page);

      //
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_delete() async {
    try {
      //
      schema.clear();

      //
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar.view(context: context, message: "Please select a row.", color: Colors.red);
        return;
      }

      //
      schema.data[schema.ID]?["value"] = row.cells[schema.ID]!.value;

      //
      final value = await Navigator.push(context, MaterialPageRoute(builder: (context) => delete.Main_()));
      if (value == null) return;

      //
      row_total = row_total - 1;
      state_manager?.removeCurrentRow();

      //
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  dynamic cell_to_data({
    dynamic data, //
    String? type, //
  }) {
    //
    if (type == "id") {
      if (data == "") return null;
      if (data != "") return data.toString();
    }

    //
    if (type == "string") {
      if (data == "") return null;
      if (data != "") return data.toString();
    }

    //
    if (type == "number") {
      if (data == 0) return null;
      if (data != 0) return double.tryParse(data.toString());
    }

    //
    if (type == "date-time") {
      if (data == "") return null;
      if (data != "") return DateTime.parse(data.toString());
    }

    if (type == "boolean") {
      if (data == "") return null;
      if (data == "Yes") return true;
      if (data == "No") return false;
    }

    return null;
  }

  String data_to_cell({
    dynamic data, //
    String? type, //
  }) {
    //
    if (type == "id") {
      if (data != null) {
        return data.toString();
      }
    }

    //
    if (type == "string") {
      if (data != null) {
        return data.toString();
      }
    }

    //
    if (type == "number") {
      if (data != null) {
        return data.toString();
      }
    }

    //
    if (type == "date-time") {
      if (data != null) {
        final dt = DateTime.tryParse(data.toString());
        if (dt != null) return DateFormat(DATE_FORMAT).format(dt.toLocal());
      }
    }

    //
    if (type == "boolean") {
      if (data != null) {
        if (data == true) return "Yes";
        if (data == false) return "No";
      }
    }

    return "";
  }

  Future<int?> select_page() async {
    final ITEM_HEIGHT = 32.0;
    final controller = ScrollController(initialScrollOffset: (page - 1) * ITEM_HEIGHT);

    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Center(child: Text("Select Page")),
          titlePadding: EdgeInsets.fromLTRB(4, 4, 4, 4),
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          content: SizedBox(
            width: 300,
            height: 600,
            child: ListView.builder(
              controller: controller,
              itemExtent: ITEM_HEIGHT,
              itemCount: (row_total / LIMIT).floor() + 1,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              itemBuilder: (context, index) {
                final p = index + 1;
                return InkWell(
                  child: Container(
                    height: ITEM_HEIGHT,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.black12)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 8),

                        Text("Page $p", style: TextStyle(fontWeight: FontWeight.bold)), //

                        Spacer(),

                        if (p == page) Icon(Icons.check, color: Colors.blue),

                        SizedBox(width: 16),
                      ],
                    ), //
                  ), //
                  onTap: () => Navigator.pop(context, p),
                );
              },
            ),
          ),
          // actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel"))],
        );
      },
    );
    return result;
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
      title: HEADER, //
      theme: theme.data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
