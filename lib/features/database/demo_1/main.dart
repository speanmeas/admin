import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/button/menu_button_text.dart";
import "package:speanmeas/core/widget/dialog/dialog_page.dart";

import "dialog/delete.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  int reload = 0;
  int page = 1;
  int row_total = 0;
  bool is_load = false;
  bool is_filter = false;

  late List<String> list_c;
  late PlutoGridStateManager state_manager;

  List<Demo_1> data = [];

  // * ########## BLOCK VARIABLES END ##########

  // * ########## BLOCK METHODS ##########
  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    state_manager.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    });
    state_manager.setAutoEditing(true);
    list_c = state_manager.refColumns.map((c) => c.field).toList();

    init();
  }

  void init() async {
    dynamic tmp = await dio.post(endpoint.DEMO_1_READ_COUNT, data: {"count": true});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    row_total = parse_int(tmp.data) ?? 0;

    int total_pages = (row_total / DEFAULT_LIMIT_ROW).ceil();
    if (page > total_pages) page = total_pages;
    if (page < 1) page = 1;

    load_page(page);
  }

  // read
  void load_page(int p) async {
    // * អានទិន្នន័យ Demo_1 តាម offset និង limit
    dynamic tmp = await dio.post(
      endpoint.DEMO_1_READ, //
      data: {
        "key": DEFAULT_KEY, //
        "order": DEFAULT_ORDER, //
        "offset": (p - 1) * DEFAULT_LIMIT_ROW, //
        "limit": DEFAULT_LIMIT_ROW,
      },
    );

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
            // * បញ្ចូល _id ជានិច្ច (ទោះបី column លាក់ក៏ដោយ) ដើម្បីឲ្យ delete/edit ទាញ id បាន
            Demo_1.ID: PlutoCell(value: d.id),
            for (var c in list_c) //
              if (c != Demo_1.ID) //
                c: (() {
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

  // create
  void on_create() async {
    dynamic tmp = await dio.post(endpoint.DEMO_1_CREATE);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Added blank. Fill the row to edit.", cl: Colors.green);
    init();
  }

  // delete
  void on_delete(PlutoColumnRendererContext rc) async {
    String? id = rc.row.cells[Demo_1.ID]?.value;
    if (id == null) return;

    final v = await dialog_delete(
      context: context, //
      id: id, //
    );
    if (v == null) return;
    init();
  }

  // update inline
  void on_changed(PlutoGridOnChangedEvent e) async {
    final id = e.row.cells[Demo_1.ID]?.value;
    if (id == null) return;

    final field = e.column.field;
    final old_value = e.oldValue;
    final value = e.value;

    if (value == null || field == "index" || field == "actions") return;

    final payload = <String, dynamic>{
      Demo_1.ID: id, //
      field: value, //
    };

    dynamic tmp = await dio.post(endpoint.DEMO_1_UPDATE, data: payload);

    if (tmp == null) {
      e.row.cells[field]?.value = old_value;
      return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    snackbar(ct: context, ms: "Success", cl: Colors.green);
  }

  // * ត្រលប់ទៅទំព័រដំបូង
  void goto_first_page() {
    if (page == 1) return;
    page = 1;
    load_page(page);
  }

  // * ទៅទំព័រមុន
  void goto_previous_page() {
    if (page == 1) return;
    page = page - 1;
    load_page(page);
  }

  // * ជ្រើសរើសទំព័រតាមចំនួនដែលអ្នកប្រើបញ្ចូល
  void goto_page() async {
    final v = await select_page(
      context, //
      page: page,
      row_total: row_total,
      limit: DEFAULT_LIMIT_ROW,
    );
    if (v == null) return;
    page = v;
    load_page(page);
  }

  // * ទៅទំព័របន្ទាប់
  void goto_next_page() {
    if (page == total_pages) return;
    page = page + 1;
    load_page(page);
  }

  // * ទៅទំព័រចុងក្រោយ
  void goto_last_page() {
    if (page == total_pages) return;
    page = total_pages;
    load_page(page);
  }

  // * គណនាចំនួនទំព័រសរុប (បង្គត់ឡើង)
  int get total_pages {
    if (row_total == 0) return 1;
    return (row_total / DEFAULT_LIMIT_ROW).ceil();
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

  // * ########## BLOCK DESIGN ##########
  Widget _layout({
    List<Widget>? header, //
    Widget? body, //
  }) {
    return Scaffold(
      body: Column(
        spacing: 1,
        children: [
          // HEADER
          if (header != null)
            Container(
              height: 40, //
              padding: const EdgeInsets.all(1),
              child: Row(
                spacing: 1, //
                children: header,
              ),
            ),

          if (is_load) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: body ?? Container()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _layout(
      header: [
        // * ទំព័រដំបូង
        Menu_Button_Icon(
          tip: "First Page", //
          icon: Icons.first_page,
          onPressed: is_load ? null : goto_first_page,
        ),

        // * ទំព័រមុន
        Menu_Button_Icon(
          tip: "Previous Page", //
          icon: Icons.navigate_before,
          onPressed: is_load ? null : goto_previous_page,
        ),

        // * ប៊ូតុងជ្រើសរើសទំព័រ
        Menu_Button_Text(
          tip: "Select Page", //
          text: "$page / $total_pages", //
          onPressed: is_load ? null : goto_page,
        ),

        // * ទំព័របន្ទាប់
        Menu_Button_Icon(
          tip: "Next Page", //
          icon: Icons.navigate_next,
          onPressed: is_load ? null : goto_next_page,
        ),

        // * ទំព័រចុងក្រោយ
        Menu_Button_Icon(
          tip: "Last Page", //
          icon: Icons.last_page,
          onPressed: is_load ? null : goto_last_page,
        ),

        const Spacer(),

        // * ប៊ូតុងបន្ថែម Demo_1 ទទេថ្មី
        Menu_Button_Icon(
          tip: "Add", //
          icon: Icons.add,
          onPressed: is_load ? null : on_create,
        ),

        // * បើក/បិទ filter
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
        // * open search dialog
        Menu_Button_Icon(
          tip: "Search", //
          icon: Icons.search,
          onPressed: () {
            // todo: open search dialog
          },
        ),

        // * ធ្វើឱ្យទិន្នន័យស្រស់
        Menu_Button_Icon(
          tip: "Refresh", //
          icon: Icons.refresh,
          onPressed: is_load ? null : init,
        ),
      ],

      body: PlutoGrid(
        key: ValueKey(reload), //
        rows: [], //
        columns: [
          // * ជួរឈរ ID (លាក់)
          PlutoColumn(
            field: Demo_1.ID, //
            title: "ID",
            type: PlutoColumnType.text(),
            width: kDebugMode ? 220 : 0,
            enableEditingMode: false,
          ),

          // * លេខរៀង
          PlutoColumn(
            field: "index", //
            title: "No.",
            type: PlutoColumnType.number(),
            width: 80,
            enableEditingMode: false,
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

          // * អត្ថបទ (កែប្រែបាន)
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

          // * លេខ (កែប្រែបាន)
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
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          // * កាលបរិច្ឆេទ (កែប្រែបាន)
          PlutoColumn(
            field: Demo_1.DATE_TIME, //
            title: "Date Time",
            type: PlutoColumnType.date(),
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_datetime(rc.cell.value), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          // * តក្កវិជ្ជា (កែប្រែបាន)
          PlutoColumn(
            field: Demo_1.LOGIC, //
            title: "Logic",
            type: PlutoColumnType.text(),
            renderer: (rc) {
              return Align(
                alignment: Alignment.center, //
                child: Text(
                  format_bool(rc.cell.value), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          // * ប៊ូតុងសកម្មភាព (លុប)
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
