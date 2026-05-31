import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/check_in_out_clean/Form_Check_In_2_Duration.dart';
import 'package:speanmeas/page/check_in_out_clean/Form_Check_In_1_Guest_Info.dart';
import 'package:speanmeas/page/check_in_out_clean/Form_Check_Out.dart';
import 'package:speanmeas/page/check_in_out_clean/Form_Clean.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Check_In_Out_Clean(),
    ),
  );
}

class Check_In_Out_Clean extends StatelessWidget {
  const Check_In_Out_Clean({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Check_In_Out_Clean_(),
    );
  }
}

class Check_In_Out_Clean_ extends StatefulWidget {
  const Check_In_Out_Clean_({super.key});

  @override
  State<Check_In_Out_Clean_> createState() => _Check_In_Out_Clean_State();
}

class _Check_In_Out_Clean_State extends State<Check_In_Out_Clean_> {
  //

  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post("/room/read_all")
        .then((r) {
          // print(r.data);
          rooms = List<Map<String, dynamic>>.from(r.data);
          // print(rooms);
          setState(() {});
        })
        .catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ...rooms.map((room) {
                return Container(
                  width: 600,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black26),
                      bottom: BorderSide(color: Colors.black26),
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Room ${room['Name']} (${room['Type']})", //
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 16),
                            Text(
                              "${room['Status']}",
                              style: TextStyle(
                                color: room['Status'] == "Available"
                                    ? Colors.green
                                    : room['Status'] == "Dirty"
                                    ? Colors.orange
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Spacer(),

                      Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text("AC: "), //
                                Text("${room['AC_USD']}"),
                                Text("\$"), //
                              ],
                            ),
                            Row(
                              children: [
                                Text("Fan: "), //
                                Text("${room['Fan_USD']}"),
                                Text("\$"), //
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 16),

                      OutlinedButton.icon(
                        onPressed: room['Status'] == "Available"
                            ? () {
                                print("${room['_id']['\$oid']}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Form_Check_In_Guest_Info_(
                                      id: room['_id']['\$oid'], //
                                    ),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.login),
                        label: const Text("Check In"), //
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: room['Status'] == "Occupied"
                            ? () {
                                print("${room['_id']['\$oid']}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Form_Check_Out_(
                                      id: room['_id']['\$oid'], //
                                    ),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.logout),
                        label: const Text("Check Out"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: room['Status'] == "Dirty"
                            ? () {
                                print("${room['_id']['\$oid']}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Form_Check_Clean_(
                                      id: room['_id']['\$oid'], //
                                    ),
                                  ),
                                );
                              }
                            : null, //
                        icon: const Icon(Icons.cleaning_services),
                        label: const Text("Clean"),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
