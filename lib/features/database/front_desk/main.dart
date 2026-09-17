import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "dialog/guest_add.dart";
import "dialog/guest_search.dart";
import "dialog/guest_update.dart";
import "dialog/check_in_by_search.dart";
import "dialog/check_in_at_select.dart";
import "dialog/check_out_by_search.dart";
import "dialog/check_out_at_select.dart";
import "dialog/mini_bar_select.dart";
import "dialog/penalty_select.dart";
import "dialog/room_search.dart";
import "dialog/shift_date_select.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK ATTRIBUTE ##########
  int reload = 0;
  bool filter = false;
  bool is_admin = false;
  late DateTime current_shift;

  late List<PlutoColumn> list_column_pluto;
  late PlutoGridStateManager state_manager;

  List<Front_Desk> data = [];

  Timer? _timer;

  // * ########## BLOCK ATTRIBUTE END ##########

  // * ########## BLOCK DESIGN ##########
  Widget _layout({
    List<Widget>? header, //
    Widget? body, //
  }) {
    return Scaffold(
      body: Column(
        spacing: 1,
        children: [
          if (header != null)
            Container(
              height: 32, //
              padding: const EdgeInsets.all(1),
              child: Row(
                spacing: 1, //
                children: header,
              ),
            ),

          if (body != null) //
            Expanded(child: body),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _layout(
      header: [
        IconButton(
          tooltip: "Goto Previous Day", //
          icon: Icon(Icons.navigate_before, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_previous_day,
        ),

        TextButton(
          child: Text(
            DateFormat("yyyy-MM-dd").format(current_shift), //
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: on_goto_day,
        ),

        IconButton(
          tooltip: "Goto Next Day", //
          icon: Icon(Icons.navigate_next, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_next_day,
        ),

        const Spacer(),

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
          // * action: add / delete (first column)
          PlutoColumn(
            field: "action", //
            title: "",
            titleSpan: WidgetSpan(
              child: Container(
                alignment: Alignment.center, //
                child: IconButton(
                  tooltip: "Add Row", //
                  icon: Icon(Icons.add_circle_outline, size: 28), //
                  padding: EdgeInsets.all(0),
                  constraints: BoxConstraints(),
                  onPressed: on_create,
                ),
              ),
            ),
            titlePadding: EdgeInsets.all(0),
            type: PlutoColumnType.number(),
            width: 40,
            enableEditingMode: false,
            enableColumnDrag: false,
            enableContextMenu: false,
            enableDropToResize: false,
            enableFilterMenuItem: false,
            enableSorting: false,
            cellPadding: EdgeInsets.all(0),
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "Remove Row", //
                    icon: Icon(Icons.remove_circle_outline, size: 28, color: Colors.red),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_delete(rc),
                  ),
                ],
              );
            },
          ),

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
            // enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "ស្វែងរក", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_update_room(rc), //
                  ),
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
            field: Front_Desk.GUEST_ID, //
            title: "ឈ្មោះ (លេខទូរស័ព្ទ)",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 200,
            renderer: (rc) {
              final guest_cell_value = rc.cell.value;
              final no_guest_id = guest_cell_value == null || (guest_cell_value is String && guest_cell_value.isEmpty);
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
            // enableEditingMode: false,
            width: 70,
            renderer: (rc) {
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
                    menuPadding: const EdgeInsets.all(0),
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
            // enableEditingMode: false,
            width: 160,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
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
            field: "duration", //
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
              if (day > 0 || hour > 0) text += "$hour ម៉ោង ";
              text += "$minute នាទី";
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  text, //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.CHECK_OUT_AT, //
            title: "ពេលចេញ",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: 160,
            renderer: (rc) {
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
                ],
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.ROOM_PRICE, //
            title: "ថ្លៃបន្ទប់",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: true,
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

          // * ការត្រួតពិនិត្យ
          PlutoColumn(
            field: Front_Desk.CHECK_IN_BY, //
            title: "ឲចូលដោយ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 140,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  if (is_admin || kDebugMode)
                    IconButton(
                      tooltip: "ជ្រើសអ្នកចូល", //
                      icon: Icon(Icons.search_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_select_check_in_by(rc), //
                    ),
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
            field: Front_Desk.CHECK_OUT_BY, //
            title: "ឲចេញដោយ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 140,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  if (is_admin || kDebugMode)
                    IconButton(
                      tooltip: "ជ្រើសអ្នកចេញ", //
                      icon: Icon(Icons.search_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_select_check_out_by(rc), //
                    ),
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
            field: Front_Desk.SHIFT_DATE, //
            title: "របាយការណ៍ថ្ងៃ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              final v = parse_datetime(rc.cell.value);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
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

          // BUTTON RECEIPT
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
        ], //
        columnGroups: [
          PlutoColumnGroup(
            title: "", //
            fields: [
              Front_Desk.ID, //
              Front_Desk.SHIFT_DATE, //
              Front_Desk.ROOM_NUMBER, //
              "action", //
              "index", //
              "other",
            ],
          ),
          PlutoColumnGroup(
            title: "ការស្នាក់នៅ", //
            fields: [
              Front_Desk.CHECK_IN_AT, //
              "duration", //
              Front_Desk.CHECK_OUT_AT,
            ],
          ),
          PlutoColumnGroup(
            title: "អតិថិជន", //
            fields: [
              Front_Desk.GUEST_ID, //
              Front_Desk.NUMBER_OF_GUEST,
            ],
          ),
          PlutoColumnGroup(
            title: "ការបង់ប្រាក់", //
            fields: [
              Front_Desk.ROOM_PRICE, //
              Front_Desk.MINI_BAR_PRICE, //
              Front_Desk.PENALTY_PRICE, //
              Front_Desk.PAY_CASH, //
              Front_Desk.PAY_BANK, //
              Front_Desk.PAY_BALANCE, //
              Front_Desk.PAY_NOTE,
            ],
          ),
          PlutoColumnGroup(
            title: "ការត្រួតពិនិត្យ", //
            fields: [
              Front_Desk.CHECK_IN_BY, //
              Front_Desk.CHECK_OUT_BY,
            ],
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
            defaultColumnTitlePadding: EdgeInsets.fromLTRB(4, 0, 26, 0),
            defaultColumnFilterPadding: EdgeInsets.fromLTRB(1, 1, 1, 1),
            defaultCellPadding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          ),
        ),

        onLoaded: on_loaded,
        onChanged: on_updated,
        onRowsMoved: on_rows_moved,
      ),
    );
  }
  // * ########## BLOCK DESIGN END ##########

  // * ########## BLOCK METHODS ##########
  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    // state_manager.setAutoEditing(true);
    state_manager.columnFooterHeight = 32;
    list_column_pluto = state_manager.refColumns.toList();

    on_load_page();
  }

  void re_index() {
    for (int i = 0; i < state_manager.rows.length; i++) {
      final row = state_manager.rows[i];
      state_manager.changeCellValue(row.cells["index"]!, i + 1, force: true, callOnChangedEvent: false);
    }
  }

  Future<void> on_rows_moved(PlutoGridOnRowsMovedEvent e) async {
    re_index();

    final List<Map<String, dynamic>> items = [];

    for (int i = 0; i < state_manager.rows.length; i++) {
      final row = state_manager.rows[i];
      final String id = row.cells[Front_Desk.ID]?.value?.toString() ?? "";
      if (id.isNotEmpty) items.add({"_id": id, "order": (i + 1).toDouble()});
    }

    if (items.isEmpty) return;

    final res = await dio.post(endpoint.FRONT_DESK_UPDATE_ORDER, data: {"items": items});

    if (res == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "Failed to update order", cl: Colors.red);
    } else {
      snackbar(ct: context, ms: "Order updated", cl: Colors.green);
    }
  }

  // * ទាញតួនាទីអ្នកប្រើសម្រាប់កំណត់ការកែប្រែ cell
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
    await on_load_page();
    snackbar(ct: context, ms: "Reloaded", cl: Colors.green);
  }

  DateTime shift_day() {
    final d = DateTime.now().subtract(const Duration(hours: 7));
    return DateTime(d.year, d.month, d.day);
  }

  Future<void> on_fetch_page() async {
    final day = current_shift;
    final start = DateTime(day.year, day.month, day.day);
    final stop = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    final tmp = await dio.post(
      endpoint.FRONT_DESK_READ_DATETIME, //
      data: {
        "key": Front_Desk.SHIFT_DATE, //
        "start": start.toIso8601String(), //
        "stop": stop.toIso8601String(), //
        "order": DEFAULT_ORDER, //
        "link": true, //
      },
    );

    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    data = List<Front_Desk>.from((tmp.data ?? const []).map((d) => Front_Desk.fromJson(d)));
    data.sort((a, b) => (b.created_at ?? DateTime(0)).compareTo(a.created_at ?? DateTime(0)));
  }

  Future<void> on_load_page() async {
    await on_fetch_page();

    // * បន្ថែមជួរដេកថ្មីទៅក្នុងតារាង
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, d) in data.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column_pluto) //
              c.field: (() {
                if (c.field == "action") return PlutoCell(value: ""); //auto
                if (c.field == "index") return PlutoCell(value: i + 1); // auto
                if (c.field == Front_Desk.ID) return PlutoCell(value: d.id ?? "");
                if (c.field == Front_Desk.ROOM_NUMBER) return PlutoCell(value: d.room_number ?? "");
                if (c.field == Front_Desk.CHECK_IN_AT) return PlutoCell(value: format_datetime(d.check_in_at));
                if (c.field == "duration") return PlutoCell(value: check_in_duration(d.check_in_at, d.check_out_at, d.room_number)); // auto
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
  }

  Future<void> on_reindex() async {
    for (int i = 0; i < state_manager.rows.length; i++) {
      final row = state_manager.rows[i];
      state_manager.changeCellValue(row.cells["index"]!, i + 1, force: true, callOnChangedEvent: false);
    }
  }

  Future<void> on_refresh_duration() async {
    for (var row in state_manager.rows) {
      final in_at = parse_datetime(row.cells[Front_Desk.CHECK_IN_AT]?.value);
      final out_at = parse_datetime(row.cells[Front_Desk.CHECK_OUT_AT]?.value);
      final room = format_string(row.cells[Front_Desk.ROOM_NUMBER]?.value);
      state_manager.changeCellValue(
        row.cells["duration"]!, //
        check_in_duration(in_at, out_at, room),
        force: true,
        callOnChangedEvent: false,
      );
    }
  }

  int check_in_duration(DateTime? in_at, DateTime? out_at, String? room_number) {
    final is_walking = (room_number ?? "").toLowerCase() == "walk-in";
    if (is_walking) return 0;
    if (in_at == null) return 0;
    if (out_at == null) return DateTime.now().difference(in_at).inMinutes;
    return out_at.difference(in_at).inMinutes;
  }

  Future<void> on_refresh_balanced() async {
    await on_fetch_page();
    for (var row in state_manager.rows) {
      final id = row.cells[Front_Desk.ID]?.value;
      Front_Desk? fd;
      for (var d in data) {
        if (d.id == id) {
          fd = d;
          break;
        }
      }
      if (fd == null) continue;
      state_manager.changeCellValue(
        row.cells[Front_Desk.PAY_BALANCE]!, //
        fd.pay_balance ?? 0.0,
        force: true,
        callOnChangedEvent: false,
      );
    }
  }

  void on_create() {
    final row = PlutoRow(
      cells: {
        for (var c in list_column_pluto) //
          c.field: PlutoCell(
            value: (() {
              if (c.field == Front_Desk.NUMBER_OF_GUEST) return 1;
              if (c.field == Front_Desk.SHIFT_DATE) return format_datetime(current_shift);
              if (c.type is PlutoColumnTypeNumber) return 0;
              if (c.type is PlutoColumnTypeText) return "";
              return null;
            })(),
          ),
      },
    );
    state_manager.insertRows(0, [row]);
    on_reindex();
    do_create(row);
  }

  Future<void> do_create(PlutoRow row) async {
    final tmp = await dio.post(
      endpoint.FRONT_DESK_CREATE,
      data: {
        Front_Desk.NUMBER_OF_GUEST: 1, //
        Front_Desk.SHIFT_DATE: current_shift.toIso8601String(), //
      },
    );
    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      await on_load_page();
      return;
    }
    final created_id = (tmp.data as List?)?.firstOrNull?["_id"] as String?;
    if (created_id != null) {
      state_manager.changeCellValue(row.cells[Front_Desk.ID]!, created_id, force: true, callOnChangedEvent: false);
    }
    snackbar(ct: context, ms: "Created", cl: Colors.green);
  }

  void on_delete(PlutoColumnRendererContext rc) {
    state_manager.removeRows([rc.row]);
    on_reindex();

    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;
    do_delete(id);
  }

  Future<void> do_delete(String? id) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_DELETE, data: {Front_Desk.ID: id});
    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      await on_load_page();
      return;
    }
    snackbar(ct: context, ms: "Deleted", cl: Colors.green);
  }

  void on_updated(PlutoGridOnChangedEvent e) {
    final fd_id = e.row.cells[Front_Desk.ID]?.value;
    state_manager.notifyListeners();
    if (e.column.field == Front_Desk.ROOM_PRICE) {
      do_update_room_price(fd_id, parse_double(e.value) ?? 0.0);
    } else if (e.column.field == Front_Desk.PAY_CASH) {
      do_update_cash(fd_id, parse_double(e.value) ?? 0.0);
    } else if (e.column.field == Front_Desk.PAY_BANK) {
      do_update_bank(fd_id, parse_double(e.value) ?? 0.0);
    } else {
      do_updated(fd_id, e.column.field, e.value);
    }
  }

  Future<void> do_update_room_price(String? id, double v) async {
    final tmp = await dio.post(
      endpoint.FRONT_DESK_UPDATE_ROOM_PRICE, //
      data: {
        Front_Desk.ID: id, //
        Front_Desk.ROOM_PRICE: v,
      },
    );
    if (tmp == null) {
      await on_load_page();
      return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_refresh_balanced();
  }

  Future<void> do_update_cash(String? id, double v) async {
    final tmp = await dio.post(
      endpoint.FRONT_DESK_UPDATE_PAYMENT,
      data: {
        "_id": id, //
        "pay_cash": v,
      },
    );
    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      await on_load_page();
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_refresh_balanced();
  }

  Future<void> do_update_bank(String? id, double v) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE_PAYMENT, data: {"_id": id, "pay_bank": v});
    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      await on_load_page();
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_refresh_balanced();
  }

  Future<void> on_update_check_in_at(PlutoColumnRendererContext rc) async {
    DateTime dt = parse_datetime(rc.cell.value) ?? DateTime.now();
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;

    final v = await dialog_check_in_at_select(context: context, initial: dt);
    if (v == null) return;

    state_manager.changeCellValue(rc.cell, format_datetime(v), force: true, callOnChangedEvent: false);

    on_refresh_duration();
    do_updated(id, Front_Desk.CHECK_IN_AT, v);
  }

  Future<void> on_update_check_out_at(PlutoColumnRendererContext rc) async {
    DateTime dt = parse_datetime(rc.cell.value) ?? DateTime.now();
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;
    final check_in = parse_datetime(rc.row.cells[Front_Desk.CHECK_IN_AT]?.value);

    final v = await dialog_check_out_at_select(context: context, initial: dt, check_in_at: check_in);
    if (v == null) return;

    state_manager.changeCellValue(rc.cell, format_datetime(v), force: true, callOnChangedEvent: false);

    on_refresh_duration();
    do_updated(id, Front_Desk.CHECK_OUT_AT, v);
  }

  void on_update_shift_date(PlutoColumnRendererContext rc) async {
    DateTime dt = parse_datetime(rc.cell.value) ?? DateTime.now();
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;

    final v = await dialog_shift_date_select(context: context, front_desk_id: id, initial: dt);
    if (v == null) return;
    await on_load_page();
  }

  void on_select_check_in_by(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final full_name = await dialog_check_in_by_search(context: context, front_desk_id: fd_id);
    if (full_name == null) return;
    state_manager.changeCellValue(rc.cell, full_name, force: true, callOnChangedEvent: false);
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
  }

  void on_select_check_out_by(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final full_name = await dialog_check_out_by_search(context: context, fd_id: fd_id);
    if (full_name == null) return;
    state_manager.changeCellValue(rc.cell, full_name, force: true, callOnChangedEvent: false);
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
  }

  void on_mini_bar_item(PlutoColumnRendererContext rc) async {
    String? fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update mini bar", cl: Colors.red);

    Front_Desk? fd = data.where((x) => x.id == fd_id).firstOrNull;

    List<Order_Mini_Bar> orders = [
      for (var it in (fd?.mini_bar_item_id ?? []))
        if (it is Mini_Bar_Item) Order_Mini_Bar.fromJson(it.toJson()),
    ];

    final price = await dialog_mini_bar_select(
      context: context, //
      list_order_mini_bar: orders, //
      front_desk_id: fd_id, //
      is_walk_in: is_row_mini_bar(rc), //
    );
    if (price == null) return;

    state_manager.changeCellValue(rc.row.cells[Front_Desk.MINI_BAR_PRICE]!, price, force: true, callOnChangedEvent: false);
    on_refresh_balanced();
  }

  void on_penalty_item(PlutoColumnRendererContext rc) async {
    String? fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update penalty", cl: Colors.red);

    Front_Desk? fd = data.where((x) => x.id == fd_id).firstOrNull;

    List<Order_Penalty> orders = [
      for (var it in (fd?.penalty_item_id ?? []))
        if (it is Penalty_Item) Order_Penalty.fromJson(it.toJson()),
    ];

    final price = await dialog_penalty_select(
      context: context, //
      list_order_penalty: orders, //
      front_desk_id: fd_id, //
    );
    if (price == null) return;

    state_manager.changeCellValue(rc.row.cells[Front_Desk.PENALTY_PRICE]!, price, force: true, callOnChangedEvent: false);
    on_refresh_balanced();
  }

  void on_update_number_of_guest(PlutoColumnRendererContext rc, double v) {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    state_manager.changeCellValue(rc.cell, v, force: true, callOnChangedEvent: false);
    do_updated(fd_id, Front_Desk.NUMBER_OF_GUEST, v.toInt());
  }

  void on_update_room(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;

    final room_number = await dialog_room_search(context: context);
    if (room_number == null) return;

    state_manager.changeCellValue(rc.cell, room_number, force: true, callOnChangedEvent: false);

    do_updated(fd_id, Front_Desk.ROOM_NUMBER, room_number);
  }

  Future<void> do_updated(String? fd_id, String field, dynamic value) async {
    final tmp = await dio.post(
      endpoint.FRONT_DESK_UPDATE, //
      data: {
        Front_Desk.ID: fd_id, //
        field: value,
      },
    );

    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      await on_load_page();
      return;
    }

    snackbar(ct: context, ms: "Updated", cl: Colors.green);
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
    final guest_id = (fd?.guest_id is Guest_Show) ? (fd!.guest_id as Guest_Show).id ?? "" : "";

    String cell_value = rc.cell.value?.toString() ?? "";
    String? current_name;
    String? current_phone;

    if (cell_value.contains("(") && cell_value.endsWith(")")) {
      int idx = cell_value.lastIndexOf("(");
      current_name = cell_value.substring(0, idx).trim();
      current_phone = cell_value.substring(idx + 1, cell_value.length - 1).trim();
    } else {
      current_name = cell_value.trim();
    }

    if (current_name == "N/A") current_name = "";
    if (current_phone == "N/A") current_phone = "";

    final name_phone = await dialog_guest_update(
      context: context, //
      fd_id: fd_id, //
      guest_id: guest_id, //
      current_name: current_name, //
      current_phone: current_phone, //
    );
    if (name_phone == null) return;
    state_manager.changeCellValue(rc.cell, name_phone, force: true, callOnChangedEvent: false);
  }

  Future<void> do_update_guest(String? fd_id, String? guest_id) async {
    final tmp = await dio.post(
      endpoint.FRONT_DESK_UPDATE_GUEST_INFO,
      data: {
        Front_Desk.ID: fd_id, //
        Front_Desk.GUEST_ID: guest_id, //
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_reload();
  }

  bool is_row_mini_bar(PlutoColumnRendererContext rc) {
    String? fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return false;
    Front_Desk? fd = data.where((x) => x.id == fd_id).firstOrNull;
    final n = (fd?.room_number ?? "").toLowerCase();
    return n == "walk-in" || n == "mini bar";
  }

  String user_name(dynamic v) {
    if (v is User_Show) return v.full_name ?? "";
    return format_string(v);
  }

  String guest_name_phone(dynamic v) {
    if (v == null) return "";
    if (v is Guest_Show) return "${v.full_name ?? "N/A"} (${v.phone_number ?? "N/A"})";
    return format_string(v);
  }

  // * រយៈពេលស្នាក់ជាថ្ងៃ ម៉ោង និងនាទី
  String duration_text(DateTime? in_at, DateTime? out_at) {
    if (in_at == null) return "";
    DateTime end = out_at ?? DateTime.now();
    int minutes = end.difference(in_at).inMinutes;
    if (minutes < 0) return "";
    int day = minutes ~/ 1440;
    int hour = (minutes % 1440) ~/ 60;
    int minute = minutes % 60;
    String text = "";
    if (day > 0) text += "$day ថ្ងៃ ";
    if (hour > 0 || day > 0) text += "$hour ម៉ោង ";
    text += "$minute នាទី";
    return text.trim();
  }

  Widget _money(PlutoColumnRendererContext rc) {
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

  Future<void> on_previous_day() async {
    current_shift = current_shift.subtract(const Duration(days: 1));
    setState(() {});
    await on_load_page();
  }

  Future<void> on_goto_day() async {
    final picked = await showDatePicker(
      context: context, //
      initialDate: current_shift, //
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    current_shift = DateTime(picked.year, picked.month, picked.day);
    setState(() {});
    await on_load_page();
  }

  Future<void> on_next_day() async {
    current_shift = current_shift.add(const Duration(days: 1));
    setState(() {});
    await on_load_page();
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
    current_shift = shift_day();
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

  // * ########## BLOCK METHODS END ##########
}

// * ថ្នាក់ Main_ ជាទំព័រគ្រប់គ្រង front desk
class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
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
