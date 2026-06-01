import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/check_in_out_clean/form_check_in/Step_2_Stay_Detail.dart';
import 'package:speanmeas/page/check_in_out_clean/form_check_in/Step_3_Payment.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Guest_Info(),
    ),
  );
}

class Guest_Info extends StatelessWidget {
  const Guest_Info({super.key});

  final id = "69f984897186bcf74f8a5dde"; //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Guest_Info_(id: id),
    );
  }
}

class Guest_Info_ extends StatefulWidget {
  const Guest_Info_({super.key, required this.id});

  final String id;

  @override
  State<Guest_Info_> createState() => _Guest_Info_State();
}

class _Guest_Info_State extends State<Guest_Info_> {
  //

  late String? room_id = widget.id;

  int? number_of_guests;

  ScrollController? number_of_guests_scroll_controller = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check In - Guest Info.", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            tooltip: "Close",
          ),
          SizedBox(width: 4),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(4, 8, 8, 0),
                alignment: Alignment.center,
                child: Text(
                  "Photo of ID Card or Passport: ", //
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              // ID Card or Passport
              Container(
                width: 400,
                height: 200,
                margin: EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.badge_outlined, //
                        size: 56,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),

              // Name input
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "Name (EN):",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              // Name input
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "Name (KH):",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              // Nationality
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: TextEditingController(text: "Cambodia"), //
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "Nationality:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "Phone Number",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(4, 8, 8, 0),
                child: Row(
                  children: [
                    Text(
                      "Number of Guests: ", //
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(4, 4, 8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Scrollbar(
                        controller: number_of_guests_scroll_controller,
                        thumbVisibility: true,
                        thickness: 12, // scrollbar width
                        radius: const Radius.circular(0),
                        child: SingleChildScrollView(
                          controller: number_of_guests_scroll_controller,
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.only(top: 4),
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                ...List.generate(10, (i) => i + 1).map((e) {
                                  return InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (number_of_guests == e) Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                                          if (number_of_guests != e) Icon(Icons.radio_button_unchecked, size: 24), //
                                          SizedBox(width: 2),
                                          if (e == 1) //
                                            Text("1 Person", style: TextStyle(fontSize: 16))
                                          else //
                                            Text("$e Persons", style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      number_of_guests = e;
                                      setState(() {});
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 80,
                      child: TextField(
                        controller: TextEditingController(text: number_of_guests?.toString() ?? ""),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Persons",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) {
                          number_of_guests = int.tryParse(value);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //
              Container(
                padding: EdgeInsets.all(8),
                child: OutlinedButton.icon(
                  label: Text("Next"), //
                  icon: Icon(Icons.play_arrow_outlined, size: 32),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Stay_Detail_(
                          id: widget.id, //
                        ),
                      ),
                    );
                  }, //
                ),
              ),

              //
              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }
}
