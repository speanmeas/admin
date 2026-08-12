// TODO: Add notification when overtime.

import "dart:async";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:speanmeas/core/i18n.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/schema/room.g.dart";
import "package:speanmeas/core/schema/mini_bar.g.dart";

import "form/add_pay mini_bar_a.dart" as charge;
import "form/detail.dart" as detail;
import "form/check_in.dart" as check_in;
import "form/pay_room.dart" as pay_room;
import "form/add_pay_room.dart" as pay_room_update;
import "form/add_pay_other.dart" as pay_other;
import "form/check_out.dart" as check_out;
import "form/clean.dart" as clean;
import "form/cancel.dart" as cancel;
import "form/broke.dart" as broke;
import "form/fix.dart" as fix;
import "form/change_room.dart" as change_room;

import "form/guest_update.dart" as update_guest;
import "form/check_in_update.dart" as update_stay;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  Timer? _debounce; // * ពន្យាពេល rebuild ពេលវាយស្វែងរក
  final c_search = TextEditingController();
  List<Map<String, dynamic>> list_r = [];
  Map<String, dynamic> map_fd = {};
  List<Map<String, dynamic>> list_mb = []; // * បញ្ជីទំនិញ mini bar (catalog) សម្រាប់លក់
  List<Map<String, dynamic>> list_walkin = []; // * ទំនិញ walk-in (អតិថិជនដើរចូលទិញ មិនស្នាក់នៅបន្ទប់)

  void init() async {
    try {
      map_fd.clear();
      list_r.clear();
      // sm_room.clear();
      // sm_guest.clear();
      // sm_front_desk.clear();

      // * ទាញយកទិន្នន័យបន្ទប់ទាំងអស់ពី Server
      tmp = await dio.post(
        endpoint.ROOM_CRUD_READ,
        data: {
          "key": sm_room.NUMBER, //
          "order": 1, //
        },
      );
      list_r = List<Map<String, dynamic>>.from(tmp.data);

      // * ទាញយកទិន្នន័យ front desk ដែលទាក់ទងនឹងបន្ទប់
      // * (ផ្ញើរួមគ្នាប៉ារ៉ាឡែល មិនរង់ចាំមួយៗ ដើម្បីកុំឲ្យយឺត)
      final ids = <dynamic>[];
      for (var r in list_r) {
        final fd_id = r[sm_room.FRONT_DESK_ID];
        if (fd_id != null && !ids.contains(fd_id)) ids.add(fd_id);
      }

      final futures = [
        for (var fd_id in ids)
          dio.post(
            endpoint.FRONT_DESK_READ_ID, //
            data: {
              sm_front_desk.ID: fd_id, //
            },
          ),
      ];
      final results = await Future.wait(futures);
      for (var i = 0; i < ids.length; i++) {
        map_fd[ids[i]] = results[i].data[0];
      }

      // * ទាញយកបញ្ជីទំនិញ mini bar (catalog) ពី Server
      // tmp = await dio.post(
      //   endpoint.MINI_BAR_READ, //
      //   data: {
      //     "key": DEFAULT_KEY, //
      //     "order": DEFAULT_ORDER, //
      //     "offset": 0, //
      //     "limit": DEFAULT_LIMIT_ROW,
      //   },
      // );
      list_mb = List<Map<String, dynamic>>.from(tmp.data);

      setState(() {});
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  // * យកតម្លៃបច្ចុប្បន្នពីបញ្ជីប្រវត្តិតម្លៃ (element ចុងក្រោយ = តម្លៃបច្ចុប្បន្ន)
  double _current_price(dynamic list) {
    if (list is! List || list.isEmpty) return 0;
    return double.tryParse(list.last["price"]?.toString() ?? "0") ?? 0;
  }

  Widget _layout(List<Widget> children) {
    return Scaffold(
      body: Column(
        children: [
          // * បង្ហាញប៊ូតុង refresh
          Row(
            children: [
              SizedBox(width: 38),

              Spacer(),

              Container(
                width: 200,
                height: 40,
                padding: EdgeInsets.only(top: 8), //
                child: TextField(
                  controller: c_search,
                  decoration: InputDecoration(
                    isDense: true, //
                    labelText: t("Search"), //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                    contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                    prefixIcon: Icon(Icons.search, size: 20), //
                  ),
                  onChanged: (v) {
                    // * រង់ចាំអ្នកប្រើឈប់វាយ 500ms ទើប rebuild
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      setState(() {});
                    });
                  },
                ),
              ),

              Spacer(),

              Tooltip(
                message: "Refresh",
                child: InkWell(
                  onTap: init,
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    child: Icon(Icons.refresh, size: 30, color: Colors.blue), //
                  ),
                ),
              ),
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
    return _layout([
      // * បង្ហាញ container សម្រាប់លក់ mini bar ឲ្យអតិថិជនដើរចូលទិញ (Walk-in)
      // Container(
      //   width: 500,
      //   margin: EdgeInsets.all(2),
      //   padding: EdgeInsets.all(4),
      //   decoration: BoxDecoration(border: Border.all(color: Colors.purple, width: 1)),
      //   child: Row(
      //     children: [
      //       // info
      //       // Expanded(
      //       //   child: Column(
      //       //     mainAxisAlignment: MainAxisAlignment.start,
      //       //     crossAxisAlignment: CrossAxisAlignment.start,
      //       //     children: [
      //       //       // header row
      //       //       Row(
      //       //         spacing: 4,
      //       //         children: [
      //       //           Icon(Icons.person_add_outlined, size: 24, color: Colors.purple), //
      //       //           Text(t("Mini Bar For Sale (Walk-in):"), style: TextStyle(fontWeight: FontWeight.bold)), //
      //       //           //
      //       //           SizedBox(width: 4), //
      //       //           Icon(Icons.circle, size: 6), //
      //       //           Text("${_walkin_total.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.purple)), //
      //       //         ],
      //       //       ),

      //       //       // items
      //       //       if (list_walkin.isEmpty) Text(t("No Items"), style: TextStyle(color: Colors.grey)),
      //       //       for (var line in list_walkin)
      //       //         Row(
      //       //           spacing: 4,
      //       //           children: [
      //       //             Text("${line[sm_mini_bar.NAME]}", style: TextStyle(fontWeight: FontWeight.bold)), //
      //       //             Text("x${line["qty"]}", style: TextStyle(color: Colors.grey)), //
      //       //             Text("${line["total"]} \$", style: TextStyle(color: Colors.blue)), //
      //       //           ],
      //       //         ),
      //       //     ],
      //       //   ),
      //       // ),

      //       // buttons
      //       OutlinedButton.icon(
      //         onPressed: list_mb.isEmpty ? null : on_walkin, //
      //         icon: Icon(Icons.add_shopping_cart),
      //         label: Text(t("Sell")),
      //         style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.purple)),
      //       ), //

      //       if (list_walkin.isNotEmpty)
      //         OutlinedButton.icon(
      //           onPressed: on_clear_walkin, //
      //           icon: Icon(Icons.delete_outline),
      //           label: Text(t("Clear")),
      //           style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
      //         ), //
      //     ],
      //   ),
      // ),

      //

      // * បង្ហាញបញ្ជីបន្ទប់ទាំងអស់ (ត្រងតាមការស្វែងរក)
      for (var r in _list_show)
        Container(
          width: 500,
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          child: Row(
            children: [
              // info.
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // * លេខបន្ទប់ (កណ្តាល) + ស្ថានភាព (ស្តាំ)
                    Stack(
                      children: [
                        // * លេខបន្ទប់នៅកណ្តាលជានិច្ច
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

                        // * ស្ថានភាពបន្ទប់នៅខាងស្តាំ
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

                              // menu
                              Tooltip(
                                message: "Menu",
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
                                    //
                                    if (!["Available"].contains(r[sm_room.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.receipt_outlined, color: Colors.blue),
                                        child: Text(t("View Details"), style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_detail(r), //
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

                                    //
                                    if (["Pending Pay", "Pending Leave"].contains(r[sm_room.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.swap_horiz_outlined, color: Colors.blue),
                                        child: Text(t("Change Room"), style: TextStyle(color: Colors.blue)),
                                        onPressed: () => on_change_room(r), //
                                      ),

                                    //
                                    if (["Pending Pay", "Pending Leave"].contains(r[sm_room.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                        child: Text(t("Cancel"), style: TextStyle(color: Colors.red)),
                                        onPressed: () => on_cancel(r), //
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        })(),
                      ],
                    ),

                    // * room info
                    (() {
                      String kind = r[sm_room.KIND] ?? "N/A";
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

                    // * guest info
                    if (r[sm_room.FRONT_DESK_ID] != null) ...[
                      // guest info
                      if (!"${r[sm_room.STATUS]}".contains("Pending Fix"))
                        (() {
                          final fd = map_fd[r[sm_room.FRONT_DESK_ID]];
                          final guest_name = fd?[sm_front_desk.GUEST_ID]["full_name"] ?? "N/A";
                          final guest_phone = fd?[sm_front_desk.GUEST_ID]["phone_number"] ?? "N/A";
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.person, size: 24), //
                              Text(t("Guest:"), style: TextStyle(fontWeight: FontWeight.bold)),
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
                                ),
                              ),
                            ],
                          );
                        })(),

                      // * stay info
                      if (!["Pending Fix"].contains(r[sm_room.STATUS]))
                        (() {
                          final fd = map_fd[r[sm_room.FRONT_DESK_ID]];
                          final stay_n_guest = fd?[sm_front_desk.CHECK_IN_NUMBER] ?? "0";
                          final stay_day = fd?[sm_front_desk.CHECK_IN_DAY] ?? "0";
                          final stay_hour = fd?[sm_front_desk.CHECK_IN_HOUR] ?? "0";
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.calendar_month, size: 24), //
                              Text(t("Stay:"), style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // payment room info
                      if (!["Pending Fix"].contains(r[sm_room.STATUS]))
                        (() {
                          double price_ro = _current_price(map_fd[r[sm_room.FRONT_DESK_ID]]?["price_room"]);
                          double pay_room = 0;
                          double pay_return = 0;
                          for (var l in (map_fd[r[sm_room.FRONT_DESK_ID]]?["pay_room"] ?? [])) {
                            pay_room += double.tryParse(l["pay_cash"]?.toString() ?? "0") ?? 0;
                            pay_room += double.tryParse(l["pay_bank"]?.toString() ?? "0") ?? 0;
                            pay_return += double.tryParse(l["pay_return"]?.toString() ?? "0") ?? 0;
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.receipt_outlined, size: 24), //
                              Text(t("Room Payment:"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Price"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${price_ro.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Pay"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${pay_room.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Change"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${pay_return.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //

                              if (!["Pending Clean"].contains(r[sm_room.STATUS]))
                                Tooltip(
                                  message: t("Edit Room Payment"),
                                  child: InkWell(
                                    onTap: () => on_update_rp(r),
                                    child: Icon(Icons.edit_outlined, size: 24, color: Colors.blue), //
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // payment mini bar info
                      if (!["Pending Fix"].contains(r[sm_room.STATUS]))
                        (() {
                          // * បន្ទាប់ពី update backend៖ pay_mini_bar រាល់បន្ទាត់ = Mini_Bar {name, quantity, price, price_total, ...}
                          double price_re = 0;
                          for (var l in (map_fd[r[sm_room.FRONT_DESK_ID]]?["pay_mini_bar"] ?? [])) {
                            price_re += double.tryParse(l["price_total"]?.toString() ?? "0") ?? 0;
                          }
                          double pay_re = 0;
                          for (var l in (map_fd[r[sm_room.FRONT_DESK_ID]]?["pay_mini_bar"] ?? [])) {
                            pay_re += double.tryParse(l["pay_cash"]?.toString() ?? "0") ?? 0;
                            pay_re += double.tryParse(l["pay_bank"]?.toString() ?? "0") ?? 0;
                          }
                          double return_re = 0;
                          for (var l in (map_fd[r[sm_room.FRONT_DESK_ID]]?["pay_mini_bar"] ?? [])) {
                            return_re += double.tryParse(l["pay_return"]?.toString() ?? "0") ?? 0;
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.receipt_outlined, size: 24), //
                              Text(t("Mini Bar Payment:"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Price"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${price_re.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Pay"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${pay_re.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Change"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${return_re.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              if (r[sm_room.STATUS] != "Pending Clean")
                                Tooltip(
                                  message: t("Edit Mini Bar Payment"),
                                  child: InkWell(
                                    onTap: () => on_update_mnb(r),
                                    child: Icon(Icons.edit_outlined, size: 24, color: Colors.blue), //
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // payment other info
                      if (!["Pending Fix"].contains(r[sm_room.STATUS]))
                        (() {
                          double price_re = _current_price(map_fd[r[sm_room.FRONT_DESK_ID]]?["price_other"]);
                          double pay_re = 0;
                          double return_re = 0;
                          for (var l in (map_fd[r[sm_room.FRONT_DESK_ID]]?["pay_other"] ?? [])) {
                            pay_re += double.tryParse(l["pay_cash"]?.toString() ?? "0") ?? 0;
                            pay_re += double.tryParse(l["pay_bank"]?.toString() ?? "0") ?? 0;
                            return_re += double.tryParse(l["pay_return"]?.toString() ?? "0") ?? 0;
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.receipt_outlined, size: 24), //
                              Text(t("Other Payment:"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Price"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${price_re.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Pay"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${pay_re.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text(t("Change"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("${return_re.toStringAsFixed(2)} \$", style: TextStyle(color: Colors.blue)), //
                              //
                              if (r[sm_room.STATUS] != "Pending Clean")
                                Tooltip(
                                  message: t("Edit Other Payment"),
                                  child: InkWell(
                                    onTap: () => on_update_ot(r),
                                    child: Icon(Icons.edit_outlined, size: 24, color: Colors.blue), //
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // check in, due to, check out info
                      if (r[sm_room.STATUS] != "Pending Fix")
                        (() {
                          String check_in = "";
                          final check_in_at = map_fd[r[sm_room.FRONT_DESK_ID]]?[sm_front_desk.CHECK_IN_AT];
                          if (check_in_at != null) {
                            final due = DateTime.parse(check_in_at);
                            check_in = DateFormat(DEFAULT_DATE_FORMAT).format(due);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.login, size: 24), //
                              Text(t("Time In:"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(check_in, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      // due to info
                      if (r[sm_room.STATUS] != "Pending Fix")
                        (() {
                          String due = "";
                          final stay_due = map_fd[r[sm_room.FRONT_DESK_ID]]?[sm_front_desk.CHECK_IN_DUE];
                          if (stay_due != null) {
                            tmp = DateTime.parse(stay_due);
                            due = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.time_to_leave_outlined, size: 24), //
                              Text(t("Due:"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(due, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      //
                      if (r[sm_room.STATUS] != "Pending Fix")
                        (() {
                          String check_out = "";
                          final check_out_at = map_fd[r[sm_room.FRONT_DESK_ID]]?[sm_front_desk.CHECK_OUT_AT];
                          if (check_out_at != null) {
                            tmp = DateTime.parse(check_out_at);
                            check_out = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.logout, size: 24), //
                              Text(t("Time Out:"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(check_out, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      // broke info
                      if (r[sm_room.STATUS] == "Pending Fix")
                        (() {
                          String broke_date = "";
                          final broke_at = map_fd[r[sm_room.FRONT_DESK_ID]]?[sm_front_desk.BROKE_AT];
                          if (broke_at != null) {
                            tmp = DateTime.parse(broke_at);
                            broke_date = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.bug_report_outlined, size: 24), //
                              Text(t("Broken At:"), style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(broke_date, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),
                    ],

                    // buttons
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (r[sm_room.STATUS] == "Available") //
                          OutlinedButton.icon(
                            onPressed: () => on_check_in(r), //
                            icon: Icon(Icons.login),
                            label: Text("Check In"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.green)),
                          ), //

                        if (r[sm_room.STATUS] == "Pending Pay") //
                          OutlinedButton.icon(
                            onPressed: () => on_payment(r), //
                            icon: Icon(Icons.payment),
                            label: Text("Payment"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.orange)),
                          ), //

                        if (r[sm_room.STATUS] == "Pending Leave") //
                          OutlinedButton.icon(
                            onPressed: () => on_check_out(r), //
                            icon: Icon(Icons.logout),
                            label: Text("Check Out"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.blue)),
                          ), //

                        if (r[sm_room.STATUS] == "Pending Clean") //
                          OutlinedButton.icon(
                            onPressed: () => on_clean(r), //
                            icon: Icon(Icons.cleaning_services),
                            label: Text("Clean"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.grey)),
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

  //
  void on_detail(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => detail.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_cancel(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => cancel.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_fix(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => fix.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_broke(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => broke.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_clean(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => clean.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_check_out(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => check_out.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_payment(dynamic r) async {
    try {
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pay_room.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_update_rp(dynamic r) async {
    try {
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pay_room_update.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_check_in(dynamic r) async {
    try {
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => check_in.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_change_room(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => change_room.Main_(
            room_id: r[sm_room.ID], //
          ),
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_update_stay(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => update_stay.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_update_guest(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => update_guest.Main_(
            room_id: r[sm_room.ID], //
          ),
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_update_mnb(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => charge.Charge_(
            room: r, //
            catalog: list_mb, //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  void on_update_ot(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pay_other.Main_(
            room_id: r[sm_room.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  // * បន្ថែមទំនិញ mini bar សម្រាប់អតិថិជនដើរចូលទិញ (Walk-in)
  void on_walkin() async {
    try {
      // * គណនាចំនួនដែលបានលក់រួចហើយ (walk-in)
      final sold = <dynamic, int>{};
      for (var line in list_walkin) {
        final id = line[sm_mini_bar.ID];
        if (id != null) sold[id] = (sold[id] ?? 0) + (line["qty"] as int);
      }

      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => charge.Charge_(
            room: null, //
            catalog: list_mb, //
            sold: sold, //
          ), //
        ),
      );

      //
      if (tmp != null) {
        list_walkin.addAll(List<Map<String, dynamic>>.from(tmp));
        setState(() {});
      }

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  //
  // * សម្អាតទំនិញ walk-in ទាំងអស់
  void on_clear_walkin() {
    list_walkin.clear();
    setState(() {});
  }

  //
  // * សរុបតម្លៃ walk-in
  double get _walkin_total {
    var total = 0.0;
    for (var line in list_walkin) {
      total += (line["total"] as num).toDouble();
    }
    return total;
  }

  // * បញ្ជីបន្ទប់ដែលត្រងតាមការស្វែងរក (លេខបន្ទប់ + ស្ថានភាព)
  List<Map<String, dynamic>> get _list_show {
    final q = c_search.text.trim().toLowerCase();
    if (q.isEmpty) return list_r;
    return list_r.where((r) {
      final room_number = '${r[sm_room.NUMBER]}'.toLowerCase();
      final room_status = '${r[sm_room.STATUS]}'.toLowerCase();
      final room_kind = '${r[sm_room.KIND]}'.toLowerCase();
      return room_number.contains(q) || room_status.contains(q) || room_kind.contains(q);
    }).toList();
  }

  //
  @override
  void initState() {
    super.initState();
    init();
  }

  //
  @override
  void dispose() {
    _debounce?.cancel();
    c_search.dispose();
    super.dispose();
  }

  //
}

//
class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

//
void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
