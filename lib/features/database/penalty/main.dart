// * ទំព័រគ្រប់គ្រងឧទាហរណ៍ (Demo 1) សម្រាប់បង្កើត អាន កែ និងលុប

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/dialog/dialog_page.dart";
import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/button/menu_button_text.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  int reload = 0; // this variable is used to reload the PlutoGrid when the data changes
  bool is_load = false; // this variable is used to guard the fast clicking of the buttons, to prevent multiple requests to the server

  // dynamic tmp;
  late List<String> list_c;

  bool is_filter = false;
  int page = 1;
  int row_total = 0;
  late PlutoGridStateManager state_manager;

  List<Penalty> data = [];
  // * ########## BLOCK VARIABLES END ##########

  // * ########## BLOCK METHODS ##########
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void reassemble() {
    super.reassemble();
    reload++; // * rebuild grid តាម key ដើម្បីឲ្យ hot reload អាប់ដេតជួរឈរ/ទិន្នន័យ
  }

  // * ផ្ទុកចំនួនជួរដេកសរុប និងទំព័រដំបូង
  void init() async {
    setState(() => is_load = true);
    dynamic tmp = await dio.post(endpoint.PENALTY_READ_COUNT, data: {"count": true});
    setState(() => is_load = false);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    row_total = parse_int(tmp.data) ?? 0;
    load_page(page);
  }

  // * ធ្វើឱ្យទិន្នន័យស្រស់ឡើងវិញ
  void on_refresh() async {
    setState(() => is_load = true);
    dynamic tmp = await dio.post(endpoint.PENALTY_READ_COUNT, data: {"count": true});
    setState(() => is_load = false);
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    row_total = parse_int(tmp.data) ?? 0;

    if (page > total_pages) page = total_pages;
    if (page < 1) page = 1;

    load_page(page);
  }

  // * ផ្ទុកទិន្នន័យតាមទំព័រ
  void load_page(int p) async {
    // * អានទិន្នន័យឧទាហរណ៍តាម offset និង limit
    setState(() => is_load = true);
    dynamic tmp = await dio.post(
      endpoint.PENALTY_READ, //
      data: {
        "key": DEFAULT_KEY, //
        "order": DEFAULT_ORDER, //
        "offset": (p - 1) * DEFAULT_LIMIT_ROW, //
        "limit": DEFAULT_LIMIT_ROW,
      },
    );
    setState(() => is_load = false);

    // * dio ត្រឡប់ null ពេល request បរាជ័យ
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
            for (var c in list_c) //
              c: (() {
                if (c == "index") //
                  return PlutoCell(value: i + 1);
                final penalty = data[i];
                if (c == Penalty.ID) //
                  return PlutoCell(value: penalty.id);
                if (c == Penalty.NAME) //
                  return PlutoCell(value: penalty.name);
                if (c == Penalty.PRICE) //
                  return PlutoCell(value: penalty.price);
                if (c == Penalty.NOTE) //
                  return PlutoCell(value: penalty.note);

                return PlutoCell(value: null);
              })(),
          },
        ),
    ]);

    // * អនុវត្ត sort និង filter ឡើងវិញ
    if (sorted_column != null) state_manager.sortBySortIdx(sorted_column);
    state_manager.setFilterWithFilterRows(filter_rows);

    setState(() {});
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

  void on_changed(PlutoGridOnChangedEvent e) {
    //
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

  // * បើកទំព័របង្កើតឧទាហរណ៍ថ្មី
  void on_create() async {
    //
  }

  // * បើកទំព័រលុបឧទាហរណ៍
  void on_delete() async {
    //
  }

  // * គណនាចំនួនទំព័រសរុប (បង្គត់ឡើង)
  int get total_pages {
    if (row_total == 0) return 1;
    return (row_total / DEFAULT_LIMIT_ROW).ceil();
  }

  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;
    state_manager.addListener(() => setState(() {}));
    state_manager.setAutoEditing(true);
    list_c = state_manager.refColumns.map((c) => c.field).toList();

    //  state_manager = e.stateManager;
    // state_manager.addListener(() => setState(() {}));
    // state_manager.columnFooterHeight = 32; // * កម្ពស់ជួរសរុប
    // state_manager.setShowColumnFilter(true);
    // list_column = state_manager.refColumns.map((c) => c.field).toList();

    init();
  }
  // * ########## BLOCK METHODS END ##########

  // * ########## BLOCK DESIGN ##########
  Widget _layout({
    List<Widget>? header, //
    Widget? body, //
    List<Widget>? footer, //
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

          // FOOTER
          if (footer != null)
            Container(
              height: 40, //
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
        // * toggle mini bar column
        Menu_Button_Icon(
          tip: "First Page", //
          icon: Icons.first_page,
          onPressed: () {
            //
          },
        ),

        Menu_Button_Icon(
          tip: "Previous Page",
          icon: Icons.navigate_before,
          onPressed: () {
            //
          },
        ),

        // * ប៊ូតុងជ្រើសរើសទំព័រ
        Menu_Button_Text(
          tip: t("Select Page"), //
          text: "$page / $total_pages", //
          onPressed: is_load ? null : goto_page,
        ),

        Menu_Button_Icon(
          tip: "Next Page",
          icon: Icons.navigate_next,
          onPressed: () {
            //
          },
        ),
        Menu_Button_Icon(
          tip: "Last Page",
          icon: Icons.last_page,
          onPressed: () {
            //
          },
        ),

        const Spacer(),

        Menu_Button_Icon(
          tip: "Add", //
          icon: Icons.add,
          onPressed: on_create,
        ),

        Menu_Button_Icon(
          tip: is_filter ? t("Close Filter") : t("Open Filter"), //
          icon: is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined,
          onPressed: () {
            is_filter = !is_filter;
            state_manager.setShowColumnFilter(is_filter);
            if (!is_filter) state_manager.setFilterWithFilterRows([]);
            setState(() {});
          },
        ),

        Menu_Button_Icon(
          tip: t("Refresh"), //
          icon: Icons.refresh,
          onPressed: is_load ? null : on_refresh,
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
            type: PlutoColumnType.number(),
            width: 0,
            enableEditingMode: false,
            hide: true, //
          ),

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

          PlutoColumn(
            field: Penalty.NAME, //
            title: "Name",
            type: PlutoColumnType.text(),
            // width: WIDTH,
            // enableEditingMode: false,
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
            field: Penalty.PRICE, //
            title: "Price",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,##0.00", //
            ),
            // width: WIDTH,
            width: 80,
            // enableEditingMode: false,
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

          PlutoColumn(
            field: Penalty.NOTE, //
            title: "Note",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            // width: WIDTH,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerLeft, //
                child: Text(
                  format_datetime(rc.cell.value), //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

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
                    onPressed: () {
                      print("Delete: ${rc.row.cells["index"]?.value}");
                    }, //
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

// * ថ្នាក់ Main_ ជាទំព័រគ្រប់គ្រងឧទាហរណ៍
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
