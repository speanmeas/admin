///
///
///
///

import "package:flutter/material.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "__config__.dart";
import "schema.g.dart" as schema;
import "package:speanmeas/features/database/room/schema.g.dart" as r_schema;
import "package:speanmeas/features/database/guest/schema.g.dart" as g_schema;

import "form/check_in/1_guest.dart" as check_in;
import "form/payment/1_room_payment.dart" as payment;
import "form/check_out/1_revenue_payment.dart" as check_out;
import "form/clean/1_note.dart" as clean;

import "widget/button_menu.dart" as button_menu;

import "menu/summary.dart" as summary;
import "menu/update_guest.dart" as update_guest;
import "menu/revenue_payment_ai.dart" as revenue_payment;

class _Main_State extends State<Main_> {
  //

  List<Map<String, dynamic>> rooms = [];

  void init() async {
    try {
      //
      final r = await dio.post(
        "/room/read", //
        data: {
          "key": r_schema.NUMBER, //
          "order": 1, //
          "limit": 1000,
        },
      );

      //
      rooms = List<Map<String, dynamic>>.from(r.data);

      //
      if (mounted) setState(() {});
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final row_count = is_mobile ? 2 : 1;
          return GridView(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: is_mobile ? 2 : 4, //
              mainAxisExtent: constraints.maxHeight / row_count,
            ),
            children: [
              // check-in
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  children: [
                    // header
                    Text(
                      "Check In", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ), //

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Wrap(
                          children: [
                            for (var r in rooms)
                              (() {
                                if (r[r_schema.STATUS] == "Available")
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: button_menu.Main_(
                                      color: Colors.green,
                                      icon: Icons.hotel_outlined,
                                      text: r[r_schema.NUMBER],
                                      menuChildren: [
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.info_outline),
                                          child: Text("Status"), //
                                          onPressed: () {
                                            snackbar.view(context: context, message: "Under Development.", color: Colors.blue);
                                          }, //
                                        ),
                                        // // Divider(height: 1),
                                        // MenuItemButton(
                                        //   leadingIcon: Icon(Icons.build_outlined),
                                        //   child: Text("Broken"), //
                                        //   onPressed: () {
                                        //     // TODO:
                                        //     snackbar.show(context: context, message: "Under Development.", color: Colors.blue);
                                        //   }, //
                                        // ),
                                      ],
                                      onPressed: () => on_check_in(r), //
                                    ),
                                  );

                                //
                                return SizedBox.shrink();
                              })(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // payment
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  children: [
                    // header
                    Text(
                      "Payment", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                    ), //

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Wrap(
                          children: [
                            for (var r in rooms)
                              (() {
                                if (r[r_schema.STATUS] == "Pending Pay")
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: button_menu.Main_(
                                      color: Colors.orange,
                                      icon: Icons.hotel_outlined,
                                      text: r[r_schema.NUMBER],
                                      menuChildren: [
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.info_outline),
                                          child: Text("Summary"),
                                          onPressed: () {
                                            on_summary(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.change_circle_outlined),
                                          child: Text("Change Room"),
                                          onPressed: () {
                                            on_change_room(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.edit_outlined),
                                          child: Text("Update Stay"),
                                          onPressed: () {
                                            on_update_stay(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.edit_outlined),
                                          child: Text("Update Guest"),
                                          onPressed: () {
                                            on_guest_update(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                          child: Text("Cancel", style: TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            on_cancel(r);
                                          }, //
                                        ),
                                      ],
                                      onPressed: () => on_payment(r), //
                                    ),
                                  );

                                //
                                return SizedBox.shrink();
                              })(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // check-out
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  children: [
                    // header
                    Text(
                      "Check Out", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ), //

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Wrap(
                          children: [
                            for (var r in rooms)
                              (() {
                                if (r[r_schema.STATUS] == "Pending Leave")
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: button_menu.Main_(
                                      color: Colors.blue,
                                      icon: Icons.hotel_outlined,
                                      text: r[r_schema.NUMBER],
                                      menuChildren: [
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.info_outline),
                                          child: Text("Summary"),
                                          onPressed: () {
                                            on_summary(r);
                                          }, //
                                        ),
                                        // MenuItemButton(
                                        //   leadingIcon: Icon(Icons.change_circle_outlined),
                                        //   child: Text("Change Room"),
                                        //   onPressed: () {
                                        //     // TODO:
                                        //     snackbar.show(context: context, message: "Under Development.", color: Colors.blue);
                                        //   }, //
                                        // ),
                                        // MenuItemButton(
                                        //   leadingIcon: Icon(Icons.edit_outlined),
                                        //   child: Text("Update Staying"),
                                        //   onPressed: () {
                                        //     // TODO:
                                        //     snackbar.show(context: context, message: "Under Development.", color: Colors.blue);
                                        //   }, //
                                        // ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.add_outlined),
                                          child: Text("Revenue Payment"),
                                          onPressed: () {
                                            on_revenue_payment(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.change_circle_outlined),
                                          child: Text("Change Room"),
                                          onPressed: () {
                                            on_change_room(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.edit_outlined),
                                          child: Text("Update Stay"),
                                          onPressed: () {
                                            on_update_stay(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.edit_outlined),
                                          child: Text("Update Guest"),
                                          onPressed: () {
                                            on_guest_update(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                          child: Text("Cancel", style: TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            on_cancel(r);
                                          }, //
                                        ),
                                      ],
                                      onPressed: () => on_check_out(r), //
                                    ),
                                  );

                                //
                                return SizedBox.shrink();
                              })(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // clean
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Column(
                  children: [
                    // header
                    Text(
                      "Clean", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ), //

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Wrap(
                          children: [
                            for (var r in rooms)
                              (() {
                                if (r[r_schema.STATUS] == "Pending Clean")
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: button_menu.Main_(
                                      color: Colors.black,
                                      icon: Icons.hotel_outlined,
                                      text: r[r_schema.NUMBER],
                                      menuChildren: [
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.info_outline),
                                          child: Text("Summary"),
                                          onPressed: () {
                                            on_summary(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.change_circle_outlined),
                                          child: Text("Change Room"),
                                          onPressed: () {
                                            on_change_room(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.edit_outlined),
                                          child: Text("Update Stay"),
                                          onPressed: () {
                                            on_update_stay(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.edit_outlined),
                                          child: Text("Update Guest"),
                                          onPressed: () {
                                            on_guest_update(r);
                                          }, //
                                        ),
                                        MenuItemButton(
                                          leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                          child: Text("Cancel", style: TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            on_cancel(r);
                                          }, //
                                        ),
                                      ],
                                      onPressed: () => on_clean(r), //
                                    ),
                                  );

                                //
                                return SizedBox();
                              })(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void on_revenue_payment(r) async {
    try {
      //
      schema.clear();
      g_schema.clear();
      r_schema.clear();

      //
      var f = await dio.post(
        "/front_desk/read_id", //
        data: {"_id": r[r_schema.FRONT_DESK_ID]},
      );
      final fd = (f.data is List) ? f.data[0] : f.data;
      for (var e in schema.data.entries) e.value["value"] = fd[e.key];

      //

      var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => revenue_payment.Main_()));
      if (value == null) return;

      //
      init();
      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_guest_update(r) async {
    try {
      //
      schema.clear();
      g_schema.clear();
      r_schema.clear();

      //
      var f = await dio.post(
        "/front_desk/read_id", //
        data: {"_id": r[r_schema.FRONT_DESK_ID]},
      );
      for (var e in schema.data.entries) e.value["value"] = f.data[0][e.key];

      //

      var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => update_guest.Main_()));
      if (value == null) return;

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_summary(r) async {
    try {
      //
      schema.clear();
      g_schema.clear();
      r_schema.clear();

      for (var e in r.entries) print(e);

      //
      var f = await dio.post(
        "/front_desk/read_id", //
        data: {"_id": r[r_schema.FRONT_DESK_ID]},
      );

      final fd = (f.data is List) ? f.data[0] : f.data;
      for (var e in schema.data.entries) e.value["value"] = fd[e.key];

      //

      var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => summary.Main_()));
      if (value == null) return;

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_check_in(r) async {
    try {
      //
      schema.clear();
      g_schema.clear();
      r_schema.clear();

      //
      schema.data[schema.ROOM_ID]?["value"] = r[r_schema.ID];
      schema.data[schema.ROOM_NUMBER]?["value"] = r[r_schema.NUMBER];
      schema.data[schema.ROOM_KIND]?["value"] = r[r_schema.KIND];
      schema.data[schema.ROOM_USD_PER_3H]?["value"] = r[r_schema.USD_PER_3H];
      schema.data[schema.ROOM_USD_PER_DAY]?["value"] = r[r_schema.USD_PER_DAY];

      //

      final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => check_in.Main_()));
      if (v == null) return;

      //
      init();

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_payment(r) async {
    try {
      //
      schema.clear();
      g_schema.clear();
      r_schema.clear();

      //
      var f = await dio.post("/front_desk/read_id", data: {"_id": r[r_schema.FRONT_DESK_ID]});
      for (var e in schema.data.entries) e.value["value"] = f.data[0][e.key];

      //

      var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => payment.Main_()));
      if (value == null) return;

      //
      init();

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_check_out(r) async {
    //
    try {
      //
      schema.clear();
      g_schema.clear();
      r_schema.clear();

      //
      var f = await dio.post(
        "/front_desk/read_id", //
        data: {"_id": r[r_schema.FRONT_DESK_ID]},
      );
      final fd = (f.data is List) ? f.data[0] : f.data;
      for (var e in schema.data.entries) e.value["value"] = fd[e.key];

      //

      var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => check_out.Main_()));
      if (value == null) return;

      //
      init();

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_clean(r) async {
    try {
      //
      schema.clear();
      g_schema.clear();
      r_schema.clear();

      //
      var f = await dio.post(
        "/front_desk/read_id", //
        data: {"_id": r[r_schema.FRONT_DESK_ID]},
      );
      final fd = (f.data is List) ? f.data[0] : f.data;
      for (var e in schema.data.entries) e.value["value"] = fd[e.key];

      //

      var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => clean.Main_()));
      if (value == null) return;

      //
      init();

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_cancel(r) async {
    try {
      //
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Cancel Booking"),
            content: Text("Are you sure you want to cancel this booking?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No")),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Yes", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
      if (confirmed != true) return;

      //
      await dio.post(
        "/room/update", //
        data: {
          "_id": r[r_schema.ID], //
          r_schema.STATUS: "Available", //
        },
      );

      await dio.post(
        "/front_desk/delete", //
        data: {"_id": r[r_schema.FRONT_DESK_ID]},
      );

      //
      init();

      //

      snackbar.view(context: context, message: "Cancelled", color: Colors.green);

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  //
  void on_change_room(r) async {
    snackbar.view(context: context, message: "Under Development", color: Colors.blue);
  }

  //
  void on_update_stay(r) async {
    snackbar.view(context: context, message: "Under Development", color: Colors.blue);
  }

  //
  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: HEADER, //
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
