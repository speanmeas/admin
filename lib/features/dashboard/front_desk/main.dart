import "dart:async";
import "dart:convert";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "dialog/add_mini_bar.dart";
import "dialog/check_in.dart";
import "dialog/check_in_at_select.dart";
import "dialog/check_out.dart";
import "dialog/check_out_at_select.dart";
import "dialog/clean.dart";
import "dialog/guest_add.dart";
import "dialog/guest_search.dart";
import "dialog/guest_update.dart";
import "dialog/mini_bar_select.dart";
import "dialog/penalty_select.dart";
import "dialog/room_search.dart";
import "dialog/shift_date_select.dart";

class _Main_State extends State<Main_> {
  // ########## BLOCK ATTRIBUTE ##########
  int reload = 0;
  bool filter = false;
  bool is_admin = false;
  bool show_check_in = true;
  bool show_check_out = true;
  bool show_clean = true;
  DateTime current_shift = DateTime.now();

  late List<PlutoColumn> list_column_pluto;
  late PlutoGridStateManager state_manager;

  List<dynamic> rooms = [];
  List<Front_Desk> data = [];

  // ########## BLOCK ATTRIBUTE END ##########

  // ########## BLOCK DESIGN ##########
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
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 1),
              child: Wrap(spacing: 1, runSpacing: 1, children: check_in),
            ),
          if (check_out != null && check_out.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 1),
              child: Wrap(spacing: 1, runSpacing: 1, children: check_out),
            ),
          if (clean != null && clean.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 1),
              child: Wrap(spacing: 1, runSpacing: 1, children: clean),
            ),
          if (header != null && header.isNotEmpty)
            Container(
              height: 32,
              padding: const EdgeInsets.all(1),
              child: Row(spacing: 1, children: header),
            ),
          if (body != null) Expanded(child: body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _layout(
      check_in: [
        if (show_check_in) ...[
          for (var r in rooms.where((r) => r[Room.STATUS] == "Available" && !is_walk_in_room(r)))
            Tooltip(
              message: "Check-in ${r[Room.NUMBER]}",
              child: OutlinedButton.icon(
                icon: const Icon(Icons.bed_outlined),
                label: Text("${r[Room.NUMBER]}"),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
                onPressed: () => on_check_in(r),
              ),
            ),
          Tooltip(
            message: "Add Mini Bar",
            child: OutlinedButton.icon(
              label: const Text("Mini Bar"),
              icon: const Icon(Icons.local_bar_outlined),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
              onPressed: on_mini_bar_only,
            ),
          ),
        ],
      ],
      check_out: [
        if (show_check_out) ...[
          for (var r in rooms.where((r) => r[Room.STATUS] == "Occupied"))
            Tooltip(
              message: "Check-out ${r[Room.NUMBER]}",
              child: OutlinedButton.icon(
                icon: const Icon(Icons.hotel_outlined),
                label: Text("${r[Room.NUMBER]}"),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => on_check_out(r),
              ),
            ),
        ],
      ],
      clean: [
        if (show_clean) ...[
          for (var r in rooms.where((r) => r[Room.STATUS] == "Dirty"))
            Tooltip(
              message: "Clean ${r[Room.NUMBER]}",
              child: OutlinedButton.icon(
                icon: const Icon(Icons.cleaning_services_outlined),
                label: Text("${r[Room.NUMBER]}"),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
                onPressed: () => on_clean(r),
              ),
            ),
        ],
      ],
      header: [
        IconButton(tooltip: "Goto Previous Day", icon: const Icon(Icons.navigate_before, size: 30), padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: on_previous_day),
        TextButton(
          child: Text(DateFormat("yyyy-MM-dd").format(current_shift), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          onPressed: on_goto_day,
        ),
        IconButton(tooltip: "Goto Next Day", icon: const Icon(Icons.navigate_next, size: 30), padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: on_next_day),
        const Spacer(),
        IconButton(tooltip: filter ? "Hide Filter" : "Show Filter", icon: Icon(filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, size: 30), padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: on_filter),
        IconButton(tooltip: "Reload", icon: const Icon(Icons.refresh, size: 30), padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: on_reload),
      ],
      body: PlutoGrid(
        key: ValueKey(reload),
        rows: [],
        columns: [
          PlutoColumn(
            field: Front_Desk.ID, //
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
            enableRowDrag: true,
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
                alignment: Alignment.centerRight,
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
            field: Front_Desk.ROOM_NUMBER, //
            title: "បន្ទប់",
            type: PlutoColumnType.text(),
            width: 80,
            enableEditingMode: false,
            renderer: (rc) {
              final is_walk_in = is_row_mini_bar(rc);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  if (!is_walk_in)
                    IconButton(
                      tooltip: "ផ្លាស់ប្តូរបន្ទប់", //
                      icon: Icon(Icons.swap_horiz_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_update_room(rc), //
                    ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.GUEST_ID, //
            title: "ឈ្មោះ (លេខទូរស័ព្ទ)",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 200,
            renderer: (rc) {
              final val = rc.cell.value;
              final no_guest_id = val == null || (val is String && val.isEmpty);
              final has_guest_id = !no_guest_id;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "Search Guest", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_search_guest(rc), //
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  if (no_guest_id)
                    IconButton(
                      tooltip: "Add Guest", //
                      icon: Icon(Icons.person_add_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_add_guest(rc),
                    ),
                  if (has_guest_id)
                    IconButton(
                      tooltip: "Update Guest", //
                      icon: Icon(Icons.edit_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_guest_update(rc),
                    ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.NUMBER_OF_GUEST, //
            title: "ចំនួន",
            type: PlutoColumnType.number(),
            width: 70,
            renderer: (rc) {
              if (is_row_mini_bar(rc)) return const SizedBox();
              double value = parse_double(rc.cell.value) ?? 0.0;
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      value == 0 ? "" : "${value.toInt()} នាក់", //
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<double>(
                    menuPadding: EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    itemBuilder: (context) => [
                      for (double o in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) ...[
                        PopupMenuItem(
                          value: o,
                          child: Text("${o.toInt()} នាក់", style: TextStyle(fontSize: 14)),
                        ),
                        const PopupMenuDivider(height: 0),
                      ],
                    ],
                    onSelected: (v) => on_update_number_of_guest(rc, v), //
                    child: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.CHECK_IN_AT, //
            title: "ពេលចូល",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 160,
            renderer: (rc) {
              final is_walk_in = is_row_mini_bar(rc);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  if (!is_walk_in)
                    IconButton(
                      tooltip: "កែពេលចូល", //
                      icon: Icon(Icons.calendar_month_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_update_check_in_at(rc), //
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.CHECK_OUT_AT, //
            title: "ពេលចេញ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 160,
            renderer: (rc) {
              if (is_row_mini_bar(rc)) return const SizedBox();
              final has_checkout = rc.cell.value != null && rc.cell.value != "";
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "កែពេលចេញ", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_update_check_out_at(rc), //
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  if (!has_checkout)
                    IconButton(
                      tooltip: "ស្នាក់នៅបន្ត", //
                      icon: Icon(Icons.navigate_next_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_update_carry_over(rc), //
                    ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.ROOM_PRICE, //
            title: "ថ្លៃបន្ទប់",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: true,
            checkReadOnly: (row, cell) => is_walk_in_row(row),
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: Front_Desk.MINI_BAR_PRICE, //
            title: "ថ្លៃមីនីបារ",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "Mini Bar Items", //
                    icon: Icon(Icons.local_bar_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_mini_bar_item(rc), //
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              );
            },
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: Front_Desk.PENALTY_PRICE, //
            title: "ថ្លៃពិន័យ",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              if (is_row_mini_bar(rc)) {
                return const Align(
                  alignment: Alignment.center, //
                  child: Text("-", style: TextStyle(color: Colors.grey)),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "Penalty Items", //
                    icon: Icon(Icons.gavel_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_penalty_item(rc), //
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              );
            },
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: Front_Desk.PAY_CASH, //
            title: "លុយ",
            type: PlutoColumnType.number(
              negative: true, //
              format: "#,##0.00",
            ),
            enableEditingMode: true,
            width: 90,
            renderer: (rc) => _money_cash_bank(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: Front_Desk.PAY_BANK, //
            title: "ធនាគារ",
            type: PlutoColumnType.number(
              negative: true, //
              format: "#,##0.00",
            ),
            enableEditingMode: true,
            width: 90,
            renderer: (rc) => _money_cash_bank(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: Front_Desk.PAY_BALANCE, //
            title: "សមតុល្យ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: true,
            checkReadOnly: (row, cell) => is_walk_in_row(row),
            width: 90,
            renderer: (rc) => _money_balance(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: Front_Desk.PAY_NOTE, //
            title: "ចំណាំ",
            type: PlutoColumnType.text(),
            enableEditingMode: true,
            width: 120,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          if (kDebugMode)
            PlutoColumn(
              field: Front_Desk.SHIFT_DATE, //
              title: "របាយការណ៍ថ្ងៃ",
              type: PlutoColumnType.text(),
              enableEditingMode: false,
              width: 120,
              renderer: (rc) {
                final is_walk_in = is_row_mini_bar(rc);
                final v = parse_datetime(rc.cell.value);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center, //
                  children: [
                    if (!is_walk_in)
                      IconButton(
                        tooltip: "កែថ្ងៃ", //
                        icon: Icon(Icons.calendar_month_outlined),
                        padding: EdgeInsets.all(0),
                        constraints: BoxConstraints(),
                        onPressed: () => on_update_shift_date(rc), //
                      ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center, //
                        child: Text(
                          v == null ? "" : DateFormat("yyyy-MM-dd").format(v), //
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
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
                    onPressed: () => snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue), //
                  ),
                ],
              );
            },
          ),
        ],
        columnGroups: [
          PlutoColumnGroup(title: "", fields: [Front_Desk.ID, Front_Desk.SHIFT_DATE, Front_Desk.ROOM_NUMBER, "index", "other"]),
          PlutoColumnGroup(title: "ការស្នាក់នៅ", fields: [Front_Desk.CHECK_IN_AT, Front_Desk.CHECK_OUT_AT]),
          PlutoColumnGroup(title: "អតិថិជន", fields: [Front_Desk.GUEST_ID, Front_Desk.NUMBER_OF_GUEST]),
          PlutoColumnGroup(title: "ការបង់ប្រាក់", fields: [Front_Desk.ROOM_PRICE, Front_Desk.MINI_BAR_PRICE, Front_Desk.PENALTY_PRICE, Front_Desk.PAY_CASH, Front_Desk.PAY_BANK, Front_Desk.PAY_BALANCE, Front_Desk.PAY_NOTE]),
        ],
        configuration: const PlutoGridConfiguration(
          scrollbar: PlutoGridScrollbarConfig(isAlwaysShown: false, scrollbarThickness: 0, scrollbarThicknessWhileDragging: 0),
          style: PlutoGridStyleConfig(rowHeight: 28, columnHeight: 32, columnFilterHeight: 32, defaultColumnTitlePadding: EdgeInsets.fromLTRB(4, 0, 26, 0), defaultColumnFilterPadding: EdgeInsets.all(1), defaultCellPadding: EdgeInsets.symmetric(horizontal: 2)),
        ),
        onLoaded: on_loaded,
        onChanged: on_updated,
        onRowsMoved: on_rows_moved,
      ),
    );
  }
  // ########## BLOCK DESIGN END ##########

  // ########## BLOCK METHODS ##########
  // ########## HELPERS ##########
  bool is_walk_in_room(dynamic r) => (r[Room.NUMBER] ?? "").toString().toLowerCase() == "walk-in";

  bool is_walk_in_row(PlutoRow row) {
    final rn = (row.cells[Front_Desk.ROOM_NUMBER]?.value ?? "").toString().toLowerCase();
    if (rn == "walk-in") return true;
    final fd_id = row.cells[Front_Desk.ID]?.value;
    if (fd_id != null) {
      final fd = data.where((x) => x.id == fd_id).firstOrNull;
      if ((fd?.room_number ?? "").toLowerCase() == "walk-in") return true;
    }
    return false;
  }

  bool is_row_mini_bar(PlutoColumnRendererContext rc) => is_walk_in_row(rc.row);

  void re_index() {
    for (int i = 0; i < state_manager.rows.length; i++) {
      final row = state_manager.rows[i];
      state_manager.changeCellValue(row.cells["index"]!, i + 1, force: true, callOnChangedEvent: false);
    }
  }

  String user_name(dynamic v) {
    if (v == null) return "";
    if (v is User_Show) return v.full_name ?? "";
    if (v is Map) return (v[User.FULL_NAME] ?? "").toString();
    return format_string(v);
  }

  String guest_name_phone(dynamic v) {
    if (v == null) return "";
    if (v is Guest_Show) return "${v.full_name ?? "N/A"} (${v.phone_number ?? "N/A"})";
    if (v is Map) return "${v[Guest.FULL_NAME] ?? "N/A"} (${v[Guest.PHONE_NUMBER] ?? "N/A"})";
    return format_string(v);
  }

  Widget _money(PlutoColumnRendererContext rc) {
    if (is_row_mini_bar(rc)) {
      return const Align(
        alignment: Alignment.center,
        child: Text("-", style: TextStyle(color: Colors.grey)),
      );
    }
    return Align(
      alignment: Alignment.center, //
      child: Text(
        format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", //
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _money_cash_bank(PlutoColumnRendererContext rc) {
    double v = parse_double(rc.cell.value) ?? 0;
    return Align(
      alignment: Alignment.center, //
      child: Text(
        format_double(v, digits: 2) + " \$", //
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: v >= 0 ? Colors.black : Colors.red),
      ),
    );
  }

  Widget _money_balance(PlutoColumnRendererContext rc) {
    double v = parse_double(rc.cell.value) ?? 0;
    return Align(
      alignment: Alignment.center, //
      child: Text(
        format_double(v, digits: 2) + " \$", //
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: v == 0 ? Colors.black : (v > 0 ? Colors.green : Colors.red)),
      ),
    );
  }

  Widget _sum_footer(PlutoColumnFooterRendererContext rc) {
    return PlutoAggregateColumnFooter(
      rendererContext: rc, //
      format: "#,##0.00", //
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      type: PlutoAggregateColumnType.sum,
      titleSpanBuilder: (value) {
        return [
          WidgetSpan(
            child: Text(
              "$value \$", //
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            ),
          ),
        ];
      },
    );
  }

  // ########## DATA LOADING ##########
  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    state_manager.columnFooterHeight = 32;
    list_column_pluto = state_manager.refColumns.toList();

    await on_load_dashboard();
  }

  Future<void> on_load_dashboard([DateTime? shift_date]) async {
    final res = await dio.post(endpoint.FRONT_DESK_DASHBOARD, data: {if (shift_date != null) "shift_date": DateFormat("yyyy-MM-dd").format(shift_date)});
    if (res == null) {
      if (mounted) snackbar(ct: context, ms: dio.error_msg ?? "Failed to load dashboard", cl: Colors.red);
      return;
    }

    dynamic raw = res.data;
    if (raw is String) raw = jsonDecode(raw);
    final res_data = raw is Map ? Map<String, dynamic>.from(raw) : {};

    if (res_data["shift_date"] != null) {
      current_shift = DateTime.tryParse(res_data["shift_date"].toString()) ?? current_shift;
    }
    rooms = (res_data["rooms"] as List<dynamic>?) ?? [];
    final staysJson = (res_data["stays"] as List<dynamic>?) ?? [];
    data = staysJson.map((e) => Front_Desk.fromJson(Map<String, dynamic>.from(e as Map))).toList();

    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, d) in data.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column_pluto) //
              c.field: (() {
                if (c.field == "index") return PlutoCell(value: i + 1); // auto
                if (c.field == Front_Desk.ID) return PlutoCell(value: d.id ?? "");
                if (c.field == Front_Desk.ROOM_NUMBER) return PlutoCell(value: d.room_number ?? "");
                if (c.field == Front_Desk.CHECK_IN_AT) return PlutoCell(value: format_datetime(d.check_in_at));
                if (c.field == Front_Desk.CHECK_OUT_AT) return PlutoCell(value: format_datetime(d.check_out_at));
                if (c.field == Front_Desk.GUEST_ID) return PlutoCell(value: guest_name_phone(d.guest_id));
                if (c.field == Front_Desk.NUMBER_OF_GUEST) return PlutoCell(value: d.number_of_guest ?? 0);
                if (c.field == Front_Desk.ROOM_PRICE) return PlutoCell(value: d.room_price ?? 0.0);
                if (c.field == Front_Desk.MINI_BAR_PRICE) return PlutoCell(value: d.mini_bar_price ?? 0.0);
                if (c.field == Front_Desk.PENALTY_PRICE) return PlutoCell(value: d.penalty_price ?? 0.0);
                if (c.field == Front_Desk.PAY_CASH) return PlutoCell(value: d.pay_cash ?? 0.0);
                if (c.field == Front_Desk.PAY_BANK) return PlutoCell(value: d.pay_bank ?? 0.0);
                if (c.field == Front_Desk.PAY_BALANCE) return PlutoCell(value: d.pay_balance ?? 0.0);
                if (c.field == Front_Desk.PAY_NOTE) return PlutoCell(value: d.pay_note ?? "");
                if (c.field == Front_Desk.CHECK_IN_BY) return PlutoCell(value: user_name(d.check_in_by));
                if (c.field == Front_Desk.CHECK_OUT_BY) return PlutoCell(value: user_name(d.check_out_by));
                if (c.field == Front_Desk.SHIFT_DATE) return PlutoCell(value: format_datetime(d.shift_date));
                return PlutoCell(value: "");
              })(),
          },
        ),
    ]);
    re_index();
    setState(() {});
  }

  Future<void> on_refresh_balanced() async {
    await on_load_dashboard(current_shift);
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
    await load_auth();
    await on_load_dashboard(current_shift);
    if (mounted) snackbar(ct: context, ms: "Reloaded", cl: Colors.green);
  }

  // ########## USER ACTIONS & CELL EDITS ##########
  void on_updated(PlutoGridOnChangedEvent e) {
    final fd_id = e.row.cells[Front_Desk.ID]?.value;
    final is_walk_in = is_walk_in_row(e.row);
    state_manager.notifyListeners();

    if (is_walk_in) {
      if (e.column.field == Front_Desk.ROOM_PRICE || e.column.field == Front_Desk.PAY_BALANCE || e.column.field == Front_Desk.ROOM_NUMBER || e.column.field == Front_Desk.NUMBER_OF_GUEST || e.column.field == Front_Desk.PENALTY_PRICE) {
        state_manager.changeCellValue(e.row.cells[e.column.field]!, e.oldValue, callOnChangedEvent: false);
        return;
      }
    }

    if (e.column.field == Front_Desk.ROOM_PRICE) {
      do_update_room_price(fd_id, parse_double(e.value) ?? 0.0);
    } else if (e.column.field == Front_Desk.PAY_CASH) {
      do_update_cash(fd_id, parse_double(e.value) ?? 0.0, is_walk_in: is_walk_in);
    } else if (e.column.field == Front_Desk.PAY_BANK) {
      do_update_bank(fd_id, parse_double(e.value) ?? 0.0, is_walk_in: is_walk_in);
    } else {
      do_updated(fd_id, e.column.field, e.value);
    }
  }

  Future<void> do_update_room_price(String? id, double v) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE_ROOM_PRICE, data: {Front_Desk.ID: id, Front_Desk.ROOM_PRICE: v});
    if (tmp == null) {
      await on_load_dashboard(current_shift);
      return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_refresh_balanced();
  }

  Future<void> do_update_cash(String? id, double v, {bool is_walk_in = false}) async {
    final ep = is_walk_in ? endpoint.FRONT_DESK_UPDATE_WALKIN : endpoint.FRONT_DESK_UPDATE_PAYMENT;
    final tmp = await dio.post(ep, data: {"_id": id, "pay_cash": v});
    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      await on_load_dashboard(current_shift);
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_refresh_balanced();
  }

  Future<void> do_update_bank(String? id, double v, {bool is_walk_in = false}) async {
    final ep = is_walk_in ? endpoint.FRONT_DESK_UPDATE_WALKIN : endpoint.FRONT_DESK_UPDATE_PAYMENT;
    final tmp = await dio.post(ep, data: {"_id": id, "pay_bank": v});
    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      await on_load_dashboard(current_shift);
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_refresh_balanced();
  }

  Future<void> do_updated(String? fd_id, String field, dynamic value) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE, data: {Front_Desk.ID: fd_id, field: value});
    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      await on_load_dashboard(current_shift);
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
  }

  Future<void> on_rows_moved(PlutoGridOnRowsMovedEvent e) async {
    re_index();
    final int idx = e.idx;
    if (idx < 0 || idx >= state_manager.rows.length) return;

    final String id = state_manager.rows[idx].cells[Front_Desk.ID]?.value?.toString() ?? "";
    if (id.isEmpty) return;

    final String? prev_id = idx > 0 ? state_manager.rows[idx - 1].cells[Front_Desk.ID]?.value?.toString() : null;
    final String? next_id = idx < state_manager.rows.length - 1 ? state_manager.rows[idx + 1].cells[Front_Desk.ID]?.value?.toString() : null;

    final res = await dio.post(endpoint.FRONT_DESK_UPDATE_ORDER, data: {"_id": id, if (prev_id != null && prev_id.isNotEmpty) "prev_id": prev_id, if (next_id != null && next_id.isNotEmpty) "next_id": next_id});
    if (res == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "Failed to update order", cl: Colors.red);
    } else {
      snackbar(ct: context, ms: "Order updated", cl: Colors.green);
    }
  }

  // ########## DIALOG ACTIONS ##########
  Future<void> on_check_in(dynamic r) async {
    final v = await dialog_check_in(context: context, lead: "Room ${r[Room.NUMBER]}", room_number: r[Room.NUMBER]);
    if (v == true) await on_load_dashboard(current_shift);
  }

  Future<void> on_check_out(dynamic r) async {
    final room_number = (r[Room.NUMBER] ?? "").toString();
    if (room_number.isEmpty) return;
    final v = await dialog_check_out(context: context, lead: "Room $room_number", room_number: room_number);
    if (v == true) await on_load_dashboard(current_shift);
  }

  Future<void> on_clean(dynamic r) async {
    final v = await dialog_clean(context: context, lead: "Room ${r[Room.NUMBER]}", room_number: r[Room.NUMBER]);
    if (v == true) await on_load_dashboard(current_shift);
  }

  Future<void> on_mini_bar_only() async {
    final v = await dialog_add_mini_bar(context: context);
    if (v == true) await on_load_dashboard(current_shift);
  }

  void on_update_room(PlutoColumnRendererContext rc) async {
    if (is_row_mini_bar(rc)) return;
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final room_number = await dialog_room_search(context: context);
    if (room_number == null) return;
    state_manager.changeCellValue(rc.cell, room_number, force: true, callOnChangedEvent: false);
    do_updated(fd_id, Front_Desk.ROOM_NUMBER, room_number);
  }

  Future<void> on_search_guest(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final name_phone = await dialog_guest_search(context: context, fd_id: fd_id);
    if (name_phone == null) return;
    state_manager.changeCellValue(rc.cell, name_phone, force: true, callOnChangedEvent: false);
  }

  Future<void> on_add_guest(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final name_phone = await dialog_guest_add(context: context, fd_id: fd_id);
    if (name_phone == null) return;
    state_manager.changeCellValue(rc.cell, name_phone, force: true, callOnChangedEvent: false);
  }

  void on_guest_update(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final fd = data.where((x) => x.id == fd_id).firstOrNull;
    final guest = fd?.guest_id is Guest_Show ? fd!.guest_id as Guest_Show : null;

    final name_phone = await dialog_guest_update(context: context, fd_id: fd_id, guest_id: guest?.id ?? "", current_name: guest?.full_name ?? "", current_phone: guest?.phone_number ?? "");
    if (name_phone == null) return;
    state_manager.changeCellValue(rc.cell, name_phone, force: true, callOnChangedEvent: false);
  }

  void on_update_number_of_guest(PlutoColumnRendererContext rc, double v) {
    if (is_row_mini_bar(rc)) return;
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    state_manager.changeCellValue(rc.cell, v, force: true, callOnChangedEvent: false);
    do_updated(fd_id, Front_Desk.NUMBER_OF_GUEST, v.toInt());
  }

  Future<void> on_update_check_in_at(PlutoColumnRendererContext rc) async {
    if (is_row_mini_bar(rc)) return;
    DateTime dt = parse_datetime(rc.cell.value) ?? DateTime.now();
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;
    final v = await dialog_check_in_at_select(context: context, initial: dt);
    if (v == null) return;
    state_manager.changeCellValue(rc.cell, format_datetime(v), force: true, callOnChangedEvent: false);
    do_updated(id, Front_Desk.CHECK_IN_AT, v);
  }

  Future<void> on_update_check_out_at(PlutoColumnRendererContext rc) async {
    if (is_row_mini_bar(rc)) return;
    DateTime dt = parse_datetime(rc.cell.value) ?? DateTime.now();
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;
    final check_in = parse_datetime(rc.row.cells[Front_Desk.CHECK_IN_AT]?.value);
    final v = await dialog_check_out_at_select(context: context, initial: dt, check_in_at: check_in);
    if (v == null) return;
    state_manager.changeCellValue(rc.cell, format_datetime(v), force: true, callOnChangedEvent: false);
    do_updated(id, Front_Desk.CHECK_OUT_AT, v);
  }

  Future<void> on_update_carry_over(PlutoColumnRendererContext rc) async {
    if (is_row_mini_bar(rc)) return;
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final tmp = await dio.post(endpoint.FRONT_DESK_CARRY_OVER_ONE, data: {Front_Desk.ID: fd_id});
    if (tmp == null) {
      return snackbar(ct: context, ms: dio.error_msg ?? "Failed to carry over", cl: Colors.red);
    }
    snackbar(ct: context, ms: "Carried Over", cl: Colors.green);
    await on_load_dashboard(current_shift);
  }

  void on_mini_bar_item(PlutoColumnRendererContext rc) async {
    String? fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update mini bar", cl: Colors.red);
    Front_Desk? fd = data.where((x) => x.id == fd_id).firstOrNull;

    List<Order_Mini_Bar> orders = [
      for (var it in (fd?.mini_bar_item_id ?? []))
        if (it is Mini_Bar_Item) Order_Mini_Bar.fromJson(it.toJson()),
    ];

    final price = await dialog_mini_bar_select(context: context, list_order_mini_bar: orders, front_desk_id: fd_id, is_walk_in: is_row_mini_bar(rc));
    if (price == null) return;
    state_manager.changeCellValue(rc.row.cells[Front_Desk.MINI_BAR_PRICE]!, price, force: true, callOnChangedEvent: false);
    on_refresh_balanced();
  }

  void on_penalty_item(PlutoColumnRendererContext rc) async {
    if (is_row_mini_bar(rc)) return;
    String? fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update penalty", cl: Colors.red);
    Front_Desk? fd = data.where((x) => x.id == fd_id).firstOrNull;

    List<Order_Penalty> orders = [
      for (var it in (fd?.penalty_item_id ?? []))
        if (it is Penalty_Item) Order_Penalty.fromJson(it.toJson()),
    ];

    final price = await dialog_penalty_select(context: context, list_order_penalty: orders, front_desk_id: fd_id);
    if (price == null) return;
    state_manager.changeCellValue(rc.row.cells[Front_Desk.PENALTY_PRICE]!, price, force: true, callOnChangedEvent: false);
    on_refresh_balanced();
  }

  void on_update_shift_date(PlutoColumnRendererContext rc) async {
    if (is_row_mini_bar(rc)) return;
    DateTime dt = parse_datetime(rc.cell.value) ?? DateTime.now();
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;
    final v = await dialog_shift_date_select(context: context, front_desk_id: id, initial: dt);
    if (v == null) return;
    await on_load_dashboard(current_shift);
  }

  Future<void> on_previous_day() async {
    current_shift = current_shift.subtract(const Duration(days: 1));
    await on_load_dashboard(current_shift);
  }

  Future<void> on_goto_day() async {
    final picked = await showDatePicker(context: context, initialDate: current_shift, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked == null) return;
    current_shift = DateTime(picked.year, picked.month, picked.day);
    await on_load_dashboard(current_shift);
  }

  Future<void> on_next_day() async {
    current_shift = current_shift.add(const Duration(days: 1));
    await on_load_dashboard(current_shift);
  }

  void on_filter() {
    state_manager.setShowColumnFilter(!filter);
    if (!filter) state_manager.setFilterWithFilterRows([]);
    filter = !filter;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load_auth();
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(MaterialApp(home: const Main_(), theme: theme_data, title: "Development", debugShowCheckedModeBanner: false));
}
