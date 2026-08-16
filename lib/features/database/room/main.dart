// * ទំព័រគ្រប់គ្រងបន្ទប់ សម្រាប់បង្កើត អាន កែ និងលុប

import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/dialog/dialog_page.dart";
import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/button/menu_button_text.dart";

import "form/create.dart" as create;
import "form/read.dart" as read;
import "form/update.dart" as update;
import "form/delete.dart" as delete;

// * បង្កើត layout មេរបស់ទំព័រគ្រប់គ្រងបន្ទប់
Widget _layout(List<Widget> children) {
  return Scaffold(
    body: Column(
      children: children, //
    ),
  );
}

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទិន្នន័យបន្ទប់
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;
  List<String> list_c = columns.map((c) => c.field).toList();

  bool is_filter = false;
  int page = 1;
  int row_total = 0;
  PlutoGridStateManager? state_manager;

  List<Room> data = [];

  // * ផ្ទុកចំនួនជួរដេកសរុប និងទំព័រដំបូង
  void init() async {
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_COUNT, data: {"count": true});
    setState(() => is_loading = false);
    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_CRUD_READ_COUNT}", cl: Colors.red);

    row_total = parse_int(tmp.data) ?? 0;
    load_page(page);
  }

  // * ធ្វើឱ្យទិន្នន័យស្រស់ឡើងវិញ
  void on_refresh() async {
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_COUNT, data: {"count": true});
    setState(() => is_loading = false);
    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_CRUD_READ_COUNT}", cl: Colors.red);

    row_total = parse_int(tmp.data) ?? 0;

    if (page > total_pages) page = total_pages;
    if (page < 1) page = 1;

    load_page(page);
  }

  // * ផ្ទុកទិន្នន័យតាមទំព័រ
  void load_page(int p) async {
    // * អានទិន្នន័យបន្ទប់តាម offset និង limit
    setState(() => is_loading = true);
    tmp = await dio.post(
      endpoint.ROOM_CRUD_READ, //
      data: {
        "key": DEFAULT_KEY, //
        "order": DEFAULT_ORDER, //
        "offset": (p - 1) * DEFAULT_LIMIT_ROW, //
        "limit": DEFAULT_LIMIT_ROW,
      },
    );
    setState(() => is_loading = false);

    // * dio ត្រឡប់ null ពេល request បរាជ័យ
    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_CRUD_READ}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    // * រក្សាទុក sort និង filter មុនពេលផ្ទុកឡើងវិញ
    final sorted_column = state_manager?.getSortedColumn;
    final filter_rows = List<PlutoRow>.from(state_manager?.filterRows ?? const <PlutoRow>[]);

    // * បម្លែងទិន្នន័យទៅជា List<Room> ដើម្បីបង្កើត PlutoRow
    data = List<Room>.from((tmp.data ?? const []).map((d) => Room.fromJson(d)));

    // * បន្ថែមជួរដេកថ្មីទៅក្នុងតារាង
    state_manager?.removeAllRows();
    state_manager?.appendRows([
      for (var i = 0; i < data.length; i++)
        PlutoRow(
          cells: {
            for (var c in list_c) //
              c: (() {
                if (c == "index") //
                  return PlutoCell(value: i + 1);
                final room = data[i];
                if (c == Room.ID) //
                  return PlutoCell(value: room.id);
                if (c == Room.NUMBER) //
                  return PlutoCell(value: room.number);
                if (c == Room.USD_PER_DAY) //
                  return PlutoCell(value: room.usd_per_day);
                if (c == Room.USD_PER_3H) //
                  return PlutoCell(value: room.usd_per_3h);
                if (c == Room.KIND) //
                  return PlutoCell(value: room.kind);
                if (c == Room.STATUS) //
                  return PlutoCell(value: room.status);
                if (c == Room.NOTE) //
                  return PlutoCell(value: room.note);

                return PlutoCell(value: null);
              })(),
          },
        ),
    ]);

    // * អនុវត្ត sort និង filter ឡើងវិញ
    if (sorted_column != null) state_manager?.sortBySortIdx(sorted_column);
    state_manager?.setFilterWithFilterRows(filter_rows);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // * របារម៉ឺនុយសកម្មភាព
      Container(
        height: 40, //
        padding: EdgeInsets.all(1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * ប៊ូតុងបង្កើត
            Menu_Button_Icon(
              tip: t("Create"), //
              icon: Icons.add,
              onPressed: is_loading ? null : on_create,
            ),

            // * ប៊ូតុងអាន
            Menu_Button_Icon(
              tip: t("Read"), //
              icon: Icons.visibility_outlined,
              onPressed: is_loading ? null : on_read,
            ),

            // * ប៊ូតុងកែប្រែ
            Menu_Button_Icon(
              tip: t("Update"), //
              icon: Icons.edit_outlined,
              onPressed: is_loading ? null : on_update,
            ),

            // * ប៊ូតុងលុប
            Menu_Button_Icon(
              tip: t("Delete"), //
              icon: Icons.delete_outline,
              onPressed: is_loading ? null : on_delete,
              color: Colors.red,
            ),

            Spacer(),

            // * ប៊ូតុងបើក/បិទ filter
            Menu_Button_Icon(
              tip: is_filter ? t("Close Filter") : t("Open Filter"), //
              icon: is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined,
              onPressed: () {
                is_filter = !is_filter;
                state_manager?.setShowColumnFilter(is_filter);
                if (!is_filter) state_manager?.setFilterWithFilterRows([]);
                setState(() {});
              },
            ),

            // * ប៊ូតុងស្វែងរក (តែក្នុង debug mode)
            if (kDebugMode)
              Menu_Button_Icon(
                tip: "Search", //
                icon: Icons.search,
                onPressed: () {
                  snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
                },
              ),

            // * ប៊ូតុងធ្វើឱ្យស្រស់
            Menu_Button_Icon(
              tip: t("Refresh"), //
              icon: Icons.refresh,
              onPressed: is_loading ? null : on_refresh,
            ),
          ],
        ),
      ),

      // * បង្ហាញ progress bar ពេលកំពុងផ្ទុក
      if (is_loading) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

      // * តារាងទិន្នន័យ
      Expanded(
        child: PlutoGrid(
          rows: [], //
          columns: columns, //
          configuration: PlutoGridConfiguration(
            scrollbar: PlutoGridScrollbarConfig(
              scrollbarThickness: 12, //
              scrollbarThicknessWhileDragging: 12,
              isAlwaysShown: true,
            ),
            style: PlutoGridStyleConfig(
              rowHeight: 28, //
              columnHeight: 32,
              columnFilterHeight: 36,
              defaultColumnTitlePadding: EdgeInsets.fromLTRB(8, 0, 24, 0),
              defaultColumnFilterPadding: EdgeInsets.fromLTRB(1, 1, 1, 1),
            ),
          ),
          onLoaded: (event) {
            state_manager = event.stateManager;
            state_manager?.addListener(() => setState(() {}));
          },
        ),
      ),

      // * របារប្តូរទំព័រ
      Container(
        height: 40, //
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 120),

            Spacer(),

            // * ត្រលប់ទៅទំព័រដំបូង
            Menu_Button_Icon(
              tip: t("First Page"), //
              icon: Icons.first_page,
              onPressed: is_loading ? null : goto_first_page,
            ),

            // * ប៊ូតុងទៅទំព័រមុន
            Menu_Button_Icon(
              tip: t("Previous Page"), //
              icon: Icons.navigate_before,
              onPressed: is_loading ? null : goto_previous_page,
            ),

            // * ប៊ូតុងជ្រើសរើសទំព័រ
            Menu_Button_Text(
              tip: t("Select Page"), //
              text: "$page / $total_pages", //
              onPressed: is_loading ? null : goto_page,
            ),

            // * ប៊ូតុងទៅទំព័របន្ទាប់
            Menu_Button_Icon(
              tip: t("Next Page"), //
              icon: Icons.navigate_next,
              onPressed: is_loading ? null : goto_next_page,
            ),

            // * ប៊ូតុងទៅទំព័រចុងក្រោយ
            Menu_Button_Icon(
              tip: t("Last Page"), //
              icon: Icons.last_page,
              onPressed: is_loading ? null : goto_last_page,
            ),

            Spacer(),

            // * បង្ហាញចំនួនជួរដេក
            Container(
              height: 40,
              padding: EdgeInsets.only(right: 16),
              alignment: Alignment.center,
              child: Text(
                "${state_manager?.rows.length ?? 0} Rows", //
                style: TextStyle(
                  fontSize: 18, //
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ), //
            ),

            SizedBox(width: 8),
          ],
        ),
      ),
    ]);
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

  // * បើកទំព័របង្កើតបន្ទប់ថ្មី
  void on_create() async {
    tmp = await nav_push(context, create.Main_());
    if (tmp == null) return;

    // * លុប sort + filter
    final sorted_column = state_manager?.getSortedColumn;
    if (sorted_column != null) state_manager?.sortBySortIdx(sorted_column);
    state_manager?.setFilterWithFilterRows([]);

    load_page(page);
    state_manager?.scroll.vertical?.jumpTo(0);
  }

  // * បើកទំព័រអានព័ត៌មានបន្ទប់
  void on_read() async {
    final row = state_manager?.currentRow;
    final id = row?.cells[Room.ID]?.value?.toString() ?? "";
    if (row == null || id.isEmpty) return snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);

    nav_push(context, read.Main_(id: id));
  }

  // * បើកទំព័រកែប្រែបន្ទប់
  void on_update() async {
    final row = state_manager?.currentRow;
    final id = row?.cells[Room.ID]?.value?.toString() ?? "";
    if (row == null || id.isEmpty) return snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);

    tmp = await nav_push(context, update.Main_(id: id));
    if (tmp == null) return;

    load_page(page);
  }

  // * បើកទំព័រលុបបន្ទប់
  void on_delete() async {
    final row = state_manager?.currentRow;
    final id = row?.cells[Room.ID]?.value?.toString() ?? "";
    if (row == null || id.isEmpty) {
      snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);
      return;
    }

    tmp = await nav_push(context, delete.Main_(id: id));
    if (tmp == null) return;

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
    init();
  }
}

