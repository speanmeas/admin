import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "dialog/guest_search.dart";
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
  int current_page = 1;

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
            DateFormat("yyyy-MM-dd").format(page_day(current_page)), //
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
            enableEditingMode: false,
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
                    tooltip: "ស្វែងរក", //
                    icon: Icon(Icons.search_outlined),
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
            title: "ឈ្មោះ - លេខទូរស័ព្ទ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 200,
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
                    tooltip: "Add Guest", //
                    icon: Icon(Icons.person_add_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: "Search Guest", //
                    icon: Icon(Icons.search_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_search_guest(rc), //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Front_Desk.NUMBER_OF_GUEST, //
            title: "ចំនួន",
            type: PlutoColumnType.select([]),
            enableEditingMode: false,
            width: 70,
            renderer: (rc) {
              double value = rc.cell.value is double ? rc.cell.value as double : 0.0;
              return PopupMenuButton<double>(
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value == 0 ? "" : "${value.toInt()} នាក់", //
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ],
                ),
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
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
              if (hour > 0) text += "$hour ម៉ោង ";
              if (minute > 0 || text.isEmpty) text += "$minute នាទី";
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
            enableEditingMode: false,
            width: 160,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
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
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
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
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
                    ),
                  ),
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
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  if (is_admin || kDebugMode)
                    IconButton(
                      tooltip: "ជ្រើសអ្នកចូល", //
                      icon: Icon(Icons.search_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_select_check_in_by(rc), //
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
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  if (is_admin || kDebugMode)
                    IconButton(
                      tooltip: "ជ្រើសអ្នកចេញ", //
                      icon: Icon(Icons.search_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () => on_select_check_out_by(rc), //
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
              final v = rc.cell.value is DateTime ? rc.cell.value as DateTime : null;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(
                        v == null ? "" : DateFormat("yyyy-MM-dd").format(v), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: "កែថ្ងៃ", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_update_shift_date(rc), //
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
      ),
    );
  }
  // * ########## BLOCK DESIGN END ##########

  // * ########## BLOCK METHODS ##########
  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;

    state_manager.setAutoEditing(true);
    state_manager.columnFooterHeight = 32;
    list_column_pluto = state_manager.refColumns.toList();

    on_load_page(current_page);
  }

  // * ទាញតួនាទីអ្នកប្រើសម្រាប់កំណត់ការកែប្រែ cell
  Future<void> load_auth() async {
    final user = await auth.fetch();
    if (user == null) return;
    is_admin = user.is_admin == true;
    reload++;
    setState(() {});
  }

  Future<void> on_reload() async {
    await load_auth();
    await on_load_page(current_page);
    snackbar(ct: context, ms: "Reloaded", cl: Colors.green);
  }

  DateTime shift_day() {
    final d = DateTime.now().subtract(const Duration(hours: 7));
    return DateTime(d.year, d.month, d.day);
  }

  DateTime page_day(int p) => shift_day().subtract(Duration(days: p - 1));

  Future<void> on_fetch_page(int p) async {
    final day = page_day(p);
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
  }

  Future<void> on_load_page(int p) async {
    await on_fetch_page(p);

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
                if (c.field == "duration") return PlutoCell(value: check_in_duration(d)); // auto
                if (c.field == Front_Desk.ID) return PlutoCell(value: d.id ?? "");
                if (c.field == Front_Desk.SHIFT_DATE) return PlutoCell(value: d.shift_date);
                if (c.field == Front_Desk.ROOM_NUMBER) return PlutoCell(value: d.room_number ?? "");
                if (c.field == Front_Desk.CHECK_IN_AT) return PlutoCell(value: d.check_in_at);
                if (c.field == Front_Desk.CHECK_OUT_AT) return PlutoCell(value: d.check_out_at);
                if (c.field == Front_Desk.GUEST_ID) {
                  final g = d.guest_id;
                  return PlutoCell(value: g == null ? "" : "${g.full_name ?? "N/A"} (${g.phone_number ?? "N/A"})");
                }
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
                return PlutoCell(value: "");
              })(),
          },
        ),
    ]);

    on_reindex();
    setState(() {});
  }

  Future<void> on_reindex() async {
    for (int i = 0; i < state_manager.rows.length; i++) {
      final row = state_manager.rows[i];
      state_manager.changeCellValue(row.cells["index"]!, i + 1, force: true, callOnChangedEvent: false);
    }
  }

  Future<void> on_refresh_duration() async {
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
        row.cells["duration"]!, //
        check_in_duration(fd),
        force: true,
        callOnChangedEvent: false,
      );
    }
  }

  int check_in_duration(Front_Desk fd) {
    if ((fd.room_number ?? "").toLowerCase() == "walk-in") return 0;
    DateTime? in_at = fd.check_in_at;
    DateTime? out_at = fd.check_out_at;
    if (in_at == null) return 0;
    if (out_at == null) return DateTime.now().difference(in_at).inMinutes;
    return out_at.difference(in_at).inMinutes;
  }

  Future<void> on_refresh_balanced() async {
    await on_fetch_page(current_page);
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
        Front_Desk.SHIFT_DATE: page_day(current_page).toIso8601String(), //
      },
    );
    if (tmp == null) {
      await on_load_page(current_page);
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    final created_id = (tmp.data as List?)?.firstOrNull?["_id"] as String?;
    if (created_id != null) {
      row.cells[Front_Desk.ID]!.value = created_id;
      state_manager.notifyListeners();
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
      await on_load_page(current_page);
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    snackbar(ct: context, ms: "Deleted", cl: Colors.green);
  }

  void on_updated(PlutoGridOnChangedEvent e) {
    final fd_id = e.row.cells[Front_Desk.ID]?.value;
    if (e.column.field == Front_Desk.ROOM_PRICE) {
      do_update_room_price(fd_id, e.value);
    } else if (e.column.field == Front_Desk.PAY_CASH) {
      do_update_cash(fd_id, e.value);
    } else if (e.column.field == Front_Desk.PAY_BANK) {
      do_update_bank(fd_id, e.value);
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
      await on_load_page(current_page);
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
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
      await on_load_page(current_page);
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_refresh_balanced();
  }

  Future<void> do_update_bank(String? id, double v) async {
    final tmp = await dio.post(endpoint.FRONT_DESK_UPDATE_PAYMENT, data: {"_id": id, "pay_bank": v});
    if (tmp == null) {
      await on_load_page(current_page);
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_refresh_balanced();
  }

  Future<void> on_update_check_in_at(PlutoColumnRendererContext rc) async {
    DateTime? dt = rc.cell.value is DateTime ? rc.cell.value as DateTime : null;
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;

    final v = await dialog_select_check_in_datetime(context: context, initial: dt);
    if (v == null) return;

    rc.cell.value = DateTime.tryParse(v);
    state_manager.notifyListeners();

    on_refresh_duration();
    do_updated(id, Front_Desk.CHECK_IN_AT, v);
  }

  Future<void> on_update_check_out_at(PlutoColumnRendererContext rc) async {
    DateTime? dt = rc.cell.value is DateTime ? rc.cell.value as DateTime : null;
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;
    final check_in = rc.row.cells[Front_Desk.CHECK_IN_AT]?.value;

    final v = await dialog_select_check_out_datetime(context: context, initial: dt, check_in_at: check_in);
    if (v == null) return;

    rc.cell.value = DateTime.tryParse(v);
    state_manager.notifyListeners();

    on_refresh_duration();
    do_updated(id, Front_Desk.CHECK_OUT_AT, v);
  }

  void on_update_shift_date(PlutoColumnRendererContext rc) async {
    DateTime? dt = rc.cell.value is DateTime ? rc.cell.value as DateTime : null;
    final id = rc.row.cells[Front_Desk.ID]?.value;
    if (id == null) return;

    final v = await dialog_select_shift_date(context: context, front_desk_id: id, initial: dt);
    if (v == null) return;
    await on_load_page(current_page);
  }

  void on_select_check_in_by(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final full_name = await dialog_select_check_in_by(context: context, front_desk_id: fd_id);
    if (full_name == null) return;
    rc.cell.value = full_name;
    state_manager.notifyListeners();
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
  }

  void on_select_check_out_by(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    final full_name = await dialog_select_check_out_by(context: context, fd_id: fd_id);
    if (full_name == null) return;
    rc.cell.value = full_name;
    state_manager.notifyListeners();
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

    final price = await dialog_select_mini_bar(
      context: context, //
      list_order_mini_bar: orders, //
      front_desk_id: fd_id, //
      is_walk_in: is_row_mini_bar(rc), //
    );
    if (price == null) return;

    state_manager.changeCellValue(rc.row.cells[Front_Desk.MINI_BAR_PRICE]!, price, force: true, callOnChangedEvent: false);
    state_manager.notifyListeners();
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

    final price = await dialog_select_penalty(
      context: context, //
      list_order_penalty: orders, //
      front_desk_id: fd_id, //
    );
    if (price == null) return;

    state_manager.changeCellValue(rc.row.cells[Front_Desk.PENALTY_PRICE]!, price, force: true, callOnChangedEvent: false);
    state_manager.notifyListeners();
    on_refresh_balanced();
  }

  void on_update_number_of_guest(PlutoColumnRendererContext rc, double v) {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    rc.cell.value = v;
    state_manager.notifyListeners();
    do_updated(fd_id, Front_Desk.NUMBER_OF_GUEST, v);
  }

  void on_update_room(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;

    final room_number = await dialog_select_room(context: context);
    if (room_number == null) return;

    rc.cell.value = room_number;
    state_manager.notifyListeners();

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
      await on_load_page(current_page);
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }

    snackbar(ct: context, ms: "Updated", cl: Colors.green);
  }

  Future<void> on_search_guest(PlutoColumnRendererContext rc) async {
    final fd_id = rc.row.cells[Front_Desk.ID]?.value;
    if (fd_id == null) return;
    await dialog_search_guest(context: context, fd_id: fd_id);
    await on_reload();
  }

  Future<void> do_update_guest(String? fd_id, String? guest_id) async {
    final tmp = await dio.post(
      endpoint.FRONT_DESK_UPDATE_GUEST_INFO,
      data: {
        Front_Desk.ID: fd_id, //
        Front_Desk.GUEST_ID: guest_id, //
      },
    );
    if (tmp == null) {
      await on_reload();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }
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

  // * បង្ហាញតម្លៃលុយ (ថ្លៃបន្ទប់ / មីនីបារ / ពិន័យ) — ដូច report (center, no color, null-safe)
  Widget _money(PlutoColumnRendererContext rc) {
    return Align(
      alignment: Alignment.center, //
      child: Text(
        format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", //
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // * សាច់ប្រាក់/ធនាគារ — ដូច report (center; ខ្មៅ = វិជ្ជមាន, ក្រហម = អវិជ្ជមាន)
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

  // * សមតុល្យ — ដូច report (center; ខ្មៅ = 0, បៃតង = >0, ក្រហម = <0)
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

  // * footer ជួរសរុប (sum) — ដូច report (center, no color)
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

  // * មើលថ្ងៃម្សិលមិញ (page បន្ទាប់ = ថ្ងៃកន្លងទៅ 1 ថ្ងៃទៀត)
  Future<void> on_previous_day() async {
    current_page = current_page + 1;
    await on_load_page(current_page);
  }

  // * ជ្រើសកាលបរិច្ឆេទដោយផ្ទាល់ → លោតទៅទំព័រនៃថ្ងៃនោះ
  Future<void> on_goto_day() async {
    final picked = await showDatePicker(
      context: context, //
      initialDate: page_day(current_page), //
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final picked_day = DateTime(picked.year, picked.month, picked.day);
    current_page = shift_day().difference(picked_day).inDays + 1;
    if (current_page < 1) current_page = 1;
    await on_load_page(current_page);
  }

  // * មើលថ្ងៃស្អែក (page មុន = ថ្ងៃជិតជាងនេះ, ឈប់នៅថ្ងៃនេះ)
  Future<void> on_next_day() async {
    if (current_page == 1) return;
    current_page = current_page - 1;
    await on_load_page(current_page);
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
