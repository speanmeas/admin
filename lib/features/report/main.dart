// TODO: make report

import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:flutter_svg/flutter_svg.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/widget/select_datetime.dart";

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_filter = false;
  bool is_loading = false;
  DateTime? start;
  DateTime? stop;
  double total_income = 0.0;
  PlutoGridStateManager? state_manager;

  void init() async {
    //
    if (kDebugMode) start = DateTime.now().subtract(Duration(days: 7));
    if (kDebugMode) stop = DateTime.now();
    if (kDebugMode) on_search();
  }

  void on_search() async {
    // validate
    if (start == null) {
      snackbar(ct: context, ms: "Please select start date", cl: Colors.red);
      return;
    }
    //
    if (stop == null) {
      snackbar(ct: context, ms: "Please select stop date", cl: Colors.red);
      return;
    }

    // check if start is after stop
    if (start!.isAfter(stop!)) {
      snackbar(ct: context, ms: "Start date must be before stop date", cl: Colors.red);
      return;
    }

    setState(() => is_loading = true);
    try {
      //
      tmp = await dio.post(
        endpoint.REPORT,
        data: {
          "key": "check_in_at", //
          "start": start?.toIso8601String(),
          "stop": stop?.toIso8601String(),
          "limit": 10000, //
        },
      );

      // add data to row
      state_manager?.removeAllRows();
      state_manager?.appendRows([
        for (var d in tmp.data)
          PlutoRow(
            cells: {
              "index": PlutoCell(value: tmp.data.indexOf(d) + 1),
              for (var e in sm_front_desk.data.entries) //
                e.key: PlutoCell(value: d[e.key] ?? ""),
            },
          ),
      ]);

      // calculate total income
      total_income = 0.0;
      for (var d in tmp.data) {
        total_income += d[sm_front_desk.ROOM_PAY_TOTAL] ?? 0.0;
        total_income += d[sm_front_desk.REVENUE_PAY_TOTAL] ?? 0.0;
      }

      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    } finally {
      setState(() => is_loading = false);
    }
  }

  Widget _layout(Widget child) {
    return Scaffold(
      body: Column(
        children: [
          // header
          Container(
            height: 40, //
            padding: EdgeInsets.all(1),
            child: Row(
              spacing: 1,
              children: [
                //
                SizedBox(
                  width: 160,
                  child: SelectDateTime(
                    title: "ចាប់ពី:", //
                    onChanged: (v) => start = v,
                  ),
                ),

                //
                SizedBox(
                  width: 160,
                  child: SelectDateTime(
                    title: "រហូតដល់:", //
                    onChanged: (v) => stop = v,
                  ),
                ),

                // search
                Tooltip(
                  message: "ស្វែងរក", //
                  child: InkWell(
                    onTap: on_search,
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.search, //
                        size: 30,
                        color: Colors.blue,
                      ), //
                    ), //
                  ),
                ),
                Spacer(),

                // filter
                Tooltip(
                  message: is_filter ? "បិទច្រោះ" : "បើកច្រោះ",
                  child: InkWell(
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      child: Icon(
                        is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, //
                        size: 30,
                        color: Colors.blue,
                      ), //
                    ), //
                    onTap: () {
                      is_filter = !is_filter; // *
                      state_manager?.setShowColumnFilter(is_filter);
                      if (!is_filter) state_manager?.setFilterWithFilterRows([]);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),

          if (is_loading) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          // body
          Expanded(child: child),

          // footer
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
                  "$total_income \$",
                  style: TextStyle(
                    fontSize: 18, //
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                Spacer(),

                //
                // if (kDebugMode)
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

                //
                // if (kDebugMode)
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

  final double WIDTH = 100; // * ទទឹងស្តង់ដាររបស់ជួរឈរទិន្នន័យ

  @override
  Widget build(BuildContext context) {
    return _layout(
      PlutoGrid(
        rows: [], //
        columns: [
          PlutoColumn(
            field: "index", //
            title: "ល.រ.",
            type: PlutoColumnType.number(),
            width: WIDTH,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight, //
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
            width: WIDTH,
            hide: true, //
          ),
          PlutoColumn(
            field: sm_front_desk.ROOM_NUMBER, //
            title: "បន្ទប់",
            type: PlutoColumnType.text(),
            width: WIDTH,
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
            field: sm_front_desk.GUEST_FULL_NAME, //
            title: "ឈ្មោះភ្ញៀវ",
            type: PlutoColumnType.text(),
            width: 150,
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
            field: sm_front_desk.STAY_N_GUEST, //
            title: "ចំនួនភ្ញៀវ",
            type: PlutoColumnType.number(),
            width: WIDTH,
            renderer: (rc) {
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${rc.cell.value} នាក់', //
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
          //
          PlutoColumn(
            field: sm_front_desk.CHECK_IN_AT, //
            title: "ពេលចូល",
            type: PlutoColumnType.text(),
            width: 150,
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
          //
          PlutoColumn(
            field: sm_front_desk.CHECK_OUT_AT, //
            title: "ពេលចេញ",
            type: PlutoColumnType.text(),
            width: 150,
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
          //
          PlutoColumn(
            field: sm_front_desk.STAY_DAY, //
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
          //
          PlutoColumn(
            field: sm_front_desk.STAY_HOUR, //
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
          //
          PlutoColumn(
            field: sm_front_desk.ROOM_PRICE, //
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
          //
          PlutoColumn(
            field: sm_front_desk.ROOM_PAY_CASH, //
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
          //
          PlutoColumn(
            field: sm_front_desk.ROOM_PAY_BANK, //
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
          //
          PlutoColumn(
            field: sm_front_desk.ROOM_RETURN, //
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
          //
          PlutoColumn(
            field: sm_front_desk.REVENUE_PRICE, //
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
          //
          PlutoColumn(
            field: sm_front_desk.REVENUE_PAY_CASH, //
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
          //
          PlutoColumn(
            field: sm_front_desk.REVENUE_PAY_BANK, //
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
          //
          PlutoColumn(
            field: sm_front_desk.REVENUE_RETURN, //
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
          //
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
        ], //
        //
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

  dynamic cell_to_data({
    dynamic data, //
    String? type, //
  }) {
    //
    if (type == "id") {
      if (data == "") return null;
      if (data != "") return data.toString();
    }

    //
    if (type == "string") {
      if (data == "") return null;
      if (data != "") return data.toString();
    }

    //
    if (type == "number") {
      if (data == "") return null;
      if (data != "") return double.tryParse(data.toString());
    }

    //
    if (type == "date-time") {
      if (data == "") return null;
      if (data != "") {
        final tmp = DateFormat(DEFAULT_DATE_FORMAT).tryParse(data.toString());
        if (tmp != null) return tmp.toIso8601String();
      }
    }

    if (type == "boolean") {
      if (data == "") return null;
      if (data == "Yes") return true;
      if (data == "No") return false;
    }

    return null;
  }

  String data_to_cell({
    dynamic data, //
    String? type, //
  }) {
    //
    if (type == "id") {
      if (data != null) return data.toString();
    }

    //
    if (type == "string") {
      if (data != null) return data.toString();
    }

    //
    if (type == "number") {
      if (data != null) return data.toString();
    }

    //
    if (type == "date-time") {
      if (data != null) {
        final tmp = DateTime.tryParse(data.toString());
        if (tmp != null) return DateFormat(DEFAULT_DATE_FORMAT).format(tmp.toLocal());
      }
    }

    //
    if (type == "boolean") {
      if (data != null) {
        if (data == true) return "Yes";
        if (data == false) return "No";
      }
    }

    return "";
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    ),
  );
}
