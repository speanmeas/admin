import "dart:async";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
// import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/dialog/dialog_datetime.dart";
// import "package:speanmeas/core/utility/gen_data.dart";

// import "form/check_in.dart" as check_in;
import "dialog/check_in.dart";
import "dialog/check_out.dart";
import "dialog/clean.dart";
import "dialog/search_guest.dart";
// import "form/check_out.dart" as check_out;
// import "form/clean.dart" as clean;
// import "dialog/check_in.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  int reload = 0; // this variable is used to reload the PlutoGrid when the data changes
  bool is_load = false; // this variable is used to guard the fast clicking of the buttons, to prevent multiple requests to the server
  double WIDTH = 120;

  late List<String> list_column;
  late PlutoGridStateManager state_manager;

  //   DateTime dt = DateTime.now();
  DateTime date = DateTime.now();

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

  Future<void> init() async {
    dynamic tmp_r = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
    if (tmp_r == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    rooms = tmp_r.data as List<dynamic>? ?? [];

    dynamic tmp_fd = await dio.post(
      endpoint.FRONT_DESK_READ,
      data: {
        "key": Front_Desk.CREATED_AT, //
        "order": 1, //
        "link": true, //
      },
    );
    if (tmp_fd == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    front_desks = (tmp_fd.data as List<dynamic>? ?? []).map<Front_Desk>((e) => Front_Desk.fromJson(e)).toList();
    // pprint(front_desks);

    update_grid();

    setState(() {});
  }

  // * accessors for Front_Desk linked/expanded fields
  Room? fd_room(Front_Desk fd) => fd.room_id is Room ? fd.room_id as Room : null;
  Guest? fd_guest(Front_Desk fd) => fd.guest_id is Guest ? fd.guest_id as Guest : null;

  void update_grid() {
    //
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, fd) in front_desks.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column) //
              c: (() {
                if (c == "_id") //
                  return PlutoCell(value: fd.id ?? "");
                if (c == "index") //
                  return PlutoCell(value: i + 1);
                if (c == "room") //
                  return PlutoCell(value: fd_room(fd)?.number ?? "");

                if (c == "guest_name") //
                  return PlutoCell(value: fd_guest(fd)?.full_name ?? "");
                if (c == "guest_phone") //
                  return PlutoCell(value: fd_guest(fd)?.phone_number ?? "");

                if (c == "check_in_people") //
                  return PlutoCell(value: fd.number_of_guest ?? 0);

                if (c == "check_in_at") //
                  return PlutoCell(value: fd.check_in_at);

                if (c == "check_in_duration") {
                  DateTime? in_at = fd.check_in_at;
                  DateTime? out_at = fd.check_out_at;
                  if (in_at == null) return PlutoCell(value: 0);
                  if (out_at == null) return PlutoCell(value: DateTime.now().difference(in_at).inMinutes);
                  return PlutoCell(value: out_at.difference(in_at).inMinutes);
                }

                if (c == "check_out_at") //
                  return PlutoCell(value: fd.check_out_at);

                // * room payment fields are inline on the stay (no Room_Pay child array)
                if (c == "room_price") return PlutoCell(value: fd.room_price);
                if (c == "room_cash") return PlutoCell(value: fd.room_cash);
                if (c == "room_bank") return PlutoCell(value: fd.room_bank);
                if (c == "room_balance") return PlutoCell(value: fd.room_balance);

                if (c == "check_in_by") {
                  dynamic u = fd.check_in_by;
                  return PlutoCell(value: u is User_Show ? u.full_name : (u ?? ""));
                }
                if (c == "check_out_by") {
                  dynamic u = fd.check_out_by;
                  return PlutoCell(value: u is User_Show ? u.full_name : (u ?? ""));
                }

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
    // todo: sync to server, don't reinit.
    pprint("Old: ${e.oldValue} | New: ${e.value} | Row: ${e.row.cells["_id"]?.value} | Column: ${e.column.field}");
    final fd_id = e.row.cells["_id"]?.value;
    if (fd_id == null) return;

    if (e.column.field == "guest_name") {
      dynamic tmp_fd = await dio.post(
        endpoint.FRONT_DESK_UPDATE_GUEST,
        data: {
          Front_Desk.ID: fd_id, //
          Guest.FULL_NAME: e.value, //
        },
      );
      if (tmp_fd == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    if (e.column.field == "guest_phone") {
      dynamic tmp_fd = await dio.post(
        endpoint.FRONT_DESK_UPDATE_GUEST,
        data: {
          Front_Desk.ID: fd_id, //
          Guest.PHONE_NUMBER: e.value, //
        },
      );
      if (tmp_fd == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    if (e.column.field == "check_in_people") {
      dynamic tmp_fdn = await dio.post(
        endpoint.FRONT_DESK_UPDATE,
        data: {
          Front_Desk.ID: fd_id, //
          Front_Desk.NUMBER_OF_GUEST: int.tryParse(e.value?.toString() ?? ""), //
        },
      );
      if (tmp_fdn == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    if (e.column.field == "room_price") {
      dynamic tmp_fdn = await dio.post(
        endpoint.FRONT_DESK_ROOM_PAY_UPDATE,
        data: {
          Front_Desk.ID: fd_id, //
          Front_Desk.ROOM_PRICE: num.tryParse(e.value?.toString() ?? "")?.toDouble(), //
        },
      );
      if (tmp_fdn == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    if (e.column.field == "room_cash") {
      dynamic tmp_fdn = await dio.post(
        endpoint.FRONT_DESK_ROOM_PAY_UPDATE,
        data: {
          Front_Desk.ID: fd_id, //
          Front_Desk.ROOM_CASH: num.tryParse(e.value?.toString() ?? "")?.toDouble(), //
        },
      );
      if (tmp_fdn == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    if (e.column.field == "room_bank") {
      dynamic tmp_fdn = await dio.post(
        endpoint.FRONT_DESK_ROOM_PAY_UPDATE,
        data: {
          Front_Desk.ID: fd_id, //
          Front_Desk.ROOM_BANK: num.tryParse(e.value?.toString() ?? "")?.toDouble(), //
        },
      );
      if (tmp_fdn == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    init();
  }

  void on_check_in(dynamic r) async {
    var v = await dialog_check_in(
      context: context, //
      lead: "Room ${r[Room.NUMBER]}", //
      room_id: r[Room.ID], //
      price_per_day: r[Room.PRICE_PER_DAY], //
    );
    if (v == null) return;
    init();
  }

  void on_check_out(dynamic r) async {
    var v = await dialog_check_out(
      context: context, //
      lead: "Room ${r[Room.NUMBER]}", //
      front_desk_id: r[Room.FRONT_DESK_ID], //
      room_id: r[Room.ID], //
    );
    if (v == null) return;

    init();
  }

  void on_clean(dynamic r) async {
    var v = await dialog_clean(
      context: context, //
      lead: "Room ${r[Room.NUMBER]}", //
      front_desk_id: r[Room.FRONT_DESK_ID], //
      room_id: r[Room.ID], //
    );
    if (v == null) return;
    init();
  }

  Future<void> pick_datetime(PlutoColumnRendererContext rc, {required bool is_check_in}) async {
    String? fd_id = rc.row.cells["_id"]?.value;
    if (fd_id == null) return;

    DateTime? current = parse_datetime(rc.cell.value) ?? DateTime.now();

    final DateTime? picked_datetime = await dialog_datetime(context, initial: current);
    if (picked_datetime == null || !mounted) return;

    String key = is_check_in ? Front_Desk.CHECK_IN_AT : Front_Desk.CHECK_OUT_AT;
    dynamic tmp = await dio.post(
      endpoint.FRONT_DESK_UPDATE,
      data: {
        Front_Desk.ID: fd_id, //
        key: format_datetime(picked_datetime), //
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    init();
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
            onPressed: () => on_check_in(r), //
          ),
      ],

      //
      check_out: [
        for (var r in rooms.where((r) => r[Room.STATUS] == "Occupied"))
          OutlinedButton.icon(
            icon: Icon(Icons.hotel_outlined), //
            label: Text("${r[Room.NUMBER]}"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => on_check_out(r), //
          ),
      ],

      //
      clean: [
        for (var r in rooms.where((r) => r[Room.STATUS] == "Dirty"))
          OutlinedButton.icon(
            icon: Icon(Icons.hotel_outlined), //
            label: Text("${r[Room.NUMBER]}"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
            onPressed: () => on_clean(r), //
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
            // hide: !kDebugMode,
            // hide: true,
            width: 0,
          ),

          PlutoColumn(
            field: "index", //
            title: "ល.រ.",
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
            title: "បន្ទប់",
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
            title: "ឈ្មោះ",
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
            title: "លេខទូរស័ព្ទ",
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
                ],
              );
            },
          ),

          PlutoColumn(
            field: "guest_search", //
            title: "",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            enableContextMenu: false,
            enableDropToResize: false,
            enableColumnDrag: false,
            enableSorting: false,
            enableFilterMenuItem: false,

            width: 40,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "Search Guest", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () async {
                      //   print("Search Guest: ${rc.row.cells["index"]?.value}");
                      var v = await dialog_search_guest(
                        context: context, //
                        front_desk_id: rc.row.cells["_id"]?.value,
                      );
                      if (v == null) return;
                      init();
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "check_in_people", //
            title: "ចំនួន",
            type: PlutoColumnType.number(negative: false, format: "#,###"),
            width: 60,
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
            title: "ពេលចូល",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
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
                    tooltip: "កែពេលចូល", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => pick_datetime(rc, is_check_in: true), //
                  ),
                ],
              );
            },
          ),

          // auto calculate
          PlutoColumn(
            field: "check_in_duration", //
            title: "រយៈពេល",
            type: PlutoColumnType.number(negative: false, format: "#,###"),
            enableEditingMode: false,
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
            title: "ពេលចេញ",
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
                    tooltip: "កែពេលចេញ", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => pick_datetime(rc, is_check_in: false), //
                  ),
                ],
              );
            },
          ),

          //   PlutoColumn(
          //     field: "clean_at", //
          //     title: "Clean At",
          //     enableEditingMode: false,
          //     type: PlutoColumnType.text(),
          //     width: 160,
          //     renderer: (rc) {
          //       return Row(
          //         children: [
          //           Expanded(
          //             child: Align(
          //               alignment: Alignment.center, //
          //               child: Text(
          //                 format_datetime(rc.cell.value), //
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ),
          //           ),

          //           if (rc.cell.value != null)
          //             IconButton(
          //               tooltip: "Update Clean", //
          //               icon: Icon(Icons.calendar_month_outlined),
          //               padding: EdgeInsets.all(0),
          //               constraints: BoxConstraints(),
          //               onPressed: () async {
          //                 DateTime? result = await dialog_datetime(context, initial: rc.cell.value);
          //                 pprint(result);
          //               }, //
          //             ),
          //         ],
          //       );
          //     },
          //   ),
          PlutoColumn(
            field: "room_price", //
            title: "តម្លៃ",
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
            title: "លុយ",
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
            title: "ធនាគារ",
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
            field: "room_balance", //
            title: "សមតុល្យ",
            type: PlutoColumnType.number(
              negative: true, //
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
            title: "ចំណាំ",
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
          //     title: "ទំនិញ",
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
          //     title: "តម្លៃ",
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
          //     title: "លុយ",
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
          //     title: "ធនាគារ",
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
          //     title: "បានបង់",
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
          //     title: "ចំណាំ",
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
            title: "ឲចូលដោយ",
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
            title: "ឲចេញដោយ",
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

          //   PlutoColumn(
          //     field: "clean_by", //
          //     title: "Clean By",
          //     type: PlutoColumnType.text(),
          //     enableEditingMode: false,
          //     width: 140,
          //     renderer: (rc) {
          //       return Align(
          //         alignment: Alignment.centerLeft, //
          //         child: Text(
          //           format_string(rc.cell.value), //
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       );
          //     },
          //   ),

          // BUTTON RECEIPT
          PlutoColumn(
            field: "other", //
            title: "ផ្សេងៗ",
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
            title: "អតិថិជន", //
            fields: ["guest_name", "guest_phone", "guest_search"],
          ),
          PlutoColumnGroup(
            title: "ការស្នាក់នៅ", //
            fields: ["check_in_people", "check_in_duration", "check_in_at", "check_out_at", "clean_at"],
          ),
          PlutoColumnGroup(
            title: "ការបង់ប្រាក់ បន្ទប់", //
            fields: ["room_price", "room_cash", "room_bank", "room_balance", "room_note"],
          ),
          PlutoColumnGroup(
            title: "ការបង់ប្រាក់ មីនីបារ", //
            fields: ["mini_bar_item", "mini_bar_price", "mini_bar_cash", "mini_bar_bank", "mini_bar_paid", "mini_bar_note"],
          ),
          PlutoColumnGroup(
            title: "Penalty Payment", //
            fields: ["penalty_item", "penalty_price", "penalty_cash", "penalty_bank", "penalty_paid", "penalty_note"],
          ),
          PlutoColumnGroup(
            title: "ការត្រួតពិនិត្យ", //
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
        // //
        // Text(
        //   "Total Revenue: xxx\$", //
        //   style: TextStyle(
        //     fontSize: 16, //
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),

        // SizedBox(width: 8), //
        // //
        // Text(
        //   "Total Income: xxx\$", //
        //   style: TextStyle(
        //     fontSize: 16, //
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),

        // // const Spacer(),

        // // * ប៊ូតុងបញ្ចេញជា PDF
        // Tooltip(
        //   message: "Export as PDF",
        //   child: InkWell(
        //     onTap: () {
        //       snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
        //     },
        //     child: Container(
        //       width: 32,
        //       height: 32,
        //       alignment: Alignment.center,
        //       child: SvgPicture.asset(
        //         "assets/icon/pdf.svg", //
        //         width: 30,
        //         height: 30,
        //         colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
        //       ),
        //     ),
        //   ),
        // ),

        // // * ប៊ូតុងបញ្ចេញជា Excel
        // Tooltip(
        //   message: "Export as Excel",
        //   child: InkWell(
        //     onTap: () {
        //       snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
        //     },
        //     child: Container(
        //       width: 32,
        //       height: 32,
        //       alignment: Alignment.center,
        //       child: SvgPicture.asset(
        //         "assets/icon/excel.svg", //
        //         width: 30,
        //         height: 30,
        //         colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
        //       ),
        //     ),
        //   ),
        // ),
        Spacer(), //

        IconButton(
          tooltip: "Previous", //
          icon: Icon(Icons.navigate_before, size: 32), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {
            date = date.subtract(Duration(days: 1));
            setState(() {});
          },
        ),

        TextButton(
          child: Text(
            DateFormat("yyyy-MM-dd").format(date), //
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
            date = date.add(Duration(days: 1));
            setState(() {});
          },
        ),

        Spacer(), //

        OutlinedButton.icon(
          icon: Icon(Icons.restart_alt), //
          label: Text("Rollover"), //
          onPressed: () {
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

void main() {
  runApp(
    MaterialApp(
      home: const Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
