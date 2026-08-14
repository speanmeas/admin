// * ទំព័រគ្រប់គ្រងធនាគារ (Bank) សម្រាប់បង្កើត អាន កែ និងលុប

import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:pluto_grid/pluto_grid.dart";

import "package:speanmeas/core/i18n/main.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/config.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/button/menu_button_text.dart";
import "package:speanmeas/core/widget/dialog/dialog_page.dart";
import "package:speanmeas/core/schema/bank.g.dart";

import "form/create.dart" as create;
import "form/read.dart" as read;
import "form/update.dart" as update;
import "form/delete.dart" as delete;

// * បង្កើត layout មេរបស់ទំព័រគ្រប់គ្រងធនាគារ
Widget _layout(List<Widget> children) {
  return Scaffold(
    body: Column(
      children: children, //
    ),
  );
}

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទិន្នន័យធនាគារ
class _Main_State extends State<Main_> {
  dynamic tmp;

  int page = 1;
  int row_total = 0;
  bool is_loading = true;
  bool is_filter = false;
  int load_request_id = 0;
  PlutoGridStateManager? state_manager;

  // * ផ្ទុកចំនួនជួរដេកសរុប និងទំព័រដំបូង
  void init() async {
    try {
      tmp = await dio.post(endpoint.BANK_CRUD_READ_COUNT, data: {"count": true});
      row_total = int.tryParse(tmp.data?.toString() ?? "0") ?? 0;

      load_page(page);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  // * ធ្វើឱ្យទិន្នន័យស្រស់ឡើងវិញ
  void on_refresh() async {
    try {
      final r = await dio.post(endpoint.BANK_CRUD_READ_COUNT, data: {"count": true});
      row_total = int.tryParse(r.data?.toString() ?? "0") ?? 0;

      if (page > total_pages) page = total_pages;
      if (page < 1) page = 1;

      load_page(page);

      snackbar(ct: context, ms: "Refresh completed.", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  // * ផ្ទុកទិន្នន័យតាមទំព័រ
  void load_page(int p) async {
    final request_id = ++load_request_id;

    try {
      is_loading = true;
      setState(() {});

      // * អានទិន្នន័យធនាគារតាម offset និង limit
      tmp = await dio.post(
        endpoint.BANK_CRUD_READ, //
        data: {
          "key": DEFAULT_KEY, //
          "order": DEFAULT_ORDER, //
          "offset": (p - 1) * DEFAULT_LIMIT_ROW, //
          "limit": DEFAULT_LIMIT_ROW,
        },
      );
      final data = List<Map<String, dynamic>>.from(tmp.data ?? const []);

      if (!mounted || request_id != load_request_id) return;

      // * រក្សាទុក sort និង filter មុនពេលផ្ទុកឡើងវិញ
      final sorted_column = state_manager?.getSortedColumn;
      final filter_rows = List<PlutoRow>.from(state_manager?.filterRows ?? const <PlutoRow>[]);

      // * បន្ថែមជួរដេកថ្មីទៅក្នុងតារាង
      state_manager?.removeAllRows();
      state_manager?.appendRows([
        for (var d in data)
          PlutoRow(
            cells: {
              "index": PlutoCell(value: data.indexOf(d) + 1),
              sm_bank.ID: PlutoCell(value: d[sm_bank.ID] ?? ""),
              sm_bank.NAME: PlutoCell(value: d[sm_bank.NAME] ?? ""),
              sm_bank.NOTE: PlutoCell(value: d[sm_bank.NOTE] ?? ""),
            },
          ),
      ]);

      // * អនុវត្ត sort និង filter ឡើងវិញ
      if (sorted_column != null) state_manager?.sortBySortIdx(sorted_column);
      state_manager?.setFilterWithFilterRows(filter_rows);

      is_loading = false;

      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
      if (request_id == load_request_id && mounted) {
        is_loading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // menu
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
              onPressed: on_create,
            ),

            // * ប៊ូតុងអាន
            Menu_Button_Icon(
              tip: t("Read"), //
              icon: Icons.visibility_outlined,
              onPressed: on_read,
            ),

            // * ប៊ូតុងកែប្រែ
            Menu_Button_Icon(
              tip: t("Update"), //
              icon: Icons.edit_outlined,
              onPressed: on_update,
            ),

            // * ប៊ូតុងលុប
            Menu_Button_Icon(
              tip: t("Delete"), //
              icon: Icons.delete_outline,
              onPressed: on_delete,
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
              onPressed: on_refresh,
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

            // * ប៊ូតុងទៅទំព័រដំបូង
            Menu_Button_Icon(
              tip: t("First Page"), //
              icon: Icons.first_page,
              onPressed: () {
                if (page == 1) return;
                page = 1;
                load_page(page);
              },
            ),

            // * ប៊ូតុងទៅទំព័រមុន
            Menu_Button_Icon(
              tip: t("Previous Page"), //
              icon: Icons.navigate_before,
              onPressed: () {
                if (page == 1) return;
                page = page - 1;
                load_page(page);
              },
            ),

            // * ប៊ូតុងជ្រើសរើសទំព័រ
            Menu_Button_Text(
              tip: t("Select Page"), //
              text: "$page / $total_pages", //
              onPressed: () async {
                final v = await select_page(
                  context, //
                  page: page,
                  row_total: row_total,
                  limit: DEFAULT_LIMIT_ROW,
                );
                if (v == null) return;
                page = v;
                load_page(page);
              },
            ),

            // * ប៊ូតុងទៅទំព័របន្ទាប់
            Menu_Button_Icon(
              tip: t("Next Page"), //
              icon: Icons.navigate_next,
              onPressed: () {
                if (page == total_pages) return;
                page = page + 1;
                load_page(page);
              },
            ),

            // * ប៊ូតុងទៅទំព័រចុងក្រោយ
            Menu_Button_Icon(
              tip: t("Last Page"), //
              icon: Icons.last_page,
              onPressed: () {
                if (page == total_pages) return;
                page = total_pages;
                load_page(page);
              },
            ),

            Spacer(),

            // * បង្ហាញចំនួនជួរដេក
            Container(
              height: 40,
              padding: EdgeInsets.only(right: 16),
              alignment: Alignment.center,
              child: Text(
                "${state_manager?.rows.length} Rows", //
                style: TextStyle(
                  fontSize: 18, //
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ), //
            ),

            SizedBox(width: 4),
          ],
        ),
      ),
    ]);
  }

  // * បើកទំព័របង្កើតធនាគារថ្មី
  void on_create() async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => create.Main_()));
      if (tmp == null) return;

      // * លុប sort + filter
      final sorted_column = state_manager?.getSortedColumn;
      if (sorted_column != null) state_manager?.sortBySortIdx(sorted_column);
      state_manager?.setFilterWithFilterRows([]);

      //
      row_total = row_total + 1;
      page = 1;
      load_page(page);

      state_manager?.scroll.vertical?.jumpTo(0);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  // * បើកទំព័រអានព័ត៌មានធនាគារ
  void on_read() async {
    try {
      final row = state_manager?.currentRow;
      final id = row?.cells[sm_bank.ID]?.value?.toString() ?? "";
      if (row == null || id.isEmpty) {
        snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => read.Main_(
            id: id, //
          ),
        ),
      );
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  // * បើកទំព័រកែប្រែធនាគារ
  void on_update() async {
    try {
      final row = state_manager?.currentRow;
      final id = row?.cells[sm_bank.ID]?.value?.toString() ?? "";
      if (row == null || id.isEmpty) {
        snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);
        return;
      }

      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => update.Main_(
            id: id, //
          ),
        ),
      );
      if (tmp == null) return;

      load_page(page);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  // * បើកទំព័រលុបធនាគារ
  void on_delete() async {
    try {
      final row = state_manager?.currentRow;
      final id = row?.cells[sm_bank.ID]?.value?.toString() ?? "";
      if (row == null || id.isEmpty) {
        snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);
        return;
      }

      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => delete.Main_(
            id: id, //
          ),
        ),
      );
      if (tmp == null) return;

