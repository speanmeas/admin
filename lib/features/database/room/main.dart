import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";

import "package:speanmeas/core/utility/all.dart";

import "dialog/select_page.dart";

class _Main_State extends State<Main_> {
  // ########## BLOCK ATTRIBUTE ##########
  int reload = 0;
  int total_row = 0;
  int current_page = 1;
  bool filter = false;

  late List<PlutoColumn> list_column_pluto;
  late PlutoGridStateManager state_manager;

  List<String> kinds = ["Single", "Double", "VIP"];
  List<String> statuses = ["Available", "Occupied", "Dirty", "Broken"];

  List<Room> data = [];

  // ########## BLOCK ATTRIBUTE END ##########

  // ########## BLOCK DESIGN ##########
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
          tooltip: "First Page", //
          icon: Icon(Icons.first_page, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_first_page,
        ),

        IconButton(
          tooltip: "Previous Page", //
          icon: Icon(Icons.navigate_before, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_previous_page,
        ),

        TextButton(
          child: Text(
            "$current_page / $total_pages", //
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: on_goto_page,
        ),

        IconButton(
          tooltip: "Next Page", //
          icon: Icon(Icons.navigate_next, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_next_page,
        ),

        IconButton(
          tooltip: "Last Page", //
          icon: Icon(Icons.last_page, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: on_last_page,
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
          PlutoColumn(
            field: Room.ID, //
            title: "ID",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 0,
            // width: kDebugMode ? 220 : 0,
          ),

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
            type: PlutoColumnType.text(),
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
            field: "index", //
            title: "No.",
            type: PlutoColumnType.number(),
            width: 60,
            enableEditingMode: false,
            enableRowDrag: true,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_int(rc.cell.value), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: Room.NUMBER, //
            title: "Number",
            type: PlutoColumnType.text(),
            width: 100,
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
            field: Room.PRICE_PER_DAY, //
            title: "Price/Day",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,##0.00", //
            ),
            width: 110,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: Room.PRICE_PER_3H, //
            title: "Price/3H",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,##0.00", //
            ),
            width: 110,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: Room.KIND, //
            title: "Kind",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              String value = rc.cell.value ?? "";
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(
                        value.isEmpty ? "" : value, //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    menuPadding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    itemBuilder: (context) => [
                      for (String k in kinds) ...[
                        PopupMenuItem(
                          value: k,
                          child: Text(k, style: TextStyle(fontSize: 14)),
                        ),
                        const PopupMenuDivider(height: 0),
                      ],
                    ],
                    onSelected: (v) => on_change_field(rc, Room.KIND, v), //
                    child: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Room.STATUS, //
            title: "Status",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: 120,
            renderer: (rc) {
              String value = rc.cell.value ?? "";
              return Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, //
                      child: Text(
                        value.isEmpty ? "" : value, //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    menuPadding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    itemBuilder: (context) => [
                      for (String st in statuses) ...[
                        PopupMenuItem(
                          value: st,
                          child: Text(st, style: TextStyle(fontSize: 14)),
                        ),
                        const PopupMenuDivider(height: 0),
                      ],
                    ],
                    onSelected: (v) => on_change_field(rc, Room.STATUS, v), //
                    child: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Room.NOTE, //
            title: "Note",
            type: PlutoColumnType.text(),
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
        ], //
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
  // ########## BLOCK DESIGN END ##########

  // ########## BLOCK METHODS ##########
  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    // state_manager.setAutoEditing(true);
    list_column_pluto = state_manager.refColumns.toList();

    await on_reload();
  }

  Future<void> on_rows_moved(PlutoGridOnRowsMovedEvent e) async {
    re_index();

    final int idx = e.idx;
    if (idx < 0 || idx >= state_manager.rows.length) return;

    final moved_row = state_manager.rows[idx];
    final String id = moved_row.cells[Room.ID]?.value?.toString() ?? "";
    if (id.isEmpty) return;

    final String? prev_id = idx > 0 ? state_manager.rows[idx - 1].cells[Room.ID]?.value?.toString() : null;
    final String? next_id = idx < state_manager.rows.length - 1 ? state_manager.rows[idx + 1].cells[Room.ID]?.value?.toString() : null;

    final Map<String, dynamic> body = {"_id": id};
    if (prev_id != null && prev_id.isNotEmpty) body["prev_id"] = prev_id;
    if (next_id != null && next_id.isNotEmpty) body["next_id"] = next_id;

    final res = await dio.post(endpoint.ROOM_UPDATE_ORDER, data: body);

    if (res == null) {
      snackbar(ct: context, ms: dio.error_msg ?? "Failed to update order", cl: Colors.red);
    } else {
      snackbar(ct: context, ms: "Order updated", cl: Colors.green);
    }
  }

  Future<void> on_reload() async {
    final tmp = await dio.post(endpoint.ROOM_READ_COUNT);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    total_row = parse_int(tmp.data) ?? 0;

    int total_pages = (total_row / DEFAULT_LIMIT_ROW).ceil();
    if (current_page > total_pages) current_page = total_pages;
    if (current_page < 1) current_page = 1;

    on_load_page(current_page);
    snackbar(ct: context, ms: "Reloaded", cl: Colors.green);
  }

  Future<void> on_load_page(int p) async {
    final tmp = await dio.post(
      endpoint.ROOM_READ, //
      data: {
        "key": "order", //
        "order": 1, //
        "offset": (p - 1) * DEFAULT_LIMIT_ROW, //
        "limit": DEFAULT_LIMIT_ROW,
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    data = List<Room>.from((tmp.data ?? const []).map((d) => Room.fromJson(d)));

    // រក្សាទុក sort និង filter មុនពេលផ្ទុកឡើងវិញ
    final sorted_column = state_manager.getSortedColumn;
    final filter_rows = List<PlutoRow>.from(state_manager.filterRows);

    // បន្ថែមជួរដេកថ្មីទៅក្នុងតារាង
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, d) in data.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column_pluto) //
              c.field: (() {
                if (c.field == "action") return PlutoCell(value: "");
                if (c.field == "index") return PlutoCell(value: i + 1);
                if (c.field == Room.ID) return PlutoCell(value: d.id ?? "");
                if (c.field == Room.NUMBER) return PlutoCell(value: d.number ?? "");
                if (c.field == Room.PRICE_PER_DAY) return PlutoCell(value: d.price_per_day ?? 0.0);
                if (c.field == Room.PRICE_PER_3H) return PlutoCell(value: d.price_per_3h ?? 0.0);
                if (c.field == Room.KIND) return PlutoCell(value: d.kind ?? "");
                if (c.field == Room.STATUS) return PlutoCell(value: d.status ?? "");
                if (c.field == Room.NOTE) return PlutoCell(value: d.note ?? "");

                return PlutoCell(value: "");
              })(),
          },
        ),
    ]);

    // អនុវត្ត sort និង filter ឡើងវិញ
    if (sorted_column != null) state_manager.sortBySortIdx(sorted_column);
    state_manager.setFilterWithFilterRows(filter_rows);

    re_index();
    setState(() {});
  }

  void re_index() {
    for (int i = 0; i < state_manager.rows.length; i++) {
      final row = state_manager.rows[i];
      state_manager.changeCellValue(row.cells["index"]!, i + 1, force: true, callOnChangedEvent: false);
    }
  }

  void on_create() {
    final row = PlutoRow(
      cells: {
        for (var c in list_column_pluto) //
          c.field: PlutoCell(
            value: (() {
              if (c.type is PlutoColumnTypeNumber) return 0;
              if (c.type is PlutoColumnTypeText) return "";
              return null;
            })(),
          ),
      },
    );
    state_manager.insertRows(0, [row]);
    re_index();
    do_create(row);
  }

  Future<void> do_create(PlutoRow row) async {
    final tmp = await dio.post(endpoint.ROOM_CREATE);
    if (tmp == null) {
      await on_reload();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    final created_id = (tmp.data as List?)?.firstOrNull?["_id"] as String?;
    if (created_id != null) {
      row.cells[Room.ID]!.value = created_id;
      state_manager.notifyListeners();
    }
    snackbar(ct: context, ms: "Created", cl: Colors.green);
  }

  void on_delete(PlutoColumnRendererContext rc) {
    state_manager.removeRows([rc.row]);
    re_index();

    final id = rc.row.cells[Room.ID]?.value;
    if (id == null) return;
    do_delete(id);
  }

  Future<void> do_delete(String? id) async {
    final tmp = await dio.post(endpoint.ROOM_DELETE, data: {Room.ID: id});
    if (tmp == null) {
      await on_reload();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
      return;
    }
    snackbar(ct: context, ms: "Deleted", cl: Colors.green);
  }

  void on_updated(PlutoGridOnChangedEvent e) {
    final id = e.row.cells[Room.ID]?.value;
    do_updated(id, e.column.field, e.value);
  }

  void on_change_field(PlutoColumnRendererContext rc, String field, String v) {
    final id = rc.row.cells[Room.ID]?.value;
    if (id == null) return;
    rc.cell.value = v;
    state_manager.notifyListeners();
    do_updated(id, field, v);
  }

  Future<void> do_updated(String? id, String field, dynamic value) async {
    final tmp = await dio.post(endpoint.ROOM_UPDATE, data: {Room.ID: id, field: value});
    if (tmp == null) {
      await on_reload();
      snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
  }

  void on_first_page() {
    if (current_page == 1) return;
    current_page = 1;
    on_load_page(current_page);
  }

  void on_previous_page() {
    if (current_page == 1) return;
    current_page = current_page - 1;
    on_load_page(current_page);
  }

  void on_goto_page() async {
    final v = await dialog_select_page(
      context, //
      page: current_page,
      total_row: total_row,
      limit: DEFAULT_LIMIT_ROW,
    );
    if (v == null) return;
    current_page = v;
    await on_load_page(current_page);
  }

  void on_last_page() async {
    if (current_page == total_pages) return;
    current_page = total_pages;
    await on_load_page(current_page);
  }

  void on_next_page() async {
    if (current_page == total_pages) return;
    current_page = current_page + 1;
    await on_load_page(current_page);
  }

  void on_filter() {
    state_manager.setShowColumnFilter(!filter);
    if (!filter) state_manager.setFilterWithFilterRows([]);
    filter = !filter;
    setState(() {});
  }

  int get total_pages {
    if (total_row == 0) return 1;
    return (total_row / DEFAULT_LIMIT_ROW).ceil();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }

  // ########## BLOCK METHODS END ##########
}

// ថ្នាក់ Main_ ជាទំព័រគ្រប់គ្រងបន្ទប់
class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

// ចំណុចចាប់ផ្តើមកម្មវិធី
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
