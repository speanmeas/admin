import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pluto_grid/pluto_grid.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar_show.dart";

import "__config__.dart";
import "schema.g.dart" as schema;

import "form/create.dart" as create;
import "form/read.dart" as read;
import "form/update.dart" as update;
import "form/delete.dart" as delete;

import "widget/page_select.dart" as p_select;

class _Main_State extends State<Main_> {
  //

  int page = 1;
  int row_total = 0;

  bool is_loading = true;
  bool is_filter = false;
  PlutoGridStateManager? state_manager;

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
        "$PATH/read_count", //
        data: {"count": true},
      );
      row_total = int.parse(r.data.toString());

      //
      load_page(page);

      //
    } catch (e) {
      print(e.toString());
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  //
  void on_refresh() async {
    try {
      //
      final r = await dio.post(
        "$PATH/read_count", //
        data: {"count": true},
      );
      row_total = int.parse(r.data.toString());

      //
      if (page > (row_total / LIMIT).floor() + 1) page = (row_total / LIMIT).floor() + 1;
      if (page < 1) page = 1;

      //
      load_page(page);

      //
    } catch (e) {
      print(e.toString());
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void load_page(int p) async {
    try {
      //
      is_loading = true;
      setState(() {});

      //
      final r = await dio.post(
        "$PATH/read", //
        data: {
          "key": KEY, //
          "order": ORDER, //
          "offset": (p - 1) * LIMIT, //
          "limit": LIMIT,
        },
      );
      final data = List<Map<String, dynamic>>.from(r.data);

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
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // menu
          (() {
            return Container(
              height: 32, //
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Create
                  Tooltip(
                    message: "Create",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add, //
                          size: 24,
                          color: Colors.blue,
                        ), //
                      ), //
                      onTap: on_create,
                    ),
                  ),

                  // Read
                  Tooltip(
                    message: "Read",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.visibility_outlined, //
                          size: 24,
                          color: Colors.blue,
                        ), //
                      ), //
                      onTap: on_read,
                    ),
                  ),

                  // Update
                  Tooltip(
                    message: "Update",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit_outlined, //
                          size: 24,
                          color: Colors.blue,
                        ), //
                      ), //
                      onTap: on_update,
                    ),
                  ),

                  Spacer(),
                  // Delete
                  Tooltip(
                    message: "Delete",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.delete_outline, //
                          size: 24,
                          color: Colors.red,
                        ), //
                      ), //
                      onTap: on_delete,
                    ),
                  ),

                  SizedBox(width: 4),
                ],
              ),
            );
          })(),

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
            return Container(
              height: 32, //
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 8),

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
                        is_filter = !is_filter;
                        state_manager?.setShowColumnFilter(is_filter);
                        setState(() {});
                      },
                    ),
                  ),

                  // search
                  Tooltip(
                    message: "Search",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.search, //
                          size: 24,
                          color: Colors.blue,
                        ), //
                      ), //
                      onTap: () {
                        snackbar_show(context: context, message: "Development", color: Colors.black);
                      },
                    ),
                  ),

                  Spacer(),

                  // * ត្រលប់ទៅទំព័រដំបូង
                  Tooltip(
                    message: "First Page",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
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
                  ),

                  // previous page
                  Tooltip(
                    message: "Previous Page",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
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
                  ),

                  // select page
                  Tooltip(
                    message: "Select Page",
                    child: InkWell(
                      child: Container(
                        height: 32,
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        alignment: Alignment.center,
                        child: Text(
                          "$page / ${(row_total / LIMIT).floor() + 1}", //
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                        ), //
                      ), //
                      onTap: () async {
                        final v = await p_select.show(
                          context, //
                          page: page,
                          row_total: row_total,
                          limit: LIMIT,
                        );
                        if (v == null) return;
                        page = v;
                        load_page(page);
                      }, //
                    ),
                  ),

                  // next page
                  Tooltip(
                    message: "Next Page",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
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
                  ),

                  // last page
                  Tooltip(
                    message: "Last Page",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
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
                  ),

                  Spacer(),

                  // refresh
                  Tooltip(
                    message: "Refresh",
                    child: InkWell(
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.refresh, //
                          size: 24,
                          color: Colors.blue,
                        ), //
                      ), //
                      onTap: on_refresh,
                    ),
                  ),

                  SizedBox(width: 8),
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
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_read() async {
    try {
      //
      schema.clear();

      //
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
        return;
      }

      //
      for (var e in schema.data.entries) {
        e.value["value"] = cell_to_data(data: row.cells[e.key]?.value, type: e.value["type"]);
      }

      //
      Navigator.push(context, MaterialPageRoute(builder: (context) => read.Main_()));

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_update() async {
    try {
      //
      schema.clear();

      //
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
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
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_delete() async {
    try {
      //
      schema.clear();

      //
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
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
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
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
      if (data == "") return null;
      if (data != "") return double.tryParse(data.toString());
    }

    //
    if (type == "date-time") {
      if (data == "") return null;
      if (data != "") return DateTime.tryParse(data.toString())?.toIso8601String();
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
      if (data != null) return data.toString();
    }

    //
    if (type == "string") {
      if (data != null) return data.toString();
    }

    //
    if (type == "number") {
      if (data != null) return data.toString();
    }

    //
    if (type == "date-time") {
      if (data != null) {
        final tmp = DateTime.tryParse(data.toString());
        if (tmp != null) return DateFormat(DATE_FORMAT).format(tmp);
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
      theme: Theme_Data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
