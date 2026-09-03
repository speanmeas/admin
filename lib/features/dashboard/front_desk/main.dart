import "dart:async";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "dialog/add_mini_bar.dart";
import "dialog/change_room.dart";
import "dialog/check_in.dart";
import "dialog/list_mini_bar.dart";
import "dialog/list_penalty.dart";
import "dialog/pick_datetime.dart";
import "dialog/search_guest.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  int reload = 0;
  bool is_load = false;
  double WIDTH = 120;

  late List<String> list_column;
  late PlutoGridStateManager state_manager;

  //   DateTime dt = DateTime.now();
  DateTime date = DateTime.now();

  List<dynamic> rooms = [];
  List<Front_Desk> front_desks = [];

  Timer? timer_refresh;

  bool is_admin = false;
  bool is_refresh = false;
  bool is_filter = false;
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

          if (is_load) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: body ?? Container()),

          if (footer != null && footer.isNotEmpty)
            Container(
              height: 34, //
              padding: const EdgeInsets.only(top: 1),
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

        Tooltip(
          message: "Add Mini Bar", //
          child: OutlinedButton.icon(
            label: Text("Mini Bar"), //
            icon: Icon(Icons.local_bar_outlined), //
            style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
            onPressed: on_mini_bar_only, //
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
        IconButton(
          tooltip: "Carry Over", //
          icon: Icon(Icons.event_repeat_outlined, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_carry_over, //
        ),

        const Spacer(),

        // IconButton(
        //   tooltip: "Previous", //
        //   icon: Icon(Icons.navigate_before, size: 32), //
        //   padding: EdgeInsets.all(0),
        //   constraints: BoxConstraints(),
        //   onPressed: () {},
        // ),
        Text(
          DateFormat("yyyy-MM-dd").format(date.subtract(const Duration(hours: 7))), //
          style: TextStyle(
            fontSize: 16, //
            color: Colors.blue,
            fontWeight: FontWeight.bold, //
          ),
        ),

        //   onPressed: pick_date,

        // IconButton(
        //   tooltip: "RollOver", //
        //   icon: Icon(Icons.navigate_next, size: 32), //
        //   padding: EdgeInsets.all(0),
        //   constraints: BoxConstraints(),
        //   onPressed: () {},
        // ),
        const Spacer(), //
        // IconButton(
        //   tooltip: is_filter ? "Hide Filter" : "Show Filter", //
        //   icon: Icon(is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, size: 30), //
        //   padding: EdgeInsets.all(0),
        //   constraints: BoxConstraints(),
        //   onPressed: on_filter, // not yet implemented
        // ),
        IconButton(
          tooltip: "Reload", //
          icon: Icon(Icons.refresh, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_load_front_desk, //
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
                alignment: Alignment.center,
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
            width: 100,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(
                        format_string(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (!is_checked_out(rc) && !is_row_mini_bar(rc))
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
                      child: Text(
                        format_datetime(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  if (!is_checked_out(rc) && !is_row_mini_bar(rc))
                    IconButton(
                      tooltip: "កែពេលចូល", //
                      icon: Icon(Icons.calendar_month_outlined),
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: () async {
                        final v = await dialog_pick_datetime(context: context, rc: rc, is_check_in: true);
                        if (v == true) on_load_front_desk();
                      }, //
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
                alignment: Alignment.center, //
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
                ],
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
                      alignment: Alignment.center, //
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
                      alignment: Alignment.center, //
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
                    onPressed: () async {
                      //   print("Search Guest: ${rc.row.cells["index"]?.value}");
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
                child: Text(
                  format_double(rc.cell.value, digits: 0) + " នាក់", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: "room_price", //
            title: "ថ្លៃបន្ទប់",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,##0.00",
            ),
            // enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            footerRenderer: _sum_footer,
          ),

          PlutoColumn(
            field: "mini_bar_price", //
            title: "ថ្លៃមីនីបារ",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,##0.00",
            ),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(
                        format_double(rc.cell.value, digits: 2) + " \$", //
                        overflow: TextOverflow.ellipsis,
                      ),
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
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,##0.00",
            ),
            enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(
                        format_double(rc.cell.value, digits: 2) + " \$", //
                        overflow: TextOverflow.ellipsis,
                      ),
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
            type: PlutoColumnType.number(
              //   negative: false, //
              format: "#,##0.00",
            ),
            // enableEditingMode: false,
            // enableEditingMode: true,
            width: 90,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
                  ),
                ),
              );
            },
            footerRenderer: _sum_footer,
          ),

          PlutoColumn(
            field: "pay_bank", //
            title: "ធនាគារ",
            type: PlutoColumnType.number(
              //   negative: false, //
              format: "#,##0.00",
            ),
            // enableEditingMode: false,
            width: 90,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: rc.cell.value >= 0 ? Colors.black : Colors.red, //
                  ),
                ),
              );
            },
            footerRenderer: _sum_footer,
          ),

          PlutoColumn(
            field: "pay_balance", //
            title: "សមតុល្យ",
            type: PlutoColumnType.number(
              negative: true, //
              format: "#,##0.00",
            ),
            enableEditingMode: is_admin, // * កែសមតុល្យបានតែ admin ប៉ុណ្ណោះ
            width: 80,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
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
            field: "pay_note", //
            title: "ចំណាំ",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
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
                alignment: Alignment.center, //
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
                alignment: Alignment.center, //
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
          PlutoColumnGroup(
            title: "", //
            fields: ["index"],
          ),

          PlutoColumnGroup(
            title: "អតិថិជន", //
            fields: ["guest_name", "guest_phone", "guest_search", "check_in_people"],
          ),
          PlutoColumnGroup(
            title: "ការស្នាក់នៅ", //
            fields: ["room", "check_in_duration", "check_in_at", "check_out_at", "clean_at"],
          ),
          PlutoColumnGroup(
            title: "ការបង់ប្រាក់", //
            fields: ["room_price", "mini_bar_price", "penalty_price", "pay_cash", "pay_bank", "pay_balance", "pay_note"],
          ),
          PlutoColumnGroup(
            title: "ការត្រួតពិនិត្យ", //
            fields: ["check_in_by", "check_out_by"],
          ),
        ],
        configuration: PlutoGridConfiguration(
          scrollbar: PlutoGridScrollbarConfig(
            // isAlwaysShown: true, //
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
    load_auth();
  }

  // * ទាញតួនាទីអ្នកប្រើសម្រាប់កំណត់ការកែប្រែ cell
  Future<void> load_auth() async {
    final user = await auth.fetch();
    if (user == null) return;
    setState(() {
      is_admin = user.is_admin == true;
      reload++; // * rebuild grid ដើម្បីអនុវត្ត enableEditingMode
    });
  }

  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    state_manager.addListener(() => setState(() {}));
    state_manager.setAutoEditing(true);
    state_manager.columnFooterHeight = 32; // * កម្ពស់ជួរសរុប
    // state_manager.setShowColumnFilter(true);
    list_column = state_manager.refColumns.map((c) => c.field).toList();

    on_load_room();
    on_load_front_desk();
  }

  void on_load_room() async {
    dynamic tmp_r = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
    if (tmp_r == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    rooms = tmp_r.data as List<dynamic>? ?? [];
  }

  void on_load_front_desk() async {
    // * អានសម្រាប់តែថ្ងៃ shift ថ្ងៃនេះ (boundary 7:00)
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

    front_desks = (tmp_fd.data as List<dynamic>? ?? []).map<Front_Desk>((e) => Front_Desk.fromJson(e)).toList();

    on_update_grid();

    setState(() {});
  }

  void on_update_grid() {
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, fd) in front_desks.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column) //
              c: (() {
                if (c == "_id") return PlutoCell(value: fd.id ?? "");
                if (c == "index") return PlutoCell(value: i + 1);
                if (c == "room") return PlutoCell(value: fd_room(fd)?.number ?? "");
                if (c == "guest_name") return PlutoCell(value: fd_guest(fd)?.full_name ?? "");
                if (c == "guest_phone") return PlutoCell(value: fd_guest(fd)?.phone_number ?? "");
                if (c == "check_in_people") return PlutoCell(value: fd.number_of_guest ?? 0);
                if (c == "check_in_at") return PlutoCell(value: fd.check_in_at);

                if (c == "check_in_duration") {
                  if (is_walkin(fd)) return PlutoCell(value: 0);
                  DateTime? in_at = fd.check_in_at;
                  DateTime? out_at = fd.check_out_at;
                  if (in_at == null) return PlutoCell(value: 0);
                  if (out_at == null) return PlutoCell(value: DateTime.now().difference(in_at).inMinutes);
                  return PlutoCell(value: out_at.difference(in_at).inMinutes);
                }

                if (c == "check_out_at") return PlutoCell(value: fd.check_out_at);

                // * room payment fields are inline on the stay (no Room_Pay child array)
                if (c == "room_price") return PlutoCell(value: fd.room_price);
                if (c == "mini_bar_price") return PlutoCell(value: fd.mini_bar_price);
                if (c == "penalty_price") return PlutoCell(value: fd.penalty_price);
                if (c == "pay_cash") return PlutoCell(value: fd.pay_cash);
                if (c == "pay_bank") return PlutoCell(value: fd.pay_bank);
                if (c == "pay_balance") return PlutoCell(value: fd.pay_balance);
                if (c == "pay_note") return PlutoCell(value: fd.pay_note ?? "");
                if (c == "check_in_by") return PlutoCell(value: fd.check_in_by is User_Show ? (fd.check_in_by as User_Show).full_name : (fd.check_in_by ?? ""));
                if (c == "check_out_by") return PlutoCell(value: fd.check_out_by is User_Show ? (fd.check_out_by as User_Show).full_name : (fd.check_out_by ?? ""));

                return PlutoCell(value: "");
              })(),
          },
        ),
    ]);

    setState(() {});
  }

  // * ដើមថ្ងៃ shift ថ្ងៃនេះ (shift_date = កណ្ដាលអធ្រាត្រ, ថ្ងៃ shift = now − 7h) → ISO
  String shift_start() {
    final shift_day = DateTime.now().subtract(const Duration(hours: 7));
    return DateTime(shift_day.year, shift_day.month, shift_day.day).toIso8601String();
  }

  // * ចុងថ្ងៃ shift ថ្ងៃនេះ (ថ្ងៃស្អែក 00:00) → ISO
  String shift_stop() {
    final shift_day = DateTime.now().subtract(const Duration(hours: 7));
    return DateTime(shift_day.year, shift_day.month, shift_day.day).add(const Duration(days: 1)).toIso8601String();
  }

  // * accessors for Front_Desk linked/expanded fields
  Room? fd_room(Front_Desk fd) {
    return fd.room_id is Room ? fd.room_id as Room : null;
  }

  Guest? fd_guest(Front_Desk fd) {
    return fd.guest_id is Guest ? fd.guest_id as Guest : null;
  }

  // * ពិនិត្យថា stay ជា Walk-In / Mini Bar only (លក់ minibar តែប៉ុណ្ណោះ) — មិនអាស្រ័យតែលើ expanded room ទេ
  bool is_walkin(Front_Desk fd) {
    Room? room = fd_room(fd);
    if (room != null) return _is_mini_bar_room(room.number);
    // * room_id អាចមកជា string id (មិន expanded) → រកក្នុងបញ្ជី rooms
    String rid = (fd.room_id ?? "").toString();
    if (rid.isEmpty) return false;
    for (var r in rooms) {
      if ((r[Room.ID] ?? "").toString() == rid && _is_mini_bar_room(r[Room.NUMBER]?.toString())) {
        return true;
      }
    }
    return false;
  }

  // * ពិនិត្យថាឈ្មោះបន្ទប់ជា Walk-In ឬ Mini Bar (minibar only)
  bool _is_mini_bar_room(String? number) {
    String n = (number ?? "").toLowerCase();
    return n == "walk-in" || n == "mini bar";
  }

  // * ពិនិត្យថា room ជា Walk-In / Mini Bar (លក់ minibar តែប៉ុណ្ណោះ)
  bool is_walk_in_room(dynamic r) => _is_mini_bar_room(r[Room.NUMBER]?.toString());

  // * footer ជួរសរុប (sum) សម្រាប់ជួរលុយ
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
  }

  // * ផ្ញើ POST អាប់ដេត → បង្ហាញ snackbar ជោគជ័យ/បរាជ័យ ហើយត្រឡប់ទិន្នន័យ row ថ្មី (null = បរាជ័យ)
  Future<dynamic> _update(String ep, Map<String, dynamic> data) async {
    final tmp = await dio.post(ep, data: data);
    if (tmp == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return null;
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    return tmp.data;
  }

  // * កែ cell ក្នុង grid ដោយមិន reload ទាំងស្រុង (ដូច demo_1) — reload តែពេលបរាជ័យដើម្បីត្រឡប់តម្លៃដើម
  // * អាប់ដេតសមតុល្យ (pay_balance) ក្នុង row ដែលកំពុងកែ ដោយមិន reload ទាំងស្រុង
  void _apply_balance(PlutoGridOnChangedEvent e, dynamic row_data) {
    if (row_data == null) return;
    dynamic balance = row_data is List ? (row_data.isEmpty ? null : row_data[0]?["pay_balance"]) : row_data["pay_balance"];
    if (balance == null) return;
    final cell = e.row.cells["pay_balance"];
    if (cell != null) state_manager.changeCellValue(cell, balance, callOnChangedEvent: false);
  }

  // * កែ cell ក្នុង grid ដោយមិន reload ទាំងស្រុង (ដូច demo_1) — reload តែពេលបរាជ័យដើម្បីត្រឡប់តម្លៃដើម
  void on_changed(PlutoGridOnChangedEvent e) async {
    // pprint("Old: ${e.oldValue} | New: ${e.value} | Row: ${e.row.cells["_id"]?.value} | Column: ${e.column.field}");
    final fd_id = e.row.cells["_id"]?.value;
    if (fd_id == null) return;

    // * Walk-In (Minibar only): អនុញ្ញាតឲ្យកែឈ្មោះ/លេខទូរស័ព្ទភ្ញៀវ (guest_name / guest_phone) និងលុយ/ធនាគារ (pay_cash / pay_bank)
    // * — មិនអនុញ្ញាតឲ្យកែ room price, change room ឬ penalty ទេ (revert តម្លៃដើមវិញ)
    bool is_walkin_row = false;
    {
      Front_Desk? walk_fd = front_desks.where((x) => x.id == fd_id).firstOrNull;
      is_walkin_row = walk_fd != null && is_walkin(walk_fd);
      if (is_walkin_row && e.column.field != "guest_name" && e.column.field != "guest_phone" && e.column.field != "pay_cash" && e.column.field != "pay_bank" && e.column.field != "pay_balance") {
        e.row.cells[e.column.field]!.value = e.oldValue;
        return;
      }
    }

    dynamic updated;
    if (e.column.field == "guest_name") updated = await _update(endpoint.FRONT_DESK_UPDATE_GUEST_INFO, {Front_Desk.ID: fd_id, Guest.FULL_NAME: e.value});
    if (e.column.field == "guest_phone") updated = await _update(endpoint.FRONT_DESK_UPDATE_GUEST_INFO, {Front_Desk.ID: fd_id, Guest.PHONE_NUMBER: e.value});
    if (e.column.field == "check_in_people") updated = await _update(endpoint.FRONT_DESK_UPDATE, {Front_Desk.ID: fd_id, Front_Desk.NUMBER_OF_GUEST: int.tryParse(e.value?.toString() ?? "")});

    // * កែ room_price → endpoint update_room_price; cash / bank / note → update_payment (បន្ទាប់ពីដកចេញពី update_payment)
    if (e.column.field == "room_price") {
      dynamic value = num.tryParse(e.value?.toString() ?? "")?.toDouble();
      updated = await _update(endpoint.FRONT_DESK_UPDATE_ROOM_PRICE, {Front_Desk.ID: fd_id, Front_Desk.ROOM_PRICE: value});
      _apply_balance(e, updated);
    }
    if (e.column.field == "pay_cash" || e.column.field == "pay_bank" || e.column.field == "pay_note") {
      dynamic key = switch (e.column.field) {
        "pay_cash" => Front_Desk.PAY_CASH,
        "pay_bank" => Front_Desk.PAY_BANK,
        _ => Front_Desk.PAY_NOTE,
      };
      dynamic value = e.column.field == "pay_note" ? e.value?.toString() : num.tryParse(e.value?.toString() ?? "")?.toDouble();
      updated = await _update(is_walkin_row ? endpoint.FRONT_DESK_UPDATE_WALKIN : endpoint.FRONT_DESK_UPDATE_PAYMENT, {Front_Desk.ID: fd_id, key: value});
      _apply_balance(e, updated);
    }

    // * កែសមតុល្យ (balance) ដោយផ្ទាល់ — អនុញ្ញាតតែ admin ប៉ុណ្ណោះ
    if (e.column.field == "pay_balance" && is_admin) updated = await _update(endpoint.FRONT_DESK_UPDATE_PAYMENT, {Front_Desk.ID: fd_id, Front_Desk.PAY_BALANCE: num.tryParse(e.value?.toString() ?? "")?.toDouble()});
    if (e.column.field == "mini_bar_price") {
      updated = await _update(endpoint.FRONT_DESK_UPDATE_MINI_BAR_ITEM, {Front_Desk.ID: fd_id});
      _apply_balance(e, updated);
    }
    if (e.column.field == "penalty_price") {
      updated = await _update(endpoint.FRONT_DESK_UPDATE_PENALTY_ITEM, {Front_Desk.ID: fd_id});
      _apply_balance(e, updated);
    }

    // * reload ដើម្បីយកទិន្នន័យពិតមកវិញ (revert ដោយស្វ័យប្រវត្តិពី server)
    on_load_front_desk();
  }

  void on_check_in(dynamic r) async {
    var v = await dialog_check_in(
      context: context, //
      lead: "Room ${r[Room.NUMBER]}", //
      room_id: r[Room.ID], //
    );
    if (v == null) return;
    on_load_room();
    on_load_front_desk();
  }

  void on_carry_over() async {
    dynamic tmp = await dio.post(endpoint.FRONT_DESK_CARRY_OVER, data: {});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Carried Over", cl: Colors.green);
    on_load_room();
    on_load_front_desk();
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
    on_load_room();
    on_load_front_desk();
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
    on_load_room();
    on_load_front_desk();
  }

  // * បើក Walk-In: យក (ឬបង្កើត) row Walk-In នៃថ្ងៃ shift នេះ សម្រាប់លក់ minibar តែប៉ុណ្ណោះ
  Future<void> on_mini_bar_only() async {
    final v = await dialog_add_mini_bar(context: context);
    if (v == null) return;
    on_load_front_desk();
  }

  // * បញ្ជាការកែប្រែ និងការបោះបង់ពីជួរ grid (action រស់នៅក្នុង method មិននៅក្នុង UI)
  String? row_stay_id(PlutoColumnRendererContext rc) => rc.row.cells["_id"]?.value;

  Front_Desk? row_stay(PlutoColumnRendererContext rc) {
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return null;
    return front_desks.where((x) => x.id == fd_id).firstOrNull;
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
  bool is_row_mini_bar(PlutoColumnRendererContext rc) {
    Front_Desk? fd = row_stay(rc);
    if (fd == null) return false;
    return is_walkin(fd);
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
    on_load_front_desk();
  }

  void on_penalty_item(PlutoColumnRendererContext rc) async {
    if (checkout_guard(rc)) return;
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update penalty", cl: Colors.red);

    Front_Desk? fd = front_desks.where((x) => x.id == fd_id).firstOrNull;

    List<Order_Penalty> orders = [
      for (var it in (fd?.penalty_item_id ?? []))
        if (it is Penalty_Item) Order_Penalty.fromJson(it.toJson()),
    ];

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => List_Penalty(
        list_order_penalty: orders, //
        front_desk_id: fd_id, //
      ),
    );
    if (saved != true) return;

    on_load_front_desk();
  }

  void on_mini_bar_item(PlutoColumnRendererContext rc) async {
    if (checkout_guard(rc)) return;
    String? fd_id = row_stay_id(rc);
    if (fd_id == null) return snackbar(ct: context, ms: "No stay to update mini bar", cl: Colors.red);

    Front_Desk? fd = front_desks.where((x) => x.id == fd_id).firstOrNull;

    List<Order_Mini_Bar> orders = [
      for (var it in (fd?.mini_bar_item_id ?? []))
        if (it is Mini_Bar_Item) Order_Mini_Bar.fromJson(it.toJson()),
    ];

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => List_Mini_Bar(
        list_order_mini_bar: orders, //
        front_desk_id: fd_id, //
        is_walk_in: is_row_mini_bar(rc), //
      ),
    );
    if (saved != true) return;

    on_load_front_desk();
  }

  // * ធ្វើបច្ចុប្បន្នភាពជួរ "រយៈពេល" ដោយស្ងៀមស្ងាត់ — មិនកសាង grid ឡើងវិញទេ ដើម្បីកុំរំខានពេលកំពុងកែប្រែ
  void refresh_time() {
    if (is_refresh || !mounted || list_column.isEmpty) return;
    // * ប្រសិនបើកំពុងកែប្រែ cell ឬកំពុងជ្រើសរើស → រំលងដើម្បីកុំរំខាន (នឹងបន្តនៅជុំបន្ទាប់)
    if (state_manager.isEditing) return;
    is_refresh = true;

    for (final row in state_manager.rows) {
      final cell = row.cells["check_in_duration"];
      if (cell == null) continue;
      final fd_id = row.cells["_id"]?.value;
      if (fd_id == null) continue;
      final Front_Desk? fd = front_desks.where((x) => x.id == fd_id).firstOrNull;
      if (fd == null) continue;
      if (is_walkin(fd)) continue;

      DateTime? in_at = fd.check_in_at;
      DateTime? out_at = fd.check_out_at;
      if (in_at == null) continue;
      int minutes = out_at == null ? DateTime.now().difference(in_at).inMinutes : out_at.difference(in_at).inMinutes;
      state_manager.changeCellValue(cell, minutes, callOnChangedEvent: false);
    }

    is_refresh = false;
  }

  @override
  void dispose() {
    timer_refresh?.cancel();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }

  void on_filter() {
    is_filter = !is_filter;
    state_manager.setShowColumnFilter(is_filter);
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
