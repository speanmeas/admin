import "package:flutter/material.dart";
import "package:dio/dio.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";

import "package:speanmeas/environment.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "_setup.dart";
import "schema.g.dart" as schema;

import "filter_string.dart" as filter_string;
import "filter_number.dart" as filter_number;
import "filter_boolean.dart" as filter_boolean;
import "filter_datetime.dart" as filter_datetime;

import "form_create.dart" as create;
import "form_read.dart" as read;
import "form_update.dart" as update;
import "form_delete.dart" as delete;

class _Main_State extends State<Main_> {
  //

  PlutoGridStateManager? state_manager;

  bool is_loading = false;
  bool has_more = true;

  //
  String? key;
  String? query;
  double? min;
  double? max;
  DateTime? start;
  DateTime? end;
  bool? has;
  int? order;

  @override
  void initState() {
    super.initState();
    init();
  }

  //
  void init() async {
    //
    await dio
        .post(
          "$PATH/data_read",
          data: FormData.fromMap({
            "key": key, //
            "has": has, //
            "query": query, //
            "min": min, //
            "max": max, //
            "start": start, //
            "end": end, //
            "order": order, //
            "limit": ROW_LIMIT, //
          }),
        )
        .then((r) {
          final data = List<Map<String, dynamic>>.from(r.data);

          if (r.data.length == ROW_LIMIT) has_more = true;
          if (r.data.length != ROW_LIMIT) has_more = false;

          // clear data
          state_manager?.removeAllRows();

          // add data to row
          state_manager?.appendRows([
            for (var d in data)
              PlutoRow(
                cells: {
                  for (var e in schema.data.entries)
                    // exclude password field
                    if (e.key.toString().contains("password"))
                      e.key: PlutoCell(value: "**********")
                    // id
                    else if (e.value["type"] == "_id") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          return d[e.key].toString();
                        })(),
                      )
                    // string
                    else if (e.value["type"] == "string") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          return d[e.key].toString();
                        })(),
                      )
                    // number
                    else if (e.value["type"] == "number") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          return d[e.key].toString();
                        })(),
                      )
                    // date-time
                    else if (e.value["type"] == "date-time") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          final dt = DateTime.tryParse(d[e.key].toString());
                          if (dt == null) return "";
                          return DateFormat(DATE_FORMAT).format(dt.toLocal());
                        })(),
                      )
                    // boolean
                    else if (e.value["type"] == "boolean") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          if (d[e.key] == true) return "Yes";
                          return "No";
                        })(),
                      ),
                },
              ),
          ]);

          // clear sort
          final sorted_column = state_manager?.getSortedColumn;
          if (sorted_column != null) state_manager?.sortBySortIdx(sorted_column);

          // jump to top
          state_manager?.scroll.vertical?.jumpTo(0);

          // notify
          setState(() {});
        })
        .catchError((e) {
          print(e.toString());
        });
  }

  //
  void on_load_more() async {
    await dio
        .post(
          "$PATH/data_read",
          data: FormData.fromMap({
            "key": key, //
            "has": has, //
            "query": query, //
            "min": min, //
            "max": max, //
            "start": start, //
            "end": end, //
            "order": order, //
            "offset": state_manager?.rows.length, //
            "limit": ROW_LIMIT, //
          }),
        ) //
        .then((r) {
          final data = List<Map<String, dynamic>>.from(r.data);

          if (r.data.length == ROW_LIMIT) has_more = true;
          if (r.data.length != ROW_LIMIT) has_more = false;

          // add data to row
          state_manager?.appendRows([
            for (var d in data)
              PlutoRow(
                cells: {
                  for (var e in schema.data.entries)
                    // exclude password field
                    if (e.key.toString().contains("password"))
                      e.key: PlutoCell(value: "**********")
                    // id
                    else if (e.value["type"] == "_id") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          return d[e.key].toString();
                        })(),
                      )
                    // string
                    else if (e.value["type"] == "string") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          return d[e.key].toString();
                        })(),
                      )
                    // number
                    else if (e.value["type"] == "number") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          return d[e.key].toString();
                        })(),
                      )
                    // date-time
                    else if (e.value["type"] == "date-time") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          final dt = DateTime.tryParse(d[e.key].toString());
                          if (dt == null) return "";
                          return DateFormat(DATE_FORMAT).format(dt.toLocal());
                        })(),
                      )
                    // boolean
                    else if (e.value["type"] == "boolean") //
                      e.key: PlutoCell(
                        value: (() {
                          if (d[e.key] == null) return "";
                          if (d[e.key] == true) return "Yes";
                          return "No";
                        })(),
                      ),
                },
              ),
          ]);
          is_loading = false;
          setState(() {});
        })
        .catchError((e) {
          print(e.toString());
        });
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
                    Container(
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.add), //
                        label: Text("Create"),
                        onPressed: on_create,
                      ),
                    ),

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
                    Container(
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 0, 2),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.delete_outline, color: Colors.red), //
                        label: Text("Delete", style: TextStyle(color: Colors.red)),
                        onPressed: on_delete,
                      ),
                    ),
                  ],
                ),
              ),

              // refresh
              Container(
                height: 32,
                margin: EdgeInsets.fromLTRB(0, 2, 2, 2),
                child: InkWell(
                  child: Icon(
                    Icons.refresh, //
                    size: 28,
                    color: Colors.blue,
                  ), //
                  onTap: on_refresh,
                ),
              ),
            ],
          ),

          // pluto table
          Expanded(
            child: PlutoGrid(
              rows: [],
              columns: [
                for (var e in schema.data.entries)
                  build_plutocolumn(
                    field: e.key, //
                    title: e.value["title"]!,
                    type: e.value["type"]!,
                    hide: e.value["hide"]!,
                    on_filter: () => on_filter(e),
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
                ),
              ),
              onLoaded: (event) {
                state_manager = event.stateManager;
                state_manager?.scroll.bodyRowsVertical!.addListener(() {
                  final position = state_manager?.scroll.bodyRowsVertical!.position;
                  if (!is_loading) {
                    if (position!.pixels >= position.maxScrollExtent) {
                      if (has_more) {
                        is_loading = true;
                        on_load_more();
                      }
                      setState(() {});
                    }
                  }
                });
              },
            ),
          ),

          // footer loading
          if (is_loading)
            Container(
              height: 24, //
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                  SizedBox(width: 12),
                  Text("Loading more..."),
                ],
              ),
            ),

          // footer total row count
          if (!is_loading && state_manager != null)
            Container(
              height: 24, //
              child: Text("Loaded: ${state_manager!.rows.length} items"),
            ),
        ],
      ),
    );
  }

  void on_filter(e) {
    // clear
    key = has = query = min = max = start = end = order = null;

    // init
    key = e.key;
    order = 1;

    //
    if (e.value["type"] == "string") {
      Navigator.push(
        context, //
        MaterialPageRoute(builder: (context) => filter_string.Main_()),
      ).then((v) {
        if (v == null) return;
        query = v;
        init();
      });
    }

    //
    if (e.value["type"] == "number") {
      Navigator.push(
        context, //
        MaterialPageRoute(builder: (context) => filter_number.Main_()),
      ).then((v) {
        if (v == null) return;
        min = v["min"];
        max = v["max"];
        init();
      });
    }

    //
    if (e.value["type"] == "date-time") {
      Navigator.push(
        context, //
        MaterialPageRoute(builder: (context) => filter_datetime.Main_()),
      ).then((v) {
        if (v == null) return;
        start = v["start"];
        end = v["end"];
        init();
      });
    }

    //
    if (e.value["type"] == "boolean") {
      Navigator.push(
        context, //
        MaterialPageRoute(builder: (context) => filter_boolean.Main_()),
      ).then((v) {
        if (v == null) return;
        has = v;
        init();
      });
    }
  }

  void on_create() {
    //
    schema.clear();

    //
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => create.Main_()),
    ).then((v) {
      if (v == null) return;
      init();
    });
  }

  void on_read() {
    //
    schema.clear();

    //
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    //
    final row = state_manager?.currentRow;
    row!.cells.forEach((k, c) {
      schema.data[k]?["value"] = c.value;
    });

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => read.Main_()),
    );
  }

  void on_update() {
    //
    schema.clear();

    //
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    //
    final row = state_manager?.currentRow;
    row!.cells.forEach((k, c) {
      schema.data[k]?["value"] = c.value;
    });

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => update.Main_()),
    ).then((v) {
      if (v == null) return;
      init();
    });
  }

  void on_delete() {
    //
    schema.clear();

    //
    if (state_manager?.currentRow == null) {
      snackbar_show(context: context, message: "Please select a row.", color: Colors.red);
      return;
    }

    //
    schema.data["_id"]?["value"] = state_manager?.currentRow!.cells["_id"]!.value;

    //
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => delete.Main_()),
    ).then((v) {
      if (v == null) return;

      // remove current row
      state_manager?.removeCurrentRow();

      state_manager?.notifyListeners();
      setState(() {});
    });
  }

  //
  void on_refresh() {
    //
    key = has = query = min = max = start = end = order = null;

    //
    init();

    //
    snackbar_show(context: context, message: "Refreshed successfully", color: Colors.green);
  }

  //
  build_plutocolumn({
    required String title, //
    required String field,
    required String type,
    required bool hide,
    required VoidCallback on_filter,
  }) {
    //
    PlutoColumnType column_type;
    if (type == "number") {
      column_type = PlutoColumnType.number();
    } else {
      column_type = PlutoColumnType.text();
    }

    //
    return PlutoColumn(
      title: title,
      field: field,
      type: column_type,
      width: 160,
      minWidth: 100,
      readOnly: true,
      enableFilterMenuItem: false,
      hide: hide,
      titleSpan: WidgetSpan(
        child: Row(
          children: [
            if (type == "string")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.filter_alt_outlined, size: 20, color: Colors.blue),
              )
            else if (type == "number")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.tune, size: 20, color: Colors.blue),
              )
            else if (type == "date-time")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.date_range, size: 20, color: Colors.blue),
              )
            else if (type == "boolean")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.toggle_on_outlined, size: 20, color: Colors.blue),
              )
            else
              SizedBox(),

            SizedBox(width: 4),

            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(width: 20),
          ],
        ),
      ),
    );
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
      title: HEADER, //
      theme: Theme_Data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
