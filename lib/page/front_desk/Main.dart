import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/front_desk/Main_Widget.dart';
import 'package:speanmeas/page/front_desk/form_check_in/__Model__.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_2_Stay_Detail.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_1_Guest_Info.dart';
import 'package:speanmeas/page/front_desk/form_check_out/Form_Check_Out.dart';
import 'package:speanmeas/page/front_desk/form_check_out/__Model__.dart';
import 'package:speanmeas/page/front_desk/form_clean/Form_Clean.dart';
import 'package:speanmeas/page/front_desk/form_clean/__Model__.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post(
          "/room/data_read", //
          data: FormData.fromMap({
            "key": "room_number", //
            "order": "1",
          }),
        )
        .then((r) {
          // print(r.data);
          data = List<Map<String, dynamic>>.from(r.data);

          // print(data);

          setState(() {});
        })
        .catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //
              ...data.map((room) {
                return Container(
                  width: 600,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey), //
                    ),
                  ),

                  child: Row(
                    children: [
                      // room status
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Text(
                              "Room ${room['room_number']} (${room['room_type']})", //
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            //
                            SizedBox(width: 16),

                            //
                            if (room['status'] == "Available")
                              Text(
                                "Available",
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),

                            if (room['status'] == "Dirty")
                              Text(
                                "Dirty",
                                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                              ),
                            if (room['status'] == "Occupied")
                              Text(
                                "Occupied - A/R ${room['ar'] ?? 0} USD ", //
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ),

                      Spacer(),

                      // three-dot action menu
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          tooltip: "Actions",
                          itemBuilder: (context) => [
                            if (room['status'] == "Available")
                              PopupMenuItem(
                                value: "check_in",
                                child: Row(
                                  children: [
                                    Icon(Icons.login), //
                                    SizedBox(width: 8), Text("Check In"),
                                  ],
                                ),
                              ),
                            if (room['status'] == "Occupied")
                              PopupMenuItem(
                                value: "check_out",
                                child: Row(
                                  children: [
                                    Icon(Icons.logout), //
                                    SizedBox(width: 8), Text("Check Out"),
                                  ],
                                ),
                              ),
                            if (room['status'] == "Dirty")
                              PopupMenuItem(
                                value: "clean",
                                child: Row(
                                  children: [
                                    Icon(Icons.cleaning_services), //
                                    SizedBox(width: 8), Text("Clean"),
                                  ],
                                ),
                              ),

                            PopupMenuItem(
                              value: "payment",
                              child: Row(
                                children: [
                                  Icon(Icons.payment), //
                                  SizedBox(width: 8), Text("Payment"),
                                ],
                              ),
                            ),

                            PopupMenuItem(
                              value: "update",
                              child: Row(
                                children: [
                                  Icon(Icons.update), //
                                  SizedBox(width: 8), Text("Update"),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == "check_in") {
                              on_check_in(room);
                            }

                            if (value == "check_out") {
                              on_check_out(room);
                            }

                            if (value == "clean") {
                              on_check_clean(room);
                            }

                            if (value == "payment") {
                              print("Update payment for room ${room['room_number']}");
                            }

                            if (value == "update") {
                              print("Update info for room ${room['room_number']}");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  void on_check_in(dynamic room) {
    //
    // print("${room['id']}");

    Model.room_id = room['id'].toString();
    Model.room_number = room['room_number'].toString();
    Model.room_type = room['room_type'].toString();

    Model.price_per_day = double.parse(room['price_per_day'].toString());
    Model.price_per_3_hour = double.parse(room['price_per_3_hour'].toString());

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Guest_Info_()),
    ).then((v) {
      if (v == true) {
        init();
      }
      Model.clear();
    });
  }

  void on_check_out(dynamic room) {
    //
    // print("${room['id']}");

    Model_Check_Out.room_id = room['id'].toString();
    Model_Check_Out.room_number = room['room_number'].toString();
    Model_Check_Out.account_receivable = double.parse(room['ar']?.toString() ?? '0');

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Form_Check_Out_()),
    ).then((v) {
      if (v == true) {
        init();
      }
      Model.clear();
    });
  }

  void on_check_clean(dynamic room) {
    //
    print("${room['id']}");

    Model_Clean.room_id = room['id'].toString();
    Model_Clean.room_number = room['room_number'].toString();

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Form_Check_Clean_()),
    ).then((v) {
      if (v == true) {
        init();
      }
    });
  }
}
