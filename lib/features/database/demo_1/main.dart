import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:flutter/foundation.dart";
import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as sb;

import "config.dart";
import "schema.g.dart" as sm;

import "form/create.dart" as create;
import "form/read.dart" as read;
import "form/update.dart" as update;
import "form/delete.dart" as delete;

import "widget/page_select.dart" as p_select;

Widget _layout(List<Widget> children) {
  return Scaffold(
    body: Column(
      children: children, //
    ),
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  PlutoGridStateManager? state_manager;
  int page = 1;
  int row_total = 0;
  bool is_loading = true;
  bool is_filter = false;
  int load_request_id = 0;
  int get total_pages => row_total == 0 ? 1 : (row_total + LIMIT - 1) ~/ LIMIT;

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
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
      if (page > total_pages) page = total_pages;
      if (page < 1) page = 1;

      //
      load_page(page);

      sb.view(context: context, message: "Refresh completed.", color: Colors.green);

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void load_page(int p) async {
    final request_id = ++load_request_id;

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

      // Ignore a response from an earlier page request.
      if (!mounted || request_id != load_request_id) return;

      // keep sort + filter
      final sorted_column = state_manager?.getSortedColumn;
      final filter_rows = List<PlutoRow>.from(state_manager?.filterRows ?? const <PlutoRow>[]);

      // add data to row
      state_manager?.removeAllRows();
      state_manager?.appendRows([
        for (var d in data)
          PlutoRow(
            cells: {
              for (var e in sm.data.entries) //
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
      sb.view(context: context, message: e.toString(), color: Colors.red);
      if (request_id == load_request_id && mounted) {
        is_loading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
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
                  onTap: on_create,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add, //
                      size: 24,
                      color: Colors.blue,
                    ), //
                  ),
                ),
              ),

              // Read
              Tooltip(
                message: "Read",
                child: InkWell(
                  onTap: on_read,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.visibility_outlined, //
                      size: 24,
                      color: Colors.blue,
                    ), //
                  ),
                ),
              ),

              // Update
              Tooltip(
                message: "Update",
                child: InkWell(
                  onTap: on_update,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.edit_outlined, //
                      size: 24,
                      color: Colors.blue,
                    ), //
                  ),
                ),
              ),

              // Delete
              Tooltip(
                message: "Delete",
                child: InkWell(
                  onTap: on_delete,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.delete_outline, //
                      size: 24,
                      color: Colors.red,
                    ), //
                  ),
                ),
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
                    is_filter = !is_filter;
                    state_manager?.setShowColumnFilter(is_filter);

                    // * លុប filter ពេលលាក់
                    if (!is_filter) {
                      state_manager?.setFilterWithFilterRows([]);
                    }

                    setState(() {});
                  },
                ),
              ),

              // search
              if (kDebugMode)
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
                      sb.view(context: context, message: "Development", color: Colors.black);
                    },
                  ),
                ),

              // refresh
              Tooltip(
                message: "Refresh",
                child: InkWell(
                  onTap: on_refresh,
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
        );
      })(),

      if (is_loading) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

      // pluto table
      Expanded(
        child: PlutoGrid(
          rows: [],
          columns: [
            for (var e in sm.data.entries)
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
            state_manager?.addListener(() => setState(() {}));
          },
        ),
      ),

      // footer
      (() {
        return Container(
          height: 32, //
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 80),

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
                      "$page / $total_pages", //
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
                    if (page == total_pages) return;
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
                    if (page == total_pages) return;
                    page = total_pages;
                    load_page(page);
                  },
                ),
              ),

              Spacer(),

              // total row
              Container(
                height: 32,
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                alignment: Alignment.center,
                child: Text(
                  "${state_manager?.rows.length} Rows", //
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ), //
              ),

              SizedBox(width: 4),
            ],
          ),
        );
      })(),
    ]);
  }

  void on_create() async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => create.Main_(
            //
          ),
        ),
      );
      if (tmp == null) return;

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
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_read() async {
    try {
      //
      final row = state_manager?.currentRow;
      if (row == null) {
        sb.view(context: context, message: "Please select a row.", color: Colors.red);
        return;
      }

      //
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => read.Main_(
            id: row.cells[sm.ID]!.value.toString(), //
          ),
        ),
      );

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_update() async {
    try {
      //
      final row = state_manager?.currentRow;
      if (row == null) {
        sb.view(context: context, message: "Please select a row.", color: Colors.red);
        return;
      }

      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => update.Main_(
            id: row.cells[sm.ID]!.value.toString(), //
          ),
        ),
      );
      if (tmp == null) return;

      //
      load_page(page);

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_delete() async {
    try {
      //
      final row = state_manager?.currentRow;
      if (row == null) {
        sb.view(context: context, message: "Please select a row.", color: Colors.red);
        return;
      }

      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => delete.Main_(
            id: row.cells[sm.ID]!.value.toString(), //
          ),
        ),
      );
      if (tmp == null) return;

      //
      row_total = row_total - 1;
      state_manager?.removeCurrentRow();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
      if (data != "") {
        final tmp = DateFormat(DATE_FORMAT).tryParse(data.toString());
        if (tmp != null) return tmp.toIso8601String();
      }
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
        if (tmp != null) return DateFormat(DATE_FORMAT).format(tmp.toLocal());
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
      theme: theme.data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
