import 'dart:convert';

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
  }

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
              // room number + room type
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),

                child: Row(
                  children: [
                    Text("Room Number: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.room_number, style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Room Type: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.room_type, style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),

              // price per day + price per 3 hour
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Room Price: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${Model.price_per_day.toString()}\$", style: TextStyle(color: Colors.blue)),
                    Text(" / Day , ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${Model.price_per_3_hour.toString()}\$", style: TextStyle(color: Colors.blue)),
                    Text(" / 3 Hours", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // guest name + guest gender
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Guest Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.guest_name, style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),

              // guest name + guest gender
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Guest Gender: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.guest_gender, style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),

              // guest phone number
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),

                child: Row(
                  children: [
                    Text("Guest Phone Number: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.guest_phone_number, style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),

              // guest nationality
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Guest Nationality: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.guest_nationality, style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),

              // number of guests
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Number of Guests: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.number_of_guests.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" Persons", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // stay duration day + stay duration hour
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Stay Duration: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.stay_duration_day.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" Days ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.stay_duration_hour.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" Hours", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // total price
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Total Price: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.price_total_usd.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" USD = ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.price_total_khr.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" KHR ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // paid bank usd + paid bank khr
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Paid Bank: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.paid_bank_usd.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" USD + ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.paid_bank_khr.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" KHR ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // paid cash usd + paid cash khr
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Paid Cash: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.paid_cash_usd.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" USD + ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.paid_cash_khr.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" KHR ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // return usd + return khr
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Return: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.return_usd.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" USD + ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.return_khr.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" KHR ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // balance usd + balance khr
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Text("Balance: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.balance_usd.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" USD + ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Model.balance_khr.toString(), style: TextStyle(color: Colors.blue)),
                    Text(" KHR ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // button check in + print
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 80),

                    OutlinedButton.icon(
                      label: Text("Check In"), //
                      icon: Icon(Icons.login_outlined),
                      onPressed: on_check_in,
                    ),

                    OutlinedButton.icon(
                      label: Text("Print"),
                      icon: Icon(Icons.print_outlined),
                      onPressed: on_print, //
                    ),
                  ],
                ),
              ),

              // add bottom space
              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  void on_print() {
    //
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Invoice_()),
    );
  }

  void on_check_in() async {
    //
    // todo: save guest info + stay detail + payment to database

    await dio
        .post(
          "/check_in/data_create",
          data: FormData.fromMap({
            "room_number": Model.room_number, //
            "room_type": Model.room_type,
            "price_per_day": Model.price_per_day,
            "price_per_3_hour": Model.price_per_3_hour,
            "guest_name": Model.guest_name,
            "guest_phone_number": Model.guest_phone_number,
            "guest_gender": Model.guest_gender,
            "number_of_guests": Model.number_of_guests,
            "stay_duration_day": Model.stay_duration_day,
            "stay_duration_hour": Model.stay_duration_hour,
            "price_total_usd": Model.price_total_usd,
            "paid_bank_usd": Model.paid_bank_usd,
            "paid_bank_khr": Model.paid_bank_khr,
            "paid_cash_usd": Model.paid_cash_usd,
            "paid_cash_khr": Model.paid_cash_khr,
            "return_usd": Model.return_usd,
            "return_khr": Model.return_khr,
            "balance_usd": Model.balance_usd,
            "balance_khr": Model.balance_khr,
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
            "id": Model.room_id, //
            "account_receivable": double.parse(Model.balance_usd.toString()), //
            "status": "Occupied", //
          }),
        )
        .then((r) {
          print(r.data);

          Model.clear();

          Navigator.pop(context); // close step 4
          Navigator.pop(context); // close step 3
          Navigator.pop(context); // close step 2
          Navigator.pop(context, true); // close step 1
        })
        .catchError((e) {
          print(e);
        });
  }
}
