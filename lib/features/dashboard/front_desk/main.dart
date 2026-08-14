// TODO: Add notification when overtime.

import "dart:async";
import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/config.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/global.dart"; // ignore: unused_import
import "package:speanmeas/core/i18n/main.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/room.g.dart";
import "package:speanmeas/core/widget/button/menu_button_icon.dart";
import "package:speanmeas/core/widget/snackbar.dart";

import "form/add_pay_other.dart" as pay_other;
import "form/broke.dart" as broke;
import "form/cancel.dart" as cancel;
import "form/change_room.dart" as change_room;
import "form/check_in.dart" as check_in; // 1
import "form/check_out.dart" as check_out; // 3
import "form/clean.dart" as clean; // 4
import "form/detail.dart" as detail;
import "form/fix.dart" as fix; // 6
import "form/pay_room.dart" as pay_room; // 2
import "form/update_guest.dart" as update_guest;
import "form/update_pay_room.dart" as update_pay_room;
import "form/update_stay.dart" as update_stay;

class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;

  dynamic list_r = []; // * សម្រាប់រក្សាពត៏មានបន្ទប់ទាំងអស់
  dynamic map_fd = {}; // * សម្រាប់រក្សាពត៏មាន front desk ទាំងអស់

  String? search;
  Timer? _debounce; // * ពន្យាពេល rebuild សម្រាប់ការស្វែងរក

  void init() async {
    try {
      tmp = await dio.post(endpoint.ROOM_CRUD_READ, data: {"key": sm_room.NUMBER, "order": 1});
      list_r = tmp.data as List<dynamic>;

      for (var r in list_r) //
        if (r[sm_room.FRONT_DESK_ID] != null) {
          tmp = await dio.post(
            endpoint.FRONT_DESK_CRUD_READ_ID, //
            data: {sm_front_desk.ID: r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]},
          );
          map_fd[r[sm_room.ID]] = tmp.data[0];
        }

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  Widget _layout(List<Widget> children) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 8), //

              Container(
                width: 200,
                height: 40,
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
                    prefixIcon: Icon(Icons.search, size: 20), //
                  ),
                  onChanged: (v) {
                    // * រង់ចាំអ្នកប្រើឈប់វាយទើប rebuild
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 200), () {
                      search = v;
                      setState(() {});
                    });
                  },
                ),
              ),

              Spacer(),

              Menu_Button_Icon(
                tip: "Refresh", //
                icon: Icons.refresh, //
                onPressed: init, //
              ),

              SizedBox(width: 8), //
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Wrap(
                  children: children, //
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      for (var r in _list_show)
        Container(
          width: 600,
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Row(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${t("Room")} ${r[sm_room.NUMBER]}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),

                        (() {
                          var color = Colors.black; // Default color
                          if (["Available"].contains(r[sm_room.STATUS])) color = Colors.green;
                          if (["Pending Pay"].contains(r[sm_room.STATUS])) color = Colors.orange;
                          if (["Pending Leave"].contains(r[sm_room.STATUS])) color = Colors.blue;
                          if (["Pending Clean"].contains(r[sm_room.STATUS])) color = Colors.grey;
                          if (["Pending Fix"].contains(r[sm_room.STATUS])) color = Colors.red;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.circle, size: 10, color: color),
                              SizedBox(width: 4),
                              Text("${r[sm_room.STATUS]}", style: TextStyle(fontSize: 14, color: color)),

                              Tooltip(
                                message: t("Menu"),
                                child: MenuAnchor(
                                  style: MenuStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                                  builder: (context, controller, child) {
                                    return InkWell(
                                      child: Container(
                                        // width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Icon(Icons.more_vert, color: color), //
                                      ), //
                                      onTap: () {
                                        controller.isOpen ? controller.close() : controller.open();
                                      },
                                    );
                                  },
                                  menuChildren: [
                                    if (!["Available"].contains(r[sm_room.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.receipt_outlined, color: Colors.blue),
                                        child: Text(t("View Details"), style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_detail(r), //
                                        // onPressed: () {},
                                      ),

                                    if (["Available"].contains(r[sm_room.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.bug_report_outlined, color: Colors.blue),
                                        child: Text(t("Set as Broken"), style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_broke(r), //
                                      ),

                                    if (["Pending Fix"].contains(r[sm_room.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.build_outlined, color: Colors.blue),
                                        child: Text(t("Mark as Fixed"), style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_fix(r), //
                                      ),

                                    if (["Pending Pay", "Pending Leave"].contains(r[sm_room.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.swap_horiz_outlined, color: Colors.blue),
                                        child: Text(t("Change Room"), style: TextStyle(color: Colors.blue)),
                                        onPressed: () => on_change_room(r), //
                                      ),

                                    if (["Pending Pay", "Pending Leave"].contains(r[sm_room.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                        child: Text(t("Cancel"), style: TextStyle(color: Colors.red)),
                                        onPressed: () => on_cancel(r), //
                                        // onPressed: () {},
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        })(),
                      ],
                    ),

                    (() {
                      String kind = r[sm_room.KIND] ?? t("N/A");
                      double usd_per_3h = (r[sm_room.USD_PER_3H] as num?)?.toDouble() ?? 0;
                      double usd_per_day = (r[sm_room.USD_PER_DAY] as num?)?.toDouble() ?? 0;
                      return Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(kind, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Text("-"), //
                          Text("${usd_per_3h.toStringAsFixed(2)} \$ / 3 ${t("Hours")}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), //
                          Text("-"), //
                          Text("${usd_per_day.toStringAsFixed(2)} \$ / 1 ${t("Days")}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      );
                    })(),

                    if (r[sm_room.FRONT_DESK_ID] != null) ...[
                      if (!"${r[sm_room.STATUS]}".contains("Pending Fix"))
                        (() {
                          tmp = _fd(r)[sm_front_desk.GUEST_ID] as Map<String, dynamic>? ?? {};
                          final guest_name = tmp[sm_guest.FULL_NAME] ?? "N/A";
                          final guest_phone = tmp[sm_guest.PHONE_NUMBER] ?? "N/A";
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.person_2_outlined, size: 24), //
                              Text('${t("Guest")}:', style: TextStyle(fontWeight: FontWeight.bold)),
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text(guest_name, style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text(guest_phone, style: TextStyle(color: Colors.blue)), //
                              // always show
                              Tooltip(
                                message: t("Edit Guest Info"),
                                child: InkWell(
                                  child: Icon(Icons.edit_outlined, size: 24, color: Colors.blue), //
                                  onTap: () => on_update_guest(r),
                                  // onTap: () {},
                                ),
                              ),
                            ],
                          );
                        })(),

                      if (!["Pending Fix"].contains(r[sm_room.STATUS]))
                        (() {
                          tmp = _fd(r);
                          final stay_n_guest = tmp[sm_front_desk.CHECK_IN_NUMBER] ?? "0";
                          final stay_day = tmp[sm_front_desk.CHECK_IN_DAY] ?? "0";
                          final stay_hour = tmp[sm_front_desk.CHECK_IN_HOUR] ?? "0";
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.calendar_month, size: 24), //
                              Text('${t("Stay")}:', style: TextStyle(fontWeight: FontWeight.bold)),
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text("$stay_n_guest ${t("Persons")}", style: TextStyle(color: Colors.blue)),
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text("$stay_day ${t("Days")}", style: TextStyle(color: Colors.blue)),
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text("$stay_hour ${t("Hours")}", style: TextStyle(color: Colors.blue)),
                              if (r[sm_room.STATUS] != "Pending Clean")
                                Tooltip(
                                  message: t("Edit Stay Info"),
                                  child: InkWell(
                                    child: Icon(Icons.edit_outlined, size: 24, color: Colors.blue), //
                                    onTap: () => on_update_stay(r),
                                    // onTap: () {},
                                  ),
                                ),
                            ],
                          );
                        })(),

                      if (!["Pending Fix"].contains(r[sm_room.STATUS]))
                        (() {
                          tmp = _fd(r)[sm_front_desk.PAY_ROOM] as List<dynamic>? ?? [];
                          double price = 0;
                          double pay = 0;
                          double change = 0;
                          if (tmp.isNotEmpty) price = double.parse(tmp.last["pay_price"]?.toString() ?? "0");
                          for (var l in tmp) {
                            pay = pay + double.parse(l["pay_cash"]?.toString() ?? "0");
                            pay = pay + double.parse(l["pay_bank"]?.toString() ?? "0");
                            change = change + double.parse(l["pay_return"]?.toString() ?? "0");
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.receipt_outlined, size: 24), //
                              Text('${t("Room Payment")}:', style: TextStyle(fontWeight: FontWeight.bold)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Price"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${price.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Pay"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${pay.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Return"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${change.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //

                              if (!["Pending Clean"].contains(r[sm_room.STATUS]))
                                Tooltip(
                                  message: t("Edit Room Payment"),
                                  child: InkWell(
                                    child: Icon(Icons.edit_outlined, size: 24, color: Colors.blue), //
                                    onTap: () => on_update_room_payment(r),
                                    // onTap: () {},
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // payment other info
                      if (!["Pending Fix"].contains(r[sm_room.STATUS]))
                        (() {
                          tmp = _fd(r)[sm_front_desk.PAY_OTHER] as List<dynamic>? ?? [];
                          // pprint(tmp);
                          double price = 0;
                          double pay = 0;
                          double change = 0;
                          if (tmp.isNotEmpty) price = double.parse(tmp.last["pay_price"]?.toString() ?? "0");
                          for (var l in tmp) {
                            pay = pay + double.parse(l["pay_cash"]?.toString() ?? "0");
                            pay = pay + double.parse(l["pay_bank"]?.toString() ?? "0");
                            change = change + double.parse(l["pay_return"]?.toString() ?? "0");
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.receipt_outlined, size: 24), //
                              Text('${t("Other Payment")}:', style: TextStyle(fontWeight: FontWeight.bold)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Price"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${price.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Pay"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${pay.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Return"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${change.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              if (r[sm_room.STATUS] != "Pending Clean")
                                Tooltip(
                                  message: t("Edit Other Payment"),
                                  child: InkWell(
                                    child: Icon(Icons.edit_outlined, size: 24, color: Colors.blue), //
                                    onTap: () => on_pay_other(r),
                                    // onTap: () {},
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // check in, due to, check out info
                      if (r[sm_room.STATUS] != "Pending Fix")
                        (() {
                          tmp = _fd(r);
                          String check_in = "";
                          if (tmp[sm_front_desk.CHECK_IN_AT] != null) {
                            final dt = DateTime.parse(tmp[sm_front_desk.CHECK_IN_AT]);
                            check_in = DateFormat(DEFAULT_DATE_FORMAT).format(dt);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.login, size: 24), //
                              Text('${t("Check In")}:', style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(check_in, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      // due to info
                      if (r[sm_room.STATUS] != "Pending Fix")
                        (() {
                          tmp = _fd(r);
                          String due = "";
                          if (tmp[sm_front_desk.CHECK_IN_DUE] != null) {
                            final dt = DateTime.parse(tmp[sm_front_desk.CHECK_IN_DUE]);
                            due = DateFormat(DEFAULT_DATE_FORMAT).format(dt);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.time_to_leave_outlined, size: 24), //
                              Text('${t("Stay Due")}:', style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(due, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      //
                      if (r[sm_room.STATUS] != "Pending Fix")
                        (() {
                          tmp = _fd(r);
                          String check_out = "";
                          if (tmp[sm_front_desk.CHECK_OUT_AT] != null) {
                            final dt = DateTime.parse(tmp[sm_front_desk.CHECK_OUT_AT]);
                            check_out = DateFormat(DEFAULT_DATE_FORMAT).format(dt);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.logout, size: 24), //
                              Text('${t("Check Out")}:', style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(check_out, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      // broke info
                      if (r[sm_room.STATUS] == "Pending Fix")
                        (() {
                          tmp = _fd(r);
                          String broke_date = "";
                          if (tmp[sm_front_desk.BROKE_AT] != null) {
                            final dt = DateTime.parse(tmp[sm_front_desk.BROKE_AT]);
                            broke_date = DateFormat(DEFAULT_DATE_FORMAT).format(dt);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.bug_report_outlined, size: 24), //
                              Text('${t("Broken Date")}:', style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(broke_date, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (r[sm_room.STATUS] == "Available") //
                          OutlinedButton.icon(
                            icon: Icon(Icons.login),
                            label: Text(t("Check In")),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.green)),
                            onPressed: () => on_check_in(r), //
                          ), //
                        if (r[sm_room.STATUS] == "Pending Pay") //
                          OutlinedButton.icon(
                            icon: Icon(Icons.payment),
                            label: Text(t("Payment")),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.orange)),
                            onPressed: () => on_payment(r), //
                          ), //
                        if (r[sm_room.STATUS] == "Pending Leave") //
                          OutlinedButton.icon(
                            icon: Icon(Icons.logout),
                            label: Text(t("Check Out")),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.blue)),
                            onPressed: () => on_check_out(r), //
                          ), //
                        if (r[sm_room.STATUS] == "Pending Clean") //
                          OutlinedButton.icon(
                            icon: Icon(Icons.cleaning_services),
                            label: Text(t("Clean")),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.grey)),
                            onPressed: () => on_clean(r), //
                          ), //
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    ]);
  }

  void on_check_in(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => check_in.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_payment(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => pay_room.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_check_out(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => check_out.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_clean(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => clean.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_broke(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => broke.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_fix(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => fix.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_detail(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => detail.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_cancel(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => cancel.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_change_room(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => change_room.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_update_stay(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => update_stay.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_update_guest(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => update_guest.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_update_room_payment(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => update_pay_room.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  void on_pay_other(dynamic r) async {
    try {
      tmp = await Navigator.push(context, MaterialPageRoute(builder: (context) => pay_other.Main_(room_id: r[sm_room.ID])));
      if (tmp != null) init();
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  // * Safe lookup into map_fd; returns {} if the room's front-desk fetch failed/missing
  Map<String, dynamic> _fd(dynamic r) => map_fd[r[sm_room.ID]] as Map<String, dynamic>? ?? {};

  List<dynamic> get _list_show {
    final q = search?.trim().toLowerCase();
    if (q == null || q.isEmpty) return list_r;
    return list_r.where((r) {
      final room_number = '${r[sm_room.NUMBER]}'.toLowerCase();
      final room_status = '${r[sm_room.STATUS]}'.toLowerCase();
      final room_kind = '${r[sm_room.KIND]}'.toLowerCase();
      return room_number.contains(q) || room_status.contains(q) || room_kind.contains(q);
    }).toList();
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
  //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: MaterialApp(
        home: Main_(), //
        theme: theme_data, //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
