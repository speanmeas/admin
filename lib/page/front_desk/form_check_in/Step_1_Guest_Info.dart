import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/front_desk/form_check_in/__Model__.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_2_Stay_Detail.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_3_Payment.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(const Guest_Info());
}

class Guest_Info extends StatelessWidget {
  const Guest_Info({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Guest_Info_(),
    );
  }
}

class Guest_Info_ extends StatefulWidget {
  const Guest_Info_({super.key});

  @override
  State<Guest_Info_> createState() => _Guest_Info_State();
}

class _Guest_Info_State extends State<Guest_Info_> {
  //

  ScrollController? number_of_guests_scroll_controller = ScrollController();

  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_gender = TextEditingController(text: "Male");
  TextEditingController controller_phone_number = TextEditingController();
  TextEditingController controller_number_of_guests = TextEditingController(text: "1");

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
                padding: EdgeInsets.fromLTRB(8, 12, 8, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Room Number: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      Model_Check_In.room_number ?? "",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),

              //
              if (kDebugMode && false)
                Container(
                  width: 600,
                  padding: EdgeInsets.fromLTRB(4, 8, 8, 0),
                  alignment: Alignment.center,
                  child: Text(
                    "Photo of ID Card or Passport: ", //
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

              // photo of id card or passport
              if (kDebugMode && false)
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

              // input name general
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: controller_name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "Name:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              // name in khmer input
              if (kDebugMode && false)
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

              // nationality input
              if (kDebugMode && false)
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

              // input phone number
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: controller_phone_number,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), //
                    labelText: "Phone Number",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),

              // input gender
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    // gender
                    Expanded(
                      child: TextField(
                        controller: controller_gender,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(), //
                          labelText: "Gender:",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),

                    // male
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.male_outlined), //
                        label: Text("Male"), //
                        onPressed: () {
                          controller_gender.text = "Male";
                          setState(() {});
                        }, //
                      ),
                    ),

                    // female
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.female_outlined), //
                        label: Text("Female"), //
                        onPressed: () {
                          controller_gender.text = "Female";
                          setState(() {});
                        }, //
                      ),
                    ),
                  ],
                ),
              ),

              // input number of guests
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  children: [
                    TextField(
                      controller: controller_number_of_guests,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Number of Guests:",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),

                    SizedBox(height: 4),

                    //
                    Row(
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
                                height: 50,
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    ...List.generate(10, (i) => i + 1).map((e) {
                                      return Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            controller_number_of_guests.text = e.toString();
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.person_outline),
                                          label: Text("$e"),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //
              Container(
                padding: EdgeInsets.all(8),
                child: OutlinedButton.icon(
                  label: Text("Next"), //
                  icon: Icon(Icons.arrow_forward, size: 24),
                  onPressed: on_next,
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

  void on_next() {
    //
    Model_Check_In.guest_name = controller_name.text;
    Model_Check_In.guest_gender = controller_gender.text;
    Model_Check_In.guest_phone_number = controller_phone_number.text;
    Model_Check_In.number_of_guests = controller_number_of_guests.text;

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Stay_Detail_()),
    );
  }
}
