import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final controller_name = TextEditingController();
  final gender_options = const ["Male", "Female", "Other"];
  final controller_phone_number = TextEditingController();
  final controller_nationality = TextEditingController();
  final number_of_guests_options = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final controller_number_of_guests = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller_name.text = Model.guest_name;
    controller_phone_number.text = Model.guest_phone_number;
    controller_nationality.text = Model.guest_nationality;
  }

  // late final scroll_number_of_guest = ScrollController();
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
              // room number
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Room Number: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      Model.room_number ?? "",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),

              // guest name
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_name,
                  decoration: InputDecoration(
                    labelText: "Guest Name:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    Model.guest_name = v;
                    setState(() {});
                  },
                ),
              ),

              // guest gender
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: DropdownButtonFormField<String>(
                  initialValue: gender_options.first,
                  decoration: InputDecoration(
                    labelText: "Guest Gender:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  items: gender_options.map((i) {
                    return DropdownMenuItem<String>(value: i, child: Text(i));
                  }).toList(),
                  onChanged: (v) {
                    Model.guest_gender = v ?? "";
                    setState(() {});
                  },
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

              // input phone number
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_phone_number,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9+]'))],
                  decoration: InputDecoration(
                    labelText: "Phone Number:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    Model.guest_phone_number = v;
                    setState(() {});
                  },
                ),
              ),

              // Guest Nationality
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_nationality,
                  decoration: InputDecoration(
                    labelText: "Guest Nationality:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    Model.guest_nationality = v;
                    setState(() {});
                  },
                ),
              ),

              // number of guests
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: DropdownButtonFormField<int>(
                  initialValue: number_of_guests_options.first,
                  decoration: InputDecoration(
                    labelText: "Number of Guests:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  items: number_of_guests_options.map((i) {
                    return DropdownMenuItem<int>(value: i, child: Text(i.toString()));
                  }).toList(),
                  onChanged: (v) {
                    Model.number_of_guests = v ?? 0;
                    setState(() {});
                  },
                ),
              ),

              //
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Stay_Detail_()),
    );
  }
}
