import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/utility/gen_data.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  dynamic tmp;
  int reload = 0;
  double WIDTH = 120;
  bool is_load = true;

  late List<String> list_column;
  late PlutoGridStateManager state_manager;

  List<Front_Desk> data = [];
  // * ########## BLOCK VARIABLES END ##########

  // * ########## BLOCK METHODS ##########

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // setState(() => is_load = true);
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }

  void on_loaded(PlutoGridOnLoadedEvent e) async {
    setState(() => is_load = true);
    state_manager = e.stateManager;
    state_manager.columnFooterHeight = 32; // * កម្ពស់ជួរសរុប

    // show filter
    // state_manager.setShowColumnFilter(true);

    list_column = state_manager.refColumns.map((c) => c.field).toList();

    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var i = 0; i < 10; i++)
        PlutoRow(
          cells: {
            for (var c in list_column) //
              c: (() {
                if (c == "index") //
                  return PlutoCell(value: i + 1);
                if (c == "room") //
                  return PlutoCell(value: (100 + gen_number() * 900).toInt().toString());
                if (c == "guest_name") //
                  return PlutoCell(value: gen_text());
                if (c == "guest_phone") //
                  return PlutoCell(value: (1000000000 + gen_number() * 9000000000).toInt().toString());
                if (c == "stay") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "check_in") //
                  return PlutoCell(value: gen_datetime());
                if (c == "check_out") //
                  return PlutoCell(value: gen_datetime());
                if (c == "room_price") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "room_cash") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "room_bank") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "mini_bar_price") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "mini_bar_cash") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "mini_bar_bank") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "penalty_price") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "penalty_cash") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "penalty_bank") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "check_in_by") //
                  return PlutoCell(value: gen_text());
                if (c == "check_out_by") //
                  return PlutoCell(value: gen_text());
                if (c == "note_1") //
                  return PlutoCell(value: gen_text());
                if (c == "note_2") //
                  return PlutoCell(value: gen_text());

                return PlutoCell(value: "");
              })(),
          },
        ),
    ]);

    setState(() => is_load = false);
  }

  void on_changed(PlutoGridOnChangedEvent e) async {
    pprint("onChanged: ${e.row.cells["index"]?.value} | ${e.column.field} | ${e.value}");
  }

  // * ########## BLOCK METHODS END ##########

  // * ########## BLOCK DESIGN ##########
  Widget _layout({
    List<Widget>? check_in, //
    List<Widget>? check_out, //
    List<Widget>? clean, //
    Widget? body, //
    List<Widget>? footer, //
  }) {
    return Scaffold(
      body: Column(
        children: [
          // CHECK IN
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Container(
                height: 34, //
                width: 100, //
                alignment: Alignment.centerRight, //
                child: Text(
                  "Check-In: ", //
                  style: TextStyle(
                    fontSize: 16, //
                    fontWeight: FontWeight.bold,
                    // color: Colors.green,
                  ),
                ),
              ),

              Expanded(
                child: Wrap(
                  spacing: 1, //
                  runSpacing: 1,
                  children: [...?check_in],
                ),
              ),
            ],
          ),

          // CHECK OUT
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Container(
                height: 34, //
                width: 100, //
                alignment: Alignment.centerRight, //
                child: Text(
                  "Check-Out: ", //
                  style: TextStyle(
                    fontSize: 16, //
                    fontWeight: FontWeight.bold,
                    // color: Colors.green,
                  ),
                ),
              ),

              Expanded(
                child: Wrap(
                  spacing: 1, //
                  runSpacing: 1,
                  children: [...?check_out],
                ),
              ),
            ],
          ),

          // CLEAN
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Container(
                height: 34, //
                width: 100, //
                alignment: Alignment.centerRight, //
                child: Text(
                  "Clean: ", //
                  style: TextStyle(
                    fontSize: 16, //
                    fontWeight: FontWeight.bold,
                    // color: Colors.green,
                  ),
                ),
              ),

              Expanded(
                child: Wrap(
                  spacing: 1, //
                  runSpacing: 1,
                  children: [...?clean],
                ),
              ),
            ],
          ),

          SizedBox(height: 2),

          if (is_load) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: body ?? Container()),

          // FOOTER
          Container(
            height: 34, //
            padding: const EdgeInsets.all(1),
            child: InteractiveViewer(
              panEnabled: true, //
              constrained: false, //
              scaleEnabled: false, //
              panAxis: PanAxis.horizontal, //
              alignment: Alignment.center, //
              child: Row(
                spacing: 2, //
                mainAxisAlignment: MainAxisAlignment.center, //
                crossAxisAlignment: CrossAxisAlignment.center, //
                children: [...?footer],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _layout(
      check_in: [
        for (var i = 0; i < 10; i++)
          OutlinedButton.icon(
            icon: Icon(Icons.hotel_outlined), //
            label: Text("${200 + i}"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
            onPressed: () {
              pprint("Check-In");
            },
          ),
      ],
      check_out: [
        for (var i = 0; i < 10; i++)
          OutlinedButton.icon(
            icon: Icon(Icons.hotel_outlined), //
            label: Text("${300 + i}"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              pprint("Check-Out");
            },
          ),
      ],
      clean: [
        for (var i = 0; i < 100; i++)
          OutlinedButton.icon(
            icon: Icon(Icons.hotel_outlined), //
            label: Text("${400 + i}"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
            onPressed: () {
              pprint("Clean");
            },
          ),
      ],
      body: PlutoGrid(
        key: ValueKey(reload), //
        rows: [], //
        columns: [
          PlutoColumn(
            field: "_id", //
            title: "ID",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            hide: true, //
          ),

          PlutoColumn(
            field: "index", //
            title: "No.",
            type: PlutoColumnType.number(),
            enableEditingMode: false,
            width: 60,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_string(rc.cell.value), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.count,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "Sum: ", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "room", //
            title: "Room",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_string(rc.cell.value), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: "guest_name", //
            title: "Name",
            type: PlutoColumnType.text(),
            enableEditingMode: true,
            width: WIDTH,
            renderer: (rc) {
              return Row(
                children: [
                  //
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, //
                      child: Text(
                        format_string(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "guest_phone", //
            title: "Phone",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: WIDTH,

            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, //
                      child: Text(
                        format_string(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  IconButton(
                    tooltip: "Search Guest", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Search Guest: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "stay_people", //
            title: "People",
            type: PlutoColumnType.number(negative: false, format: "#,###"),
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 0) + " នាក់", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: "stay_day", //
            title: "Days",
            type: PlutoColumnType.number(negative: false, format: "#,###"),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 0) + " ថ្ងៃ", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: "stay_hour", //
            title: "Hours",
            type: PlutoColumnType.number(negative: false, format: "#,###"),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 0) + " ម៉ោង", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: "check_in", //
            title: "Check-In At",
            enableEditingMode: false,
            type: PlutoColumnType.text(),
            width: 160,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(
                        format_datetime(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  IconButton(
                    tooltip: "Update Check-In", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Update Check-In: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "check_out", //
            title: "Check-Out At",
            enableEditingMode: false,
            type: PlutoColumnType.text(),
            width: 160,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(
                        format_datetime(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  IconButton(
                    tooltip: "Update Check-Out", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Update Check-Out: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "room_price", //
            title: "Price",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "room_cash", //
            title: "Cash",
            type: PlutoColumnType.number(
              //   negative: false, //
              format: "#,###.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "room_bank", //
            title: "Bank",
            type: PlutoColumnType.number(
              //   negative: false, //
              format: "#,###.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "room_note", //
            title: "Note",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, //
                      child: Text(
                        format_string(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  IconButton(
                    tooltip: "Search", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Search: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
            // renderer: (rc) {
            //   return Align(
            //     alignment: Alignment.centerLeft, //
            //     child: Text(
            //       format_string(rc.cell.value), //
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   );
            // },
          ),

          PlutoColumn(
            field: "mini_bar_item", //
            title: "Items",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, //
                children: [
                  //
                  IconButton(
                    tooltip: "Update Mini Bar Items", //
                    icon: Icon(Icons.local_bar_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Update Mini Bar Items: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "mini_bar_price", //
            title: "Price",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.00",
            ),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "mini_bar_cash", //
            title: "Cash",
            type: PlutoColumnType.number(
              //   negative: false, //
              format: "#,###.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "mini_bar_bank", //
            title: "Bank",
            type: PlutoColumnType.number(
              //   negative: false, //
              format: "#,###.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "mini_bar_note", //
            title: "Note",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, //
                      child: Text(
                        format_string(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  IconButton(
                    tooltip: "Search", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Search: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "penalty_item", //
            title: "Items",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "Update Penalty Items", //
                    icon: Icon(Icons.gavel_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Update Penalty Items: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "penalty_price", //
            title: "Price",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.00",
            ),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "penalty_cash", //
            title: "Cash",
            type: PlutoColumnType.number(
              //   negative: false, //
              format: "#,###.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "penalty_bank", //
            title: "Bank",
            type: PlutoColumnType.number(
              //   negative: false, //
              format: "#,###.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,###.00", //
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.sum,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "$value \$", //
                        style: TextStyle(
                          fontSize: 14, //
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ];
                },
              );
            },
          ),

          PlutoColumn(
            field: "penalty_note", //
            title: "Note",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, //
                      child: Text(
                        format_string(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  IconButton(
                    tooltip: "Search", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Search: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "check_in_by", //
            title: "Check-in By",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 140,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
                child: Text(
                  format_string(rc.cell.value), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
          PlutoColumn(
            field: "check_out_by", //
            title: "Check-Out By",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 140,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
                child: Text(
                  format_string(rc.cell.value), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          // BUTTON RECEIPT
          PlutoColumn(
            field: "other", //
            title: "Others",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, //
                children: [
                  //
                  IconButton(
                    tooltip: "Change Room", //
                    icon: Icon(Icons.swap_horiz_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Change Room: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),

                  //
                  IconButton(
                    tooltip: "Cancel", //
                    icon: Icon(Icons.cancel_outlined, color: Colors.red),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Cancel: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),

                  //
                  IconButton(
                    tooltip: "Print Receipt", //
                    icon: Icon(Icons.print_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Print Receipt: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),
        ], //
        columnGroups: [
          PlutoColumnGroup(
            title: "", //
            fields: ["index"],
          ),
          PlutoColumnGroup(
            title: "", //
            fields: ["room"],
          ),
          PlutoColumnGroup(
            title: "Guest", //
            fields: ["guest_name", "guest_phone", "guest_update"],
          ),
          PlutoColumnGroup(
            title: "Stay", //
            fields: ["stay_people", "stay_day", "stay_hour", "check_in", "check_out"],
          ),
          PlutoColumnGroup(
            title: "Room Payment", //
            fields: ["room_price", "room_cash", "room_bank", "room_note"],
          ),
          PlutoColumnGroup(
            title: "Mini Bar Payment", //
            fields: ["mini_bar_item", "mini_bar_price", "mini_bar_cash", "mini_bar_bank", "mini_bar_note"],
          ),
          PlutoColumnGroup(
            title: "Penalty Payment", //
            fields: ["penalty_item", "penalty_price", "penalty_cash", "penalty_bank", "penalty_note"],
          ),
          PlutoColumnGroup(
            title: "Person In Charge", //
            fields: ["check_in_by", "check_out_by"],
          ),
          PlutoColumnGroup(
            title: "", //
            fields: ["other"],
          ),
        ],
        configuration: PlutoGridConfiguration(
          scrollbar: PlutoGridScrollbarConfig(
            isAlwaysShown: true, //
            scrollbarThickness: 12,
            scrollbarThicknessWhileDragging: 12,
          ),
          style: PlutoGridStyleConfig(
            rowHeight: 28, //
            columnHeight: 32, //
            columnFilterHeight: 32,
            defaultColumnTitlePadding: EdgeInsets.fromLTRB(4, 2, 26, 0),
            defaultColumnFilterPadding: EdgeInsets.fromLTRB(1, 1, 1, 1),
            defaultCellPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          ),
        ),

        onLoaded: on_loaded,
        onChanged: on_changed,
      ),

      footer: [
        // * ប៊ូតុងបញ្ចេញជា PDF
        Tooltip(
          message: "Export as PDF",
          child: InkWell(
            onTap: () {
              snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
            },
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/icon/pdf.svg", //
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
              ),
            ),
          ),
        ),

        // * ប៊ូតុងបញ្ចេញជា Excel
        Tooltip(
          message: "Export as Excel",
          child: InkWell(
            onTap: () {
              snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
            },
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/icon/excel.svg", //
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
              ),
            ),
          ),
        ),

        IconButton(
          tooltip: "Previous", //
          icon: Icon(Icons.navigate_before, size: 32), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {},
        ),

        TextButton(
          child: Text(
            "2026-08-24", //
            style: TextStyle(
              fontSize: 16, //
              fontWeight: FontWeight.bold, //
            ),
          ),
          onPressed: () {},
        ),

        IconButton(
          tooltip: "Next", //
          icon: Icon(Icons.navigate_next, size: 32), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {},
        ),
      ],
    );
  }

  // * ########## BLOCK DESIGN END ##########
}

// * ########## BLOCK ARGUMENTS OF MAIN ##########
class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}
// * ########## BLOCK ARGUMENTS OF MAIN END ##########

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: MaterialApp(
        home: const Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
