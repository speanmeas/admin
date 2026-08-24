// * ទំព័រដើម Front Desk (កំណែតារាង PlutoGrid)
// * បង្ហាញបន្ទប់ទាំងអស់ក្នុងតារាងមួយ ទាញទិន្នន័យពី API (ROOM_READ + FRONT_DESK_READ)

import "dart:async";

import "package:flutter/material.dart";
import "package:pluto_grid/pluto_grid.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/enum/room_status.dart" as room_status;
import "package:speanmeas/core/utility/all.dart";

// * នាំចូលទម្រង់ front desk ដែលមានស្រាប់
import "../front_desk/form/broke.dart" as broke;
import "../front_desk/form/cancel.dart" as cancel;
import "../front_desk/form/update_change_room.dart" as change_room;
import "../front_desk/form/check_in.dart" as check_in;
import "../front_desk/form/check_out.dart" as check_out;
import "../front_desk/form/clean.dart" as clean;
import "../front_desk/form/detail.dart" as detail;
import "../front_desk/form/fix.dart" as fix;
import "../front_desk/form/payment.dart" as pay_room;
import "../front_desk/form/update_guest.dart" as update_guest;
import "../front_desk/form/update_pay_other.dart" as pay_other;
import "../front_desk/form/update_pay_room.dart" as update_pay_room;
import "../front_desk/form/update_stay.dart" as update_stay;
import "../front_desk/form/update_mini_bar_1.dart" as update_mini_bar_1;
import "../front_desk/helper.dart";

// * ទំហំជួរឈរស្តង់ដារ
const double _W = 140;
const double _W_SMALL = 90;

// * ពណ៌តាមស្ថានភាពបន្ទប់
Color _status_color(String? status) {
  switch (status) {
    case room_status.AVAILABLE:
      return Colors.green;
    case room_status.PENDING_PAY:
      return Colors.orange;
    case room_status.PENDING_LEAVE:
      return Colors.blue;
    case room_status.PENDING_CLEAN:
      return Colors.grey;
    case room_status.PENDING_FIX:
      return Colors.red;
    default:
      return Colors.black;
  }
}

