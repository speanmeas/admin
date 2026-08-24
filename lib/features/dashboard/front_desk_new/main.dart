import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/button/menu_button_text.dart";

const double WIDTH = 140;

Widget _layout(List<Widget> children) {
  return Scaffold(
    body: Column(
      children: children, //
    ),
  );
}

class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_load = true;
  List<String> list_c = [];

  bool is_filter = false;
  int page = 1;
  int row_total = 0;
  PlutoGridStateManager? state_manager;

  List<Demo_1> data = [];

  int _grid_reload = 0;

  // * បង្ខំ PlutoGrid បង្កើតឡើងវិញពេល hot reload (pluto មិនអាន columns ថ្មីដោយខ្លួនឯងទេ)
  @override
  void reassemble() {
    super.reassemble();
    _grid_reload++;
  }

  void init() async {}

  void on_refresh() async {}

  void load_page(int p) async {}

  @override
  Widget build(BuildContext context) {
    return _layout([
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
              // onPressed: is_load ? null : on_create,
            ),

            Menu_Button_Icon(
              tip: t("Read"), //
              icon: Icons.visibility_outlined,
              // onPressed: is_load ? null : on_read,
            ),

            Menu_Button_Icon(
              tip: t("Update"), //
              icon: Icons.edit_outlined,
              // onPressed: is_load ? null : on_update,
            ),

            Menu_Button_Icon(
              tip: t("Delete"), //
              icon: Icons.delete_outline,
              // onPressed: is_load ? null : on_delete,
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
              onPressed: is_load ? null : on_refresh,
            ),
          ],
        ),
      ),

      if (is_load) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

      Expanded(
        child: PlutoGrid(
          key: ValueKey(_grid_reload), //
          rows: [], //
          columns: [
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
              field: Demo_1.ID, //
              title: "ID",
              type: PlutoColumnType.number(),
              width: WIDTH,
              enableEditingMode: false,
              hide: true, //
            ),

            PlutoColumn(
              field: Demo_1.TEXT_1, //
              title: "Room Number",
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
            PlutoColumn(
              field: "001", //
              title: "Guest Name",
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

            PlutoColumn(
              field: Demo_1.NUMBER_1, //
              title: "Number 1",
              type: PlutoColumnType.number(),
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

            PlutoColumn(
              enableEditingMode: false,
              field: Demo_1.DATETIME_1, //
              title: "Date Time 1",
              type: PlutoColumnType.text(),
              width: WIDTH,
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

            PlutoColumn(
              field: Demo_1.LOGIC_1, //
              title: "Logic 1",
              type: PlutoColumnType.text(),
              width: WIDTH,
              enableEditingMode: false,
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

            PlutoColumn(
              field: Demo_1.NOTE, //
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
          ], //
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
            list_c = state_manager?.columns.map((c) => c.field).toList() ?? [];
            setState(() => is_load = false);
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
              // onPressed: is_load ? null : goto_first_page,
            ),

            Menu_Button_Icon(
              tip: t("Previous Page"), //
              icon: Icons.navigate_before,
              // onPressed: is_load ? null : goto_previous_page,
            ),

            Menu_Button_Text(
              tip: t("Select Page"), //
              text: "1 / 100", //
              // onPressed: is_load ? null : goto_page,
            ),

            Menu_Button_Icon(
              tip: t("Next Page"), //
              icon: Icons.navigate_next,
              // onPressed: is_load ? null : goto_next_page,
            ),

            Menu_Button_Icon(
              tip: t("Last Page"), //
              icon: Icons.last_page,
              // onPressed: is_load ? null : goto_last_page,
            ),

            Spacer(),

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

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

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
