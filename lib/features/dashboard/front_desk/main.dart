import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "dialog/add_mini_bar.dart";
import "dialog/select_room.dart";
import "dialog/check_in.dart";
import "dialog/check_out.dart";
import "dialog/clean.dart";
import "dialog/list_mini_bar.dart";
import "dialog/list_penalty.dart";
import "dialog/update_check_in_at.dart";
import "dialog/update_check_out_at.dart";
import "dialog/search_guest.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK ATTRIBUTE ##########
  int reload = 0;
  bool filter = false;
  bool is_admin = false;
  bool show_co = true;

  List<dynamic> rooms = [];
  List<Front_Desk> data = [];

  late List<PlutoColumn> list_column_pluto;
  late PlutoGridStateManager state_manager;

  Timer? _timer;
  // * ########## BLOCK ATTRIBUTE END ##########

  // * ########## BLOCK DESIGN ##########
  Widget _layout({
    List<Widget>? check_in, //
    List<Widget>? check_out, //
    List<Widget>? clean, //
    List<Widget>? header, //
    Widget? body, //
  }) {
    return Scaffold(
      body: Column(
        spacing: 1,
        children: [
          if (check_in != null && check_in.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft, //
              padding: const EdgeInsets.only(top: 1),
              child: Wrap(
                spacing: 1, //
                runSpacing: 1,
                children: check_in,
              ),
            ),

          if (check_out != null && check_out.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft, //
              padding: const EdgeInsets.only(top: 1),
              child: Wrap(
                spacing: 1, //
                runSpacing: 1,
                children: check_out,
              ),
            ),

          if (clean != null && clean.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft, //
              padding: const EdgeInsets.only(top: 1),
              child: Wrap(
                spacing: 1, //
                runSpacing: 1,
                children: [...clean],
              ),
            ),

          if (header != null && header.isNotEmpty)
            Container(
              height: 34, //
              padding: const EdgeInsets.only(top: 1),
              child: Row(
                spacing: 1, //
                children: header,
              ),
            ),

          Expanded(child: body ?? Container()),
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

        Tooltip(
          message: "Add Mini Bar", //
          child: OutlinedButton.icon(
            label: Text("Mini Bar"), //
            icon: Icon(Icons.local_bar_outlined), //
            style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
            onPressed: () => on_mini_bar_only(), //
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
        SizedBox(width: 8), //

        Text(
          DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(const Duration(hours: 7))), //
          style: TextStyle(
            fontSize: 16, //
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(), //

        if (is_admin || kDebugMode)
          IconButton(
            tooltip: "Carry Over", //
            icon: Icon(Icons.event_repeat_outlined, size: 30), //
            padding: EdgeInsets.all(0),
            constraints: BoxConstraints(),
            onPressed: on_carry_over, //
          ),

        if (is_admin || kDebugMode)
          IconButton(
            tooltip: "Over Time", //
            icon: Icon(Icons.schedule_outlined, size: 30), //
            padding: EdgeInsets.all(0),
            constraints: BoxConstraints(),
            onPressed: on_over_time, //
          ),

        IconButton(
          tooltip: show_co ? "Hide Carry-over" : "Show Carry-over", //
          icon: Icon(show_co ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_toggle_carry_over, //
        ),

        IconButton(
          tooltip: filter ? "Hide Filter" : "Show Filter", //
          icon: Icon(filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_filter,
        ),

        IconButton(
          tooltip: "Reload", //
          icon: Icon(Icons.refresh, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_reload,
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
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
            footerRenderer: (rc) {
              return PlutoAggregateColumnFooter(
                rendererContext: rc, //
                format: "#,##0.00", //
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                type: PlutoAggregateColumnType.count,
                titleSpanBuilder: (value) {
                  return [
                    WidgetSpan(
                      child: Text(
                        "Sum: ", //
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
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
            width: 100,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  if (!is_row_mini_bar(rc))
                    IconButton(
                      tooltip: "Change Room", //
                      icon: Icon(Icons.swap_horiz_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_change_room(rc), //
                    ),
                ],
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
                      alignment: Alignment.center, //
                      child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),

                  if (!is_row_mini_bar(rc))
                    IconButton(
                      tooltip: "កែពេលចូល", //
                      icon: Icon(Icons.calendar_month_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_update_check_in_at(rc), //
                    ),
                ],
              );
            },
          ),

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
                alignment: Alignment.center, //
                child: Text(text, overflow: TextOverflow.ellipsis),
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
                      child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  if (!is_row_mini_bar(rc) && rc.cell.value != null)
                    IconButton(
                      tooltip: "កែពេលចេញ", //
                      icon: Icon(Icons.calendar_month_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_update_check_out_at(rc), //
                    ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "guest_name", //
            title: "ឈ្មោះ",
            type: PlutoColumnType.text(),
            enableEditingMode: true,
            width: 120,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
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
            width: 120,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),

                  IconButton(
                    tooltip: "Search Guest", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () async {
                      var v = await dialog_search_guest(
                        context: context, //
                        front_desk_id: rc.row.cells["_id"]?.value,
                      );
                      if (v == null) return;
                      on_load_front_desk();
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
                alignment: Alignment.center, //
                child: Text(format_double(rc.cell.value, digits: 0) + " នាក់", overflow: TextOverflow.ellipsis),
              );
            },
          ),

          PlutoColumn(
            field: "room_price", //
            title: "ថ្លៃបន្ទប់",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            width: 90,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_double(rc.cell.value, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
              );
            },
            footerRenderer: _sum_footer,
          ),

          PlutoColumn(
            field: "mini_bar_price", //
            title: "ថ្លៃមីនីបារ",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_double(rc.cell.value, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
                    ),
                  ),

                  IconButton(
                    tooltip: "Mini Bar Items", //
                    icon: Icon(Icons.local_bar_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_mini_bar_item(rc), //
                  ),
                ],
              );
            },
            footerRenderer: _sum_footer,
          ),

          PlutoColumn(
            field: "penalty_price", //
            title: "ថ្លៃពិន័យ",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_double(rc.cell.value, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
                    ),
                  ),

                  if (!is_row_mini_bar(rc))
                    IconButton(
                      tooltip: "Penalty Items", //
                      icon: Icon(Icons.gavel_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_penalty_item(rc), //
                    ),
                ],
              );
            },
            footerRenderer: _sum_footer,
          ),

          PlutoColumn(
            field: "pay_cash", //
            title: "សាច់ប្រាក់",
            type: PlutoColumnType.number(format: "#,##0.00"),
            width: 90,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: rc.cell.value >= 0 ? Colors.black : Colors.red),
                ),
              );
            },
            footerRenderer: _sum_footer,
          ),

          PlutoColumn(
            field: "pay_bank", //
            title: "ធនាគារ",
            type: PlutoColumnType.number(format: "#,##0.00"),
            width: 90,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: rc.cell.value >= 0 ? Colors.black : Colors.red),
                ),
              );
            },
            footerRenderer: _sum_footer,
          ),

          PlutoColumn(
            field: "pay_balance", //
            title: "សមតុល្យ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: is_admin,
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: rc.cell.value == 0 ? Colors.black : (rc.cell.value > 0 ? Colors.green : Colors.red)),
                ),
              );
            },
          ),

          PlutoColumn(
            field: "pay_note", //
            title: "ចំណាំ",
            type: PlutoColumnType.text(),
            width: 120,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.CHECK_IN_BY, //
            title: "ឲចូលដោយ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 140,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
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
                alignment: Alignment.center, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          PlutoColumn(
            field: "other", //
            title: "ផ្សេងៗ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            enableColumnDrag: false,
            enableContextMenu: false,
            enableDropToResize: false,
            enableFilterMenuItem: false,
            enableSorting: false,
            width: 40,
            cellPadding: EdgeInsets.all(0),
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
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
          PlutoColumnGroup(title: "", fields: ["index"]),
          PlutoColumnGroup(title: "អតិថិជន", fields: ["guest_name", "guest_phone", "check_in_people"]),
          PlutoColumnGroup(title: "ការស្នាក់នៅ", fields: ["room", "check_in_duration", "check_in_at", "check_out_at"]),
          PlutoColumnGroup(title: "ការបង់ប្រាក់", fields: ["room_price", "mini_bar_price", "penalty_price", "pay_cash", "pay_bank", "pay_balance", "pay_note"]),
          PlutoColumnGroup(title: "ការត្រួតពិនិត្យ", fields: [Front_Desk.CHECK_IN_BY, "check_out_by"]),
        ],
        configuration: PlutoGridConfiguration(
          scrollbar: PlutoGridScrollbarConfig(scrollbarThickness: 12, scrollbarThicknessWhileDragging: 12),
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
        onChanged: on_updated,
      ),
    );
  }
  // * ########## BLOCK DESIGN END ##########

  // * ########## BLOCK METHODS ##########
  @override
  void initState() {
    super.initState();
    load_auth();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      on_refresh_duration();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }

  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    state_manager.setAutoEditing(true);
    state_manager.columnFooterHeight = 32;
    list_column_pluto = state_manager.refColumns.toList();

    on_load_room();
    on_load_front_desk();
  }

  Future<void> load_auth() async {
    final user = await auth.fetch();
    if (user == null) return;
    final new_is_admin = user.is_admin == true;
    if (is_admin != new_is_admin) {
      is_admin = new_is_admin;
      reload++;
      setState(() {});
    }
  }

  Future<void> on_reload() async {
    reload++;
    await load_auth();
    await Future.wait([on_load_room(), on_load_front_desk()]);
    setState(() {});
  }

  String shift_start() {
    final shift_day = DateTime.now().subtract(const Duration(hours: 7));
    return DateTime(shift_day.year, shift_day.month, shift_day.day).toIso8601String();
  }

  String shift_stop() {
    final shift_day = DateTime.now().subtract(const Duration(hours: 7));
    return DateTime(shift_day.year, shift_day.month, shift_day.day).add(const Duration(days: 1)).toIso8601String();
  }

  Future<void> on_load_room() async {
    dynamic tmp_r = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
    if (tmp_r == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    rooms = tmp_r.data as List<dynamic>? ?? [];
  }

  Future<void> on_load_front_desk() async {
    dynamic tmp_fd = await dio.post(
      endpoint.FRONT_DESK_READ_DATETIME,
      data: {
        "key": Front_Desk.SHIFT_DATE, //
        "start": shift_start(), //
        "stop": shift_stop(), //
        "order": -1, //
        "link": true, //
      },
    );
    if (tmp_fd == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    data = (tmp_fd.data as List<dynamic>? ?? []).map<Front_Desk>((e) => Front_Desk.fromJson(e)).toList();

    state_manager.removeAllRows();
    final now = DateTime.now();
    final cutoff_2pm = DateTime(now.year, now.month, now.day, 14, 0);
    state_manager.appendRows([
      for (var (i, fd) in data.indexed)
        if (show_co || !(fd.room_price == 0 && (fd.check_out_at == null || !fd.check_out_at!.isAfter(cutoff_2pm))))
          PlutoRow(
            cells: {
              for (var c in list_column_pluto) //
                c.field: (() {
                  if (c.field == "_id") return PlutoCell(value: fd.id ?? "");
                  if (c.field == "index") return PlutoCell(value: i + 1);
                  if (c.field == "room") return PlutoCell(value: fd.room_number ?? "");
                  if (c.field == "guest_name") return PlutoCell(value: fd.guest_id is Guest_Show ? (fd.guest_id as Guest_Show).full_name : "");
                  if (c.field == "guest_phone") return PlutoCell(value: fd.guest_id is Guest_Show ? (fd.guest_id as Guest_Show).phone_number : "");
                  if (c.field == "check_in_people") return PlutoCell(value: fd.number_of_guest ?? 0);
                  if (c.field == "check_in_at") return PlutoCell(value: fd.check_in_at);
                  if (c.field == "check_in_duration") return PlutoCell(value: check_in_duration(fd));
                  if (c.field == "check_out_at") return PlutoCell(value: fd.check_out_at);
                  if (c.field == "room_price") return PlutoCell(value: fd.room_price);
                  if (c.field == "mini_bar_price") return PlutoCell(value: fd.mini_bar_price);
                  if (c.field == "penalty_price") return PlutoCell(value: fd.penalty_price);
                  if (c.field == "pay_cash") return PlutoCell(value: fd.pay_cash);
                  if (c.field == "pay_bank") return PlutoCell(value: fd.pay_bank);
                  if (c.field == "pay_balance") return PlutoCell(value: fd.pay_balance);
                  if (c.field == "pay_note") return PlutoCell(value: fd.pay_note ?? "");
                  if (c.field == "check_in_by") return PlutoCell(value: fd.check_in_by is User_Show ? (fd.check_in_by as User_Show).full_name : (fd.check_in_by ?? ""));
                  if (c.field == "check_out_by") return PlutoCell(value: fd.check_out_by is User_Show ? (fd.check_out_by as User_Show).full_name : (fd.check_out_by ?? ""));

                  return PlutoCell(value: "");
                })(),
            },
          ),
]);

    setState(() {});
  }

  int check_in_duration(Front_Desk fd) {
    if (is_walkin(fd)) return 0;
    DateTime? in_at = fd.check_in_at;
    DateTime? out_at = fd.check_out_at;
    if (in_at == null) return 0;
    if (out_at == null) return DateTime.now().difference(in_at).inMinutes;
    return out_at.difference(in_at).inMinutes;
  }

  bool is_walkin(Front_Desk fd) {
    return _is_mini_bar_room(fd.room_number);
  }

  bool _is_mini_bar_room(String? number) {
    String n = (number ?? "").toLowerCase();
    return n == "walk-in" || n == "mini bar";
  }

  bool is_walk_in_room(dynamic r) => _is_mini_bar_room(r[Room.NUMBER]?.toString());

  // * ធ្វើឲ្យ duration ក្នុងតារាងថ្មីតាមពេលបច្ចុប្បន្ន
  void on_refresh_duration() {
    for (var row in state_manager.rows) {
      final id = row.cells["_id"]?.value;
      if (id == null) continue;
      Front_Desk? fd = data.where((x) => x.id == id).firstOrNull;
      if (fd == null) continue;
      state_manager.changeCellValue(
        row.cells["check_in_duration"]!, //
        check_in_duration(fd),
        force: true,
        callOnChangedEvent: false,
      );
    }
  }

  PlutoAggregateColumnFooter _sum_footer(PlutoColumnFooterRendererContext rc) {
    return PlutoAggregateColumnFooter(
      rendererContext: rc, //
      format: "#,##0.00", //
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      type: PlutoAggregateColumnType.sum,
      titleSpanBuilder: (value) {
        return [
          WidgetSpan(
            child: Text(
              "$value \$", //
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            ),
          ),
        ];
      },
    );
  }

  void on_updated(PlutoGridOnChangedEvent e) {
    final fd_id = e.row.cells["_id"]?.value;
    if (fd_id == null) return;

    bool is_walkin_row = false;
    {
      Front_Desk? walk_fd = data.where((x) => x.id == fd_id).firstOrNull;
      is_walkin_row = walk_fd != null && is_walkin(walk_fd);
      if (is_walkin_row && e.column.field != "guest_name" && e.column.field != "guest_phone" && e.column.field != "pay_cash" && e.column.field != "pay_bank" && e.column.field != "pay_balance") {
        state_manager.changeCellValue(e.row.cells[e.column.field]!, e.oldValue, callOnChangedEvent: false);
        return;
      }
    }

    // * dispatch ទៅ do_* methods (fire-and-forget)
    if (e.column.field == "guest_name" || e.column.field == "guest_phone") {
      do_update_guest(fd_id, e.value);
    } else if (e.column.field == "check_in_people") {
      do_update(fd_id, Front_Desk.NUMBER_OF_GUEST, num.tryParse(e.value?.toString() ?? "")?.toDouble());
    } else if (e.column.field == "room_price") {
      do_update_room_price(fd_id, num.tryParse(e.value?.toString() ?? "")?.toDouble());
    } else if (e.column.field == "pay_cash" || e.column.field == "pay_bank" || e.column.field == "pay_note") {
      final key = switch (e.column.field) {
        "pay_cash" => Front_Desk.PAY_CASH,
        "pay_bank" => Front_Desk.PAY_BANK,
        _ => Front_Desk.PAY_NOTE,
      };
      final value = e.column.field == "pay_note" ? e.value?.toString() : num.tryParse(e.value?.toString() ?? "")?.toDouble();
      final ep = is_walkin_row ? endpoint.FRONT_DESK_UPDATE_WALKIN : endpoint.FRONT_DESK_UPDATE_PAYMENT;
      do_update_payment(fd_id, key, value, ep);
    } else if (e.column.field == "pay_balance" && is_admin) {
      do_update_payment(fd_id, Front_Desk.PAY_BALANCE, num.tryParse(e.value?.toString() ?? "")?.toDouble(), endpoint.FRONT_DESK_UPDATE_PAYMENT);
    } else if (e.column.field == "mini_bar_price") {
      do_update_mini_bar(fd_id);
    } else if (e.column.field == "penalty_price") {
      do_update_penalty(fd_id);
    }
  }

  Future<void> do_update(String? fd_id, String field, dynamic value) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE, data: {Front_Desk.ID: fd_id, field: value});
    if (tmp == null) {
      await on_load_front_desk();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
  }

  Future<void> do_update_guest(String? fd_id, dynamic guest_id) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE_GUEST_INFO, data: {Front_Desk.ID: fd_id, Front_Desk.GUEST_ID: guest_id});
    if (tmp == null) {
      await on_load_front_desk();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    // * reload balance
    await on_load_front_desk();
  }

  Future<void> do_update_room_price(String? fd_id, dynamic value) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE_ROOM_PRICE, data: {Front_Desk.ID: fd_id, Front_Desk.ROOM_PRICE: value});
    if (tmp == null) {
      await on_load_front_desk();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    await on_load_front_desk();
  }

  Future<void> do_update_payment(String? fd_id, String key, dynamic value, String ep) async {
    final tmp = await dio.post(ep, data: {Front_Desk.ID: fd_id, key: value});
    if (tmp == null) {
      await on_load_front_desk();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    await on_load_front_desk();
  }

  Future<void> do_update_mini_bar(String? fd_id) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE_MINI_BAR_ITEM, data: {Front_Desk.ID: fd_id});
    if (tmp == null) {
      await on_load_front_desk();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    await on_load_front_desk();
  }

  Future<void> do_update_penalty(String? fd_id) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE_PENALTY_ITEM, data: {Front_Desk.ID: fd_id});
    if (tmp == null) {
      await on_load_front_desk();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    await on_load_front_desk();
  }

  Future<void> on_update_check_in_at(PlutoColumnRendererContext rc) async {
    DateTime? dt = rc.cell.value is DateTime ? rc.cell.value as DateTime : null;
    final id = rc.row.cells["_id"]?.value;
    if (id == null) return;
    final v = await dialog_update_check_in_at(context: context, fd_id: id, initial: dt);
    if (v == null) return;
    state_manager.changeCellValue(rc.cell, DateTime.tryParse(v), force: true, callOnChangedEvent: false);
    on_refresh_duration();
    do_update(id, Front_Desk.CHECK_IN_AT, v);
  }

  Future<void> on_update_check_out_at(PlutoColumnRendererContext rc) async {
    DateTime? dt = rc.cell.value is DateTime ? rc.cell.value as DateTime : null;
    final id = rc.row.cells["_id"]?.value;
    if (id == null) return;
    final v = await dialog_update_check_out_at(context: context, fd_id: id, initial: dt);
    if (v == null) return;
    state_manager.changeCellValue(rc.cell, DateTime.tryParse(v), force: true, callOnChangedEvent: false);
    on_refresh_duration();
    do_update(id, Front_Desk.CHECK_OUT_AT, v);
  }

  Future<void> on_check_in(dynamic r) async {
    var v = await dialog_check_in(
      context: context, //
      lead: "Room ${r[Room.NUMBER]}", //
      room_number: r[Room.NUMBER], //
    );
    if (v == null) return;
    await Future.wait([on_load_room(), on_load_front_desk()]);
  }

  Future<void> on_carry_over() async {
    dynamic tmp = await dio.post(endpoint.FRONT_DESK_CARRY_OVER, data: {});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Carried Over", cl: Colors.green);
    await Future.wait([on_load_room(), on_load_front_desk()]);
  }

  Future<void> on_over_time() async {
    dynamic tmp = await dio.post(endpoint.FRONT_DESK_OVER_TIME, data: {});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Over Time Applied", cl: Colors.green);
    await Future.wait([on_load_room(), on_load_front_desk()]);
  }

  Future<void> on_check_out(dynamic r) async {
    String? fd_id = (data.where((fd) => (fd.room_number ?? "") == (r[Room.NUMBER] ?? ""))).firstOrNull?.id;
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to check out", cl: Colors.red);

    var v = await dialog_check_out(
      context: context, //
      lead: "Room ${r[Room.NUMBER]}", //
      front_desk_id: fd_id, //
    );
    if (v == null) return;

    await Future.wait([on_load_room(), on_load_front_desk()]);
  }

  Future<void> on_clean(dynamic r) async {
    var v = await dialog_clean(
      context: context, //
      lead: "Room ${r[Room.NUMBER]}", //
      room_number: r[Room.NUMBER], //
    );
    if (v == null) return;

    await Future.wait([on_load_room(), on_load_front_desk()]);
  }

  Future<void> on_mini_bar_only() async {
    final v = await dialog_add_mini_bar(context: context);
    if (v == null) return;
    await on_load_front_desk();
  }

  String? row_stay_id(PlutoColumnRendererContext rc) => rc.row.cells["_id"]?.value;

  Front_Desk? row_stay(PlutoColumnRendererContext rc) {
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return null;
    return data.where((x) => x.id == fd_id).firstOrNull;
  }

  bool is_row_mini_bar(PlutoColumnRendererContext rc) {
    Front_Desk? fd = row_stay(rc);
    if (fd == null) return false;
    return is_walkin(fd);
  }

  Future<void> on_change_room(PlutoColumnRendererContext rc) async {
    String? fd_id = rc.row.cells["_id"]?.value;
    if (fd_id == null) return;
    var v = await dialog_select_room(
      context: context, //
      lead: "Room ${rc.row.cells[Front_Desk.ROOM_NUMBER]?.value}", //
      front_desk_id: fd_id, //
    );
    if (v == null) return;
    await Future.wait([on_load_room(), on_load_front_desk()]);
  }

  Future<void> on_penalty_item(PlutoColumnRendererContext rc) async {
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update penalty", cl: Colors.red);

    Front_Desk? fd = data.where((x) => x.id == fd_id).firstOrNull;

    List<Order_Penalty> orders = [
      for (var it in (fd?.penalty_item_id ?? []))
        if (it is Penalty_Item) Order_Penalty.fromJson(it.toJson()),
    ];

    final price = await dialog_select_penalty(
      context: context, //
      list_order_penalty: orders, //
      front_desk_id: fd_id, //
    );
    if (price == null) return;

    state_manager.changeCellValue(rc.row.cells["penalty_price"]!, price, force: true, callOnChangedEvent: false);
    await on_load_front_desk();
  }

  Future<void> on_mini_bar_item(PlutoColumnRendererContext rc) async {
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update mini bar", cl: Colors.red);

    Front_Desk? fd = data.where((x) => x.id == fd_id).firstOrNull;

    List<Order_Mini_Bar> orders = [
      for (var it in (fd?.mini_bar_item_id ?? []))
        if (it is Mini_Bar_Item) Order_Mini_Bar.fromJson(it.toJson()),
    ];

    final price = await dialog_select_mini_bar(
      context: context, //
      list_order_mini_bar: orders, //
      front_desk_id: fd_id, //
      is_walk_in: is_row_mini_bar(rc), //
    );
    if (price == null) return;

    state_manager.changeCellValue(rc.row.cells["mini_bar_price"]!, price, force: true, callOnChangedEvent: false);
    await on_load_front_desk();
  }

  void on_filter() {
    filter = !filter;
    state_manager.setShowColumnFilter(filter);
  }

  void on_toggle_carry_over() {
    show_co = !show_co;
    on_load_front_desk();
    setState(() {});
  }

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
