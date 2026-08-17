// * ទំព័ររបាយការណ៍ចំណូល (Report)

// TODO: add field manually

import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:provider/provider.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:flutter_svg/flutter_svg.dart";

import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/select/select_date_time.dart";

// * បូកតម្លៃពីបញ្ជីទូទាត់តាម accessor (បញ្ជីទទេត្រឡប់ 0)
double _sum<T>(List<T>? list, double Function(T) f) {
  double total = 0;
  for (var l in (list ?? [])) {
    total += f(l);
  }
  return total;
}

// * យកធាតុចុងក្រោយនៃបញ្ជីដោយសុវត្ថិភាព (បញ្ជីទទេត្រឡប់ null)
T? _lastOf<T>(List<T>? list) {
  if (list == null || list.isEmpty) return null;
  return list.last;
}

// * បង្ហាញលេខបន្ទប់ ឬ "Walk in" សម្រាប់ walk-in mini bar (ពេលគ្មានបន្ទប់)
String _room_cell(Front_Desk fd) {
  final number = fd.room_id?.number ?? "";
  if (number.isNotEmpty) return number;
  return "Walk in";
}

// * អ្នកទទួលប្រាក់ចុងក្រោយ
String _receiver(Front_Desk fd) {
  final room = _lastOf(fd.pay_room)?.created_by?.full_name ?? "";
  if (room.isNotEmpty) return room;
  final mini = _lastOf(fd.pay_mini_bar)?.created_by?.full_name ?? "";
  if (mini.isNotEmpty) return mini;
  return _lastOf(fd.pay_other)?.created_by?.full_name ?? "";
}

// * បញ្ចូល note ទាំងអស់ចូលគ្នា
String _notes(Front_Desk fd) {
  final parts = <String>[
    if ((fd.check_in_note ?? "").isNotEmpty) fd.check_in_note!,
    if ((fd.cancel_note ?? "").isNotEmpty) fd.cancel_note!,
    if ((fd.change_note ?? "").isNotEmpty) fd.change_note!,
    if ((fd.check_out_note ?? "").isNotEmpty) fd.check_out_note!,
    if ((fd.clean_note ?? "").isNotEmpty) fd.clean_note!,
    if ((fd.broke_note ?? "").isNotEmpty) fd.broke_note!,
    if ((fd.fix_note ?? "").isNotEmpty) fd.fix_note!,
    for (var p in (fd.pay_room ?? []))
      if ((p.note ?? "").isNotEmpty) p.note!,
    for (var p in (fd.pay_mini_bar ?? []))
      if ((p.note ?? "").isNotEmpty) p.note!,
    for (var p in (fd.pay_other ?? []))
      if ((p.note ?? "").isNotEmpty) p.note!,
  ];
  return parts.join(" | ");
}

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការស្វែងរក និងបង្ហាញរបាយការណ៍
class _Main_State extends State<Main_> {
  dynamic tmp;
  List<Front_Desk> data = [];
  bool is_loading = true;

  bool is_filter = false;
  DateTime? start;
  DateTime? stop;

  double total_income = 0.0;
  double total_revenue = 0.0;
  PlutoGridStateManager? state_manager;

  List<String> list_c = columns.map((c) => c.field).toList();

  // * ផ្ទុកទិន្នន័យដំបូង (ក្នុងរបៀប debug កំណត់កាលបរិច្ឆេទស្វែងរកស្វ័យប្រវត្តិ)
  void init() async {
    if (kDebugMode) start = DateTime.now().subtract(Duration(days: 30));
    if (kDebugMode) stop = DateTime.now();
    if (kDebugMode) on_search();

    is_loading = false;
    setState(() {});
  }

  // * ស្វែងរករបាយការណ៍តាមកាលបរិច្ឆេទ
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

