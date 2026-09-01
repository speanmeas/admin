import "dart:async";

import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/dialog/dialog_datetime.dart";

import "dialog/check_in.dart";
import "dialog/cancel.dart";
import "dialog/change_room.dart";
import "dialog/list_mini_bar.dart";
import "dialog/list_penalty.dart";
import "dialog/search_guest.dart";

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

  // * ########## BLOCK DESIGN ##########
  Widget _layout({
    List<Widget>? check_in, //
    List<Widget>? check_out, //
    List<Widget>? clean, //
    List<Widget>? header, //
    Widget? body, //
    List<Widget>? footer, //
  }) {
    return Scaffold(
      body: Column(
        spacing: 1,
        children: [
          if (check_in != null)
            Container(
              alignment: Alignment.centerLeft, //
              padding: const EdgeInsets.all(1),
              child: Wrap(
                spacing: 1, //
                runSpacing: 1,
                children: check_in,
              ),
            ),

          if (check_out != null)
            Container(
              alignment: Alignment.centerLeft, //
              padding: const EdgeInsets.all(1),
              child: Wrap(
                spacing: 1, //
                runSpacing: 1,
                children: check_out,
              ),
            ),

          if (clean != null)
            Container(
              alignment: Alignment.centerLeft, //
              padding: const EdgeInsets.all(1),
              child: Wrap(
                spacing: 1, //
                runSpacing: 1,
                children: [...clean],
              ),
            ),

          if (header != null)
            Container(
              height: 34, //
              padding: const EdgeInsets.all(1),
              child: Row(
                spacing: 2, //
                children: header,
              ),
            ),

          if (is_load) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: body ?? Container()),

          if (footer != null)
            Container(
              height: 34, //
              padding: const EdgeInsets.all(1),
              child: Row(
                spacing: 2, //
                children: footer,
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
        for (var r in rooms.where((r) => r[Room.STATUS] == "Available" && !is_walk_in_room(r)))
          Tooltip(
            message: "Check-in ${r[Room.NUMBER]}",
            child: OutlinedButton.icon(
              icon: Icon(Icons.bed_outlined), //
              label: Text("${r[Room.NUMBER]}"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () => on_check_in(r), //
            ),
          ),
      ],

      check_out: [
        for (var r in rooms.where((r) => r[Room.STATUS] == "Occupied"))
          Tooltip(
            message: "Check-out ${r[Room.NUMBER]}",
            child: OutlinedButton.icon(
              icon: Icon(Icons.hotel_outlined), //
              label: Text("${r[Room.NUMBER]}"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => on_check_out(r), //
            ),
          ),
      ],

      clean: [
        for (var r in rooms.where((r) => r[Room.STATUS] == "Dirty"))
          Tooltip(
            message: "Clean ${r[Room.NUMBER]}",
            child: OutlinedButton.icon(
              icon: Icon(Icons.cleaning_services_outlined), //
              label: Text("${r[Room.NUMBER]}"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () => on_clean(r), //
            ),
          ),
      ],

      header: [
        // * toggle mini bar column
        Menu_Button_Icon(
          tip: hide_mini_bar ? "Show Mini Bar" : "Hide Mini Bar", //
          icon: Icons.local_bar_outlined,
          onPressed: () {
            hide_mini_bar = !hide_mini_bar;
            reload++;
            // * PlutoGrid មិនអាន hide attribute ក្នុង didUpdateWidget ដូច្នេះត្រូវ rebuild តាម key
            setState(() {});
          },
        ),

        // * toggle penalty column
        Menu_Button_Icon(
          tip: hide_penalty ? "Show Penalty" : "Hide Penalty", //
          icon: Icons.gavel_outlined,
          onPressed: () {
            hide_penalty = !hide_penalty;
            reload++;
            // * PlutoGrid មិនអាន hide attribute ក្នុង didUpdateWidget ដូច្នេះត្រូវ rebuild តាម key
            setState(() {});
          },
        ),

        const Spacer(),

        // * ប៊ូតុងបើក/បិទ filter
        Menu_Button_Icon(
          tip: is_filter ? "Close Filter" : "Open Filter", //
          icon: is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined,
          onPressed: () {
            is_filter = !is_filter;
            state_manager.setShowColumnFilter(is_filter);
            if (!is_filter) state_manager.setFilterWithFilterRows([]);
            setState(() {});
          },
        ),
        Menu_Button_Icon(
          tip: "Refresh", //
          icon: Icons.refresh,
          onPressed: () {
            reload++;
            // * rebuild grid តាម key ដើម្បីផ្ទុកទិន្នន័យឡើងវិញពេញលេញ
            setState(() {});
          }, //
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

                  if (!row_is_walk_in(rc))
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
                      alignment: Alignment.centerLeft, //
                      child: Text(
                        format_datetime(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  if (!is_checked_out(rc) && !row_is_walk_in(rc))
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
                      alignment: Alignment.centerLeft, //
                      child: Text(
                        format_datetime(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

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
            // enableEditingMode: true,
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
                    color: rc.cell.value == 0
                        ? Colors.black
                        : rc.cell.value > 0
                        ? Colors.green
                        : Colors.red, //
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
                ],
              );
            },
          ),

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

          // BUTTON RECEIPT
          PlutoColumn(
            field: "other", //
            title: "ផ្សេងៗ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end, //
                children: [
                  //
                  if (!is_checked_out(rc) && !row_is_walk_in(rc))
                    IconButton(
                      tooltip: "Change Room", //
                      icon: Icon(Icons.swap_horiz_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_change_room(rc), //
                    ),

                  //
                  if (!is_checked_out(rc) && !row_is_walk_in(rc))
                    IconButton(
                      tooltip: "Cancel", //
                      icon: Icon(Icons.cancel_outlined, color: Colors.red),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_cancel(rc), //
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
            fields: ["mini_bar_item", "mini_bar_price", "mini_bar_cash", "mini_bar_bank", "mini_bar_balance", "mini_bar_note"],
          ),
          PlutoColumnGroup(
            title: "ការពិន័យ", //
            fields: ["penalty_item", "penalty_price", "penalty_cash", "penalty_bank", "penalty_balance", "penalty_note"],
          ),
          PlutoColumnGroup(
            title: "ការត្រួតពិនិត្យ", //
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
    );
  }

  // * ########## BLOCK DESIGN END ##########

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

    // * អានសម្រាប់តែថ្ងៃ shift ថ្ងៃនេះ (boundary 7:00)
    dynamic tmp_fd = await dio.post(
      endpoint.FRONT_DESK_READ_DATETIME,
      data: {
        "key": Front_Desk.CREATED_AT, //
        "start": shift_start(), //
        "stop": shift_stop(), //
        "order": 1, //
        "link": true, //
      },
    );
    if (tmp_fd == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    front_desks = (tmp_fd.data as List<dynamic>? ?? []).map<Front_Desk>((e) => Front_Desk.fromJson(e)).toList();

    update_grid();

    setState(() {});
  }

  // * ដើមថ្ងៃ shift ថ្ងៃនេះ (boundary 7:00) → ISO
  String shift_start() {
    final now_dt = DateTime.now();
    DateTime shift_day = now_dt.hour < 7 ? now_dt.subtract(const Duration(days: 1)) : now_dt;
    return DateTime(shift_day.year, shift_day.month, shift_day.day, 7, 0).toIso8601String();
  }

  // * ចុងថ្ងៃ shift ថ្ងៃនេះ (ថ្ងៃស្អែក 7:00) → ISO
  String shift_stop() {
    final now_dt = DateTime.now();
    DateTime shift_day = now_dt.hour < 7 ? now_dt.subtract(const Duration(days: 1)) : now_dt;
    return DateTime(shift_day.year, shift_day.month, shift_day.day, 7, 0).add(const Duration(days: 1)).toIso8601String();
  }

  // * accessors for Front_Desk linked/expanded fields
  Room? fd_room(Front_Desk fd) => fd.room_id is Room ? fd.room_id as Room : null;
  Guest? fd_guest(Front_Desk fd) => fd.guest_id is Guest ? fd.guest_id as Guest : null;

  // * ពិនិត្យថា room ជា Walk-In (លក់ minibar តែប៉ុណ្ណោះ)
  bool is_walk_in_room(dynamic r) {
    String? number = r[Room.NUMBER]?.toString().toLowerCase();
    return number == "walk-in";
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
                if (c == "room_note") return PlutoCell(value: fd.room_note ?? "");

                // * mini bar payment fields are inline on the stay (no Mini_Bar_Pay child array)
                if (c == "mini_bar_price") return PlutoCell(value: fd.mini_bar_price);
                if (c == "mini_bar_cash") return PlutoCell(value: fd.mini_bar_cash);
                if (c == "mini_bar_bank") return PlutoCell(value: fd.mini_bar_bank);
                if (c == "mini_bar_balance") return PlutoCell(value: fd.mini_bar_balance);
                if (c == "mini_bar_note") return PlutoCell(value: fd.mini_bar_note ?? "");

                // * penalty payment fields are inline on the stay (no Penalty_Pay child array)
                if (c == "penalty_price") return PlutoCell(value: fd.penalty_price);
                if (c == "penalty_cash") return PlutoCell(value: fd.penalty_cash);
                if (c == "penalty_bank") return PlutoCell(value: fd.penalty_bank);
                if (c == "penalty_balance") return PlutoCell(value: fd.penalty_balance);
                if (c == "penalty_note") return PlutoCell(value: fd.penalty_note ?? "");

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
    state_manager.setAutoEditing(true);
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

    // * Walk-In: row នេះប្រើសម្រាប់ភ្ញៀវ walk-in ទិញ minibar តែប៉ុណ្ណោះ
    // * — មិនអនុញ្ញាតឲ្យកែឈ្មោះ/លេខទូរស័ព្ទភ្ញៀវ ឬផ្នែកផ្សេងទៀតទេ (កែបានតែលុយ/ធនាគារ minibar)
    bool is_walkin_row = false;
    {
      Front_Desk? walk_fd = front_desks.where((x) => x.id == fd_id).firstOrNull;
      Room? walk_room = walk_fd == null ? null : fd_room(walk_fd);
      is_walkin_row = walk_room != null && (walk_room.number ?? "").toLowerCase() == "walk-in";
      if (is_walkin_row && e.column.field != "mini_bar_cash" && e.column.field != "mini_bar_bank") {
        e.row.cells[e.column.field]!.value = e.oldValue;
        return;
      }
    }

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

    if (e.column.field == "mini_bar_price") {
      dynamic tmp_fdn = await dio.post(
        endpoint.FRONT_DESK_MINI_BAR_ITEM,
        data: {
          Front_Desk.ID: fd_id, //
        },
      );
      if (tmp_fdn == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    if (e.column.field == "mini_bar_cash" || e.column.field == "mini_bar_bank") {
      String key = e.column.field == "mini_bar_cash" ? Front_Desk.MINI_BAR_CASH : Front_Desk.MINI_BAR_BANK;
      dynamic tmp_fdn = await dio.post(
        is_walkin_row ? endpoint.FRONT_DESK_WALK_IN_UPDATE : endpoint.FRONT_DESK_MINI_BAR_PAY,
        data: {
          Front_Desk.ID: fd_id, //
          key: num.tryParse(e.value?.toString() ?? "")?.toDouble(), //
        },
      );
      if (tmp_fdn == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    if (e.column.field == "penalty_price") {
      dynamic tmp_fdn = await dio.post(
        endpoint.FRONT_DESK_PENALTY_ITEM,
        data: {
          Front_Desk.ID: fd_id, //
        },
      );
      if (tmp_fdn == null) snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    if (e.column.field == "penalty_cash" || e.column.field == "penalty_bank") {
      String key = e.column.field == "penalty_cash" ? Front_Desk.PENALTY_CASH : Front_Desk.PENALTY_BANK;
      dynamic tmp_fdn = await dio.post(
        endpoint.FRONT_DESK_PENALTY_PAY,
        data: {
          Front_Desk.ID: fd_id, //
          key: num.tryParse(e.value?.toString() ?? "")?.toDouble(), //
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
      price_per_day: r[Room.PRICE_PER_DAY] ?? 0, //
    );
    if (v == null) return;
    init();
  }

  void on_check_out(dynamic r) async {
    String? fd_id = r[Room.FRONT_DESK_ID];
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to check out", cl: Colors.red);

    dynamic tmp = await dio.post(
      endpoint.FRONT_DESK_CHECK_OUT,
      data: {
        Front_Desk.ID: fd_id, //
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Checked Out", cl: Colors.green);
    init();
  }

  void on_clean(dynamic r) async {
    dynamic tmp = await dio.post(
      endpoint.FRONT_DESK_CLEAN,
      data: {
        Front_Desk.ROOM_ID: r[Room.ID], //
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Cleaned", cl: Colors.green);
    init();
  }

  // * បញ្ជាការកែប្រែ និងការបោះបង់ពីជួរ grid (action រស់នៅក្នុង method មិននៅក្នុង UI)
  String? row_stay_id(PlutoColumnRendererContext rc) => rc.row.cells["_id"]?.value;

  Front_Desk? row_stay(PlutoColumnRendererContext rc) {
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return null;
    return front_desks.where((x) => x.id == fd_id).firstOrNull;
  }

  // * ប្រមូល id ទំនិញដែលបានចុះពីថ្ងៃមុនៗ (locked) តាមខ្សែសង្វាក់ prev_front_desk_id
  Set<String> locked_mini_bar_ids(Front_Desk fd) {
    Set<String> ids = {};
    String? cursor = fd.prev_front_desk_id;
    while (cursor != null) {
      Front_Desk? prev = front_desks.where((x) => x.id == cursor).firstOrNull;
      if (prev == null) break;
      for (var it in (prev.list_mini_bar_item_id ?? [])) {
        if (it is Mini_Bar_Item && it.id != null) ids.add(it.id!);
      }
      cursor = prev.prev_front_desk_id;
    }
    return ids;
  }

  Set<String> locked_penalty_ids(Front_Desk fd) {
    Set<String> ids = {};
    String? cursor = fd.prev_front_desk_id;
    while (cursor != null) {
      Front_Desk? prev = front_desks.where((x) => x.id == cursor).firstOrNull;
      if (prev == null) break;
      for (var it in (prev.list_penalty_item_id ?? [])) {
        if (it is Penalty_Item && it.id != null) ids.add(it.id!);
      }
      cursor = prev.prev_front_desk_id;
    }
    return ids;
  }

  // * ហាមប្រើប្រាស់ ប្រសិនបើបាន check out រួចហើយ
  bool checkout_guard(PlutoColumnRendererContext rc) {
    Front_Desk? fd = row_stay(rc);
    if (fd?.check_out_at != null) {
      snackbar(ct: context, ms: "Already checked out", cl: Colors.red);
      return true;
    }
    return false;
  }

  // * ពិនិត្យថា stay បាន check out រួចហើយឬនៅ (សម្រាប់លាក់ប៊ូតុង)
  bool is_checked_out(PlutoColumnRendererContext rc) => row_stay(rc)?.check_out_at != null;

  // * ពិនិត្យថា stay ជា Walk-In (លក់ minibar តែប៉ុណ្ណោះ)
  bool row_is_walk_in(PlutoColumnRendererContext rc) {
    Front_Desk? fd = row_stay(rc);
    Room? room = fd == null ? null : fd_room(fd);
    return room != null && (room.number ?? "").toLowerCase() == "walk-in";
  }

  void on_cancel(PlutoColumnRendererContext rc) async {
    if (checkout_guard(rc)) return;
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to cancel", cl: Colors.red);

    var v = await dialog_cancel(
      context: context, //
      lead: "Room ${rc.row.cells["room"]?.value}", //
      front_desk_id: fd_id, //
    );
    if (v == null) return;
    init();
  }

  void on_change_room(PlutoColumnRendererContext rc) async {
    if (checkout_guard(rc)) return;
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to change room", cl: Colors.red);

    var v = await dialog_change_room(
      context: context, //
      lead: "Room ${rc.row.cells["room"]?.value}", //
      front_desk_id: fd_id, //
      rooms: rooms.where((r) => r[Room.STATUS] == "Available").toList(), //
    );
    if (v == null) return;
    init();
  }

  void on_penalty_item(PlutoColumnRendererContext rc) async {
    if (checkout_guard(rc)) return;
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update penalty", cl: Colors.red);

    Front_Desk? fd = front_desks.where((x) => x.id == fd_id).firstOrNull;

    dynamic tmp_p = await dio.post(endpoint.PENALTY_READ, data: {});
    if (tmp_p == null) return snackbar(ct: context, ms: "Error: Read Penalty", cl: Colors.red);
    List<Penalty> list_penalty = (tmp_p.data as List<dynamic>? ?? []).map((e) => Penalty.fromJson(e)).toList();

    List<Order_Penalty> orders = [
      for (var it in (fd?.list_penalty_item_id ?? []))
        if (it is Penalty_Item) Order_Penalty.fromJson(it.toJson()),
    ];

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => List_Penalty(
        list_penalty: list_penalty, //
        list_order_penalty: orders, //
        locked_ids: fd == null ? {} : locked_penalty_ids(fd), //
      ),
    );
    if (saved != true) return;

    // * រក្សាទុកទំនិញ penalty: ថ្មី → create, មានរួច → update quantity
    List<String> ids = [];
    for (var o in orders) {
      if (o.id != null) {
        dynamic tmp_up = await dio.post(
          endpoint.PENALTY_ITEM_UPDATE,
          data: {
            Penalty_Item.ID: o.id, //
            Penalty_Item.QUANTITY: o.quantity, //
          },
        );
        if (tmp_up == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
        ids.add(o.id!);
        continue;
      }
      dynamic tmp_item = await dio.post(
        endpoint.PENALTY_ITEM_CREATE,
        data: {
          Penalty_Item.PENALTY_ID: o.penalty_id?.id, //
          Penalty_Item.QUANTITY: o.quantity, //
        },
      );
      if (tmp_item == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      ids.add(tmp_item.data[0][Penalty_Item.ID]);
    }

    dynamic tmp_fd = await dio.post(
      endpoint.FRONT_DESK_PENALTY_ITEM,
      data: {
        Front_Desk.ID: fd_id, //
        Front_Desk.LIST_PENALTY_ITEM_ID: ids, //
      },
    );
    if (tmp_fd == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Penalty Updated", cl: Colors.green);
    init();
  }

  void on_mini_bar_item(PlutoColumnRendererContext rc) async {
    if (checkout_guard(rc)) return;
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update mini bar", cl: Colors.red);

    Front_Desk? fd = front_desks.where((x) => x.id == fd_id).firstOrNull;

    dynamic tmp_m = await dio.post(endpoint.MINI_BAR_READ, data: {});
    if (tmp_m == null) return snackbar(ct: context, ms: "Error: Read Mini Bar", cl: Colors.red);
    List<Mini_Bar> list_mini_bar = (tmp_m.data as List<dynamic>? ?? []).map((e) => Mini_Bar.fromJson(e)).toList();

    List<Order_Mini_Bar> orders = [
      for (var it in (fd?.list_mini_bar_item_id ?? []))
        if (it is Mini_Bar_Item) Order_Mini_Bar.fromJson(it.toJson()),
    ];

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => List_Mini_Bar(
        list_mini_bar: list_mini_bar, //
        list_order_mini_bar: orders, //
        locked_ids: fd == null ? {} : locked_mini_bar_ids(fd), //
      ),
    );
    if (saved != true) return;

    // * រក្សាទុកទំនិញ mini bar: ថ្មី → create, មានរួច → update quantity
    List<String> ids = [];
    for (var o in orders) {
      if (o.id != null) {
        dynamic tmp_up = await dio.post(
          endpoint.MINI_BAR_ITEM_UPDATE,
          data: {
            Mini_Bar_Item.ID: o.id, //
            Mini_Bar_Item.QUANTITY: o.quantity, //
          },
        );
        if (tmp_up == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
        ids.add(o.id!);
        continue;
      }
      dynamic tmp_item = await dio.post(
        endpoint.MINI_BAR_ITEM_CREATE,
        data: {
          Mini_Bar_Item.MINI_BAR_ID: o.mini_bar_id?.id, //
          Mini_Bar_Item.QUANTITY: o.quantity, //
        },
      );
      if (tmp_item == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      ids.add(tmp_item.data[0][Mini_Bar_Item.ID]);
    }

    // * Walk-In: ប្រើ endpoint ដាច់ដោយឡែក (walk_in_update)
    if (row_is_walk_in(rc)) {
      dynamic tmp_walk = await dio.post(
        endpoint.FRONT_DESK_WALK_IN_UPDATE,
        data: {
          Front_Desk.ID: fd_id, //
          Front_Desk.LIST_MINI_BAR_ITEM_ID: ids, //
        },
      );
      if (tmp_walk == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

      snackbar(ct: context, ms: "Walk-In Mini Bar Updated", cl: Colors.green);
      init();
      return;
    }

    dynamic tmp_fd = await dio.post(
      endpoint.FRONT_DESK_MINI_BAR_ITEM,
      data: {
        Front_Desk.ID: fd_id, //
        Front_Desk.LIST_MINI_BAR_ITEM_ID: ids, //
      },
    );
    if (tmp_fd == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Mini Bar Updated", cl: Colors.green);
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

  bool is_filter = false; // this variable is used to show/hide the filter row in the PlutoGridj
  bool hide_penalty = false; // this variable is used to show/hide the penalty column in the PlutoGrid
  bool hide_mini_bar = false; // this variable is used to show/hide the mini bar column in the PlutoGrid

  // * ########## BLOCK METHODS END ##########
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
