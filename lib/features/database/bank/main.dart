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

Widget _layout(List<Widget> children) {
  return Scaffold(
    body: Column(
      children: children, //
    ),
  );
}

class _Main_State extends State<Main_> {
  dynamic tmp;

  int page = 1;
  int row_total = 0;
  bool is_loading = true;
  bool is_filter = false;
  int load_request_id = 0;
  PlutoGridStateManager? state_manager;

  void init() async {
    try {
      tmp = await dio.post(endpoint.BANK_CRUD_READ_COUNT, data: {"count": true});
      row_total = int.parse(tmp.data.toString());

      load_page(page);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_refresh() async {
    try {
      final r = await dio.post(endpoint.BANK_CRUD_READ_COUNT, data: {"count": true});
      row_total = int.parse(r.data.toString());

      if (page > total_pages) page = total_pages;
      if (page < 1) page = 1;

      load_page(page);

      snackbar(ct: context, ms: "Refresh completed.", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void load_page(int p) async {
    final request_id = ++load_request_id;

    try {
      is_loading = true;
      setState(() {});

      tmp = await dio.post(
        endpoint.BANK_CRUD_READ, //
        data: {
          "key": DEFAULT_KEY, //
          "order": DEFAULT_ORDER, //
          "offset": (p - 1) * DEFAULT_LIMIT_ROW, //
          "limit": DEFAULT_LIMIT_ROW,
        },
      );
      final data = List<Map<String, dynamic>>.from(tmp.data);

      if (!mounted || request_id != load_request_id) return;

      final sorted_column = state_manager?.getSortedColumn;
      final filter_rows = List<PlutoRow>.from(state_manager?.filterRows ?? const <PlutoRow>[]);

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
      Container(
        height: 40, //
        padding: EdgeInsets.all(1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Menu_Button_Icon(
              tip: t("Create"), //
              icon: Icons.add,
              onPressed: on_create,
            ),

            Menu_Button_Icon(
              tip: t("Read"), //
              icon: Icons.visibility_outlined,
              onPressed: on_read,
            ),

            Menu_Button_Icon(
              tip: t("Update"), //
              icon: Icons.edit_outlined,
              onPressed: on_update,
            ),

            Menu_Button_Icon(
              tip: t("Delete"), //
              icon: Icons.delete_outline,
              onPressed: on_delete,
              color: Colors.red,
            ),

            Spacer(),

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

            if (kDebugMode)
              Menu_Button_Icon(
                tip: "Search", //
                icon: Icons.search,
                onPressed: () {
                  snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
                },
              ),

            Menu_Button_Icon(
              tip: t("Refresh"), //
              icon: Icons.refresh,
              onPressed: on_refresh,
            ),
          ],
        ),
      ),

      if (is_loading) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

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

      Container(
        height: 40, //
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 120),

            Spacer(),

            Menu_Button_Icon(
              tip: t("First Page"), //
              icon: Icons.first_page,
              onPressed: () {
                if (page == 1) return;
                page = 1;
                load_page(page);
              },
            ),

            Menu_Button_Icon(
              tip: t("Previous Page"), //
              icon: Icons.navigate_before,
              onPressed: () {
                if (page == 1) return;
                page = page - 1;
                load_page(page);
              },
            ),

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

            Menu_Button_Icon(
              tip: t("Next Page"), //
              icon: Icons.navigate_next,
              onPressed: () {
                if (page == total_pages) return;
                page = page + 1;
                load_page(page);
              },
            ),

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

  void on_read() async {
    try {
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => read.Main_(
            id: row.cells[sm_bank.ID]!.value.toString(), //
          ),
        ),
      );
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_update() async {
    try {
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);
        return;
      }

      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => update.Main_(
            id: row.cells[sm_bank.ID]!.value.toString(), //
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

  void on_delete() async {
    try {
      final row = state_manager?.currentRow;
      if (row == null) {
        snackbar(ct: context, ms: "Please select a row.", cl: Colors.red);
        return;
      }

      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => delete.Main_(
            id: row.cells[sm_bank.ID]!.value.toString(), //
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

final columns = [
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
  PlutoColumn(
    field: sm_bank.ID, //
    title: "ID",
    type: PlutoColumnType.number(),
    width: WIDTH,
    enableEditingMode: false,
    hide: true, //
  ),
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

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

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
      child: const Main_(),
    ),
  );
}