    // * ផ្ញើសំណើស្វែងរករបាយការណ៍
    setState(() => is_loading = true);
    tmp = await dio.post(
      endpoint.REPORT, //
      data: {
        "start": start?.toIso8601String(), //
        "stop": stop?.toIso8601String(), //
      },
    );
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.REPORT}", cl: Colors.red);

    data = List<Front_Desk>.from((tmp.data ?? const []).map((d) => Front_Desk.fromJson(d)));
    pprint(data);

    _calc_totals();

    // * បំពេញជួរដេកទៅក្នុងតារាង
    state_manager?.removeAllRows();
    state_manager?.appendRows([
      for (var fd in data)
        PlutoRow(
          cells: {
            for (var c in list_c) //
              c: (() {
                if (c == "index") //
                  return PlutoCell(value: data.indexOf(fd) + 1);
                if (c == Front_Desk.ID) //
                  return PlutoCell(value: parse_string(fd.id));
                if (c == Front_Desk.ROOM_ID + Room_Show.NUMBER) //
                  return PlutoCell(value: _room_cell(fd));
                if (c == Front_Desk.GUEST_ID + Guest_Show.FULL_NAME) //
                  return PlutoCell(value: parse_string(fd.guest_id?.full_name));
                if (c == Front_Desk.CHECK_IN_NUMBER) //
                  return PlutoCell(value: parse_double(fd.check_in_number));
                if (c == Front_Desk.CHECK_IN_AT) //
                  return PlutoCell(value: parse_datetime(fd.check_in_at));
                if (c == Front_Desk.CHECK_IN_DUE) //
                  return PlutoCell(value: parse_datetime(fd.check_in_due));
                if (c == Front_Desk.CHECK_IN_DAY) //
                  return PlutoCell(value: parse_int(fd.check_in_day));
                if (c == Front_Desk.CHECK_IN_HOUR) //
                  return PlutoCell(value: parse_int(fd.check_in_hour));

                if (c == Front_Desk.PAY_ROOM + Pay_Room.ADD_PRICE) //
                  return PlutoCell(value: _sum(fd.pay_room, (p) => (p.add_price ?? 0) - (p.sub_price ?? 0)));
                if (c == Front_Desk.PAY_ROOM + Pay_Room.ADD_CASH) //
                  return PlutoCell(value: _sum(fd.pay_room, (p) => p.add_cash ?? 0));
                if (c == Front_Desk.PAY_ROOM + Pay_Room.ADD_BANK) //
                  return PlutoCell(value: _sum(fd.pay_room, (p) => p.add_bank ?? 0));
                if (c == Front_Desk.PAY_ROOM + Pay_Room.SUB_RETURN) //
                  return PlutoCell(value: _sum(fd.pay_room, (p) => p.sub_return ?? 0));

                if (c == Front_Desk.PAY_MINI_BAR + Pay_Mini_Bar.ADD_PRICE) //
                  return PlutoCell(value: _sum(fd.pay_mini_bar, (p) => (p.add_price ?? 0) - (p.sub_price ?? 0)));
                if (c == Front_Desk.PAY_MINI_BAR + Pay_Mini_Bar.ADD_CASH) //
                  return PlutoCell(value: _sum(fd.pay_mini_bar, (p) => p.add_cash ?? 0));
                if (c == Front_Desk.PAY_MINI_BAR + Pay_Mini_Bar.ADD_BANK) //
                  return PlutoCell(value: _sum(fd.pay_mini_bar, (p) => p.add_bank ?? 0));
                if (c == Front_Desk.PAY_MINI_BAR + Pay_Mini_Bar.SUB_RETURN) //
                  return PlutoCell(value: _sum(fd.pay_mini_bar, (p) => p.sub_return ?? 0));

                if (c == Front_Desk.PAY_OTHER + Pay_Other.ADD_PRICE) //
                  return PlutoCell(value: _sum(fd.pay_other, (p) => (p.add_price ?? 0) - (p.sub_price ?? 0)));
                if (c == Front_Desk.PAY_OTHER + Pay_Other.ADD_CASH) //
                  return PlutoCell(value: _sum(fd.pay_other, (p) => p.add_cash ?? 0));
                if (c == Front_Desk.PAY_OTHER + Pay_Other.ADD_BANK) //
                  return PlutoCell(value: _sum(fd.pay_other, (p) => p.add_bank ?? 0));
                if (c == Front_Desk.PAY_OTHER + Pay_Other.SUB_RETURN) //
                  return PlutoCell(value: _sum(fd.pay_other, (p) => p.sub_return ?? 0));

                if (c == Front_Desk.CHECK_IN_BY + User_Show.FULL_NAME) //
                  return PlutoCell(value: parse_string(fd.check_in_by?.full_name));

                if (c == Front_Desk.PAY_ROOM + User_Show.FULL_NAME) //
                  return PlutoCell(value: _receiver(fd));

                if (c == Front_Desk.CHECK_OUT_BY + User_Show.FULL_NAME) //
                  return PlutoCell(value: parse_string(fd.check_out_by?.full_name));

                if (c == "note") //
                  return PlutoCell(value: _notes(fd));

                return PlutoCell(value: null);
              })(),
          },
        ),
    ]);

    setState(() {});
  }

  // * គណនាចំណូលសរុប (income) និងចំណូលសុទ្ធ (revenue)
  // * income = ប្រាក់ដែលបានទទួលពិតប្រាកដ (add_cash + add_bank)
  // * revenue = តម្លៃសេវាកម្ម (add_price - sub_price)
  void _calc_totals() {
    total_income = 0;
    total_revenue = 0;
    for (var fd in data) {
      for (var p in (fd.pay_room ?? [])) {
        total_income += (p.add_cash ?? 0) + (p.add_bank ?? 0);
        total_revenue += (p.add_price ?? 0) - (p.sub_price ?? 0);
      }
      for (var p in (fd.pay_mini_bar ?? [])) {
        total_income += (p.add_cash ?? 0) + (p.add_bank ?? 0);
        total_revenue += (p.add_price ?? 0) - (p.sub_price ?? 0);
      }
      for (var p in (fd.pay_other ?? [])) {
        total_income += (p.add_cash ?? 0) + (p.add_bank ?? 0);
        total_revenue += (p.add_price ?? 0) - (p.sub_price ?? 0);
      }
    }
  }

  // * បង្កើត layout មេរបស់ទំព័ររបាយការណ៍
  Widget _layout(Widget child) {
    return Scaffold(
      body: Column(
        children: [
          // * របារឧបករណ៍ស្វែងរក និងច្រោះ
          Container(
            height: 40, //
            padding: EdgeInsets.all(1),
            child: Row(
              spacing: 2,
              children: [
                SizedBox(width: 4),
                // * ជ្រើសរើសកាលបរិច្ឆេទចាប់ផ្តើម
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

                // * ជ្រើសរើសកាលបរិច្ឆេទបញ្ចប់
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

                // * ប៊ូតុងស្វែងរក
                Menu_Button_Icon(
                  tip: "ស្វែងរក", //
                  icon: Icons.search, //
                  onPressed: on_search,
                ),

                Spacer(),

                // * ប៊ូតុងបើក/បិទការច្រោះជួរឈរ
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

          // * បន្ទាត់រីកចម្រើនពេលកំពុងផ្ទុក
          if (is_loading) LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          Expanded(child: child),

          // * របារបាតបង្ហាញចំណូលសរុប និងប៊ូតុងបញ្ចេញឯកសារ
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

                SizedBox(width: 24),

                // * ប្រាក់ចំណូលសុទ្ធ (revenue)
                Text(
                  "ចំណូលសុទ្ធ: ", //
                  style: TextStyle(
                    fontSize: 20, //
                    fontWeight: FontWeight.bold,
                  ),
                ), //
                Text(
                  "${total_revenue.toStringAsFixed(2)} \$",
                  style: TextStyle(
                    fontSize: 18, //
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                Spacer(),

                // * ប៊ូតុងបញ្ចេញជា PDF
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

                // * ប៊ូតុងបញ្ចេញជា Excel
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
      // * តារាងទិន្នន័យរបាយការណ៍
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

// * និយមន័យជួរឈររបស់តារាងរបាយការណ៍
final columns = [
  // * ជួរឈរលេខរៀង
  PlutoColumn(
    field: "index", //
    title: "ល.រ.",
    type: PlutoColumnType.number(),
    width: 80,
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
    field: Front_Desk.ID, //
    title: "ID",
    type: PlutoColumnType.number(),
    hide: true, //
  ),

  // * ជួរឈរលេខបន្ទប់
  PlutoColumn(
    field: Front_Desk.ROOM_ID + Room_Show.NUMBER, //
    title: "បន្ទប់",
    type: PlutoColumnType.text(),
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

  // * ជួរឈរឈ្មោះភ្ញៀវ
  PlutoColumn(
    field: Front_Desk.GUEST_ID + Guest_Show.FULL_NAME, //
    title: "ឈ្មោះភ្ញៀវ",
    type: PlutoColumnType.text(),
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

  // * ជួរឈរចំនួនភ្ញៀវ
  PlutoColumn(
    field: Front_Desk.CHECK_IN_NUMBER, //
    title: "ចំនួនភ្ញៀវ",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.center, //
        child: Text(
          '${format_int(rc.cell.value)} នាក់', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  // * ជួរឈរពេលចូល
  PlutoColumn(
    field: Front_Desk.CHECK_IN_AT, //
    title: "ពេលចូល",
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

  // * ជួរឈរពេលចេញ (stay due = ថ្ងៃដល់កំណត់ចេញ)
  PlutoColumn(
    field: Front_Desk.CHECK_IN_DUE, //
    title: "ពេលចេញ",
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

  // * ជួរឈរចំនួនថ្ងៃស្នាក់នៅ
  PlutoColumn(
    field: Front_Desk.CHECK_IN_DAY, //
    title: "ចំនួនថ្ងៃ",
    type: PlutoColumnType.number(),
    width: 80,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_int(rc.cell.value)} ថ្ងៃ', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  // * ជួរឈរចំនួនម៉ោងស្នាក់នៅ
  PlutoColumn(
    field: Front_Desk.CHECK_IN_HOUR, //
    title: "ចំនួនម៉ោង",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_int(rc.cell.value)} ម៉ោង', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  ),

  // * ជួរឈរថ្លៃបន្ទប់
  PlutoColumn(
    field: Front_Desk.PAY_ROOM + Pay_Room.ADD_PRICE, //
    title: "ថ្លៃបន្ទប់",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        type: PlutoAggregateColumnType.sum,
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរសាច់ប្រាក់ (បន្ទប់)
  PlutoColumn(
    field: Front_Desk.PAY_ROOM + Pay_Room.ADD_CASH, //
    title: "សាច់ប្រាក់",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរបង់ប្រាក់តាមធនាគារ (បន្ទប់)
  PlutoColumn(
    field: Front_Desk.PAY_ROOM + Pay_Room.ADD_BANK, //
    title: "ធនាគារ",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$', //
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00",
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរប្រាក់អាប់ (បន្ទប់)
  PlutoColumn(
    field: Front_Desk.PAY_ROOM + Pay_Room.SUB_RETURN, //
    title: "ប្រាក់អាប់",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00",
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរថ្លៃ mini bar
  PlutoColumn(
    field: Front_Desk.PAY_MINI_BAR + Pay_Mini_Bar.ADD_PRICE, //
    title: "ថ្លៃមីនីបារ",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរសាច់ប្រាក់ (mini bar)
  PlutoColumn(
    field: Front_Desk.PAY_MINI_BAR + Pay_Mini_Bar.ADD_CASH, //
    title: "សាច់ប្រាក់",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរបង់ប្រាក់តាមធនាគារ (mini bar)
  PlutoColumn(
    field: Front_Desk.PAY_MINI_BAR + Pay_Mini_Bar.ADD_BANK, //
    title: "ធនាគារ",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរប្រាក់អាប់ (mini bar)
  PlutoColumn(
    field: Front_Desk.PAY_MINI_BAR + Pay_Mini_Bar.SUB_RETURN, //
    title: "ប្រាក់អាប់",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរថ្លៃផ្សេងៗ
  PlutoColumn(
    field: Front_Desk.PAY_OTHER + Pay_Other.ADD_PRICE, //
    title: "ថ្លៃផ្សេងៗ",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរសាច់ប្រាក់ (ផ្សេងៗ)
  PlutoColumn(
    field: Front_Desk.PAY_OTHER + Pay_Other.ADD_CASH, //
    title: "សាច់ប្រាក់",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរបង់ប្រាក់តាមធនាគារ (ផ្សេងៗ)
  PlutoColumn(
    field: Front_Desk.PAY_OTHER + Pay_Other.ADD_BANK, //
    title: "ធនាគារ",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរប្រាក់អាប់ (ផ្សេងៗ)
  PlutoColumn(
    field: Front_Desk.PAY_OTHER + Pay_Other.SUB_RETURN, //
    title: "ប្រាក់អាប់",
    type: PlutoColumnType.number(),
    width: 100,
    renderer: (rc) {
      return Align(
        alignment: Alignment.centerRight, //
        child: Text(
          '${format_double(rc.cell.value)} \$',
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
    footerRenderer: (rc) {
      return PlutoAggregateColumnFooter(
        rendererContext: rc, //
        format: "#,##0.00", //
        alignment: Alignment.centerRight,
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
      );
    },
  ),

  // * ជួរឈរអ្នកឲចូល
  PlutoColumn(
    field: Front_Desk.CHECK_IN_BY + User_Show.FULL_NAME, //
    title: "ឲចូលដោយ",
    type: PlutoColumnType.text(),
    width: 160,
    renderer: (rc) {
      return Align(
        alignment: Alignment.center, //
        child: Text(
          format_string(rc.cell.value),
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
  ),

  // * ជួរឈរអ្នកទទួលប្រាក់
  PlutoColumn(
    field: Front_Desk.PAY_ROOM + User_Show.FULL_NAME, //
    title: "ទទួលប្រាក់ដោយ",
    type: PlutoColumnType.text(),
    width: 160,
    renderer: (rc) {
      return Align(
        alignment: Alignment.center, //
        child: Text(
          format_string(rc.cell.value),
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
  ),
  //
  // * ជួរឈរអ្នកឲចេញ
  PlutoColumn(
    field: Front_Desk.CHECK_OUT_BY + User_Show.FULL_NAME, //
    title: "ឲចេញដោយ",
    type: PlutoColumnType.text(),
    width: 160,
    renderer: (rc) {
      return Align(
        alignment: Alignment.center, //
        child: Text(
          format_string(rc.cell.value),
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
  ),

  PlutoColumn(
    field: "note", //
    title: "ចំណាំ",
    type: PlutoColumnType.text(),
    width: 200,
    renderer: (rc) {
      return Align(
        alignment: Alignment.center, //
        child: Text(
          format_string(rc.cell.value), //
          overflow: TextOverflow.ellipsis, //
        ),
      );
    },
  ),

  //
  // TODO: Add all notes together
  //
];

// * ថ្នាក់ Main_ ជាទំព័ររបាយការណ៍ចំណូល
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
        home: Main_(), //
        theme: theme_data,
        title: "Development",
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
