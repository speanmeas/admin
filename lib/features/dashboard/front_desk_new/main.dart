import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:speanmeas/core/utility/all.dart";

class _Main_State extends State<Main_> {
  // * ########## BLOCK VARIABLES ##########
  dynamic tmp;
  int hot_reload = 0;
  bool is_load = true;

  PlutoGridStateManager? state_manager;

  late List<String> list_c = columns.map((c) => c.field).toList();

  List<Demo_1> data = [];
  final ScrollController header_controller = ScrollController();
  List<PlutoColumn> columns = [
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
      // width: WIDTH,
      enableEditingMode: false,
      hide: true, //
    ),

    PlutoColumn(
      field: Demo_1.TEXT, //
      title: "Room",
      type: PlutoColumnType.text(),
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
      title: "Guest",
      type: PlutoColumnType.text(),
      // width: WIDTH,
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
      field: Demo_1.NUMBER, //
      title: "Number 1",
      type: PlutoColumnType.number(),
      // width: WIDTH,
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
      field: Demo_1.DATE_TIME, //
      title: "Date Time 1",
      type: PlutoColumnType.text(),
      // width: WIDTH,
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
      field: Demo_1.LOGIC, //
      title: "Logic 1",
      type: PlutoColumnType.text(),
      // width: WIDTH,
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
      field: "note", //
      title: "Note",
      type: PlutoColumnType.text(),
      // width: WIDTH,
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

  List<PlutoRow> rows = [];

  // * ########## BLOCK VARIABLES END ##########

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
            child: SingleChildScrollView(
              controller: header_controller, //
              scrollDirection: Axis.horizontal, //
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
                spacing: 2, //
                // mainAxisSize: MainAxisSize.min, //
                mainAxisAlignment: MainAxisAlignment.center, //
                crossAxisAlignment: CrossAxisAlignment.center, //
                children: [...?footer],
              ),
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
        key: ValueKey(hot_reload), //
        rows: rows, //
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
          // list_c = state_manager?.columns.map((c) => c.field).toList() ?? [];
          setState(() => is_load = false);
        },
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

  // * ########## BLOCK METHODS ##########
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    header_controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    hot_reload++;
  }

  void init() async {
    pprint(list_c);
  }

  // * ########## BLOCK METHODS END ##########
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