class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_load = true;

  // * ទិន្នន័យបន្ទប់ និង stay ទាំងអស់ពី server
  List<Room> data = [];
  List<Front_Desk> list_fd = [];
  String? selected_id;
  String? search;
  Timer? _debounce;
  final GlobalKey _grid_key = GlobalKey();
  PlutoGridStateManager? state_manager;

  // * ផ្ទុកទិន្នន័យពី server
  Future<void> init() async {
    setState(() => is_load = true);
    tmp = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
    if (tmp == null) {
      setState(() => is_load = false);
      return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_READ}", cl: Colors.red);
    }
    data = List<Room>.from((tmp.data ?? const []).map((d) => Room.fromJson(d)));

    // * អាន stay ទាំងអស់ (ភ្ជាប់ room/guest/pay រួចហើយ)
    list_fd = await load_fds();

    selected_id = null;
    setState(() => is_load = false);
    load_rows();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  // * តម្រោះតាមប្រអប់ស្វែងរក
  List<Room> get _list_show {
    final q = search?.trim().toLowerCase();
    if (q == null || q.isEmpty) return data;
    return data.where((r) {
      final guest = _fd(r)?.guest_id;
      final room_number = "${r.number}".toLowerCase();
      final room_status_ = "${r.status}".toLowerCase();
      final room_kind = "${r.kind}".toLowerCase();
      final guest_name = "${guest?.full_name ?? ""}".toLowerCase();
      final guest_phone = "${guest?.phone_number ?? ""}".toLowerCase();
      return room_number.contains(q) || room_status_.contains(q) || room_kind.contains(q) || guest_name.contains(q) || guest_phone.contains(q);
    }).toList();
  }

  // * Safe lookup stay សកម្មរបស់បន្ទប់
  Front_Desk? _fd(Room r) => active_fd(list_fd, r.id);

  // * បញ្ចូលទិន្នន័យទៅក្នុងតារាង
  void load_rows() {
    final sm = state_manager;
    if (sm == null) return;
    sm.removeAllRows();
    final show = _list_show;
    sm.appendRows([for (var i = 0; i < show.length; i++) _pluto_row(show, i)]);
    sm.notifyListeners();
  }

  // * បង្កើត PlutoRow មួយជួរពីបញ្ជីបន្ទប់
  PlutoRow _pluto_row(List<Room> show, int i) {
    final r = show[i];
    final fd = _fd(r);
    final guest = fd?.guest_id;
    final due = due_total(fd);
    return PlutoRow(
      cells: {
        "index": PlutoCell(value: i + 1),
        "number": PlutoCell(value: r.number),
        "kind": PlutoCell(value: r.kind),
        "status": PlutoCell(value: r.status),
        "guest_name": PlutoCell(value: guest?.full_name),
        "guest_phone": PlutoCell(value: guest?.phone_number),
        "persons": PlutoCell(value: fd?.check_in_number),
        "days": PlutoCell(value: fd?.check_in_day),
        "hours": PlutoCell(value: fd?.check_in_hour),
        "price_3h": PlutoCell(value: r.price_per_3h),
        "price_day": PlutoCell(value: r.price_per_day),
        "paid": PlutoCell(value: paid_total(fd)),
        "due": PlutoCell(value: due),
        "check_in": PlutoCell(value: fd?.check_in_at),
        "stay_due": PlutoCell(value: fd?.check_in_due),
        "note": PlutoCell(value: r.note),
      },
    );
  }

  // * បើកមឺនុយចុចកណ្ដុរស្ដាំ
  Future<void> _show_row_menu(Offset? local, PlutoRow row) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    var position = local;
    if (position == null) {
      final box = _grid_key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) position = box.localToGlobal(Offset.zero);
    }
    final rect = position == null ? const Rect.fromLTWH(0, 0, 0, 0) : Rect.fromLTWH(position.dx, position.dy, 0, 0);

    final r = await showMenu<Future<void> Function()>(context: context, position: RelativeRect.fromRect(rect, Offset.zero & overlay.size), items: _row_menu_items(row));
    if (r != null) {
      await r();
      if (mounted) init();
    }
  }

  // * បញ្ជី menu item តាមស្ថានភាពបន្ទប់
  List<PopupMenuEntry<Future<void> Function()>> _row_menu_items(PlutoRow row) {
    final r = _room_from_row(row);
    final items = <PopupMenuEntry<Future<void> Function()>>[];
    if (r == null) return items;

    final status = r.status;
    final has_fd = _fd(r) != null;

    if (status == room_status.AVAILABLE) {
      items.add(_m(item: Icons.login, text: t("Check In"), color: Colors.green, fn: () => on_check_in(r)));
    }
    if (status == room_status.PENDING_PAY) {
      items.add(_m(item: Icons.payment, text: t("Payment"), color: Colors.orange, fn: () => on_payment(r)));
    }
    if (status == room_status.PENDING_LEAVE) {
      items.add(_m(item: Icons.logout, text: t("Check Out"), color: Colors.blue, fn: () => on_check_out(r)));
    }
    if (status == room_status.PENDING_CLEAN) {
      items.add(_m(item: Icons.cleaning_services, text: t("Clean"), color: Colors.grey, fn: () => on_clean(r)));
    }
    if (has_fd) {
      items.add(_m(item: Icons.visibility, text: t("View Details"), color: Colors.black87, fn: () => on_detail(r)));
    }
    if (status != room_status.AVAILABLE && has_fd) {
      items.add(_m(item: Icons.group, text: t("Update Guest"), color: Colors.black87, fn: () => on_update_guest(r)));
      items.add(_m(item: Icons.calendar_month, text: t("Update Stay"), color: Colors.black87, fn: () => on_update_stay(r)));
      items.add(_m(item: Icons.payment, text: t("Payment Room"), color: Colors.black87, fn: () => on_update_room_payment(r)));
      items.add(_m(item: Icons.local_bar, text: t("Mini Bar"), color: Colors.black87, fn: () => on_pay_mini_bar(r)));
      items.add(_m(item: Icons.receipt_long, text: t("Other Payment"), color: Colors.black87, fn: () => on_pay_other(r)));
    }
    if (status == room_status.AVAILABLE || status == room_status.PENDING_CLEAN) {
      items.add(_m(item: Icons.bug_report, text: t("Set as Broken"), color: Colors.red, fn: () => on_broke(r)));
    }
    if (status == room_status.PENDING_FIX) {
      items.add(_m(item: Icons.build, text: t("Mark as Fixed"), color: Colors.green, fn: () => on_fix(r)));
    }
    if (status == room_status.PENDING_PAY || status == room_status.PENDING_LEAVE) {
      items.add(_m(item: Icons.swap_horiz, text: t("Change Room"), color: Colors.black87, fn: () => on_change_room(r)));
      items.add(_m(item: Icons.cancel, text: t("Cancel Booking"), color: Colors.red, fn: () => on_cancel(r)));
    }
    return items;
  }

  PopupMenuItem<Future<void> Function()> _m({required IconData item, required String text, required Color color, required Future<void> Function() fn}) {
    return PopupMenuItem<Future<void> Function()>(
      value: fn,
      child: Row(
        children: [
          Icon(item, size: 20, color: color), //
          const SizedBox(width: 8), //
          Text(text, style: TextStyle(color: color)), //
        ],
      ),
    );
  }

  // * មើលបន្ទប់ដែលបានជ្រើសរើសបច្ចុប្បន្ន
  Room? get _selected_room {
    for (final r in data) {
      if (r.id == selected_id) return r;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final total_room = data.length;
    final total_available = data.where((r) => r.status == room_status.AVAILABLE).length;
    final total_pay = data.where((r) => r.status == room_status.PENDING_PAY).length;
    final total_leave = data.where((r) => r.status == room_status.PENDING_LEAVE).length;
    final total_clean = data.where((r) => r.status == room_status.PENDING_CLEAN).length;
    final total_fix = data.where((r) => r.status == room_status.PENDING_FIX).length;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                _toolbar_button(
                  tip: "Check In", //
                  icon: Icons.login_outlined,
                  color: Colors.green,
                  onPressed: is_load ? null : () async => _run_for_selected((r) => on_check_in(r), allow: [room_status.AVAILABLE]),
                ),
                _toolbar_button(
                  tip: "Payment", //
                  icon: Icons.payment_outlined,
                  color: Colors.orange,
                  onPressed: is_load ? null : () async => _run_for_selected((r) => on_payment(r), allow: [room_status.PENDING_PAY, room_status.PENDING_LEAVE]),
                ),
                _toolbar_button(
                  tip: "Check Out", //
                  icon: Icons.logout_outlined,
                  color: Colors.blue,
                  onPressed: is_load ? null : () async => _run_for_selected((r) => on_check_out(r), allow: [room_status.PENDING_LEAVE]),
                ),
                _toolbar_button(
                  tip: "Clean", //
                  icon: Icons.cleaning_services_outlined,
                  color: Colors.grey,
                  onPressed: is_load ? null : () async => _run_for_selected((r) => on_clean(r), allow: [room_status.PENDING_CLEAN]),
                ),
                const SizedBox(width: 8),
                const VerticalDivider(width: 1),
                const SizedBox(width: 8),
                _toolbar_button(
                  tip: "Broke", //
                  icon: Icons.bug_report_outlined,
                  color: Colors.red,
                  onPressed: is_load ? null : () async => _run_for_selected((r) => on_broke(r), allow: [room_status.AVAILABLE, room_status.PENDING_CLEAN]),
                ),
                _toolbar_button(
                  tip: "Fix", //
                  icon: Icons.build_outlined,
                  color: Colors.redAccent,
                  onPressed: is_load ? null : () async => _run_for_selected((r) => on_fix(r), allow: [room_status.PENDING_FIX]),
                ),
                const Spacer(),
                SizedBox(
                  width: 220,
                  child: TextField(
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: "Search:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                      contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                      prefixIcon: Icon(Icons.search, size: 20),
                    ),
                    onChanged: (v) {
                      _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 250), () {
                        search = v;
                        load_rows();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 4),
                _toolbar_button(
                  tip: t("Refresh"), //
                  icon: Icons.refresh,
                  color: Colors.blue,
                  onPressed: is_load ? null : init,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          if (is_load) const LinearProgressIndicator(minHeight: 4, color: Colors.blue),

          // * សារ៉ងសង្ខេបស្ថានភាព
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            child: Row(
              spacing: 12,
              children: [
                _chip("${t("Total")}: $total_room", Colors.blueGrey),
                _chip(room_status.AVAILABLE, Colors.green, count: total_available),
                _chip(room_status.PENDING_PAY, Colors.orange, count: total_pay),
                _chip(room_status.PENDING_LEAVE, Colors.blue, count: total_leave),
                _chip(room_status.PENDING_CLEAN, Colors.grey, count: total_clean),
                _chip(room_status.PENDING_FIX, Colors.red, count: total_fix),
              ],
            ),
          ),

          // * តារាងបន្ទប់
          Expanded(
            child: Container(
              key: _grid_key,
              child: PlutoGrid(
                rows: [],
                columns: columns,
                mode: PlutoGridMode.select,
                rowColorCallback: (ctx) {
                  final status = ctx.row.cells["status"]?.value as String?;
                  return _status_color(status).withValues(alpha: 0.05);
                },
                configuration: PlutoGridConfiguration(
                  scrollbar: const PlutoGridScrollbarConfig(scrollbarThickness: 12, isAlwaysShown: true),
                  style: PlutoGridStyleConfig(rowHeight: 32, columnHeight: 36, columnFilterHeight: 36, defaultColumnTitlePadding: const EdgeInsets.fromLTRB(8, 0, 24, 0), defaultColumnFilterPadding: const EdgeInsets.fromLTRB(1, 1, 1, 1)),
                ),
                onSelected: (event) {
                  final room = _room_from_row(event.row);
                  setState(() => selected_id = room?.id);
                },
                onRowDoubleTap: (event) {
                  final room = _room_from_row(event.row);
                  if (room == null) return;
                  _show_row_menu(null, event.row);
                },
                onRowSecondaryTap: (event) {
                  final room = _room_from_row(event.row);
                  if (room == null) return;
                  _show_row_menu(event.offset, event.row);
                },
                onLoaded: (event) {
                  state_manager = event.stateManager;
                  state_manager?.addListener(() {
                    if (mounted) setState(() {});
                  });
                  load_rows();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // * រក Room ពី row (ផ្គូផ្គងតាមលេខបន្ទប់)
  Room? _room_from_row(PlutoRow? row) {
    if (row == null) return null;
    final number = row.cells["number"]?.value as String?;
    if (number == null) return null;
    for (final r in data) {
      if (r.number == number) return r;
    }
    return null;
  }

  // * ដំណើរការសកម្មភាពលើបន្ទប់ដែលបានជ្រើសរើស
  Future<void> _run_for_selected(Future<void> Function(Room r) fn, {List<String>? allow}) async {
    final r = _selected_room;
    if (r == null) {
      snackbar(ct: context, ms: t("Please select a room first."), cl: Colors.orange);
      return;
    }
    if (allow != null && !allow.contains(r.status)) {
      snackbar(ct: context, ms: t("Action not allowed for this room status."), cl: Colors.orange);
      return;
    }
    await fn(r);
    if (mounted) init();
  }

  Widget _chip(String label, Color color, {int? count}) {
    final text = count == null ? label : "$label: $count";
    return Tooltip(
      message: t("Count"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbar_button({
    required String tip, //
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 40, height: 38),
      iconSize: 30,
      tooltip: tip,
      icon: Icon(icon, color: color),
      onPressed: onPressed,
    );
  }

  // ============================================================
  // * សកម្មភាពទាំងអស់ (ហៅទម្រង់ពី front_desk/form)
  // ============================================================
  Future<void> on_check_in(Room r) async {
    tmp = await nav_push(context, check_in.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  Future<void> on_payment(Room r) async {
    final fd = _fd(r);
    final mini_bar_due = due_of(fd?.mini_bar_pay_id);
    final other_due = due_of(fd?.penalty_pay_id);
    if (mini_bar_due <= 0 && other_due <= 0) {
      tmp = await nav_push(context, pay_room.Main_(room_id: r.id));
      if (tmp != null) init();
      return;
    }
    if (mini_bar_due > 0 && other_due > 0) {
      snackbar(ct: context, ms: t("Please Complete Mini Bar and Other Payments."), cl: Colors.red);
    } else if (mini_bar_due > 0) {
      snackbar(ct: context, ms: t("Please Complete Mini Bar Payment."), cl: Colors.red);
    } else {
      snackbar(ct: context, ms: t("Please Complete Other Payment."), cl: Colors.red);
    }
  }

  Future<void> on_check_out(Room r) => _nav(check_out.Main_(room_id: r.id));
  Future<void> on_clean(Room r) => _nav(clean.Main_(room_id: r.id));
  Future<void> on_broke(Room r) => _nav(broke.Main_(room_id: r.id));
  Future<void> on_fix(Room r) => _nav(fix.Main_(room_id: r.id));
  Future<void> on_detail(Room r) => _nav(detail.Main_(room_id: r.id));
  Future<void> on_cancel(Room r) => _nav(cancel.Main_(room_id: r.id));
  Future<void> on_change_room(Room r) => _nav(change_room.Main_(room_id: r.id));
  Future<void> on_update_stay(Room r) => _nav(update_stay.Main_(room_id: r.id));
  Future<void> on_update_guest(Room r) => _nav(update_guest.Main_(room_id: r.id));
  Future<void> on_update_room_payment(Room r) => _nav(update_pay_room.Main_(room_id: r.id));
  Future<void> on_pay_other(Room r) => _nav(pay_other.Main_(room_id: r.id));
  Future<void> on_pay_mini_bar(Room r) => _nav(update_mini_bar_1.Main_(room_id: r.id));

  Future<void> _nav(dynamic page) async {
    tmp = await nav_push(context, page);
    if (tmp != null) init();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

// ============================================================
// * និយមន័យជួរឈរតារាង
// ============================================================
class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

typedef _Col = PlutoColumn;

List<PlutoColumn> get columns {
  return <PlutoColumn>[
    _Col(
      field: "index",
      title: "#",
      type: PlutoColumnType.number(),
      width: 50,
      enableEditingMode: false,
      enableSorting: false,
      enableColumnDrag: false,
      enableContextMenu: false,
      enableDropToResize: false,
      enableAutoEditing: false,
      enableRowDrag: false,
      renderer: (rc) => _cell(Text("${rc.cell.value ?? ""}", style: const TextStyle(color: Colors.grey))),
    ),
    _Col(
      field: "number",
      title: t("Room"),
      type: PlutoColumnType.text(),
      width: 90,
      enableEditingMode: false,
      renderer: (rc) {
        final status = rc.cell.row.cells["status"]?.value as String?;
        return _cell(
          Text(
            "${rc.cell.value ?? ""}",
            style: TextStyle(fontWeight: FontWeight.bold, color: _status_color(status)),
          ),
        );
      },
    ),
    _Col(field: "kind", title: t("Kind"), type: PlutoColumnType.text(), width: _W_SMALL, enableEditingMode: false, renderer: (rc) => _cell(Text("${rc.cell.value ?? ""}"))),
    _Col(
      field: "status",
      title: t("Status"),
      type: PlutoColumnType.text(),
      width: _W_SMALL + 20,
      enableEditingMode: false,
      renderer: (rc) {
        final status = rc.cell.value as String?;
        final color = _status_color(status);
        return _cell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
            child: Text(
              "${rc.cell.value ?? ""}",
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    ),
    _Col(
      field: "guest_name",
      title: t("Guest"),
      type: PlutoColumnType.text(),
      width: _W,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("${rc.cell.value ?? ""}", overflow: TextOverflow.ellipsis)),
    ),
    _Col(
      field: "guest_phone",
      title: t("Phone"),
      type: PlutoColumnType.text(),
      width: _W,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("${rc.cell.value ?? ""}", overflow: TextOverflow.ellipsis)),
    ),
    _Col(
      field: "persons",
      title: t("Persons"),
      type: PlutoColumnType.number(),
      width: 75,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("${rc.cell.value ?? ""}", textAlign: TextAlign.center)),
    ),
    _Col(
      field: "days",
      title: t("Days"),
      type: PlutoColumnType.number(),
      width: 60,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("${rc.cell.value ?? ""}", textAlign: TextAlign.center)),
    ),
    _Col(
      field: "hours",
      title: t("Hours"),
      type: PlutoColumnType.number(),
      width: 65,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("${rc.cell.value ?? ""}", textAlign: TextAlign.center)),
    ),
    _Col(
      field: "price_3h",
      title: t("\$/3 Hours"),
      type: PlutoColumnType.number(),
      width: 90,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("\$${format_double(rc.cell.value, digits: 2)}", textAlign: TextAlign.right)),
    ),
    _Col(
      field: "price_day",
      title: t("\$/Day"),
      type: PlutoColumnType.number(),
      width: 80,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("\$${format_double(rc.cell.value, digits: 2)}", textAlign: TextAlign.right)),
    ),
    _Col(
      field: "paid",
      title: t("Paid"),
      type: PlutoColumnType.number(),
      width: 100,
      enableEditingMode: false,
      renderer: (rc) {
        final v = rc.cell.value as double? ?? 0;
        return _cell(
          Text(
            "\$${v.toStringAsFixed(2)}",
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    ),
    _Col(
      field: "due",
      title: t("Due"),
      type: PlutoColumnType.number(),
      width: 100,
      enableEditingMode: false,
      renderer: (rc) {
        final v = rc.cell.value as double? ?? 0;
        final color = v > 0 ? Colors.red : Colors.green;
        return _cell(
          Text(
            "\$${v.toStringAsFixed(2)}",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        );
      },
    ),
    _Col(
      field: "check_in",
      title: t("Check In"),
      type: PlutoColumnType.text(),
      width: _W,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("${format_datetime(rc.cell.value)}", style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
    ),
    _Col(
      field: "stay_due",
      title: t("Stay Due"),
      type: PlutoColumnType.text(),
      width: _W,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("${format_datetime(rc.cell.value)}", style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
    ),
    _Col(
      field: "note",
      title: t("Note"),
      type: PlutoColumnType.text(),
      width: _W,
      enableEditingMode: false,
      renderer: (rc) => _cell(Text("${rc.cell.value ?? ""}", overflow: TextOverflow.ellipsis)),
    ),
  ];
}

// * ដាក់ CELLS ឲ្យត្រងកណ្តាល
Widget _cell(Widget child) {
  return Align(alignment: Alignment.center, child: child);
}

// * គ្រាប់ចាប់ផ្តើមសម្រាប់ការអភិវឌ្ឍន៍
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
        debugShowCheckedModeBanner: false, //
        title: "Development", //
      ),
    ),
  );
}
