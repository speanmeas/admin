// TODO: Add notification when overtime.
// * ទំព័រ Front Desk សម្រាប់គ្រប់គ្រងបន្ទប់ និងការស្នាក់នៅ

import "dart:async";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/button/menu_button_icon.dart";

// * នាំចូលទំព័រទម្រង់ផ្សេងៗរបស់ front desk
import "form/broke.dart" as broke;
import "form/cancel.dart" as cancel;
import "form/update_change_room.dart" as change_room;
import "form/check_in.dart" as check_in; // 1
import "form/check_out.dart" as check_out; // 3
import "form/clean.dart" as clean; // 4
import "form/detail.dart" as detail;
import "form/fix.dart" as fix; // 6
import "form/payment.dart" as pay_room; // 2
import "form/update_pay_other.dart" as pay_other;
import "form/update_pay_mini_bar.dart" as pay_mini_bar;
import "form/update_guest.dart" as update_guest;
import "form/update_pay_room.dart" as update_pay_room;
import "form/update_stay.dart" as update_stay;

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការបង្ហាញបន្ទប់ទាំងអស់
class _Main_State extends State<Main_> {
  dynamic tmp;
  List<Room> list_room = [];
  bool is_loading = true;

  String? search;
  Timer? _debounce; // * ពន្យាពេល rebuild សម្រាប់ការស្វែងរក

