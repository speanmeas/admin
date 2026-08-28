import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";
// import "package:speanmeas/core/utility/gen_data.dart";

import "form/check_in.dart" as check_in;
import "form/check_out.dart" as check_out;
import "form/clean.dart" as clean;
// import "dialog/check_in.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  dynamic tmp;
  int reload = 0; // this variable is used to reload the PlutoGrid when the data changes
  bool is_load = false; // this variable is used to guard the fast clicking of the buttons, to prevent multiple requests to the server
  double WIDTH = 120;

  late List<String> list_column;
  late PlutoGridStateManager state_manager;

  DateTime dt = DateTime.now();

  List<dynamic> rooms = [];
  List<Front_Desk> front_desks = [];

  Timer? timer_refresh;
  bool is_refresh = false;
  // * ########## BLOCK VARIABLES END ##########

  // * ########## BLOCK METHODS ##########
  @override
  void initState() {
    super.initState();
    timer_refresh = Timer.periodic(Duration(minutes: 1), (_) => refresh_time());
  }

  @override
  void dispose() {
    timer_refresh?.cancel();
    super.dispose();
  }

  // * ពេលបញ្ចប់ស្នាក់នៅ: មាន check_out → បិទការគណនាពេល check_out, អត់ → រត់តាមពេលបច្ចុប្បន្ន
  DateTime stay_end_of(Front_Desk fd, DateTime in_at) {
    DateTime? out_at = fd.check_out_id?.created_at;
    if (out_at != null) return out_at;
    if (fd.check_out_id == null) return DateTime.now();
    return in_at;
  }

  // * គណនាតម្លៃបន្ទប់: ក្រោម 1 ម៉ោង = 0, រួចគិតតាម 3 ម៉ោង រហូតលើសតម្លៃ 1 ថ្ងៃ ទើបគិតតាមថ្ងៃ
  double room_price_of({required int minutes, required double? price_3h, required double? price_day}) {
    double h3 = price_3h ?? 0;
    double pd = price_day ?? 0;
    if (minutes < 60) return 0;
    if (h3 <= 0) return 0;
    double total = 0;
    int remain = minutes;
    while (remain > 0) {
      int slice = remain > 1440 ? 1440 : remain;
      int blocks = (slice / 180).ceil();
      double price = blocks * h3;
      total += (pd > 0 && price > pd) ? pd : price;
      remain -= slice;
    }
    return total;
  }

  Future<void> init() async {
    tmp = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_READ}", cl: Colors.red);

    rooms = tmp.data as List<dynamic>? ?? [];

    tmp = await dio.post(
      endpoint.FRONT_DESK_READ,
      data: {
        "key": Front_Desk.CREATED_AT, //
        "order": 1, //
        "link": true, //
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.FRONT_DESK_READ}", cl: Colors.red);

    front_desks = (tmp.data as List<dynamic>? ?? []).map<Front_Desk>((e) => Front_Desk.fromJson(e)).toList();

    update_grid();

    setState(() {});
  }

  void update_grid() {
    //
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, fd) in front_desks.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column) //
              c: (() {
                if (c == "index") //
                  return PlutoCell(value: i + 1);
                if (c == "room") //
                  return PlutoCell(value: fd.room_id?.number ?? "");
                if (c == "check_in_number") //
                  return PlutoCell(value: fd.check_in_id?.number ?? 0);

                if (c == "check_in_at") //
                  return PlutoCell(value: fd.check_in_id?.created_at ?? 0);

                if (c == "check_in_duration") {
                  DateTime? in_at = fd.check_in_id?.created_at;
                  if (in_at == null) return PlutoCell(value: 0);
                  return PlutoCell(value: stay_end_of(fd, in_at).difference(in_at).inMinutes);
                }

                if (c == "room_price") {
                  //   DateTime? in_at = fd.check_in_id?.created_at;
                  //   int minutes = in_at == null ? 0 : (fd.check_out_id?.created_at ?? DateTime.now()).difference(in_at).inMinutes;
                  //   if (fd.room_id?.price_per_3h == null && fd.room_id?.price_per_day == null) return PlutoCell(value: fd.room_pay_id?.price ?? 0);
                  //   return PlutoCell(
                  //     value: room_price_of(minutes: minutes, price_3h: fd.room_id?.price_per_3h, price_day: fd.room_id?.price_per_day),
                  //   );
                  return PlutoCell(value: fd.room_pay_id?.price ?? 0);
                }

                if (c == "check_out_at") //
                  return PlutoCell(value: fd.check_out_id?.created_at ?? 0);
                if (c == "clean_at") //
                  return PlutoCell(value: fd.clean_id?.created_at ?? 0);

                if (c == "check_in_by") //
                  return PlutoCell(value: fd.check_in_id?.created_by?.full_name ?? "");
                if (c == "check_out_by") //
                  return PlutoCell(value: fd.check_out_id?.created_by?.full_name ?? "");
                if (c == "clean_by") //
                  return PlutoCell(value: fd.clean_id?.created_by?.full_name ?? "");

                return PlutoCell(value: "");
              })(),
          },
        ),
    ]);

    setState(() {});
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }

  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    state_manager.addListener(() => setState(() {}));
    state_manager.columnFooterHeight = 32; // * កម្ពស់ជួរសរុប
    // state_manager.setShowColumnFilter(true);
    list_column = state_manager.refColumns.map((c) => c.field).toList();

    init();
  }

  void on_changed(PlutoGridOnChangedEvent e) async {
    pprint("onChanged: ${e.row.cells["index"]?.value} | ${e.column.field} | ${e.value}");
  }

  void on_check_in() {
    // controller
  }

  void on_check_out() {
    // controller
  }

  void on_clean() {
    // controller
  }

  void refresh_time() async {
    if (is_refresh) return;
    is_refresh = true;
    update_grid();
    is_refresh = false;
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
                padding: const EdgeInsets.only(bottom: 2), //
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

          const SizedBox(height: 1),

          // CHECK OUT
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Container(
                height: 34, //
                width: 100, //
                alignment: Alignment.centerRight, //
                padding: const EdgeInsets.only(bottom: 2), //
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

          const SizedBox(height: 1),

          // CLEAN
          Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Container(
                height: 34, //
                width: 100, //
                alignment: Alignment.centerRight, //
                padding: const EdgeInsets.only(bottom: 2), //
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

          const SizedBox(height: 1),

          if (is_load) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: body ?? Container()),

          // FOOTER
          Container(
            height: 34, //
            padding: const EdgeInsets.all(1),
            child: Row(
              spacing: 2, //
              mainAxisAlignment: MainAxisAlignment.center, //
              crossAxisAlignment: CrossAxisAlignment.center, //
              children: [...?footer],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _layout(
      //
      check_in: [
        for (var r in rooms.where((r) => r[Room.STATUS] == "Available"))
          OutlinedButton.icon(
            icon: Icon(Icons.hotel_outlined), //
            label: Text("${r[Room.NUMBER]}"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
            onPressed: () async {
              // pprint(r[Room.ID]);
              // pprint(r[Room.NUMBER]);
              // pprint(r[Room.PRICE_PER_DAY]);
              // pprint(r[Room.PRICE_PER_3H]);
              tmp = await nav_push(
                context,
                check_in.Main_(
                  room_id: r[Room.ID], //
                  room_number: r[Room.NUMBER], //
                  price_per_day: r[Room.PRICE_PER_DAY], //
                  //   price_per_3h: r[Room.PRICE_PER_3H], //
                ),
              );
              if (tmp == null) return;
              init();
            },
          ),
      ],

      //
      check_out: [
        for (var r in rooms.where((r) => r[Room.STATUS] == "Occupied"))
          OutlinedButton.icon(
            icon: Icon(Icons.hotel_outlined), //
            label: Text("${r[Room.NUMBER]}"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              // pprint(r[Room.FRONT_DESK_ID]);
              // pprint(r[Room.ID]);
              // pprint(r[Room.NUMBER]);

              tmp = await nav_push(
                context,
                check_out.Main_(
                  front_desk_id: r[Room.FRONT_DESK_ID], //
                  room_id: r[Room.ID], //
                  room_number: r[Room.NUMBER], //
                ),
              );
              if (tmp == null) return;
              init();
            },
          ),
      ],

      //
      clean: [
        for (var r in rooms.where((r) => r[Room.STATUS] == "Dirty"))
          OutlinedButton.icon(
            icon: Icon(Icons.hotel_outlined), //
            label: Text("${r[Room.NUMBER]}"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
            onPressed: () async {
              // pprint(r[Room.FRONT_DESK_ID]);
              // pprint(r[Room.ID]);
              // pprint(r[Room.NUMBER]);

              tmp = await nav_push(
                context,
                clean.Main_(
                  front_desk_id: r[Room.FRONT_DESK_ID], //
                  room_id: r[Room.ID], //
                  room_number: r[Room.NUMBER], //
                ),
              );
              if (tmp == null) return;
              init();
            },
          ),
      ],

      //
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
                format: "#,##0.00", //
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
            field: "check_in_number", //
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

          //   PlutoColumn(
          //     field: "check_in_day", //
          //     title: "Days",
          //     type: PlutoColumnType.number(negative: false, format: "#,###"),
          //     // enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 0) + " ថ្ងៃ", //
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       );
          //     },
          //   ),
          PlutoColumn(
            field: "check_in_at", //
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

          // auto calculate
          PlutoColumn(
            field: "check_in_duration", //
            title: "Duration",
            type: PlutoColumnType.number(negative: false, format: "#,###"),
            // enableEditingMode: false,
            width: 140,
            renderer: (rc) {
              int minutes = parse_int(rc.cell.value) ?? 0;
              int day = minutes ~/ 1440;
              int hour = (minutes % 1440) ~/ 60;
              int minute = minutes % 60;
              String text = "";
              if (day > 0) text += "$day ថ្ងៃ ";
              if (hour > 0) text += "$hour ម៉ោង ";
              if (minute > 0 || text.isEmpty) text += "$minute នាទី";
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  text, //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: "check_out_at", //
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
            field: "clean_at", //
            title: "Clean At",
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
                    tooltip: "Update Clean", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Update Clean: ${rc.row.cells["index"]?.value}");
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
              format: "#,##0.00",
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
                format: "#,##0.00", //
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
              format: "#,##0.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
                  ),
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,##0.00", //
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
              format: "#,##0.00",
            ),
            // enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
                  ),
                ),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,##0.00", //
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
            field: "room_paid", //
            title: "Paid",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,##0.00",
            ),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
                  ),
                ),
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

                  //   IconButton(
                  //     tooltip: "Search", //
                  //     icon: Icon(Icons.search_outlined),
                  //     padding: EdgeInsets.all(0),
                  //     constraints: BoxConstraints(),
                  //     onPressed: () {
                  //       print("Search: ${rc.row.cells["index"]?.value}");
                  //     }, //
                  //   ),
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

          //   PlutoColumn(
          //     field: "mini_bar_item", //
          //     title: "Items",
          //     type: PlutoColumnType.text(),
          //     enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround, //
          //         children: [
          //           //
          //           IconButton(
          //             tooltip: "Update Mini Bar Items", //
          //             icon: Icon(Icons.local_bar_outlined),
          //             padding: EdgeInsets.all(0),
          //             constraints: BoxConstraints(),
          //             onPressed: () {
          //               print("Update Mini Bar Items: ${rc.row.cells["index"]?.value}");
          //             }, //
          //           ),
          //         ],
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "mini_bar_price", //
          //     title: "Price",
          //     type: PlutoColumnType.number(
          //       negative: false, //
          //       format: "#,##0.00",
          //     ),
          //     enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 2) + " \$", //
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       );
          //     },
          //     footerRenderer: (rc) {
          //       return PlutoAggregateColumnFooter(
          //         rendererContext: rc, //
          //         format: "#,##0.00", //
          //         alignment: Alignment.centerRight,
          //         padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          //         type: PlutoAggregateColumnType.sum,
          //         titleSpanBuilder: (value) {
          //           return [
          //             WidgetSpan(
          //               child: Text(
          //                 "$value \$", //
          //                 style: TextStyle(
          //                   fontSize: 14, //
          //                   fontWeight: FontWeight.bold,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ),
          //           ];
          //         },
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "mini_bar_cash", //
          //     title: "Cash",
          //     type: PlutoColumnType.number(
          //       //   negative: false, //
          //       format: "#,##0.00",
          //     ),
          //     // enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 2) + " \$", //
          //           overflow: TextOverflow.ellipsis,
          //           style: TextStyle(
          //             color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
          //           ),
          //         ),
          //       );
          //     },
          //     footerRenderer: (rc) {
          //       return PlutoAggregateColumnFooter(
          //         rendererContext: rc, //
          //         format: "#,##0.00", //
          //         alignment: Alignment.centerRight,
          //         padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          //         type: PlutoAggregateColumnType.sum,
          //         titleSpanBuilder: (value) {
          //           return [
          //             WidgetSpan(
          //               child: Text(
          //                 "$value \$", //
          //                 style: TextStyle(
          //                   fontSize: 14, //
          //                   fontWeight: FontWeight.bold,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ),
          //           ];
          //         },
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "mini_bar_bank", //
          //     title: "Bank",
          //     type: PlutoColumnType.number(
          //       //   negative: false, //
          //       format: "#,##0.00",
          //     ),
          //     // enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 2) + " \$", //
          //           overflow: TextOverflow.ellipsis,
          //           style: TextStyle(
          //             color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
          //           ),
          //         ),
          //       );
          //     },
          //     footerRenderer: (rc) {
          //       return PlutoAggregateColumnFooter(
          //         rendererContext: rc, //
          //         format: "#,##0.00", //
          //         alignment: Alignment.centerRight,
          //         padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          //         type: PlutoAggregateColumnType.sum,
          //         titleSpanBuilder: (value) {
          //           return [
          //             WidgetSpan(
          //               child: Text(
          //                 "$value \$", //
          //                 style: TextStyle(
          //                   fontSize: 14, //
          //                   fontWeight: FontWeight.bold,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ),
          //           ];
          //         },
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "mini_bar_paid", //
          //     title: "Paid",
          //     type: PlutoColumnType.number(
          //       negative: false, //
          //       format: "#,##0.00",
          //     ),
          //     enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 2) + " \$", //
          //           overflow: TextOverflow.ellipsis,
          //           style: TextStyle(
          //             color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
          //           ),
          //         ),
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "mini_bar_note", //
          //     title: "Note",
          //     type: PlutoColumnType.text(),
          //     // enableEditingMode: false,
          //     width: 120,
          //     renderer: (rc) {
          //       return Row(
          //         children: [
          //           Expanded(
          //             child: Align(
          //               alignment: Alignment.centerLeft, //
          //               child: Text(
          //                 format_string(rc.cell.value), //
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ),
          //           ),

          //           //   IconButton(
          //           //     tooltip: "Search", //
          //           //     icon: Icon(Icons.search_outlined),
          //           //     padding: EdgeInsets.all(0),
          //           //     constraints: BoxConstraints(),
          //           //     onPressed: () {
          //           //       print("Search: ${rc.row.cells["index"]?.value}");
          //           //     }, //
          //           //   ),
          //         ],
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "penalty_item", //
          //     title: "Items",
          //     type: PlutoColumnType.text(),
          //     enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Row(
          //         mainAxisAlignment: MainAxisAlignment.center, //
          //         children: [
          //           IconButton(
          //             tooltip: "Update Penalty Items", //
          //             icon: Icon(Icons.gavel_outlined),
          //             padding: EdgeInsets.all(0),
          //             constraints: BoxConstraints(),
          //             onPressed: () {
          //               print("Update Penalty Items: ${rc.row.cells["index"]?.value}");
          //             }, //
          //           ),
          //         ],
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "penalty_price", //
          //     title: "Price",
          //     type: PlutoColumnType.number(
          //       negative: false, //
          //       format: "#,##0.00",
          //     ),
          //     enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 2) + " \$", //
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       );
          //     },
          //     footerRenderer: (rc) {
          //       return PlutoAggregateColumnFooter(
          //         rendererContext: rc, //
          //         format: "#,##0.00", //
          //         alignment: Alignment.centerRight,
          //         padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          //         type: PlutoAggregateColumnType.sum,
          //         titleSpanBuilder: (value) {
          //           return [
          //             WidgetSpan(
          //               child: Text(
          //                 "$value \$", //
          //                 style: TextStyle(
          //                   fontSize: 14, //
          //                   fontWeight: FontWeight.bold,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ),
          //           ];
          //         },
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "penalty_cash", //
          //     title: "Cash",
          //     type: PlutoColumnType.number(
          //       //   negative: false, //
          //       format: "#,##0.00",
          //     ),
          //     // enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 2) + " \$", //
          //           overflow: TextOverflow.ellipsis,
          //           style: TextStyle(
          //             color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
          //           ),
          //         ),
          //       );
          //     },
          //     footerRenderer: (rc) {
          //       return PlutoAggregateColumnFooter(
          //         rendererContext: rc, //
          //         format: "#,##0.00", //
          //         alignment: Alignment.centerRight,
          //         padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          //         type: PlutoAggregateColumnType.sum,
          //         titleSpanBuilder: (value) {
          //           return [
          //             WidgetSpan(
          //               child: Text(
          //                 "$value \$", //
          //                 style: TextStyle(
          //                   fontSize: 14, //
          //                   fontWeight: FontWeight.bold,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ),
          //           ];
          //         },
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "penalty_bank", //
          //     title: "Bank",
          //     type: PlutoColumnType.number(
          //       //   negative: false, //
          //       format: "#,##0.00",
          //     ),
          //     // enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 2) + " \$", //
          //           overflow: TextOverflow.ellipsis,
          //           style: TextStyle(
          //             color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
          //           ),
          //         ),
          //       );
          //     },
          //     footerRenderer: (rc) {
          //       return PlutoAggregateColumnFooter(
          //         rendererContext: rc, //
          //         format: "#,##0.00", //
          //         alignment: Alignment.centerRight,
          //         padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          //         type: PlutoAggregateColumnType.sum,
          //         titleSpanBuilder: (value) {
          //           return [
          //             WidgetSpan(
          //               child: Text(
          //                 "$value \$", //
          //                 style: TextStyle(
          //                   fontSize: 14, //
          //                   fontWeight: FontWeight.bold,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ),
          //           ];
          //         },
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "penalty_paid", //
          //     title: "Paid",
          //     type: PlutoColumnType.number(
          //       negative: false, //
          //       format: "#,##0.00",
          //     ),
          //     enableEditingMode: false,
          //     width: 80,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerRight, //
          //         child: Text(
          //           format_double(rc.cell.value, digits: 2) + " \$", //
          //           overflow: TextOverflow.ellipsis,
          //           style: TextStyle(
          //             color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
          //           ),
          //         ),
          //       );
          //     },
          //   ),

          //   PlutoColumn(
          //     field: "penalty_note", //
          //     title: "Note",
          //     type: PlutoColumnType.text(),
          //     // enableEditingMode: false,
          //     width: 120,
          //     renderer: (rc) {
          //       return Row(
          //         children: [
          //           Expanded(
          //             child: Align(
          //               alignment: Alignment.centerLeft, //
          //               child: Text(
          //                 format_string(rc.cell.value), //
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ),
          //           ),

          //           //   IconButton(
          //           //     tooltip: "Search", //
          //           //     icon: Icon(Icons.search_outlined),
          //           //     padding: EdgeInsets.all(0),
          //           //     constraints: BoxConstraints(),
          //           //     onPressed: () {
          //           //       print("Search: ${rc.row.cells["index"]?.value}");
          //           //     }, //
          //           //   ),
          //         ],
          //       );
          //     },
          //   ),
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

          PlutoColumn(
            field: "clean_by", //
            title: "Clean By",
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
            fields: ["check_in_number", "check_in_duration", "check_in_at", "check_out_at", "clean_at"],
          ),
          PlutoColumnGroup(
            title: "Room Payment", //
            fields: ["room_price", "room_cash", "room_bank", "room_paid", "room_note"],
          ),
          PlutoColumnGroup(
            title: "Mini Bar Payment", //
            fields: ["mini_bar_item", "mini_bar_price", "mini_bar_cash", "mini_bar_bank", "mini_bar_paid", "mini_bar_note"],
          ),
          PlutoColumnGroup(
            title: "Penalty Payment", //
            fields: ["penalty_item", "penalty_price", "penalty_cash", "penalty_bank", "penalty_paid", "penalty_note"],
          ),
          PlutoColumnGroup(
            title: "Person In Charge", //
            fields: ["check_in_by", "check_out_by", "clean_by"],
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

      //
      footer: [
        //
        Text(
          "Total Revenue: xxx\$", //
          style: TextStyle(
            fontSize: 16, //
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(width: 8), //
        //
        Text(
          "Total Income: xxx\$", //
          style: TextStyle(
            fontSize: 16, //
            fontWeight: FontWeight.bold,
          ),
        ),

        // const Spacer(),

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
          onPressed: () {
            dt = dt.subtract(Duration(days: 1));
            setState(() {});
          },
        ),

        TextButton(
          child: Text(
            DateFormat("yyyy-MM-dd").format(dt), //
            style: TextStyle(
              fontSize: 16, //
              fontWeight: FontWeight.bold, //
            ),
          ),
          onPressed: () {}, // TODO: open date picker
        ),

        IconButton(
          tooltip: "Next", //
          icon: Icon(Icons.navigate_next, size: 32), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {
            dt = dt.add(Duration(days: 1));
            setState(() {});
          },
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
