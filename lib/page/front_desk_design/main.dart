import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/global.dart";
import "package:speanmeas/environment.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/layout/layout.dart";
import "package:speanmeas/theme/theme_data.dart";

import "_setup.dart";
import "schema.g.dart" as schema;

import "form_1_check_in/step_1_guest.dart" as check_in;
import "form_2_payment/step_1_room_payment.dart" as payment;
// import "../front_desk/form_3_check_out/step_1_revenue_payment.dart" as check_out;
// import "../front_desk/form_4_clean/step_1_note.dart" as clean;

class _Main_State extends State<Main_> {
  //

  List<Map<String, dynamic>> data_rooms = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post("/room/data_read")
        .then((r) {
          data_rooms = List<Map<String, dynamic>>.from(r.data);
          data_rooms.sort((a, b) => "${a[schema.ROOM_NUMBER]}".compareTo("${b[schema.ROOM_NUMBER]}"));
          setState(() {});
        })
        .catchError((e) {
          print(e.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    // bool is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;

    return Scaffold(
      body: Row(
        children: [
          // check in
          Expanded(
            child: Column(
              children: [
                //
                Row(
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

                Expanded(
                  child: ListView(
                    padding: .fromLTRB(4, 0, 16, 0),
                    children: [
                      //
                      for (var r in data_rooms.where((r) => r[schema.ROOM_STATUS] == "Available"))
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.hotel_outlined, color: Colors.green), //
                              SizedBox(width: 4), //
                              Text(
                                "${r[schema.ROOM_NUMBER]}",
                                style: TextStyle(
                                  fontSize: 14, //
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ), //

                              Spacer(),

                              PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.more_vert, color: Colors.blue),
                                itemBuilder: (context) => [
                                  PopupMenuItem(value: "view", child: Text("View")), //
                                  PopupMenuItem(value: "broke", child: Text("Set to Broke")),
                                ],
                                onSelected: (value) {
                                  print(value);
                                },
                              ),
                            ],
                          ),
                          onTap: () => on_check_in(r),
                        ),
                    ],
                  ), //
                ),
              ],
            ),
          ),

          // payment
          Expanded(
            child: Column(
              children: [
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.orange), //

                    SizedBox(width: 4), //
                    Text(
                      "Payment", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                    ), //
                  ],
                ),

                Expanded(
                  child: ListView(
                    padding: .fromLTRB(4, 0, 16, 0),
                    children: [
                      //
                      for (var r in data_rooms.where((r) => r[schema.ROOM_STATUS] == "Pending Pay"))
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.hotel_outlined, color: Colors.orange), //

                              SizedBox(width: 4), //

                              Text(
                                "${r[schema.ROOM_NUMBER]}", //
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange),
                              ), //

                              Spacer(),
                              // options
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: Colors.blue),
                                itemBuilder: (context) => [
                                  PopupMenuItem(value: "view", child: Text("View")), //
                                  PopupMenuItem(value: "change_room", child: Text("Change Room")),
                                  PopupMenuItem(value: "update_guest", child: Text("Update Guest")),
                                  PopupMenuItem(value: "change_room", child: Text("Update Staying")),
                                  PopupMenuItem(value: "update_guest", child: Text("Update Revenue")),
                                ],
                                onSelected: (value) {},
                              ),
                            ],
                          ),
                          onTap: () => on_payment(r),
                        ),
                    ],
                  ), //
                ),
              ],
            ),
          ),

          // check out
          Expanded(
            child: Column(
              children: [
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red), //

                    SizedBox(width: 4), //
                    Text(
                      "Check Out", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                    ), //
                  ],
                ),

                Expanded(
                  child: ListView(
                    padding: .fromLTRB(4, 0, 16, 0),
                    children: [
                      //
                      for (var r in data_rooms.where((r) => r[schema.ROOM_STATUS] == "Pending Leave"))
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.hotel_outlined, color: Colors.red), //

                              SizedBox(width: 4), //

                              Text(
                                "${r[schema.ROOM_NUMBER]}",
                                style: TextStyle(
                                  fontSize: 14, //
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ), //

                              Spacer(),
                              // options
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: Colors.blue),
                                itemBuilder: (context) => [
                                  PopupMenuItem(value: "view", child: Text("View")), //
                                  PopupMenuItem(value: "change_room", child: Text("Change Room")),
                                  PopupMenuItem(value: "update_guest", child: Text("Update Guest")),
                                  PopupMenuItem(value: "change_room", child: Text("Update Staying")),
                                  PopupMenuItem(value: "update_guest", child: Text("Update Guest")),
                                  PopupMenuItem(value: "update_guest", child: Text("Update Revenue")),
                                ],
                                onSelected: (value) {},
                              ),
                            ],
                          ),
                          onTap: () => on_check_out(r),
                        ),
                    ],
                  ), //
                ),
              ],
            ),
          ),

          // clean
          Expanded(
            child: Column(
              children: [
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cleaning_services, color: Colors.grey), //

                    SizedBox(width: 4), //

                    Text(
                      "Clean", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                    ), //
                  ],
                ),

                Expanded(
                  child: ListView(
                    padding: .fromLTRB(4, 0, 16, 0),
                    children: [
                      //
                      for (var r in data_rooms.where((r) => r[schema.ROOM_STATUS] == "Pending Clean"))
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.hotel_outlined, color: Colors.grey), //

                              SizedBox(width: 4), //

                              Text(
                                "${r[schema.ROOM_NUMBER]}",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                              ), //

                              Spacer(),

                              // options
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: Colors.blue),
                                itemBuilder: (context) => [PopupMenuItem(value: "view", child: Text("View"))],
                                onSelected: (value) {},
                              ),
                            ],
                          ),
                          onTap: () => on_clean(r),
                        ),
                    ],
                  ), //
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void on_check_in(r) async {
    //
    schema.clear();

    schema.data[schema.ROOM_ID]?["value"] = r["_id"];

    for (var e in r.entries) {
      if (e.key == "_id") continue;
      schema.data[e.key]?["value"] = e.value;
    }

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => check_in.Main_()),
    ).then((v) {
      if (v == true) init();
    });

    //
  }

  void on_payment(r) async {
    //
    schema.clear();

    var front_desk_id = r["front_desk_id"];

    await dio
        .post("/front_desk/data_read", data: FormData.fromMap({"_id": front_desk_id}))
        .then((r) {
          // print(r.data);
          // for (var e in r.data[0].entries) print(e);

          for (var e in r.data[0].entries) {
            // if (e.key == "_id") continue;
            schema.data[e.key]?["value"] = e.value;
          }

          // for (var e in schema.data.entries) print(e);

          // for (var e in r.data.entries) {
          //   if (e.key == "_id") continue;
          //   schema.data[e.key]?["value"] = e.value;
          // }

          Navigator.push(
            context, //
            MaterialPageRoute(builder: (context) => payment.Main_()),
          ).then((v) {
            if (v == true) init();
          });
        })
        .catchError((e) {
          print(e.toString());
        });

    // print(r);

    // schema.data[schema.ROOM_ID]?["value"] = r["_id"];

    // for (var e in r.entries) {
    //   if (e.key == "_id") continue;
    //   schema.data[e.key]?["value"] = e.value;
    // }

    // Navigator.push(
    //   context, //
    //   MaterialPageRoute(builder: (context) => payment.Main_()),
    // ).then((v) {
    //   if (v == true) init();
    // });

    //
  }

  void on_check_out(r) async {
    //
  }

  void on_clean(r) async {
    //
  }
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