  // * ផ្ទុកទិន្នន័យបន្ទប់ និង front desk ពី server
  void init() async {
    // * អានបញ្ជីបន្ទប់ទាំងអស់
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ, data: {"key": Room.NUMBER, "order": 1});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_CRUD_READ}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No rooms found", cl: Colors.red);

    // * បម្លែងទិន្នន័យទៅជា List<Room> ដើម្បីអានតាម typed model
    list_room = List<Room>.from((tmp.data ?? const []).map((d) => Room.fromJson(d)));

    setState(() {});
  }

  // * បង្កើត layout មេដែលមានប្រអប់ស្វែងរក និងប៊ូតុង refresh
  Widget _layout(List<Widget> children) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 8), //
              // * ប្រអប់ស្វែងរកបន្ទប់
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

              // * ប៊ូតុង refresh ទិន្នន័យ
              Menu_Button_Icon(
                tip: "Refresh", //
                icon: Icons.refresh, //
                onPressed: init, //
              ),

              SizedBox(width: 8), //
            ],
          ),

          // * តំបន់បង្ហាញបញ្ជីបន្ទប់
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
                              "${t("Room")} ${r.number}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),

                        (() {
                          var color = Colors.black; // Default color
                          if (["Available"].contains(r.status)) color = Colors.green;
                          if (["Pending Pay"].contains(r.status)) color = Colors.orange;
                          if (["Pending Leave"].contains(r.status)) color = Colors.blue;
                          if (["Pending Clean"].contains(r.status)) color = Colors.grey;
                          if (["Pending Fix"].contains(r.status)) color = Colors.red;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.circle, size: 10, color: color),
                              SizedBox(width: 4),
                              Text("${r.status}", style: TextStyle(fontSize: 14, color: color)),

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
                                    if (!["Available"].contains(r.status))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.receipt_outlined, color: Colors.blue),
                                        child: Text(t("View Details"), style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_detail(r), //
                                        // onPressed: () {},
                                      ),

                                    if (["Available"].contains(r.status))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.bug_report_outlined, color: Colors.blue),
                                        child: Text(t("Set as Broken"), style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_broke(r), //
                                      ),

                                    if (["Pending Fix"].contains(r.status))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.build_outlined, color: Colors.blue),
                                        child: Text(t("Mark as Fixed"), style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_fix(r), //
                                      ),

                                    if (["Pending Pay", "Pending Leave"].contains(r.status))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.swap_horiz_outlined, color: Colors.blue),
                                        child: Text(t("Change Room"), style: TextStyle(color: Colors.blue)),
                                        onPressed: () => on_change_room(r), //
                                      ),

                                    if (["Pending Pay", "Pending Leave"].contains(r.status))
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
                      String kind = r.kind ?? t("N/A");
                      double usd_per_3h = r.usd_per_3h ?? 0;
                      double usd_per_day = r.usd_per_day ?? 0;
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

                    if (r.front_desk_id != null) ...[
                      if (!"${r.status}".contains("Pending Fix"))
                        (() {
                          final guest = _fd(r)?.guest_id;
                          final guest_name = guest?.full_name ?? "N/A";
                          final guest_phone = guest?.phone_number ?? "N/A";
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

                      if (!["Pending Fix"].contains(r.status))
                        (() {
                          final fd = _fd(r);
                          final stay_n_guest = fd?.check_in_number?.toString() ?? "0";
                          final stay_day = fd?.check_in_day?.toString() ?? "0";
                          final stay_hour = fd?.check_in_hour?.toString() ?? "0";
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
                              if (r.status != "Pending Clean")
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

                      if (!["Pending Fix"].contains(r.status))
                        (() {
                          final pay_room_list = _fd(r)?.pay_room ?? [];
                          double price = 0;
                          double pay = 0;
                          double change = 0;
                          for (var l in pay_room_list) {
                            price = price + (l.add_price ?? 0);
                            price = price - (l.sub_price ?? 0);
                            pay = pay + (l.add_cash ?? 0);
                            pay = pay + (l.add_bank ?? 0);
                            change = change + (l.sub_return ?? 0);
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

                              if (!["Pending Clean"].contains(r.status))
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
                      if (!["Pending Fix"].contains(r.status))
                        (() {
                          final pay_mini_bar_list = _fd(r)?.pay_mini_bar ?? [];
                          double price = 0;
                          double pay = 0;
                          double change = 0;
                          for (var l in pay_mini_bar_list) {
                            price = price + (l.add_price ?? 0);
                            price = price - (l.sub_price ?? 0);
                            pay = pay + (l.add_cash ?? 0);
                            pay = pay + (l.add_bank ?? 0);
                            change = change + (l.sub_return ?? 0);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.receipt_outlined, size: 24), //
                              Text('${t("Mini Bar Payment")}:', style: TextStyle(fontWeight: FontWeight.bold)), //
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

                              if (!["Pending Clean"].contains(r.status))
                                Tooltip(
                                  message: t("Edit Mini Bar Payment"),
                                  child: InkWell(
                                    child: Icon(Icons.edit_outlined, size: 24, color: Colors.blue), //
                                    onTap: () => on_pay_mini_bar(r),
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // payment other info
                      if (!["Pending Fix"].contains(r.status))
                        (() {
                          final pay_other_list = _fd(r)?.pay_other ?? [];
                          double price = 0;
                          double pay = 0;
                          double change = 0;
                          for (var l in pay_other_list) {
                            price = price + (l.add_price ?? 0);
                            price = price - (l.sub_price ?? 0);
                            pay = pay + (l.add_cash ?? 0);
                            pay = pay + (l.add_bank ?? 0);
                            change = change + (l.sub_return ?? 0);
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
                              if (r.status != "Pending Clean")
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
                      if (r.status != "Pending Fix")
                        (() {
                          String check_in = format_datetime(_fd(r)?.check_in_at);
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
                      if (r.status != "Pending Fix")
                        (() {
                          String due = format_datetime(_fd(r)?.check_in_due);
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
                      if (r.status != "Pending Fix")
                        (() {
                          String check_out = format_datetime(_fd(r)?.check_out_at);
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
                      if (r.status == "Pending Fix")
                        (() {
                          String broke_date = format_datetime(_fd(r)?.broke_at);
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
                        if (r.status == "Available") //
                          OutlinedButton.icon(
                            icon: Icon(Icons.login),
                            label: Text(t("Check In")),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.green)),
                            onPressed: () => on_check_in(r), //
                          ), //
                        if (r.status == "Pending Pay") //
                          OutlinedButton.icon(
                            icon: Icon(Icons.payment),
                            label: Text(t("Payment")),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.orange)),
                            onPressed: () {
                              // * បើ mini bar ឬ other មិនទាន់បង់អស់ មិនអនុញ្ញាតឱ្យទូទាត់ទេ
                              if (can_payment(r)) {
                                on_payment(r);
                              } else {
                                snackbar(ct: context, ms: t("Please pay Mini Bar and Other first"), cl: Colors.red);
                              }
                            }, //
                          ), //
                        if (r.status == "Pending Leave") //
                          OutlinedButton.icon(
                            icon: Icon(Icons.logout),
                            label: Text(t("Check Out")),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.blue)),
                            onPressed: () => on_check_out(r), //
                          ), //
                        if (r.status == "Pending Clean") //
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

  // * គណនាចំនួនទឹកប្រាក់ដែលនៅសល់ត្រូវបង់សម្រាប់បញ្ជីទូទាត់មួយ
  double _outstanding(List<dynamic>? items) {
    double price = 0;
    double pay = 0;
    for (var l in (items ?? [])) {
      price = price + (l.add_price ?? 0);
      price = price - (l.sub_price ?? 0);
      pay = pay + (l.add_cash ?? 0);
      pay = pay + (l.add_bank ?? 0);
    }
    return price - pay;
  }

  // * អនុញ្ញាតឱ្យទូទាត់បាន លុះត្រាតែ mini bar និង other បានបង់អស់
  bool can_payment(Room r) {
    final fd = _fd(r);
    if (fd == null) return false;
    // * បើ mini bar ឬ other នៅមានបំណុល មិនអនុញ្ញាតឱ្យទូទាត់ទេ
    if (_outstanding(fd.pay_mini_bar) > 0) return false;
    if (_outstanding(fd.pay_other) > 0) return false;
    return true;
  }

  // * បើកទំព័រ check in សម្រាប់បន្ទប់
  void on_check_in(dynamic r) async {
    tmp = await nav_push(context, check_in.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រទូទាត់បន្ទប់
  void on_payment(dynamic r) async {
    tmp = await nav_push(context, pay_room.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រ check out សម្រាប់បន្ទប់
  void on_check_out(dynamic r) async {
    tmp = await nav_push(context, check_out.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រសម្អាតបន្ទប់
  void on_clean(dynamic r) async {
    tmp = await nav_push(context, clean.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រកំណត់បន្ទប់ខូច
  void on_broke(dynamic r) async {
    tmp = await nav_push(context, broke.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រកំណត់បន្ទប់ជួសជុលរួច
  void on_fix(dynamic r) async {
    tmp = await nav_push(context, fix.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រមើលព័ត៌មានលម្អិតបន្ទប់
  void on_detail(dynamic r) async {
    tmp = await nav_push(context, detail.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័របោះបង់ការស្នាក់នៅ
  void on_cancel(dynamic r) async {
    tmp = await nav_push(context, cancel.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រប្តូរបន្ទប់
  void on_change_room(dynamic r) async {
    tmp = await nav_push(context, change_room.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រកែព័ត៌មានស្នាក់នៅ
  void on_update_stay(dynamic r) async {
    tmp = await nav_push(context, update_stay.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រកែព័ត៌មានភ្ញៀវ
  void on_update_guest(dynamic r) async {
    tmp = await nav_push(context, update_guest.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រកែការទូទាត់បន្ទប់
  void on_update_room_payment(dynamic r) async {
    tmp = await nav_push(context, update_pay_room.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រទូទាត់ផ្សេងៗ
  void on_pay_other(dynamic r) async {
    tmp = await nav_push(context, pay_other.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * បើកទំព័រទូទាត់ mini bar
  void on_pay_mini_bar(dynamic r) async {
    tmp = await nav_push(context, pay_mini_bar.Main_(room_id: r.id));
    if (tmp != null) init();
  }

  // * Safe lookup into front_desk; returns null if the room has no front-desk record
  Front_Desk? _fd(Room r) => r.front_desk_id;

  // * ត្រងបញ្ជីបន្ទប់តាមលក្ខខណ្ឌស្វែងរក
  List<Room> get _list_show {
    final q = search?.trim().toLowerCase();
    if (q == null || q.isEmpty) return list_room;
    return list_room.where((r) {
      final room_number = '${r.number}'.toLowerCase();
      final room_status = '${r.status}'.toLowerCase();
      final room_kind = '${r.kind}'.toLowerCase();
      return room_number.contains(q) || room_status.contains(q) || room_kind.contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រមេ front desk
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
