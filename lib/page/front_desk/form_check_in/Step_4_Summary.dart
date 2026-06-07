import 'dart:convert';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Invoice.dart';
import 'package:speanmeas/page/front_desk/form_check_in/__Model__.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Summary(),
    ),
  );
}

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Summary_(),
    );
  }
}

class Summary_ extends StatefulWidget {
  const Summary_({super.key});

  @override
  State<Summary_> createState() => _Summary_State();
}

class _Summary_State extends State<Summary_> {
  //

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
          "Check In - Summary", //
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
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Room Number: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.room_number}"), //
                  ],
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Room Type: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.room_type}"), //
                  ],
                ),
              ),

              // guest name
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Guest Name: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.guest_name}"), //
                  ],
                ),
              ),

              // guest gender
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Guest Gender: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.guest_gender}"), //
                  ],
                ),
              ),

              // guest phone number
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Guest Phone Number: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.guest_phone_number}"), //
                  ],
                ),
              ),

              // number of guests
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Number of Guests: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.number_of_guests}"), //
                  ],
                ),
              ),

              // duration
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Duration: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.stay_duration_day} days and ${Model_Check_In.stay_duration_hour} hours"), //
                  ],
                ),
              ),

              // price per day
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Price / Day: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.price_per_day ?? 0} USD"), //
                  ],
                ),
              ),

              // price per 3 hour
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Price / 3 Hours: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.price_per_3_hour ?? 0} USD"), //
                  ],
                ),
              ),

              // price total
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Price Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.price_total_usd ?? 0} USD or ${Model_Check_In.price_total_khr ?? 0} KHR"), //
                  ],
                ),
              ),

              // paid bank usd
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Paid Bank USD: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.paid_bank_usd ?? 0} USD"), //
                  ],
                ),
              ),

              // paid bank khr
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Paid Bank KHR: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.paid_bank_khr ?? 0} KHR"), //
                  ],
                ),
              ),

              // paid cash usd
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Paid Cash USD: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.paid_cash_usd ?? 0} USD"), //
                  ],
                ),
              ),

              // paid cash khr
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Paid Cash KHR: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.paid_cash_khr ?? 0} KHR"), //
                  ],
                ),
              ),

              // return total
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Return Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.return_usd ?? 0} USD or  ${Model_Check_In.return_khr ?? 0} KHR"), //
                  ],
                ),
              ),

              // remaining total
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("Remaining Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), //
                    Text("${Model_Check_In.remain_usd ?? 0} USD or  ${Model_Check_In.remain_khr ?? 0} KHR"), //
                  ],
                ),
              ),

              //
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(width: 60),

                    Spacer(),

                    OutlinedButton.icon(
                      label: Text("Check In"),
                      icon: Icon(Icons.login_outlined),
                      onPressed: () async {
                        // todo: save data to backend

                        await dio
                            .post(
                              "/check_in/data_create",
                              data: FormData.fromMap({
                                "room_number": Model_Check_In.room_number, //
                                "room_type": Model_Check_In.room_type,
                                "price_per_day": Model_Check_In.price_per_day,
                                "price_per_3_hour": Model_Check_In.price_per_3_hour,
                                "guest_name": Model_Check_In.guest_name,
                                "guest_phone_number": Model_Check_In.guest_phone_number,
                                "guest_gender": Model_Check_In.guest_gender,
                                "number_of_guests": Model_Check_In.number_of_guests,
                                "stay_duration_day": Model_Check_In.stay_duration_day,
                                "stay_duration_hour": Model_Check_In.stay_duration_hour,
                                "price_total_usd": Model_Check_In.price_total_usd,
                                "paid_bank_usd": Model_Check_In.paid_bank_usd,
                                "paid_bank_khr": Model_Check_In.paid_bank_khr,
                                "paid_cash_usd": Model_Check_In.paid_cash_usd,
                                "paid_cash_khr": Model_Check_In.paid_cash_khr,
                                "return_usd": Model_Check_In.return_usd,
                                "remain_usd": Model_Check_In.remain_usd,
                              }),
                            )
                            .then((r) {
                              print(r.data);
                            })
                            .catchError((e) {
                              print(e);
                            });

                        //

                        await dio
                            .post(
                              "/room/data_update",
                              data: FormData.fromMap({
                                "id": Model_Check_In.room_id, //
                                "account_receivable": double.parse(Model_Check_In.remain_usd.toString()), //
                                "status": "Occupied", //
                              }),
                            )
                            .then((r) {
                              print(r.data);
                              Navigator.pop(context); // close step 4
                              Navigator.pop(context); // close step 3
                              Navigator.pop(context); // close step 2
                              Navigator.pop(context, true); // close step 1
                            })
                            .catchError((e) {
                              print(e);
                            });
                      }, //
                    ),

                    Spacer(),

                    OutlinedButton.icon(
                      label: Text("Print"),
                      icon: Icon(Icons.print_outlined),
                      onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Receipt_()));
                      }, //
                    ),
                  ],
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
