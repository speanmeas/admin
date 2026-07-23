import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__variable__.dart";
import "package:speanmeas/__config__.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/layout/layout.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "__config__.dart";
import "schema.w.dart" as schema_w;
import "package:speanmeas/page/room/schema.w.dart" as room_schema_w;

import "form_1_check_in/step_1_guest.dart" as check_in;
// import "form_2_payment/step_1_room_payment.dart" as payment;
// import "form_3_check_out/step_1_revenue_payment.dart" as check_out;
// import "form_4_clean/step_1_note.dart" as clean;

import "widget/button_icon_menu.dart" as button_icon_menu;

class _Main_State extends State<Main_> {
  //

  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      //
      final r = await dio.post("/room/read_all");

      //
      rooms = List<Map<String, dynamic>>.from(r.data);
      // print(rooms);

      //
      rooms.sort((a, b) => "${a[room_schema_w.NUMBER]}".compareTo("${b[room_schema_w.NUMBER]}"));

      setState(() {});

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // check in
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black26)),
              ), //
              child: Column(
                children: [
                  // header
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login_outlined, color: Colors.green), //
                        SizedBox(width: 4), //
                        Text(
                          "Check In", //
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                        ), //
                      ],
                    ),
                  ),

                  // body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          for (var r in rooms)
                            (() {
                              if (r[room_schema_w.STATUS] == "Available")
                                return button_icon_menu.Main_(
                                  color: Colors.green,
                                  icon: Icons.hotel_outlined,
                                  text: r[room_schema_w.NUMBER],
                                  // text: "Lorem Ipsum Dolor Sit Amet",
                                  menuChildren: [
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.info_outline),
                                      child: Text("Status"),
                                      onPressed: () {}, //
                                    ),
                                    Divider(height: 1),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Update Status"),
                                      onPressed: () {}, //
                                    ),
                                  ],
                                  onPressed: () => on_check_in(r), //
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
          ),

          // payment
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black26)),
              ), //
              child: Column(
                children: [
                  // header
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment_outlined, color: Colors.orange), //
                        SizedBox(width: 4), //
                        Text(
                          "Payment", //
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                        ), //
                      ],
                    ),
                  ),

                  // body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          for (var r in rooms)
                            (() {
                              if (r[room_schema_w.STATUS] == "Pending Pay")
                                return button_icon_menu.Main_(
                                  color: Colors.orange,
                                  icon: Icons.hotel_outlined,
                                  text: r[room_schema_w.NUMBER],
                                  menuChildren: [
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.info_outline),
                                      child: Text("Status"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.change_circle_outlined),
                                      child: Text("Change Room"),
                                      onPressed: () {}, //
                                    ),
                                    Divider(height: 1),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Update Guest"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                      child: Text("Cancel", style: TextStyle(color: Colors.red)),
                                      onPressed: () {}, //
                                    ),
                                  ],
                                  onPressed: () => on_check_in(r), //
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
          ),

          // check out
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black26)),
              ), //
              child: Column(
                children: [
                  // header
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_outlined, color: Colors.blue), //
                        SizedBox(width: 4), //
                        Text(
                          "Check Out", //
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                        ), //
                      ],
                    ),
                  ),

                  // body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          for (var r in rooms)
                            (() {
                              if (r[room_schema_w.STATUS] == "Pending Leave")
                                return button_icon_menu.Main_(
                                  color: Colors.blue,
                                  icon: Icons.hotel_outlined,
                                  text: r[room_schema_w.NUMBER],
                                  menuChildren: [
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.info_outline),
                                      child: Text("Status"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.change_circle_outlined),
                                      child: Text("Change Room"),
                                      onPressed: () {}, //
                                    ),
                                    Divider(height: 1),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Update Guest"),
                                      onPressed: () {}, //
                                    ),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Update Payment"),
                                      onPressed: () {}, //
                                    ),
                                    Divider(height: 1),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.cancel_outlined, color: Colors.red),
                                      child: Text("Cancel", style: TextStyle(color: Colors.red)),
                                      onPressed: () {}, //
                                    ),
                                  ],
                                  onPressed: () => on_check_in(r), //
                                );

                              return SizedBox();
                            })(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // clean
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.black26)),
              ), //
              child: Column(
                children: [
                  // header
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cleaning_services_outlined, color: Colors.black), //
                        SizedBox(width: 4), //
                        Text(
                          "Clean", //
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ), //
                      ],
                    ),
                  ),

                  // body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          for (var r in rooms)
                            (() {
                              if (r[room_schema_w.STATUS] == "Pending Clean")
                                return button_icon_menu.Main_(
                                  color: Colors.black,
                                  icon: Icons.hotel_outlined,
                                  text: r[room_schema_w.NUMBER],
                                  menuChildren: [
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.info_outline),
                                      child: Text("Status"),
                                      onPressed: () {}, //
                                    ),
                                    Divider(height: 1),
                                    MenuItemButton(
                                      leadingIcon: Icon(Icons.edit_outlined),
                                      child: Text("Update Guest"),
                                      onPressed: () {}, //
                                    ),
                                  ],
                                  onPressed: () => on_check_in(r), //
                                );

                              return SizedBox();
                            })(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void on_check_in(r) async {
    try {
      // print(r);
      //
      schema_w.clear();

      schema_w.data[schema_w.ROOM_LINK]?["value"] = r["_id"];

      // for (var e in r.entries) {
      //   if (e.key == "_id") continue;
      //   schema_w.data[e.key]?["value"] = e.value;
      // }

      final v = await Navigator.push(context, MaterialPageRoute(builder: (context) => check_in.Main_()));

      if (v == null) return;

      init();

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }

    //
  }

  void on_payment(r) async {
    try {
      //
      // schema.clear();

      // var response = await dio.post("/front_desk/data_read", data: FormData.fromMap({"key": schema.ID, schema.ID: r[room_schema.FRONT_DESK_ID]}));

      // for (var e in response.data[0].entries) schema.data[e.key]?["value"] = e.value;

      // var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => payment.Main_()));

      // if (value == null) return;

      // init();

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_check_out(r) async {
    //
    try {
      //

      // schema.clear();

      // var response = await dio.post("/front_desk/data_read", data: FormData.fromMap({"key": schema.ID, schema.ID: r[room_schema.FRONT_DESK_ID]}));

      // for (var e in response.data[0].entries) schema.data[e.key]?["value"] = e.value;

      // var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => check_out.Main_()));

      // if (value == null) return;

      // init();

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_clean(r) async {
    try {
      //
      // schema.clear();

      // var response = await dio.post("/front_desk/data_read", data: FormData.fromMap({"key": schema.ID, schema.ID: r[room_schema.FRONT_DESK_ID]}));

      // for (var e in response.data[0].entries) schema.data[e.key]?["value"] = e.value;

      // var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => clean.Main_()));

      // if (value == null) return;

      // init();

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
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
      title: HEADER, //
      theme: Theme_Data(), //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
