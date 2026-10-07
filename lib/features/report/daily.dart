import "dart:js_interop";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:web/web.dart" as web;

class _Main_State extends State<Main_> {
  // ########## BLOCK ATTRIBUTE ##########
  int reload = 0;
  bool filter = false;
  bool downloading = false;
  bool downloading_summary = false;
  double WIDTH = 120;

  late List<PlutoColumn> list_column_pluto;
  late PlutoGridStateManager state_manager;

  DateTime date = DateTime.now();
  dynamic report;
  List<Front_Desk> rows = [];
  Map<String, dynamic> summary = {};
  // ########## BLOCK ATTRIBUTE END ##########

  // ########## BLOCK DESIGN ##########
  Widget _layout({
    List<Widget>? header, //
    Widget? body, //
    List<Widget>? footer, //
  }) {
    return Scaffold(
      body: Column(
        spacing: 1,
        children: [
          if (header != null)
            Container(
              height: 34, //
              padding: const EdgeInsets.all(1),
              child: Row(
                spacing: 1, //
                children: header,
              ),
            ),

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
      header: [
        IconButton(
          tooltip: "Previous", //
          icon: Icon(Icons.navigate_before, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {
            date = date.subtract(const Duration(days: 1));
            on_load_page();
          },
        ),

        TextButton(
          onPressed: pick_date,
          child: Text(
            DateFormat("yyyy-MM-dd").format(date), //
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        IconButton(
          tooltip: "Next", //
          icon: Icon(Icons.navigate_next, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {
            date = date.add(const Duration(days: 1));
            on_load_page();
          },
        ),

        const Spacer(),

        IconButton(
          tooltip: "Download Excel", //
          icon: downloading ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : SvgPicture.asset("assets/icon/excel.svg", width: 30, height: 30),
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          color: Colors.blue,
          onPressed: on_download,
        ),

        IconButton(
          tooltip: "Download Summary Excel", //
          icon: downloading_summary
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset("assets/icon/excel.svg", width: 30, height: 30),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0.5),
                        decoration: BoxDecoration(color: Colors.blue.shade700, borderRadius: BorderRadius.circular(3)),
                        child: const Text(
                          "SUM",
                          style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold, height: 1.1),
                        ),
                      ),
                    ),
                  ],
                ),
          padding: EdgeInsets.all(0),
          color: Colors.blue,
          constraints: BoxConstraints(),
          onPressed: on_download_summary,
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
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
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
              return Align(
                alignment: Alignment.center, //
                child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),
          PlutoColumn(
            field: "check_out_at", //
            title: "ពេលចេញ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 160,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          PlutoColumn(
            field: "guest_name", //
            title: "ឈ្មោះ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: WIDTH,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),
          PlutoColumn(
            field: "guest_phone", //
            title: "លេខទូរស័ព្ទ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: WIDTH,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),
          PlutoColumn(
            field: "number_of_guest", //
            title: "ចំនួន",
            type: PlutoColumnType.number(negative: false, format: "#,###"),
            enableEditingMode: false,
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
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: "mini_bar_price", //
            title: "ថ្លៃមីនីបារ",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
              );
            },
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: "penalty_price", //
            title: "ថ្លៃពិន័យ",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
              );
            },
            footerRenderer: (rc) => _sum_footer(rc),
          ),

          PlutoColumn(
            field: "pay_cash", //
            title: "លុយ",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money_cash_bank(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "pay_bank", //
            title: "ធនាគារ",
            type: PlutoColumnType.number(negative: false, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money_cash_bank(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "pay_balance", //
            title: "សមតុល្យ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money_balance(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "pay_note", //
            title: "ចំណាំ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          PlutoColumn(
            field: "check_in_by", //
            title: "ឲចូលដោយ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 110,
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
            width: 110,
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
                      snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
                    }, //
                  ),
                ],
              );
            },
          ),
        ], //
        columnGroups: [
          PlutoColumnGroup(title: "", fields: ["index"]),
          PlutoColumnGroup(title: "ការស្នាក់នៅ", fields: ["room", "check_in_at", "check_out_at"]),
          PlutoColumnGroup(title: "អតិថិជន", fields: ["guest_name", "guest_phone", "number_of_guest"]),
          PlutoColumnGroup(title: "ការបង់ប្រាក់", fields: ["room_price", "mini_bar_price", "penalty_price", "pay_cash", "pay_bank", "pay_balance", "pay_note"]),
          PlutoColumnGroup(title: "ការត្រួតពិនិត្យ", fields: ["check_in_by", "check_out_by"]),
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
      ),

      footer: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("ចំណូល: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              "${format_double(total_price, digits: 2)}\$",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),

        const SizedBox(width: 8), //

        Row(
          children: [
            Text("ចំណូលសុទ្ធ: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              "${format_double(total_income, digits: 2)}\$",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),

        const Spacer(),
      ],
    );
  }
  // ########## BLOCK DESIGN END ##########

  // ########## BLOCK METHODS ##########
  @override
  void initState() {
    super.initState();
    on_load_page();
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }

  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    // state_manager.setAutoEditing(true);
    state_manager.columnFooterHeight = 32;
    list_column_pluto = state_manager.refColumns.toList();

    on_load_page();
  }

  Future<void> on_load_page() async {
    final String formatted_date = DateFormat("yyyy-MM-dd").format(date);
    dynamic tmp = await dio.post(endpoint.FRONT_DESK_REPORT_DAILY, data: {"date": formatted_date});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "Failed to load report", cl: Colors.red);

    report = tmp.data;
    rows = (report?["rows"] as List<dynamic>? ?? []).map((e) => Front_Desk.fromJson(e)).toList();
    summary = report?["summary"] ?? {};

    update_grid();
    setState(() {});
  }

  Future<void> on_reload() async {
    reload++;
    await on_load_page();
    snackbar(ct: context, ms: "Reloaded", cl: Colors.green);
  }

  Future<void> on_download() async {
    if (downloading) return;
    setState(() => downloading = true);
    try {
      final String formatted_date = DateFormat("yyyy-MM-dd").format(date);
      dynamic tmp = await dio.download(endpoint.FRONT_DESK_REPORT_DAILY_EXCEL, data: {"date": formatted_date});
      if (tmp == null) {
        snackbar(ct: context, ms: dio.error_msg ?? "Error: ${endpoint.FRONT_DESK_REPORT_DAILY_EXCEL}", cl: Colors.red);
        return;
      }

      final bytes = Uint8List.fromList(tmp.data as List<int>);
      final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
      final url = web.URL.createObjectURL(blob);
      final anchor = web.HTMLAnchorElement()
        ..href = url
        ..download = "report_daily_$formatted_date.xlsx";
      web.document.body?.appendChild(anchor);
      anchor.click();
      anchor.remove();
      web.URL.revokeObjectURL(url);
      snackbar(ct: context, ms: "Downloaded: report_daily_$formatted_date.xlsx", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: "Error: $e", cl: Colors.red);
    } finally {
      if (mounted) setState(() => downloading = false);
    }
  }

  Future<void> on_download_summary() async {
    if (downloading_summary) return;
    setState(() => downloading_summary = true);
    try {
      final String formatted_date = DateFormat("yyyy-MM-dd").format(date);
      dynamic tmp = await dio.download(endpoint.FRONT_DESK_REPORT_DAILY_SUMMARY_EXCEL, data: {"date": formatted_date});
      if (tmp == null) {
        snackbar(ct: context, ms: dio.error_msg ?? "Error: ${endpoint.FRONT_DESK_REPORT_DAILY_SUMMARY_EXCEL}", cl: Colors.red);
        return;
      }

      final bytes = Uint8List.fromList(tmp.data as List<int>);
      final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
      final url = web.URL.createObjectURL(blob);
      final anchor = web.HTMLAnchorElement()
        ..href = url
        ..download = "report_daily_summary_$formatted_date.xlsx";
      web.document.body?.appendChild(anchor);
      anchor.click();
      anchor.remove();
      web.URL.revokeObjectURL(url);
      snackbar(ct: context, ms: "Downloaded: report_daily_summary_$formatted_date.xlsx", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: "Error: $e", cl: Colors.red);
    } finally {
      if (mounted) setState(() => downloading_summary = false);
    }
  }

  Future<void> pick_date() async {
    final DateTime? picked = await showDatePicker(
      context: context, //
      initialDate: date, //
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    date = picked;
    on_load_page();
  }

  void update_grid() {
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, fd) in rows.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column_pluto) //
              c.field: (() {
                if (c.field == "_id") return PlutoCell(value: fd.id ?? "");
                if (c.field == "index") return PlutoCell(value: i + 1);
                if (c.field == "room") return PlutoCell(value: fd.room_number ?? "");
                if (c.field == "guest_name") return PlutoCell(value: fd.guest_id is Guest_Show ? (fd.guest_id as Guest_Show).full_name : "");
                if (c.field == "guest_phone") return PlutoCell(value: fd.guest_id is Guest_Show ? (fd.guest_id as Guest_Show).phone_number : "");
                if (c.field == "number_of_guest") return PlutoCell(value: fd.number_of_guest ?? 0);
                if (c.field == "check_in_at") return PlutoCell(value: fd.check_in_at);
                if (c.field == "check_out_at") return PlutoCell(value: fd.check_out_at);
                if (c.field == "check_in_by") return PlutoCell(value: fd.check_in_by is User_Show ? (fd.check_in_by as User_Show).full_name : "");
                if (c.field == "check_out_by") return PlutoCell(value: fd.check_out_by is User_Show ? (fd.check_out_by as User_Show).full_name : "");

                if (c.field == "room_price") return PlutoCell(value: fd.room_price);
                if (c.field == "penalty_price") return PlutoCell(value: fd.penalty_price);
                if (c.field == "mini_bar_price") return PlutoCell(value: fd.mini_bar_price);
                if (c.field == "pay_cash") return PlutoCell(value: fd.pay_cash);
                if (c.field == "pay_bank") return PlutoCell(value: fd.pay_bank);
                if (c.field == "pay_balance") return PlutoCell(value: fd.pay_balance);
                if (c.field == "pay_note") return PlutoCell(value: fd.pay_note);

                return PlutoCell(value: "");
              })(),
          },
        ),
    ]);
  }

  void on_filter() {
    filter = !filter;
    state_manager.setShowColumnFilter(filter);
  }

  double get total_price => parse_double(summary["total"]?["price"]) ?? 0;
  double get total_cash => parse_double(summary["total"]?["cash"]) ?? 0;
  double get total_bank => parse_double(summary["total"]?["bank"]) ?? 0;
  double get total_income => total_cash + total_bank;

  Widget _money(PlutoColumnRendererContext rc) {
    return Align(
      alignment: Alignment.center, //
      child: Text(format_double(parse_double(rc.cell.value) ?? 0, digits: 2) + " \$", overflow: TextOverflow.ellipsis),
    );
  }

  Widget _money_cash_bank(PlutoColumnRendererContext rc) {
    double v = parse_double(rc.cell.value) ?? 0;
    return Align(
      alignment: Alignment.center, //
      child: Text(
        format_double(v, digits: 2) + " \$",
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
        format_double(v, digits: 2) + " \$",
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
              "$value \$",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            ),
          ),
        ];
      },
    );
  }

  // ########## BLOCK METHODS END ##########
}

// ########## BLOCK ARGUMENTS OF MAIN ##########
class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}
// ########## BLOCK ARGUMENTS OF MAIN END ##########

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
