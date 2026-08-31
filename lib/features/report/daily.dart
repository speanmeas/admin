import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/features/report/dialog_item_show.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  int reload = 0;
  bool is_load = false;
  double WIDTH = 120;

  late List<String> list_column;
  late PlutoGridStateManager state_manager;

  DateTime date = DateTime.now();
  dynamic report; // * response របស់ /front_desk/daily_report

  List<Front_Desk> rows = [];
  Map<String, dynamic> summary = {};
  // * ########## BLOCK VARIABLES END ##########

  // * ########## BLOCK METHODS ##########
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() => is_load = true);
    dynamic tmp = await dio.post(
      endpoint.FRONT_DESK_DAILY_REPORT,
      data: {
        "date": DateFormat("yyyy-MM-dd").format(date), //
      },
    );
    setState(() => is_load = false);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    report = tmp.data;
    rows = (report?["rows"] as List<dynamic>? ?? []).map((e) => Front_Desk.fromJson(e)).toList();
    summary = report?["summary"] ?? {};

    // * បន្ថែម Walk-In counter (តែងតែនៅ index 1) សម្រាប់គ្រប់ថ្ងៃ
    dynamic tmp_walk = await dio.post(endpoint.FRONT_DESK_WALK_IN, data: {});
    if (tmp_walk != null && (tmp_walk.data as List<dynamic>? ?? []).isNotEmpty) {
      String walk_id = (tmp_walk.data as List<dynamic>)[0]["_id"]?.toString() ?? "";
      rows.removeWhere((x) => x.id?.toString() == walk_id);
      rows.insert(0, Front_Desk.fromJson((tmp_walk.data as List<dynamic>)[0]));
    }

    update_grid();

    setState(() {});
  }

  // * accessors for Front_Desk linked/expanded fields
  Room? fd_room(Front_Desk fd) => fd.room_id is Room ? fd.room_id as Room : null;
  Guest? fd_guest(Front_Desk fd) => fd.guest_id is Guest ? fd.guest_id as Guest : null;
  User_Show? fd_check_in_by(Front_Desk fd) => fd.check_in_by is User_Show ? fd.check_in_by as User_Show : null;
  User_Show? fd_check_out_by(Front_Desk fd) => fd.check_out_by is User_Show ? fd.check_out_by as User_Show : null;

  // * រយៈពេលស្នាក់ជាថ្ងៃ និងម៉ោង
  String duration_text(DateTime? in_at, DateTime? out_at) {
    if (in_at == null) return "";
    DateTime end = out_at ?? DateTime.now();
    int minutes = end.difference(in_at).inMinutes;
    if (minutes < 0) return "";
    int day = minutes ~/ 1440;
    int hour = (minutes % 1440) ~/ 60;
    String text = "";
    if (day > 0) text += "$day ថ្ងៃ ";
    if (hour > 0) text += "$hour ម៉ោង";
    if (text.isEmpty) text = "0 ម៉ោង";
    return text.trim();
  }

  void update_grid() {
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, fd) in rows.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column) //
              c: (() {
                if (c == "_id") return PlutoCell(value: fd.id ?? "");
                if (c == "index") return PlutoCell(value: i + 1);
                if (c == "room") return PlutoCell(value: fd_room(fd)?.number ?? "");
                if (c == "guest_name") return PlutoCell(value: fd_guest(fd)?.full_name ?? "");
                if (c == "guest_phone") return PlutoCell(value: fd_guest(fd)?.phone_number ?? "");
                if (c == "number_of_guest") return PlutoCell(value: fd.number_of_guest ?? 0);
                if (c == "check_in_at") return PlutoCell(value: fd.check_in_at);
                if (c == "check_out_at") return PlutoCell(value: fd.check_out_at);
                if (c == "duration") return PlutoCell(value: duration_text(fd.check_in_at, fd.check_out_at));
                if (c == "check_in_by") return PlutoCell(value: fd_check_in_by(fd)?.full_name ?? "");
                if (c == "check_out_by") return PlutoCell(value: fd_check_out_by(fd)?.full_name ?? "");

                if (c == "room_price") return PlutoCell(value: fd.room_price);
                if (c == "room_cash") return PlutoCell(value: fd.room_cash);
                if (c == "room_bank") return PlutoCell(value: fd.room_bank);
                if (c == "room_balance") return PlutoCell(value: fd.room_balance);
                if (c == "room_note") return PlutoCell(value: fd.room_note);

                if (c == "penalty_item") return PlutoCell(value: "");
                if (c == "penalty_price") return PlutoCell(value: fd.penalty_price);
                if (c == "penalty_cash") return PlutoCell(value: fd.penalty_cash);
                if (c == "penalty_bank") return PlutoCell(value: fd.penalty_bank);
                if (c == "penalty_balance") return PlutoCell(value: fd.penalty_balance);
                if (c == "penalty_note") return PlutoCell(value: fd.penalty_note);

                if (c == "mini_bar_item") return PlutoCell(value: "");
                if (c == "mini_bar_price") return PlutoCell(value: fd.mini_bar_price);
                if (c == "mini_bar_cash") return PlutoCell(value: fd.mini_bar_cash);
                if (c == "mini_bar_bank") return PlutoCell(value: fd.mini_bar_bank);
                if (c == "mini_bar_balance") return PlutoCell(value: fd.mini_bar_balance);
                if (c == "mini_bar_note") return PlutoCell(value: fd.mini_bar_note);

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
    state_manager.columnFooterHeight = 32;
    list_column = state_manager.refColumns.map((c) => c.field).toList();

    init();
  }

  // * ជ្រើសរើសកាលបរិច្ឆេទតែប៉ុណ្ណោះ (មិនមានពេលវេលា)
  Future<void> pick_date() async {
    final DateTime? picked = await showDatePicker(
      context: context, //
      initialDate: date, //
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    date = picked;
    init();
  }

  // * គណនាតម្លៃពី summary របស់ backend
  double get total_price => parse_double(summary["total"]?["price"]) ?? 0;
  double get total_cash => parse_double(summary["total"]?["cash"]) ?? 0;
  double get total_bank => parse_double(summary["total"]?["bank"]) ?? 0;
  double get total_income => total_cash + total_bank;
  // * ########## BLOCK METHODS END ##########

  // * ########## BLOCK DESIGN ##########
  Widget _layout({
    List<Widget>? header, //
    // List<Widget>? check_out, //
    // List<Widget>? clean, //
    Widget? body, //
    List<Widget>? footer, //
  }) {
    return Scaffold(
      body: Column(
        children: [
          // // HEADER
          // Container(
          //   height: 40,
          //   padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          //   child: Row(
          //     children: [
          //       OutlinedButton.icon(
          //         style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          //         icon: const Icon(Icons.calendar_month_outlined), //
          //         label: Text(DateFormat("yyyy-MM-dd").format(date)), //
          //         onPressed: pick_date, //
          //       ),
          //       const SizedBox(width: 8),
          //       OutlinedButton.icon(
          //         style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          //         icon: const Icon(Icons.refresh_outlined), //
          //         label: const Text("Refresh"),
          //         onPressed: init, //
          //       ),
          //     ],
          //   ),
          // ),
          // header
          Container(
            height: 34, //
            padding: const EdgeInsets.all(1),
            child: Row(
              spacing: 2, //
              mainAxisAlignment: MainAxisAlignment.center, //
              crossAxisAlignment: CrossAxisAlignment.center, //
              children: [...?header],
            ),
          ),

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
      header: [
        IconButton(
          tooltip: "Previous", //
          icon: Icon(Icons.navigate_before, size: 32), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {
            date = date.subtract(Duration(days: 1));
            init();
          },
        ),

        TextButton(
          onPressed: pick_date,
          child: Text(
            DateFormat("yyyy-MM-dd").format(date), //
            style: TextStyle(
              fontSize: 16, //
              fontWeight: FontWeight.bold, //
            ),
          ),
        ),

        IconButton(
          tooltip: "Next", //
          icon: Icon(Icons.navigate_next, size: 32), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {
            date = date.add(Duration(days: 1));
            init();
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
            field: "guest_name", //
            title: "ឈ្មោះ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: WIDTH,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
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
                alignment: Alignment.centerLeft, //
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
                alignment: Alignment.centerRight, //
                child: Text(format_double(rc.cell.value, digits: 0) + " នាក់", overflow: TextOverflow.ellipsis),
              );
            },
          ),
          PlutoColumn(
            field: "check_in_at", //
            title: "ពេលចូល",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 150,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),
          PlutoColumn(
            field: "duration", //
            title: "រយៈពេល",
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
            field: "check_out_at", //
            title: "ពេលចេញ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 150,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(format_datetime(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          // * ការបង់ប្រាក់ បន្ទប់
          PlutoColumn(
            field: "room_price", //
            title: "តម្លៃ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "room_cash", //
            title: "លុយ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "room_bank", //
            title: "ធនាគារ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "room_balance", //
            title: "សមតុល្យ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
          ),

          PlutoColumn(
            field: "room_note", //
            title: "ចំណាំ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          // * ការបង់ប្រាក់ mini bar
          PlutoColumn(
            field: "mini_bar_item", //
            title: "ទំនិញ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              int i = parse_int(rc.row.cells["index"]?.value) ?? 0;
              Front_Desk? fd = (i > 0 && i <= rows.length) ? rows[i - 1] : null;
              List<dynamic> list = (fd?.list_mini_bar_item_id ?? []).cast<dynamic>();
              if (list.isEmpty) return const SizedBox();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, //
                children: [
                  IconButton(
                    tooltip: "View Mini Bar Items", //
                    icon: Icon(Icons.receipt_long_outlined, color: Colors.blue),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      dialog_item_show(
                        context: context, //
                        title: "Mini Bar Items", //
                        list: list, //
                        is_mini_bar: true, //
                      );
                    }, //
                  ),
                ],
              );
            },
          ),
          PlutoColumn(
            field: "mini_bar_price", //
            title: "តម្លៃ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "mini_bar_cash", //
            title: "លុយ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "mini_bar_bank", //
            title: "ធនាគារ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "mini_bar_balance", //
            title: "សមតុល្យ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
          ),
          PlutoColumn(
            field: "mini_bar_note", //
            title: "ចំណាំ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          // * ការបង់ប្រាក់ penalty
          PlutoColumn(
            field: "penalty_item", //
            title: "ទំនិញ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              int i = parse_int(rc.row.cells["index"]?.value) ?? 0;
              Front_Desk? fd = (i > 0 && i <= rows.length) ? rows[i - 1] : null;
              List<dynamic> list = (fd?.list_penalty_item_id ?? []).cast<dynamic>();
              if (list.isEmpty) return const SizedBox();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, //
                children: [
                  IconButton(
                    tooltip: "View Penalty Items", //
                    icon: Icon(Icons.receipt_long_outlined, color: Colors.blue),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      dialog_item_show(
                        context: context, //
                        title: "Penalty Items", //
                        list: list, //
                        is_mini_bar: false, //
                      );
                    }, //
                  ),
                ],
              );
            },
          ),
          PlutoColumn(
            field: "penalty_price", //
            title: "តម្លៃ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "penalty_cash", //
            title: "លុយ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "penalty_bank", //
            title: "ធនាគារ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
            footerRenderer: (rc) => _sum_footer(rc),
          ),
          PlutoColumn(
            field: "penalty_balance", //
            title: "សមតុល្យ",
            type: PlutoColumnType.number(negative: true, format: "#,##0.00"),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) => _money(rc),
          ),
          PlutoColumn(
            field: "penalty_note", //
            title: "ចំណាំ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),

          // * ការត្រួតពិនិត្យ
          PlutoColumn(
            field: "check_in_by", //
            title: "ឲចូលដោយ",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 110,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
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
                alignment: Alignment.centerLeft, //
                child: Text(format_string(rc.cell.value), overflow: TextOverflow.ellipsis),
              );
            },
          ),
        ], //
        columnGroups: [
          PlutoColumnGroup(title: "", fields: ["index"]),
          PlutoColumnGroup(title: "", fields: ["room"]),
          PlutoColumnGroup(title: "អតិថិជន", fields: ["guest_name", "guest_phone", "number_of_guest"]),
          PlutoColumnGroup(title: "ការស្នាក់នៅ", fields: ["check_in_at", "duration", "check_out_at"]),
          PlutoColumnGroup(
            title: "ការបង់ប្រាក់ បន្ទប់", //
            fields: ["room_price", "room_cash", "room_bank", "room_balance", "room_note"],
          ),
          PlutoColumnGroup(
            title: "ការបង់ប្រាក់ មីនីបារ", //
            fields: ["mini_bar_item", "mini_bar_price", "mini_bar_cash", "mini_bar_bank", "mini_bar_balance", "mini_bar_note"],
          ),
          PlutoColumnGroup(
            title: "ការបង់ប្រាក់ Penalty", //
            fields: ["penalty_item", "penalty_price", "penalty_cash", "penalty_bank", "penalty_balance", "penalty_note"],
          ),
          PlutoColumnGroup(
            title: "ការត្រួតពិនិត្យ", //
            fields: ["check_in_by", "check_out_by"],
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
      ),

      footer: [
        //
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "ចំណូល: ", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${format_double(total_price, digits: 2)}\$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),

        SizedBox(width: 8), //
        //
        Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "ចំណូលសុទ្ធ: ", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${format_double(total_income, digits: 2)}\$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),

        // const Spacer(),

        // * ប៊ូតុងបញ្ចេញជា PDF
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

        // Spacer(), //

        // Spacer(), //

        // OutlinedButton.icon(
        //   icon: Icon(Icons.restart_alt), //
        //   label: Text("Rollover"), //
        //   onPressed: () {
        //     setState(() {});
        //   },
        // ),
        Spacer(), //
      ],
    );
  }

  Widget _money(PlutoColumnRendererContext rc) {
    return Align(
      alignment: Alignment.centerRight, //
      child: Text(
        format_double(rc.cell.value, digits: 2) + " \$", //
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: rc.cell.value >= 0 ? Colors.black : Colors.red),
      ),
    );
  }

  Widget _sum_footer(PlutoColumnFooterRendererContext rc) {
    // * price → ពណ៌ខៀវ; cash/bank → បៃតង (វិជ្ជមាន) / ក្រហម (អវិជ្ជមាន)
    bool is_price = rc.column.field.endsWith("_price");
    return PlutoAggregateColumnFooter(
      rendererContext: rc, //
      format: "#,##0.00", //
      alignment: Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      type: PlutoAggregateColumnType.sum,
      titleSpanBuilder: (value) {
        double? v = parse_double(value);
        Color color = is_price ? Colors.blue : ((v ?? 0) >= 0 ? Colors.green : Colors.red);
        return [
          WidgetSpan(
            child: Text(
              "$value \$", //
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color, overflow: TextOverflow.ellipsis),
            ),
          ),
        ];
      },
    );
  }

  // * ########## BLOCK DESIGN END ##########
}

// * ########## BLOCK ARGUMENTS OF MAIN ##########
class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}
// * ########## BLOCK ARGUMENTS OF MAIN END ##########

void main() {
  runApp(
    MaterialApp(
      home: Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
