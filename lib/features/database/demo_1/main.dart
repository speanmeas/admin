import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";

import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/dialog/dialog_datetime.dart";
import "package:speanmeas/core/widget/dialog/select_page.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK ATTRIBUTE ##########
  int reload = 0;
  bool is_load = false;
  bool is_filter = false;
  int current_page = 1;
  int total_row = 0;

  late List<String> list_column;
  late PlutoGridStateManager state_manager;

  List<Demo_1> data = [];

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

          if (is_load) LinearProgressIndicator(minHeight: 2, color: Colors.blue),

          Expanded(child: body ?? Container()),
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
          onPressed: is_load ? null : on_first_page,
        ),

        IconButton(
          tooltip: "Previous Page", //
          icon: Icon(Icons.navigate_before, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: is_load ? null : on_previous_page,
        ),

        TextButton(
          child: Text(
            "$current_page / $total_pages", //
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: is_load ? null : on_goto_page,
        ),

        IconButton(
          tooltip: "Next Page", //
          icon: Icon(Icons.navigate_next, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: is_load ? null : on_next_page,
        ),

        IconButton(
          tooltip: "Last Page", //
          icon: Icon(Icons.last_page, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: is_load ? null : on_last_page,
        ),

        const Spacer(),

        IconButton(
          tooltip: is_filter ? "Hide Filter" : "Show Filter", //
          icon: Icon(is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: is_load ? null : on_filter, // not yet implemented
        ),

        IconButton(
          tooltip: "Reload", //
          icon: Icon(Icons.refresh, size: 30), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: is_load ? null : on_reload,
        ),
      ],

      body: PlutoGrid(
        key: ValueKey(reload), //
        rows: [], //
        columns: [
          PlutoColumn(
            field: Demo_1.ID, //
            title: "ID",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 0,
            // width: kDebugMode ? 220 : 0,
          ),

          PlutoColumn(
            field: "index", //
            title: "",
            titleSpan: WidgetSpan(
              child: Container(
                padding: EdgeInsets.only(left: 20), //
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 28), //
                  padding: EdgeInsets.all(0),
                  constraints: BoxConstraints(),
                  onPressed: is_load ? null : on_create, // implemented
                ),
              ),
            ),
            type: PlutoColumnType.number(),
            width: 80,
            enableEditingMode: false,
            enableColumnDrag: false,
            enableContextMenu: false,
            enableDropToResize: false,
            enableFilterMenuItem: false,
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
            field: Demo_1.TEXT, //
            title: "Text",
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

          PlutoColumn(
            field: Demo_1.NUMBER, //
            title: "Number",
            type: PlutoColumnType.number(
              negative: true, //
              format: "#,##0.00", //
            ),
            width: 120,
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_double(rc.cell.value, digits: 2), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: Demo_1.DATE_TIME, //
            title: "Date Time",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 150,
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
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_change_datetime(rc), //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: Demo_1.LOGIC, //
            title: "Logic",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              bool value = rc.cell.value ?? false;
              return Center(
                child: SizedBox(
                  height: 24,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Switch(
                      value: value,
                      onChanged: (v) => on_change_bool(rc, v), //
                    ),
                  ),
                ),
              );
            },
          ),

          PlutoColumn(
            field: "actions", //
            title: "Actions",
            type: PlutoColumnType.text(),
            width: 80,
            enableEditingMode: false,
            enableSorting: false,
            enableColumnDrag: false,
            enableContextMenu: false,
            enableDropToResize: false,
            enableFilterMenuItem: false,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "Delete Row", //
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => on_delete(rc),
                  ),
                ],
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

        onLoaded: init,
        onChanged: on_changed,
      ),
    );
  }
  // * ########## BLOCK DESIGN END ##########

  // * ########## BLOCK METHODS ##########
  void init(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;

    state_manager.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    });
    state_manager.setAutoEditing(true);
    list_column = state_manager.refColumns.map((c) => c.field).toList();

    on_reload();
  }

  void on_reload() async {
    setState(() => is_load = true);
    final tmp = await dio.post(endpoint.DEMO_1_READ_COUNT);
    setState(() => is_load = false);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    total_row = parse_int(tmp.data) ?? 0;

    int total_pages = (total_row / DEFAULT_LIMIT_ROW).ceil();
    if (current_page > total_pages) current_page = total_pages;
    if (current_page < 1) current_page = 1;

    on_load_page(current_page);
  }

  void on_load_page(int p) async {
    setState(() => is_load = true);
    final tmp = await dio.post(
      endpoint.DEMO_1_READ, //
      data: {
        "key": DEFAULT_KEY, //
        "order": DEFAULT_ORDER, //
        "offset": (p - 1) * DEFAULT_LIMIT_ROW, //
        "limit": DEFAULT_LIMIT_ROW,
      },
    );
    setState(() => is_load = false);

    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    data = List<Demo_1>.from((tmp.data ?? const []).map((d) => Demo_1.fromJson(d)));

    // * រក្សាទុក sort និង filter មុនពេលផ្ទុកឡើងវិញ
    final sorted_column = state_manager.getSortedColumn;
    final filter_rows = List<PlutoRow>.from(state_manager.filterRows);

    // * បន្ថែមជួរដេកថ្មីទៅក្នុងតារាង
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var (i, d) in data.indexed)
        PlutoRow(
          cells: {
            for (var c in list_column) //
              c: (() {
                if (c == Demo_1.ID) return PlutoCell(value: d.id ?? "");
                if (c == "index") return PlutoCell(value: i + 1);
                if (c == "actions") return PlutoCell(value: "");
                if (c == Demo_1.TEXT) return PlutoCell(value: d.text ?? "");
                if (c == Demo_1.NUMBER) return PlutoCell(value: d.number ?? 0.0);
                if (c == Demo_1.DATE_TIME) return PlutoCell(value: d.date_time);
                if (c == Demo_1.LOGIC) return PlutoCell(value: d.logic ?? false);

                return PlutoCell(value: "");
              })(),
          },
        ),
    ]);

    // * អនុវត្ត sort និង filter ឡើងវិញ
    if (sorted_column != null) state_manager.sortBySortIdx(sorted_column);
    state_manager.setFilterWithFilterRows(filter_rows);

    setState(() {});
  }

  void on_create() async {
    setState(() => is_load = true);
    final tmp = await dio.post(endpoint.DEMO_1_CREATE);
    setState(() => is_load = false);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Created", cl: Colors.green);
    on_reload();
  }

  void on_delete(PlutoColumnRendererContext rc) async {
    setState(() => is_load = true);
    final id = rc.row.cells[Demo_1.ID]?.value;
    final tmp = await dio.post(endpoint.DEMO_1_DELETE, data: {Demo_1.ID: id});
    setState(() => is_load = false);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Deleted", cl: Colors.green);
    on_reload();
  }

  void on_changed(PlutoGridOnChangedEvent e) async {
    final id = e.row.cells[Demo_1.ID]?.value;
    final tmp = await dio.post(endpoint.DEMO_1_UPDATE, data: {Demo_1.ID: id, e.column.field: e.value});

    if (tmp == null) {
      on_reload();
      return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    snackbar(ct: context, ms: "Updated", cl: Colors.green);
  }

  void on_change_datetime(PlutoColumnRendererContext rc) async {
    DateTime? dt = rc.cell.value;
    final v = await dialog_datetime(context, initial: dt);
    if (v == null) return;
    rc.cell.value = v;
    final id = rc.row.cells[Demo_1.ID]?.value;
    if (id == null) return;
    final tmp = await dio.post(endpoint.DEMO_1_UPDATE, data: {Demo_1.ID: id, Demo_1.DATE_TIME: v.toIso8601String()});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_reload();
  }

  void on_change_bool(PlutoColumnRendererContext rc, bool v) async {
    final id = rc.row.cells[Demo_1.ID]?.value;
    final tmp = await dio.post(endpoint.DEMO_1_UPDATE, data: {Demo_1.ID: id, Demo_1.LOGIC: v});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    snackbar(ct: context, ms: "Updated", cl: Colors.green);
    on_reload();
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
    on_load_page(current_page);
  }

  void on_last_page() {
    if (current_page == total_pages) return;
    current_page = total_pages;
    on_load_page(current_page);
  }

  void on_next_page() {
    if (current_page == total_pages) return;
    current_page = current_page + 1;
    on_load_page(current_page);
  }

  void on_filter() {
    state_manager.setShowColumnFilter(!is_filter);
    if (!is_filter) state_manager.setFilterWithFilterRows([]);
    is_filter = !is_filter;
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

  // * ########## BLOCK METHODS END ##########
}

// * ថ្នាក់ Main_ ជាទំព័រគ្រប់គ្រង Demo_1
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
