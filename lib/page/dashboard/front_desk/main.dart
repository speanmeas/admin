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
import "schema.r.dart" as schema_r;

import "package:speanmeas/page/room/schema.r.dart" as r_schema_r;
import "package:speanmeas/page/guest/schema.r.dart" as g_schema_r;

import "form/check_in/1_guest.dart" as check_in;
import "form/payment/step_1_room_payment.dart" as payment;
import "form/check_out/step_1_revenue_payment.dart" as check_out;
import "form/clean/step_1_note.dart" as clean;

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
      final r = await dio.post(
        "/room/read_all", //
        data: FormData.fromMap({
          "key": r_schema_r.NUMBER, //
          "order": 1, //
          "limit": 1000,
        }),
      );

      //
      rooms = List<Map<String, dynamic>>.from(r.data);

      //
      setState(() {});
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final is_mobile = MediaQuery.of(context).size.width < 600;

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
                                if (r[r_schema_r.STATUS] == "Available")
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: button_icon_menu.Main_(
                                      color: Colors.green,
                                      icon: Icons.hotel_outlined,
                                      text: r[r_schema_r.NUMBER],
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

              //
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
                                if (r[r_schema_r.STATUS] == "Pending Pay")
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: button_icon_menu.Main_(
                                      color: Colors.orange,
                                      icon: Icons.hotel_outlined,
                                      text: r[r_schema_r.NUMBER],
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

              //
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
                                if (r[r_schema_r.STATUS] == "Pending Leave")
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: button_icon_menu.Main_(
                                      color: Colors.blue,
                                      icon: Icons.hotel_outlined,
                                      text: r[r_schema_r.NUMBER],
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

              //
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
                                if (r[r_schema_r.STATUS] == "Pending Clean")
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: button_icon_menu.Main_(
                                      color: Colors.black,
                                      icon: Icons.hotel_outlined,
                                      text: r[r_schema_r.NUMBER],
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
                                      onPressed: () => on_clean(r), //
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
            ],
          );
        },
      ),
    );
  }

  void on_check_in(r) async {
    try {
      //
      schema_w.clear();
      g_schema_r.clear();
      r_schema_r.clear();

      schema_w.data[schema_w.ROOM_LINK]?["value"] = r["_id"];

      for (var e in r_schema_r.data.entries) e.value["value"] = r[e.key];

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

      // print(r[r_schema_r.FRONT_DESK_ID]);

      var res = await dio.post(
        "/front_desk/read_id",
        data: FormData.fromMap({
          "_id": r[r_schema_r.FRONT_DESK_ID], //
        }),
      );

      print(res);

      // for (var e in response.data[0].entries) schema_r.data[e.key]?["value"] = e.value;

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
