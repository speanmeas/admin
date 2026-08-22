import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/button/menu_button_text.dart";

Widget _layout({
  List<Widget>? header, //
  List<Widget>? body, //
  List<Widget>? footer, //
}) {
  return Scaffold(
    body: Column(
      children: [
        Container(
          height: 40, //
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: header ?? const [], //
          ),
        ),
        Expanded(
          child:
              body == null ||
                  body
                      .isEmpty //
              ? const SizedBox.shrink()
              : body.length == 1
              ? body.first
              : Column(children: body),
        ),
        Container(
          height: 40, //
          padding: EdgeInsets.all(1),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: footer ?? const [], //
          ),
        ),
      ],
    ),
  );
}

class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_load = true;
  PlutoGridStateManager? state_manager;
  List<String> list_c = columns.map((c) => c.field).toList();
  List<Demo_1> data = [];

  // * គ្រប់គ្រងម៉ឺនុយដែលបង្ហាញពេលចុចលើជួរដេក
  final MenuController _menu_controller = MenuController();
  PlutoRow? _menu_row;

  // * បញ្ជី menu item សម្រាប់ជួរដេកដែលបានជ្រើសរើស
  List<Widget> _row_menu_items(PlutoRow row) {
    return [
      MenuItemButton(
        leadingIcon: Icon(Icons.visibility_outlined, color: Colors.blue),
        child: Text("Read", style: TextStyle(color: Colors.blue)), //
        onPressed: () {
          _menu_controller.close();
          on_read();
        },
      ),
      MenuItemButton(
        leadingIcon: Icon(Icons.edit_outlined, color: Colors.blue),
        child: Text("Update", style: TextStyle(color: Colors.blue)), //
        onPressed: () {
          _menu_controller.close();
          on_update();
        },
      ),
      MenuItemButton(
        leadingIcon: Icon(Icons.delete_outline, color: Colors.red),
        child: Text("Delete", style: TextStyle(color: Colors.red)), //
        onPressed: () {
          _menu_controller.close();
          on_delete();
        },
      ),
    ];
  }

  void init() {
    // * បង្កើតទិន្នន័យសាកល្បង 100 ជួរ
    data = [
      for (var i = 0; i < 100; i++)
        Demo_1(
          id: (i + 1).toString(), //
          text_1: "Text ${i + 1}", //
          number_1: (i + 1) * 10.0, //
          datetime_1: DateTime.now().add(Duration(days: i)), //
          logic_1: i % 2 == 0, //
          note: "Note ${i + 1}", //
        ),
    ];
    is_load = false;
  }

  // * បន្ថែមទិន្នន័យទៅក្នុងតារាង (ហៅបន្ទាប់ពី grid load)
  void load_data() {
    state_manager?.removeAllRows();
    state_manager?.appendRows([
      for (var i = 0; i < data.length; i++)
        PlutoRow(
          cells: {
            for (var c in list_c) //
              c: (() {
                if (c == "index") //
                  return PlutoCell(value: i + 1);
                final demo = data[i];
                if (c == Demo_1.ID) //
                  return PlutoCell(value: demo.id);
                if (c == Demo_1.TEXT_1) //
                  return PlutoCell(value: demo.text_1);
                if (c == Demo_1.NUMBER_1) //
                  return PlutoCell(value: demo.number_1);
                if (c == Demo_1.DATETIME_1) //
                  return PlutoCell(value: demo.datetime_1);
                if (c == Demo_1.LOGIC_1) //
                  return PlutoCell(value: demo.logic_1);
                if (c == Demo_1.NOTE) //
                  return PlutoCell(value: demo.note);

                return PlutoCell(value: null);
              })(),
          },
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _layout(
      header: [
        Menu_Button_Icon(
          tip: "Check In", //
          icon: Icons.login_outlined,
          onPressed: is_load ? null : on_create,
          // color: Colors.green,
        ),
        Menu_Button_Icon(
          tip: "Payment", //
          icon: Icons.payment_outlined,
          onPressed: is_load ? null : on_create,
          // color: Colors.orange,
        ),
        Menu_Button_Icon(
          tip: "Check Out", //
          icon: Icons.logout_outlined,
          onPressed: is_load ? null : on_create,
          // color: Colors.red,
        ),
        Menu_Button_Icon(
          tip: "Clean", //
          icon: Icons.cleaning_services_outlined,
          onPressed: is_load ? null : on_create,
          // color: Colors.grey,
        ),
        Menu_Button_Icon(
          tip: "Broke", //
          icon: Icons.bug_report_outlined,
          onPressed: is_load ? null : on_create,
          // color: Colors.grey,
        ),
        Menu_Button_Icon(
          tip: "Fix", //
          icon: Icons.build_outlined,
          onPressed: is_load ? null : on_create,
          // color: Colors.grey,
        ),

        Spacer(),

        Container(
          width: 120,
          height: 38,
          padding: EdgeInsets.only(top: 8), //
          child: TextField(
            decoration: InputDecoration(
              isDense: true, //
              labelText: '${t("Search")}:', //
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
              contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
              // prefixIcon: Icon(Icons.search, size: 20), //
            ),
            onChanged: (v) {
              // * រង់ចាំអ្នកប្រើឈប់វាយទើប rebuild
              // _debounce?.cancel();
              // _debounce = Timer(const Duration(milliseconds: 200), () {
              //   search = v;
              //   setState(() {});
              // });
            },
          ),
        ),

        // Menu_Button_Icon(
        //   tip: "Toggle Filter", //
        //   // icon: is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined,
        //   icon: Icons.filter_alt_outlined,
        //   onPressed: () {},
        // ),
        Menu_Button_Icon(
          tip: "Refresh", //
          icon: Icons.refresh,
          onPressed: () {},
        ),

        SizedBox(width: 4),
      ],

      // if (is_load) LinearProgressIndicator(minHeight: 4, color: Colors.blue),
      body: [
        MenuAnchor(
          controller: _menu_controller,
          menuChildren: _menu_row == null ? const [] : _row_menu_items(_menu_row!), //
          builder: (context, controller, child) {
            return PlutoGrid(
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
              onSelected: (event) {
                // * បើកម៉ឺនុយពេលចុចលើជួរដេក
                if (event.row == null || event.cell == null) return;
                setState(() => _menu_row = event.row);
                _menu_controller.open();
              },
              onLoaded: (event) {
                state_manager = event.stateManager;
                state_manager?.addListener(() => setState(() {}));
                load_data();
              },
            );
          },
        ),
      ],

      footer: [
        Menu_Button_Icon(
          tip: "First Page", //
          icon: Icons.first_page,
          onPressed: is_load ? null : on_first_page,
        ),

        Menu_Button_Icon(
          tip: "Previous Page", //
          icon: Icons.navigate_before,
          onPressed: is_load ? null : on_previous_page,
        ),

        Menu_Button_Text(
          tip: "Select Page", //
          text: "1 / 100", //
          onPressed: () {},
        ),

        Menu_Button_Icon(
          tip: "Next Page", //
          icon: Icons.navigate_next,
          onPressed: is_load ? null : on_next_page,
        ),

        Menu_Button_Icon(
          tip: "Last Page", //
          icon: Icons.last_page,
          onPressed: is_load ? null : on_last_page,
        ),
      ],
    );
  }

  void on_first_page() {}

  void on_previous_page() {}

  void on_page() async {}

  void on_next_page() {}

  void on_last_page() {}

  void on_create() async {}

  void on_read() async {}

  void on_update() async {}

  void on_delete() async {}

  @override
  void initState() {
    super.initState();
    init();
  }
}

const double WIDTH = 140;

// * និយមន័យជួរឈររបស់តារាង
List<PlutoColumn> _columns() {
  return [
    // * ជួរឈរលេខរៀង (No.)
    PlutoColumn(
      field: "index", //
      title: "#",
      type: PlutoColumnType.number(),
      width: 60,
      enableEditingMode: false,
      enableSorting: false,
      enableColumnDrag: false,
      enableContextMenu: false,
      enableDropToResize: false,
      enableAutoEditing: false,
      enableRowDrag: false,
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

    // * ជួរឈរ ID (លាក់)
    PlutoColumn(
      field: Demo_1.ID, //
      title: "ID",
      type: PlutoColumnType.number(),
      width: WIDTH,
      enableEditingMode: false,
      hide: true, //
    ),

    // * ជួរឈរអត្ថបទទី 1
    PlutoColumn(
      field: Demo_1.TEXT_1, //
      title: "Text 1",
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

    // * ជួរឈរលេខទី 1
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

    // * ជួរឈរកាលបរិច្ឆេទទី 1
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

    // * ជួរឈរតក្កវិជ្ជា (បាទ/ទេ) ទី 1
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

    // * ជួរឈរកំណត់ចំណាំ
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
  ];
}

// * កំណែសម្រាប់បង្កើត field list (ដោយគ្មាន action callback)
final columns = _columns();

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