const double WIDTH = 140;

// * និយមន័យជួរឈររបស់តារាង
final columns = [
  // * ជួរឈរលេខរៀង (No.)
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

  // * ជួរឈរ ID (លាក់)
  PlutoColumn(
    field: Room.ID, //
    title: "ID",
    type: PlutoColumnType.number(),
    width: WIDTH,
    enableEditingMode: false,
    hide: true, //
  ),

  // * ជួរឈរNumber
  PlutoColumn(
    field: Room.NUMBER, //
    title: "Number",
    type: PlutoColumnType.text(),
    width: WIDTH,
    enableEditingMode: false,
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
  // * ជួរឈរUSD/Day
  PlutoColumn(
    field: Room.USD_PER_DAY, //
    title: "USD/Day",
    type: PlutoColumnType.text(),
    width: WIDTH,
    enableEditingMode: false,
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
  // * ជួរឈរUSD/3H
  PlutoColumn(
    field: Room.USD_PER_3H, //
    title: "USD/3H",
    type: PlutoColumnType.text(),
    width: WIDTH,
    enableEditingMode: false,
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
  // * ជួរឈរKind
  PlutoColumn(
    field: Room.KIND, //
    title: "Kind",
    type: PlutoColumnType.text(),
    width: WIDTH,
    enableEditingMode: false,
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
  // * ជួរឈរStatus
  PlutoColumn(
    field: Room.STATUS, //
    title: "Status",
    type: PlutoColumnType.text(),
    width: WIDTH,
    enableEditingMode: false,
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
  // * ជួរឈរNote
  PlutoColumn(
    field: Room.NOTE, //
    title: "Note",
    type: PlutoColumnType.text(),
    width: WIDTH,
    enableEditingMode: false,
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
];

// * ថ្នាក់ Main_ ជាទំព័រគ្រប់គ្រងបន្ទប់
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
