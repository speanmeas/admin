// * ទំព័រគ្រប់គ្រង Penalty ដោយប្រើ inline editing និង dialog confirm/delete

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/button/menu_button_text.dart";
import "package:speanmeas/core/widget/dialog/dialog_page.dart";

import "dialog/delete.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  int reload = 0; // * rebuild PlutoGrid តាម key ដើម្បីឲ្យ hot reload អាប់ដេតជួរឈរ/ទិន្នន័យ
  int page = 1;
  int row_total = 0;
  bool is_load = false; // * guard fast clicking បង្ការការផ្ញើ request ច្រើនដង
  bool is_filter = false;

  late List<String> list_c;
  late PlutoGridStateManager state_manager;

  List<Penalty> data = [];

  // * ########## BLOCK VARIABLES END ##########

  // * ########## BLOCK METHODS ##########

  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    state_manager.addListener(() => setState(() {}));
    state_manager.setAutoEditing(true);
    list_c = state_manager.refColumns.map((c) => c.field).toList();

    init();
  }

  // * ផ្ទុកចំនួនជួរដេកសរុប និងទំព័រដំបូង
  void init() async {
    dynamic tmp = await dio.post(endpoint.PENALTY_READ_COUNT, data: {"count": true});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    row_total = parse_int(tmp.data) ?? 0;
    load_page(page);
  }

  // * ធ្វើឱ្យទិន្នន័យស្រស់ឡើងវិញ
  void on_reload() async {
    dynamic tmp = await dio.post(endpoint.PENALTY_READ_COUNT, data: {"count": true});
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    row_total = parse_int(tmp.data) ?? 0;

    if (page > total_pages) page = total_pages;
    if (page < 1) page = 1;

    load_page(page);
  }

  // * ផ្ទុកទិន្នន័យតាមទំព័រ
  void load_page(int p) async {
    // * អានទិន្នន័យ Penalty តាម offset និង limit
    dynamic tmp = await dio.post(
      endpoint.PENALTY_READ, //
      data: {
        "key": DEFAULT_KEY, //
        "order": DEFAULT_ORDER, //
        "offset": (p - 1) * DEFAULT_LIMIT_ROW, //
        "limit": DEFAULT_LIMIT_ROW,
      },
    );

    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    // * រក្សាទុក sort និង filter មុនពេលផ្ទុកឡើងវិញ
    final sorted_column = state_manager.getSortedColumn;
    final filter_rows = List<PlutoRow>.from(state_manager.filterRows);

    // * បម្លែងទិន្នន័យទៅជា List<Penalty> ដើម្បីបង្កើត PlutoRow
    data = List<Penalty>.from((tmp.data ?? const []).map((d) => Penalty.fromJson(d)));

    // * បន្ថែមជួរដេកថ្មីទៅក្នុងតារាង
    state_manager.removeAllRows();
    state_manager.appendRows([
      for (var i = 0; i < data.length; i++)
        PlutoRow(
          cells: {
            // * បញ្ចូល _id ជានិច្ច (ទោះបី column លាក់ក៏ដោយ) ដើម្បីឲ្យ delete/edit ទាញ id បាន
            Penalty.ID: PlutoCell(value: data[i].id),
            for (var c in list_c) //
              if (c != Penalty.ID) //
                c: (() {
                  if (c == "index") //
                    return PlutoCell(value: i + 1);
                  if (c == "actions") //
                    return PlutoCell(value: "");
                  final penalty = data[i];
                  if (c == Penalty.NAME) //
                    return PlutoCell(value: penalty.name ?? "");
                  if (c == Penalty.PRICE) //
                    return PlutoCell(value: penalty.price ?? 0.0);
                  if (c == Penalty.NOTE) //
                    return PlutoCell(value: penalty.note ?? "");

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

  // * បង្កើត Penalty ទទេថ្មីមួយជួរ ហើយបង្ហាញក្នុងតារាងដើម្បីកែ inline
  void on_create() async {
    dynamic tmp = await dio.post(endpoint.PENALTY_CREATE);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Added blank. Fill the row to edit.", cl: Colors.green);
    on_reload();
  }

  // * លុប Penalty តាមជួរដេកដែលបានជ្រើស
  void on_delete(PlutoColumnRendererContext rc) async {
    String? id = rc.row.cells[Penalty.ID]?.value;
    // String? name/ = rc.row.cells[Penalty.NAME]?.value;
    if (id == null) return;

    final v = await dialog_delete(
      context: context, //
      // lead: "Delete Penalty", //
      id: id, //
      // name: name ?? "", //
    );
    if (v == null) return;
    on_reload();
  }

  // * ផ្ទុកការកែប្រែ inline ទៅបម្រុងទុកភ្លាមៗ (auto-save)
  void on_changed(PlutoGridOnChangedEvent e) async {
    final id = e.row.cells[Penalty.ID]?.value;
    if (id == null) return;

    final field = e.column.field;
    final old_value = e.oldValue;
    final value = e.value;

    if (value == null || field == "index" || field == "actions") return;

    final payload = <String, dynamic>{
      Penalty.ID: id, //
      field: value, //
    };

    dynamic tmp = await dio.post(endpoint.PENALTY_UPDATE, data: payload);

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
                spacing: 2, //
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

        // * ប៊ូតុងបន្ថែម Penalty ទទេថ្មី
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

        // * ធ្វើឱ្យទិន្នន័យស្រស់
        Menu_Button_Icon(
          tip: "Refresh", //
          icon: Icons.refresh,
          onPressed: is_load ? null : on_reload,
        ),
      ],

      body: PlutoGrid(
        key: ValueKey(reload), //
        rows: [], //
        columns: [
          // * ជួរឈរ ID (លាក់)
          PlutoColumn(
            field: Penalty.ID, //
            title: "ID",
            type: PlutoColumnType.text(),
            width: 0,
            enableEditingMode: false,
            hide: true, //
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

          // * ឈ្មោះ (កែប្រែបាន)
          PlutoColumn(
            field: Penalty.NAME, //
            title: "Name",
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

          // * តម្លៃ (កែប្រែបាន)
          PlutoColumn(
            field: Penalty.PRICE, //
            title: "Price",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,##0.00", //
            ),
            width: 100,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 2) + " \$", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          // * កំណត់ចំណាំ (កែប្រែបាន)
          PlutoColumn(
            field: Penalty.NOTE, //
            title: "Note",
            type: PlutoColumnType.text(),
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
                child: Text(
                  format_string(rc.cell.value), //
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
            width: 100,
            enableEditingMode: false,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center, //
                children: [
                  IconButton(
                    tooltip: "Delete", //
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

// * ថ្នាក់ Main_ ជាទំព័រគ្រប់គ្រង Penalty
class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: MaterialApp(
        home: const Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
