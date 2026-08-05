/// TODO: Add notification when overtime.
///
///
///

import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep;
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as sb;

import "__config__.dart";

import "schema.g.dart" as sm;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "form/detail.dart" as detail;
import "form/check_in.dart" as check_in;
import "form/room_payment.dart" as room_payment;
import "form/check_out.dart" as check_out;
import "form/clean.dart" as clean;
import "form/cancel.dart" as cancel;
import "form/update_guest.dart" as update_guest;
import "form/update_revenue_payment.dart" as update_revenue_payment;

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
  List<Map<String, dynamic>> rooms = [];
  Map<String, dynamic> front_desks = {};

  void init() async {
    try {
      // * ទាញយកទិន្នន័យបន្ទប់ទាំងអស់ពីម៉ាស៊ីនមេ
      tmp = await dio.post(
        ep.ROOM_READ, //
        data: {
          "key": sm_r.NUMBER, //
          "order": 1, //
          "limit": 1000,
        },
      );

      // * រក្សាទុកទិន្នន័យបន្ទប់ទៅក្នុងបញ្ជី
      rooms = List<Map<String, dynamic>>.from(tmp.data);

      // * ទាញយកទិន្នន័យ front desk ដែលទាក់ទងនឹងបន្ទប់នីមួយៗ
      for (var r in rooms) {
        if (r[sm_r.FRONT_DESK_ID] != null) {
          tmp = await dio.post(
            ep.FRONT_DESK_READ_ID, //
            data: {
              sm.ID: r[sm_r.FRONT_DESK_ID], //
            },
          );
          front_desks[r[sm_r.FRONT_DESK_ID]] = tmp.data[0];
        }
      }

      setState(() {});
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // * បង្ហាញបញ្ជីបន្ទប់ទាំងអស់
      for (var r in rooms)
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
                          if (r[sm_r.STATUS] == "Available") color = Colors.green;
                          if (r[sm_r.STATUS] == "Pending Pay") color = Colors.red;
                          if (r[sm_r.STATUS] == "Pending Leave") color = Colors.orange;
                          if (r[sm_r.STATUS] == "Pending Clean") color = Colors.grey;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.circle, size: 10, color: color),
                              SizedBox(width: 4),
                              Text("${r[sm_r.STATUS]}", style: TextStyle(fontSize: 14, color: color)),

                              // menu
                              MenuAnchor(
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
                                  if (r[sm_r.STATUS] != "Available") ...[
                                    //
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.receipt_outlined, color: Colors.blue),
                                      child: Text("Detail", style: TextStyle(color: Colors.blue)), //
                                      onPressed: () => on_detail(r), //
                                    ),

                                    //
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.swap_horiz_outlined, color: Colors.blue),
                                      child: Text("Change Room", style: TextStyle(color: Colors.blue)),
                                      onPressed: () {}, //
                                    ),

                                    //
                                    if (r[sm_r.STATUS] != "Pending Clean")
                                      if (r[sm_r.STATUS] != "Pending Leave")
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                          child: Text("Cancel", style: TextStyle(color: Colors.red)),
                                          onPressed: () => on_cancel(r), //
                                        ),
                                  ],
                                ],
                              ),
                            ],
                          );
                        })(),
                      ],
                    ),

                    //
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
                      //
                      (() {
                        final guest_name = front_desks[r[sm_r.FRONT_DESK_ID]][sm.GUEST_FULL_NAME] ?? "N/A";
                        final guest_phone = front_desks[r[sm_r.FRONT_DESK_ID]][sm.GUEST_PHONE_NUMBER] ?? "N/A";
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
                            InkWell(
                              child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                              onTap: () => on_update_guest(r),
                            ),
                          ],
                        );
                      })(),

                      //
                      (() {
                        final stay_n_guest = front_desks[r[sm_r.FRONT_DESK_ID]][sm.STAY_N_GUEST] ?? "0";
                        final stay_day = front_desks[r[sm_r.FRONT_DESK_ID]][sm.STAY_DAY] ?? "0";
                        final stay_hour = front_desks[r[sm_r.FRONT_DESK_ID]][sm.STAY_HOUR] ?? "0";
                        final price = front_desks[r[sm_r.FRONT_DESK_ID]][sm.ROOM_PRICE] ?? "0";
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
                            // //
                            // Icon(Icons.payments_outlined, size: 20), //
                            // Text("$price \$", style: TextStyle(color: Colors.blue)), //
                            if (r[sm_r.STATUS] != "Pending Clean")
                              InkWell(
                                child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                                onTap: () {}, //
                              ),
                          ],
                        );
                      })(),

                      //
                      (() {
                        final room_pay = front_desks[r[sm_r.FRONT_DESK_ID]][sm.ROOM_PAY] ?? "0";
                        final room_price = front_desks[r[sm_r.FRONT_DESK_ID]][sm.ROOM_PRICE] ?? "0";
                        return Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.receipt_outlined, size: 20), //
                            Text("Room:", style: TextStyle(fontWeight: FontWeight.bold)), //
                            //
                            SizedBox(width: 4), //
                            Icon(Icons.circle, size: 6), //
                            Text("Price", style: TextStyle(fontWeight: FontWeight.bold)), //
                            Text("$room_price \$", style: TextStyle(color: Colors.blue)), //
                            //
                            SizedBox(width: 4), //
                            Icon(Icons.circle, size: 6), //
                            Text("Payment", style: TextStyle(fontWeight: FontWeight.bold)), //
                            Text("$room_pay \$", style: TextStyle(color: Colors.blue)), //
                          ],
                        );
                      })(),

                      //
                      (() {
                        final revenue_price = front_desks[r[sm_r.FRONT_DESK_ID]][sm.REVENUE_PRICE] ?? "0";
                        final revenue_pay = front_desks[r[sm_r.FRONT_DESK_ID]][sm.REVENUE_PAY] ?? "0";
                        return Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.receipt_outlined, size: 20), //
                            Text("Revenue:", style: TextStyle(fontWeight: FontWeight.bold)), //
                            //
                            SizedBox(width: 4), //
                            Icon(Icons.circle, size: 6), //
                            Text("Price", style: TextStyle(fontWeight: FontWeight.bold)), //
                            Text("$revenue_price \$", style: TextStyle(color: Colors.blue)), //
                            //
                            SizedBox(width: 4), //
                            Icon(Icons.circle, size: 6), //
                            Text("Payment", style: TextStyle(fontWeight: FontWeight.bold)), //
                            Text("$revenue_pay \$", style: TextStyle(color: Colors.blue)), //
                            if (r[sm_r.STATUS] != "Pending Clean")
                              InkWell(
                                child: Icon(Icons.edit_outlined, size: 20, color: Colors.blue), //
                                onTap: () => on_update_revenue(r), //
                              ),
                          ],
                        );
                      })(),

                      //
                      (() {
                        String check_in = "";
                        if (front_desks[r[sm_r.FRONT_DESK_ID]][sm.CHECK_IN_AT] != null) {
                          final due = DateTime.parse(front_desks[r[sm_r.FRONT_DESK_ID]][sm.CHECK_IN_AT]);
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

                      //
                      (() {
                        String due = "";
                        if (front_desks[r[sm_r.FRONT_DESK_ID]][sm.STAY_DUE] != null) {
                          tmp = DateTime.parse(front_desks[r[sm_r.FRONT_DESK_ID]][sm.STAY_DUE]);
                          due = DateFormat(DATE_FORMAT).format(tmp);
                        }
                        return Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.time_to_leave_outlined, size: 20), //
                            Text("Due:", style: TextStyle(fontWeight: FontWeight.bold)), //
                            Text(due, style: TextStyle(color: Colors.blue)), //
                          ],
                        );
                      })(),

                      //
                      (() {
                        String check_out = "";
                        if (front_desks[r[sm_r.FRONT_DESK_ID]][sm.CHECK_OUT_AT] != null) {
                          tmp = DateTime.parse(front_desks[r[sm_r.FRONT_DESK_ID]][sm.CHECK_OUT_AT]);
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
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.red)),
                          ), //

                        if (r[sm_r.STATUS] == "Pending Leave") //
                          OutlinedButton.icon(
                            onPressed: () => on_check_out(r), //
                            icon: Icon(Icons.logout),
                            label: Text("Check Out"),
                            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.orange)),
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
  void on_detail(r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => detail.Main_(
            front_desk_id: r[sm_r.FRONT_DESK_ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_update_guest(r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => update_guest.Main_(
            front_desk_id: r[sm_r.FRONT_DESK_ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_update_revenue(r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => update_revenue_payment.Main_(
            front_desk_id: r[sm_r.FRONT_DESK_ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_cancel(r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => cancel.Main_(
            front_desk_id: r[sm_r.FRONT_DESK_ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_clean(r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => clean.Main_(
            front_desk_id: r[sm_r.FRONT_DESK_ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_check_out(r) async {
    try {
      //
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => check_out.Main_(
            front_desk_id: r[sm_r.FRONT_DESK_ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_payment(r) async {
    try {
      // print(r[sm_r.FRONT_DESK_ID]);
      // return;

      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => room_payment.Main_(
            front_desk_id: r[sm_r.FRONT_DESK_ID], //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_check_in(r) async {
    try {
      tmp = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => check_in.Main_(
            room_id: r[sm_r.ID], //
            price_day: r[sm_r.USD_PER_DAY] ?? 0, //
            price_hour: r[sm_r.USD_PER_3H] ?? 0, //
          ), //
        ),
      );

      //
      if (tmp != null) init();

      //
    } catch (e) {
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
  Main_({super.key});
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
