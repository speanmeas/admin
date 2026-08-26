import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/utility/gen_data.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  dynamic tmp;
  int reload = 0;
  double WIDTH = 120;
  bool is_load = true;

  late List<String> list_column;
  late PlutoGridStateManager state_manager;

  List<Demo_1> data = [];
  // * ########## BLOCK VARIABLES END ##########

  // * ########## BLOCK METHODS ##########
  @override
  void reassemble() {
    super.reassemble();
    reload++;
  }

  void on_loaded(PlutoGridOnLoadedEvent e) async {
    state_manager = e.stateManager;

    // show filter
    // state_manager.setShowColumnFilter(true);

    list_column = state_manager.refColumns.map((c) => c.field).toList();

    state_manager.appendRows([
      for (var i = 0; i < 10; i++)
        PlutoRow(
          cells: {
            for (var c in list_column) //
              c: (() {
                if (c == "index") //
                  return PlutoCell(value: i + 1);
                if (c == "room") //
                  return PlutoCell(value: (100 + gen_number() * 900).toInt().toString());
                if (c == "guest_name") //
                  return PlutoCell(value: gen_text());
                if (c == "guest_phone") //
                  return PlutoCell(value: (1000000000 + gen_number() * 9000000000).toInt().toString());
                if (c == "stay") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "check_in") //
                  return PlutoCell(value: gen_datetime());
                if (c == "check_out") //
                  return PlutoCell(value: gen_datetime());
                if (c == "room_price") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "room_cash") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "room_bank") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "mini_bar_price") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "mini_bar_cash") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "mini_bar_bank") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "penalty_price") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "penalty_cash") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "penalty_bank") //
                  return PlutoCell(value: (gen_number() * 100).toInt().toString());
                if (c == "check_in_by") //
                  return PlutoCell(value: gen_text());
                if (c == "check_out_by") //
                  return PlutoCell(value: gen_text());
                if (c == "note_1") //
                  return PlutoCell(value: gen_text());
                if (c == "note_2") //
                  return PlutoCell(value: gen_text());

                return PlutoCell(value: null);
              })(),
          },
        ),
    ]);

    setState(() => is_load = false);
  }

  void on_changed(PlutoGridOnChangedEvent e) async {
    //
    pprint("onChanged: ${e.row.cells["index"]?.value} | ${e.column.field} | ${e.value}");
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
        children: [
          // HEADER
          Container(
            height: 34, //
            padding: const EdgeInsets.all(1),
            child: InteractiveViewer(
              panEnabled: true, //
              constrained: false, //
              scaleEnabled: false, //
              panAxis: PanAxis.horizontal, //
              alignment: Alignment.center, //
              child: Row(
                spacing: 1,
                mainAxisAlignment: MainAxisAlignment.start, //
                crossAxisAlignment: CrossAxisAlignment.center, //
                mainAxisSize: MainAxisSize.min, //
                children: [...?header],
              ),
            ),
          ),

          if (is_load) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: body ?? Container()),

          // FOOTER
          Container(
            height: 34, //
            padding: const EdgeInsets.all(1),
            child: Row(
              spacing: 2, //
              mainAxisAlignment: MainAxisAlignment.center, //
              crossAxisAlignment: CrossAxisAlignment.center, //
              children: [...?footer],
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
        SizedBox(
          height: 32,
          width: 120,
          child: TextField(
            decoration: InputDecoration(
              isDense: true, //
              hintText: "Search...", //
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.all(2), //
              prefixIcon: Icon(Icons.search, size: 24), //
              prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 32),
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
          ),
        ),

        OutlinedButton.icon(
          icon: Icon(Icons.login_outlined), //
          label: Text("Check-In"),
          onPressed: () {
            pprint("Check-In");
          },
        ),

        OutlinedButton.icon(
          icon: Icon(Icons.payment_outlined), //
          label: Text("Payment"),
          onPressed: () {
            pprint("Payment");
          },
        ),

        OutlinedButton.icon(
          icon: Icon(Icons.logout_outlined), //
          label: Text("Check-Out"),
          onPressed: () {
            pprint("Check-Out");
          },
        ),

        OutlinedButton.icon(
          icon: Icon(Icons.cleaning_services), //
          label: Text("Clean"),
          onPressed: () {
            pprint("Clean");
          },
        ),
        OutlinedButton.icon(
          icon: Icon(Icons.bug_report_outlined), //
          label: Text("Broke"),
          onPressed: () {
            pprint("Broke");
          },
        ),
        OutlinedButton.icon(
          icon: Icon(Icons.handyman_outlined), //
          label: Text("Fix"),
          onPressed: () {
            pprint("Fix");
          },
        ),
      ],
      body: PlutoGrid(
        key: ValueKey(reload), //
        rows: [], //
        columns: [
          PlutoColumn(
            field: "_id", //
            title: "ID",
            type: PlutoColumnType.number(),
            enableEditingMode: false,
            hide: true, //
          ),

          PlutoColumn(
            field: "index", //
            title: "No.",
            // titleTextAlign: PlutoColumnTextAlign.left, //
            type: PlutoColumnType.number(),
            enableEditingMode: false,
            width: 60,
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
            field: "room", //
            title: "Room",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
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
            field: "guest_name", //
            title: "Name",
            type: PlutoColumnType.text(),
            enableEditingMode: true,
            width: WIDTH,
            renderer: (rc) {
              return Row(
                children: [
                  //
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft, //
                      child: Text(
                        format_string(rc.cell.value), //
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // IconButton(
                  //   tooltip: "Edit Guest Name", //
                  //   icon: Icon(Icons.edit_outlined),
                  //   padding: EdgeInsets.all(0),
                  //   constraints: BoxConstraints(),
                  //   onPressed: () {
                  //     print("Edit Guest Name: ${rc.row.cells["index"]?.value}");
                  //   }, //
                  // ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "guest_phone", //
            title: "Phone",
            type: PlutoColumnType.text(),
            // enableEditingMode: false,
            width: WIDTH,
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

          PlutoColumn(
            field: "check_in", //
            title: "Check-In At",
            enableEditingMode: false,
            type: PlutoColumnType.text(),
            width: 160,
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
                    tooltip: "Edit", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Edit Room: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
            // renderer: (rc) {
            //   return Align(
            //     alignment: Alignment.center, //
            //     child: Text(
            //       format_datetime(rc.cell.value), //
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   );
            // },
          ),

          PlutoColumn(
            field: "stay", //
            title: "Duration",
            type: PlutoColumnType.number(
              negative: false, //
              // allowFirstDot: true,
              // format: "#,###.##",
              format: "#,###",
            ),
            // enableEditingMode: false,
            width: 100,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
                child: Text(
                  format_double(rc.cell.value, digits: 0) + " ថ្ងៃ", //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),

          PlutoColumn(
            field: "check_out", //
            title: "Check-Out At",
            enableEditingMode: false,
            type: PlutoColumnType.text(),
            width: 160,
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
                    tooltip: "Edit", //
                    icon: Icon(Icons.calendar_month_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Edit Room: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "room_price", //
            title: "Price",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            // enableEditingMode: false,
            width: 80,
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
            field: "room_cash", //
            title: "Cash",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            // enableEditingMode: false,
            width: 80,
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
            field: "room_bank", //
            title: "Bank",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            // enableEditingMode: false,
            width: 80,
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
            field: "room_note", //
            title: "Note",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
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

          PlutoColumn(
            field: "mini_bar_item", //
            title: "Items",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, //
                children: [
                  //
                  IconButton(
                    tooltip: "Update Mini Bar Items", //
                    icon: Icon(Icons.local_bar_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Update Mini Bar Items: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),

          PlutoColumn(
            field: "mini_bar_price", //
            title: "Price",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            enableEditingMode: false,
            width: 80,
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
            field: "mini_bar_cash", //
            title: "Cash",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            enableEditingMode: false,
            width: 80,
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
            field: "mini_bar_bank", //
            title: "Bank",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            enableEditingMode: false,
            width: 80,
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
            field: "mini_bar_note", //
            title: "Note",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
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

          PlutoColumn(
            field: "penalty_item", //
            title: "Items",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, //
                children: [
                  //
                  IconButton(
                    tooltip: "Update Penalty Items", //
                    icon: Icon(Icons.gavel_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Update Penalty Items: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),
          PlutoColumn(
            field: "penalty_price", //
            title: "Price",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            enableEditingMode: false,
            width: 80,
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
            field: "penalty_cash", //
            title: "Cash",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            enableEditingMode: false,
            width: 80,
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
            field: "penalty_bank", //
            title: "Bank",
            type: PlutoColumnType.number(
              negative: false, //
              format: "#,###.##",
            ),
            enableEditingMode: false,
            width: 80,
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
            field: "penalty_note", //
            title: "Note",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
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

          PlutoColumn(
            field: "check_in_by", //
            title: "Check-in By",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 140,
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
          PlutoColumn(
            field: "check_out_by", //
            title: "Check-Out By",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 140,
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

          // BUTTON RECEIPT
          PlutoColumn(
            field: "other", //
            title: "Others",
            type: PlutoColumnType.text(),
            enableEditingMode: false,
            width: 80,
            renderer: (rc) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, //
                children: [
                  //
                  IconButton(
                    tooltip: "Print Receipt", //
                    icon: Icon(Icons.print_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Print Receipt: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),

                  //
                  IconButton(
                    tooltip: "Change Room", //
                    icon: Icon(Icons.swap_horiz_outlined),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Change Room: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),

                  //
                  IconButton(
                    tooltip: "Cancel", //
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("Cancel: ${rc.row.cells["index"]?.value}");
                    }, //
                  ),
                ],
              );
            },
          ),
        ], //
        columnGroups: [
          PlutoColumnGroup(
            title: "", //
            fields: ["index"],
          ),
          PlutoColumnGroup(
            title: "", //
            fields: ["room"],
          ),
          PlutoColumnGroup(
            title: "Guest", //
            fields: ["guest_name", "guest_phone"],
          ),
          PlutoColumnGroup(
            title: "Stay", //
            fields: ["check_in", "stay", "check_out"],
          ),
          PlutoColumnGroup(
            title: "Room Payment", //
            fields: ["room_price", "room_cash", "room_bank", "room_note"],
          ),
          PlutoColumnGroup(
            title: "Mini Bar Payment", //
            fields: ["mini_bar_item", "mini_bar_price", "mini_bar_cash", "mini_bar_bank", "mini_bar_note"],
          ),
          PlutoColumnGroup(
            title: "Penalty Payment", //
            fields: ["penalty_item", "penalty_price", "penalty_cash", "penalty_bank", "penalty_note"],
          ),
          PlutoColumnGroup(
            title: "Check By", //
            fields: ["check_in_by", "check_out_by"],
          ),
          PlutoColumnGroup(
            title: "", //
            fields: ["other"],
          ),
        ],
        configuration: PlutoGridConfiguration(
          scrollbar: PlutoGridScrollbarConfig(
            scrollbarThickness: 12, //
            scrollbarThicknessWhileDragging: 12,
            isAlwaysShown: true,
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

      footer: [
        IconButton(
          tooltip: "Previous", //
          icon: Icon(Icons.navigate_before, size: 32), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {},
        ),

        TextButton(
          child: Text(
            "2026-08-24", //
            style: TextStyle(
              fontSize: 16, //
              fontWeight: FontWeight.bold, //
            ),
          ),
          onPressed: () {},
        ),

        IconButton(
          tooltip: "Next", //
          icon: Icon(Icons.navigate_next, size: 32), //
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: () {},
        ),
      ],
    );
  }

  // * ########## BLOCK DESIGN END ##########
}

// * ########## BLOCK ARGUMENTS OF MAIN ##########
class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}
// * ########## BLOCK ARGUMENTS OF MAIN END ##########

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
