// TODO: add field manually

import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:flutter_svg/flutter_svg.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/global.dart"; // ignore: unused_import
import "package:speanmeas/core/config.dart"; // ignore: unused_import
import "package:speanmeas/core/i18n/main.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/select/select_date_time.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic list_fd = [];
  bool is_loading = true;

  bool is_filter = false;
  DateTime? start;
  DateTime? stop;

  double total_income = 0.0;
  PlutoGridStateManager? state_manager;

  void init() async {
    if (kDebugMode) start = DateTime.now().subtract(Duration(days: 30));
    if (kDebugMode) stop = DateTime.now();
    if (kDebugMode) on_search();

    is_loading = false;
    setState(() {});
  }

  void on_search() async {
    if (start == null) {
      snackbar(ct: context, ms: "Please select start date", cl: Colors.red);
      return;
    }

    if (stop == null) {
      snackbar(ct: context, ms: "Please select stop date", cl: Colors.red);
      return;
    }

    if (start!.isAfter(stop!)) {
      snackbar(ct: context, ms: "Start date must be before stop date", cl: Colors.red);
      return;
    }

    setState(() => is_loading = true);

    try {
      tmp = await dio.post(
        endpoint.REPORT,
        data: {
          "key": "check_in_at", //
          "start": start?.toIso8601String(),
          "stop": stop?.toIso8601String(),
          "limit": 10000, //
        },
      );
      list_fd = tmp.data as List<dynamic>? ?? [];

      state_manager?.removeAllRows();
      state_manager?.appendRows([
        for (var fd in list_fd)
          PlutoRow(
            cells: {
              for (var c in columns.map((c) => c.field).toList()) //
                c: (() {
                  if (c == "index") //
                    return PlutoCell(value: tmp.data.indexOf(fd) + 1);
                  if (c == sm_front_desk.ROOM_ID + sm_room.NUMBER) //
                    return PlutoCell(value: fd[sm_front_desk.ROOM_ID]?[sm_room.NUMBER]);
                  if (c == sm_front_desk.GUEST_ID + sm_guest.FULL_NAME) //
                    return PlutoCell(value: fd[sm_front_desk.GUEST_ID]?[sm_guest.FULL_NAME]);
                  if (c == sm_front_desk.CHECK_IN_AT) //
                    return PlutoCell(value: fd[sm_front_desk.CHECK_IN_AT]);
                  if (c == sm_front_desk.CHECK_OUT_AT) //
                    return PlutoCell(value: fd[sm_front_desk.CHECK_OUT_AT]);

                  return PlutoCell(value: null);
                })(),
            },
          ),
      ]);

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    } finally {
      // pprint("Hi");
      setState(() => is_loading = false);
    }
  }

  Widget _layout(Widget child) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 40, //
            padding: EdgeInsets.all(1),
            child: Row(
              spacing: 2,
              children: [
                SizedBox(width: 4),
                SizedBox(
                  width: 160,
                  child: Select_Date_Time(
                    lead: "ចាប់ពី:", //
                    onChanged: (v) {
                      start = v;
                      setState(() {});
                    },
                  ),
                ),

                SizedBox(
                  width: 160,
                  child: Select_Date_Time(
                    lead: "រហូតដល់:", //
                    onChanged: (v) {
                      stop = v;
                      setState(() {});
                    },
                  ),
                ),

                Menu_Button_Icon(
                  tip: "ស្វែងរក", //
                  icon: Icons.search, //
                  onPressed: on_search,
                ),

                Spacer(),

                Menu_Button_Icon(
                  tip: is_filter ? "បិទច្រោះ" : "បើកច្រោះ", //
                  icon: is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, //,
                  onPressed: () {
                    is_filter = !is_filter; // *
                    state_manager?.setShowColumnFilter(is_filter);
                    if (!is_filter) state_manager?.setFilterWithFilterRows([]);
                    setState(() {});
                  },
                ),

                SizedBox(width: 4),
              ],
            ),
          ),

          if (is_loading) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: child),

          Container(
            height: 40, //
            padding: EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                //
                Text(
                  "ចំណូលសរុប: ", //
                  style: TextStyle(
                    fontSize: 20, //
                    fontWeight: FontWeight.bold,
                  ),
                ), //
                Text(
                  "${total_income.toStringAsFixed(2)} \$",
                  style: TextStyle(
                    fontSize: 18, //
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                Spacer(),

                Tooltip(
                  message: "បញ្ចេញជា PDF",
                  child: InkWell(
                    onTap: () {
                      snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/icon/pdf.svg", //
                        width: 30,
                        height: 30,
                        colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),

                Tooltip(
                  message: "បញ្ចេញជា Excel",
                  child: InkWell(
                    onTap: () {
                      snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/icon/excel.svg", //
                        width: 30,
                        height: 30,
                        colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),
              ],
            ),
          ),
        ], //
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout(
      PlutoGrid(
        rows: [], //
        columns: columns, //
        configuration: PlutoGridConfiguration(
          // columnSize: PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale),
          // columnSize: PlutoGridColumnSizeConfig(
          //   autoSizeMode: PlutoAutoSizeMode.scale, //
          //   resizeMode: PlutoResizeMode.pushAndPull,
          // ),
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
          state_manager?.columnFooterHeight = 32; // * កម្ពស់ជួរសរុប
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

final WIDTH = 140.0; // * ទទឹងស្តង់ដាររបស់ជួរឈរទិន្នន័យ

final columns = [
  PlutoColumn(
    field: "index", //
    title: "ល.រ.",
    type: PlutoColumnType.number(),
    width: 80,
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
    field: sm_front_desk.ID, //
    title: "ID",
    type: PlutoColumnType.number(),
    hide: true, //
  ),

  PlutoColumn(
    field: sm_front_desk.ROOM_ID + sm_room.NUMBER, //
    title: "បន្ទប់",
    type: PlutoColumnType.text(),
    width: 80,
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
    field: sm_front_desk.GUEST_ID + sm_guest.FULL_NAME, //
    title: "ឈ្មោះភ្ញៀវ",
    type: PlutoColumnType.text(),
    width: WIDTH,
    renderer: (rc) {
      String value = "";
      if (rc.cell.value != null) value = rc.cell.value.toString();
      return Align(
        alignment: Alignment.centerLeft, //
        child: Text(
          value, //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.CHECK_IN_NUMBER, //
    title: "ចំនួនភ្ញៀវ",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.center, //
        child: Text(
          '${rc.cell.value} នាក់', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.CHECK_IN_AT, //
    title: "ពេលចូល",
    type: PlutoColumnType.text(),
    width: WIDTH,
    renderer: (rc) {
      String value = "";
      if (rc.cell.value != null) {
        final tmp = DateTime.tryParse(rc.cell.value.toString());
        if (tmp != null) value = DateFormat(DEFAULT_DATE_FORMAT).format(tmp.toLocal());
      }
      return Align(
        alignment: Alignment.center, //
        child: Text(
          value, //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.CHECK_OUT_AT, //
    title: "ពេលចេញ",
    type: PlutoColumnType.text(),
    width: WIDTH,
    renderer: (rc) {
      String value = "";
      if (rc.cell.value != null) {
        final tmp = DateTime.tryParse(rc.cell.value.toString());
        if (tmp != null) value = DateFormat(DEFAULT_DATE_FORMAT).format(tmp.toLocal());
      }
      return Align(
        alignment: Alignment.center, //
        child: Text(
          value, //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.CHECK_IN_DAY, //
    title: "ចំនួនថ្ងៃ",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value} ថ្ងៃ', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.CHECK_IN_HOUR, //
    title: "ចំនួនម៉ោង",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toString()} ម៉ោង', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.PAY_ROOM + "pay_price", //
    title: "ថ្លៃបន្ទប់",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toStringAsFixed(2)} \$', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        type: PlutoAggregateColumnType.sum,
        format: "#,##0.00", //
        titleSpanBuilder: (value) {
          return [
            TextSpan(
              text: "$value \$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ];
        },
        alignment: Alignment.center,
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.PAY_ROOM + "pay_cash", //
    title: "សាច់ប្រាក់",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toStringAsFixed(2)} \$', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        type: PlutoAggregateColumnType.sum,
        format: "#,##0.00", //
        titleSpanBuilder: (value) {
          return [
            TextSpan(
              text: "$value \$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ];
        },
        alignment: Alignment.center,
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.PAY_ROOM + "pay_bank", //
    title: "ធនាគារ",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toStringAsFixed(2)} \$', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        type: PlutoAggregateColumnType.sum,
        format: "#,##0.00",
        titleSpanBuilder: (value) {
          return [
            TextSpan(
              text: "$value \$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ];
        },
        alignment: Alignment.center,
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.PAY_ROOM + "pay_return", //
    title: "ប្រាក់អាប់",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toStringAsFixed(2)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        type: PlutoAggregateColumnType.sum,
        format: "#,##0.00",
        titleSpanBuilder: (value) {
          return [
            TextSpan(
              text: "- $value \$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ];
        },
        alignment: Alignment.center,
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.PAY_OTHER + "pay_price", //
    title: "ថ្លៃផ្សេងៗ",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toStringAsFixed(2)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        type: PlutoAggregateColumnType.sum,
        format: "#,##0.00", //
        titleSpanBuilder: (value) {
          return [
            TextSpan(
              text: "$value \$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ];
        },
        alignment: Alignment.center,
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.PAY_OTHER + "pay_cash", //
    title: "សាច់ប្រាក់",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toStringAsFixed(2)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        type: PlutoAggregateColumnType.sum,
        format: "#,##0.00", //
        titleSpanBuilder: (value) {
          return [
            TextSpan(
              text: "$value \$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ];
        },
        alignment: Alignment.center,
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.PAY_OTHER + "pay_bank", //
    title: "ធនាគារ",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toStringAsFixed(2)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        type: PlutoAggregateColumnType.sum,
        format: "#,##0.00", //
        titleSpanBuilder: (value) {
          return [
            TextSpan(
              text: "$value \$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ];
        },
        alignment: Alignment.center,
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.PAY_OTHER + "pay_return", //
    title: "ប្រាក់អាប់",
    type: PlutoColumnType.number(),
    width: WIDTH,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${rc.cell.value.toStringAsFixed(2)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        type: PlutoAggregateColumnType.sum,
        format: "#,##0.00", //
        titleSpanBuilder: (value) {
          return [
            TextSpan(
              text: "- $value \$", //
              style: TextStyle(
                fontSize: 16, //
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ];
        },
        alignment: Alignment.center,
      );
    },
  ),

  PlutoColumn(
    field: sm_front_desk.CHECK_IN_BY, //
    title: "ឲចូលដោយ",
    type: PlutoColumnType.text(),
    width: 160,
    renderer: (rc) {
      String value = "";
      if (rc.cell.value != null) value = rc.cell.value.toString();
      return Align(
        alignment: Alignment.centerLeft, //
        child: Text(
          value,
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
  ),

  PlutoColumn(
    field: "${sm_front_desk.PAY_ROOM}_by", //
    title: "ទទួលប្រាក់ដោយ",
    type: PlutoColumnType.text(),
    width: 160,
    renderer: (rc) {
      String value = "";
      if (rc.cell.value != null) value = rc.cell.value.toString();
      return Align(
        alignment: Alignment.centerLeft, //
        child: Text(
          value,
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
  ),
  //
  PlutoColumn(
    field: sm_front_desk.CHECK_OUT_BY, //
    title: "ឲចេញដោយ",
    type: PlutoColumnType.text(),
    width: 160,
    renderer: (rc) {
      String value = "";
      if (rc.cell.value != null) value = rc.cell.value.toString();
      return Align(
        alignment: Alignment.centerLeft, //
        child: Text(
          value,
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
  ),
  //
  // TODO: Add all notes together
  //
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
      child: MaterialApp(
        home: Main_(), //
        theme: theme_data,
        title: "Development",
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