      load_page(page);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  // * គណនាចំនួនទំព័រសរុប
  int get total_pages {
    if (row_total == 0) return 1;
    return (row_total + DEFAULT_LIMIT_ROW - 1) ~/ DEFAULT_LIMIT_ROW;
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

const double WIDTH = 120;

// * និយមន័យជួរឈររបស់តារាងធនាគារ
final columns = [
  // * ជួរឈរលេខរៀង
  PlutoColumn(
    field: "index", //
    title: "No.",
    type: PlutoColumnType.number(),
    width: WIDTH,
    enableEditingMode: false,
    renderer: (rc) {
      return Align(
        alignment: Alignment.center, //
        child: Text(
          rc.cell.value.toString(), //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),
  // * ជួរឈរ ID (លាក់)
  PlutoColumn(
    field: sm_bank.ID, //
    title: "ID",
    type: PlutoColumnType.number(),
    width: WIDTH,
    enableEditingMode: false,
    hide: true, //
  ),
  // * ជួរឈរឈ្មោះធនាគារ
  PlutoColumn(
    field: sm_bank.NAME, //
    title: "Name",
    type: PlutoColumnType.text(),
    width: WIDTH,
    enableEditingMode: false,
    renderer: (rc) {
      return Align(
        alignment: Alignment.center, //
        child: Text(
          rc.cell.value.toString(), //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),
  // * ជួរឈរកំណត់ចំណាំ
  PlutoColumn(
    field: sm_bank.NOTE, //
    title: "Note",
    type: PlutoColumnType.text(),
    width: WIDTH,
    enableEditingMode: false,
    renderer: (rc) {
      String value = "";
      if (rc.cell.value != null) value = rc.cell.value.toString();
      return Align(
        alignment: Alignment.center, //
        child: Text(
          value, //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),
];

// * ថ្នាក់ Main_ ជាទំព័រគ្រប់គ្រងធនាគារ
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
  //
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
