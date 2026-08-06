// TODO: Add notification when overtime.

import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/theme_light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as sb;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "config.dart";

import "schema.g.dart" as sm_fd;

import "form/detail.dart" as detail;
import "form/check_in.dart" as check_in;
import "form/payment_room.dart" as payment_room;
import "form/payment_revenue.dart" as payment_revenue;
import "form/check_out.dart" as check_out;
import "form/clean.dart" as clean;
import "form/cancel.dart" as cancel;
import "form/broke.dart" as broke;
import "form/fix.dart" as fix;
import "form/change_room.dart" as change_room;

import "form/update_guest.dart" as update_guest;
import "form/update_payment_revenue.dart" as update_revenue_payment;
import "form/update_stay.dart" as update_stay;

Widget _layout(List<Widget> children) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Center(
        child: Wrap(
          children: children, //
        ),
      ),
    ),
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  List<Map<String, dynamic>> list_r = [];
  Map<String, dynamic> map_fd = {};

  void init() async {
    try {
      // * ទាញយកទិន្នន័យបន្ទប់ទាំងអស់ពីម៉ាស៊ីនមេ
      // * រក្សាទុកទិន្នន័យបន្ទប់ទៅក្នុងបញ្ជី
      tmp = await dio.post(ep.ROOM_READ, data: {"key": sm_r.NUMBER, "order": 1});
      list_r = List<Map<String, dynamic>>.from(tmp.data);

      // * ទាញយកទិន្នន័យ front desk ដែលទាក់ទងនឹងបន្ទប់នីមួយៗ
      for (var r in list_r) {
        if (r[sm_r.FRONT_DESK_ID] != null) {
          tmp = await dio.post(
            ep.FRONT_DESK_READ_ID, //
            data: {
              sm_fd.ID: r[sm_r.FRONT_DESK_ID], //
            },
          );
          map_fd[r[sm_r.FRONT_DESK_ID]] = tmp.data[0];
        }
      }

      setState(() {});
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // * បង្ហាញបញ្ជីបន្ទប់ទាំងអស់
      for (var r in list_r)
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
                              " ${r[sm_r.NUMBER]}",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),

                        // * ស្ថានភាពបន្ទប់នៅខាងស្តាំ
                        (() {
                          var color = Colors.black; // Default color
                          if (["Available"].contains(r[sm_r.STATUS])) color = Colors.green;
                          if (["Pending Pay"].contains(r[sm_r.STATUS])) color = Colors.orange;
                          if (["Pending Leave"].contains(r[sm_r.STATUS])) color = Colors.blue;
                          if (["Pending Clean"].contains(r[sm_r.STATUS])) color = Colors.grey;
                          if (["Pending Fix"].contains(r[sm_r.STATUS])) color = Colors.red;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.circle, size: 10, color: color),
                              SizedBox(width: 4),
                              Text("${r[sm_r.STATUS]}", style: TextStyle(fontSize: 14, color: color)),

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
                                    if (!["Available"].contains(r[sm_r.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.receipt_outlined, color: Colors.blue),
                                        child: Text("Detail", style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_detail(r), //
                                      ),

                                    if (["Available"].contains(r[sm_r.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.bug_report_outlined, color: Colors.blue),
                                        child: Text("Broke", style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_broke(r), //
                                      ),

                                    if (["Pending Fix"].contains(r[sm_r.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.build_outlined, color: Colors.blue),
                                        child: Text("Fixed", style: TextStyle(color: Colors.blue)), //
                                        onPressed: () => on_fix(r), //
                                      ),

                                    //
                                    if (["Pending Pay", "Pending Leave"].contains(r[sm_r.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.swap_horiz_outlined, color: Colors.blue),
                                        child: Text("Change Room", style: TextStyle(color: Colors.blue)),
                                        onPressed: () => on_change_room(r), //
                                      ),

                                    //
                                    if (["Pending Pay", "Pending Leave"].contains(r[sm_r.STATUS]))
                                      MenuItemButton(
                                        leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                        child: Text("Cancel", style: TextStyle(color: Colors.red)),
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
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${r[sm_r.KIND]}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text("-"), //
                        Text("${r[sm_r.USD_PER_3H]} \$ / 3 Hours", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), //
                        Text("-"), //
                        Text("${r[sm_r.USD_PER_DAY]} \$ / Day", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),

                    //
                    if (r[sm_r.FRONT_DESK_ID] != null) ...[
                      // guest info
                      if (!"${r[sm_r.STATUS]}".contains("Pending Fix"))
                        (() {
                          final guest_name = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.GUEST_FULL_NAME] ?? "N/A";
                          final guest_phone = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.GUEST_PHONE_NUMBER] ?? "N/A";
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.person, size: 20), //
                              Text("Guest:", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                message: "Edit guest",
                                child: InkWell(
                                  child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                                  onTap: () => on_update_guest(r),
                                ),
                              ),
                            ],
                          );
                        })(),

                      // stay info
                      if (r[sm_r.STATUS] != "Pending Fix")
                        (() {
                          final stay_n_guest = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.STAY_N_GUEST] ?? "0";
                          final stay_day = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.STAY_DAY] ?? "0";
                          final stay_hour = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.STAY_HOUR] ?? "0";
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.calendar_month, size: 20), //
                              Text("Stay:", style: TextStyle(fontWeight: FontWeight.bold)),
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text("$stay_n_guest Persons", style: TextStyle(color: Colors.blue)),
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text("$stay_day Days", style: TextStyle(color: Colors.blue)),
                              //
                              SizedBox(width: 2), //
                              Icon(Icons.circle, size: 6), //
                              Text("$stay_hour Hours", style: TextStyle(color: Colors.blue)),
                              if (r[sm_r.STATUS] != "Pending Clean")
                                Tooltip(
                                  message: "Edit stay info",
                                  child: InkWell(
                                    child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                                    onTap: () => on_update_stay(r),
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // payment room info
                      if (r[sm_r.STATUS] != "Pending Fix")
                        (() {
                          final price_ro = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.ROOM_PRICE] ?? "0";
                          final pay_ro = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.ROOM_PAY] ?? "0";
                          final return_ro = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.ROOM_RETURN] ?? "0";
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.receipt_outlined, size: 20), //
                              Text("Room:", style: TextStyle(fontWeight: FontWeight.bold)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text("Price", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("$price_ro \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text("Payment", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("$pay_ro \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text("Return", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("$return_ro \$", style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      // payment revenue info
                      if (r[sm_r.STATUS] != "Pending Fix")
                        (() {
                          final price_re = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.REVENUE_PRICE] ?? "0";
                          final pay_re = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.REVENUE_PAY] ?? "0";
                          final return_re = map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.REVENUE_RETURN] ?? "0";
                          bool is_update = false;
                          tmp = double.tryParse(pay_re.toString());
                          if (tmp != null && tmp > 0) is_update = true;
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.receipt_outlined, size: 20), //
                              Text("Revenue:", style: TextStyle(fontWeight: FontWeight.bold)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text("Price", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("$price_re \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text("Payment", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("$pay_re \$", style: TextStyle(color: Colors.blue)), //
                              //
                              SizedBox(width: 4), //
                              Icon(Icons.circle, size: 6), //
                              Text("Return", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text("$return_re \$", style: TextStyle(color: Colors.blue)), //
                              //
                              if (r[sm_r.STATUS] != "Pending Clean")
                                Tooltip(
                                  message: is_update ? "Edit Revenue" : "Add Revenue",
                                  child: InkWell(
                                    onTap: is_update ? () => on_update_rvn(r) : () => on_create_rvn(r),
                                    child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                                  ),
                                ),
                            ],
                          );
                        })(),

                      // check in, due to, check out info
                      if (r[sm_r.STATUS] != "Pending Fix")
                        (() {
                          String check_in = "";
                          if (map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.CHECK_IN_AT] != null) {
                            final due = DateTime.parse(map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.CHECK_IN_AT]);
                            check_in = DateFormat(DATE_FORMAT).format(due);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.login, size: 20), //
                              Text("Check In:", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(check_in, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      // due to info
                      if (r[sm_r.STATUS] != "Pending Fix")
                        (() {
                          String due = "";
                          if (map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.STAY_DUE] != null) {
                            tmp = DateTime.parse(map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.STAY_DUE]);
                            due = DateFormat(DATE_FORMAT).format(tmp);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.time_to_leave_outlined, size: 20), //
                              Text("Due To:", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(due, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      //
                      if (r[sm_r.STATUS] != "Pending Fix")
                        (() {
                          String check_out = "";
                          if (map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.CHECK_OUT_AT] != null) {
                            tmp = DateTime.parse(map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.CHECK_OUT_AT]);
                            check_out = DateFormat(DATE_FORMAT).format(tmp);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.logout, size: 20), //
                              Text("Check Out:", style: TextStyle(fontWeight: FontWeight.bold)), //
                              Text(check_out, style: TextStyle(color: Colors.blue)), //
                            ],
                          );
                        })(),

                      // broke info
                      if (r[sm_r.STATUS] == "Pending Fix")
                        (() {
                          String broke_date = "";
                          if (map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.BROKE_AT] != null) {
                            tmp = DateTime.parse(map_fd[r[sm_r.FRONT_DESK_ID]][sm_fd.BROKE_AT]);
                            broke_date = DateFormat(DATE_FORMAT).format(tmp);
                          }
                          return Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.bug_report_outlined, size: 20), //
                              Text("Broke Date:", style: TextStyle(fontWeight: FontWeight.bold)), //
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
                        if (r[sm_r.STATUS] == "Available") //
                          OutlinedButton.icon(
                            onPressed: () => on_check_in(r), //
                            icon: Icon(Icons.login),
                            label: Text("Check In"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.green)),
                          ), //

                        if (r[sm_r.STATUS] == "Pending Pay") //
                          OutlinedButton.icon(
                            onPressed: () => on_payment(r), //
                            icon: Icon(Icons.payment),
                            label: Text("Payment"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.orange)),
                          ), //

                        if (r[sm_r.STATUS] == "Pending Leave") //
                          OutlinedButton.icon(
                            onPressed: () => on_check_out(r), //
                            icon: Icon(Icons.logout),
                            label: Text("Check Out"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.blue)),
                          ), //

                        if (r[sm_r.STATUS] == "Pending Clean") //
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
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  // * សម្អាត
  void on_clean(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => clean.Main_(
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_payment(dynamic r) async {
    try {
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => payment_room.Main_(
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_check_in(dynamic r) async {
    try {
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => check_in.Main_(
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
            room_id: r[sm_r.ID], //
          ),
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
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
            room_id: r[sm_r.ID], //
          ),
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_create_rvn(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => payment_revenue.Main_(
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_update_rvn(dynamic r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => update_revenue_payment.Main_(
            room_id: r[sm_r.ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  @override
  void initState() {
    super.initState();
    init();
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
      title: HEADER, //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
