import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_4_Summary.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Payment(),
    ),
  );
}

class Payment extends StatelessWidget {
  const Payment({super.key});

  final id = "69f984897186bcf74f8a5dde"; //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Payment_(id: id),
    );
  }
}

class Payment_ extends StatefulWidget {
  const Payment_({super.key, required this.id});

  final String id;

  @override
  State<Payment_> createState() => _Payment_State();
}

class _Payment_State extends State<Payment_> {
  //

  String? type_pay;
  String? type_currency;

  double? total_usd;
  double? total_khr;

  double? paid_bank_usd;
  double? paid_bank_khr;

  double? paid_cash_usd;
  double? paid_cash_khr;

  double? get_paid_total_usd() {
    double bank = paid_bank_usd ?? 0;
    double cash = paid_cash_usd ?? 0;
    return bank + cash;
  }

  double? get_paid_total_khr() {
    double bank = paid_bank_khr ?? 0;
    double cash = paid_cash_khr ?? 0;
    return bank + cash;
  }

  double? get_paid_total_as_usd() {
    double total = 0;
    if (type_currency == "usd") {
      total = get_paid_total_usd() ?? 0;
    } else if (type_currency == "khr") {
      total = get_paid_total_khr() ?? 0;
    } else if (type_currency == "usd_and_khr") {
      total = (get_paid_total_usd() ?? 0) + ((get_paid_total_khr() ?? 0) / 4000);
    }
    return total;
  }

  double? get_remaining_usd() {
    if (total_usd != null && get_paid_total_usd() != null) {
      return total_usd! - get_paid_total_usd()!;
    }
    return null;
  }

  double? get_remaining_khr() {
    final remainingUsd = get_remaining_usd();
    return remainingUsd != null ? remainingUsd * 4000 : null;
  }

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
          "Check In - Payment", //
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
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  "Payment Type: ", //
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              // Payment Type
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(4, 4, 8, 8),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (type_pay == "bank") Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                            if (type_pay != "bank") Icon(Icons.radio_button_unchecked, size: 24), //
                            SizedBox(width: 4),
                            Text("Bank", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          type_pay = "bank";
                        });
                      },
                    ),

                    SizedBox(width: 4),

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (type_pay == "cash") Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                            if (type_pay != "cash") Icon(Icons.radio_button_unchecked, size: 24), //
                            SizedBox(width: 4),
                            Text("Cash", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          type_pay = "cash";
                        });
                      },
                    ),

                    SizedBox(width: 4),

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (type_pay == "bank_and_cash") Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                            if (type_pay != "bank_and_cash") Icon(Icons.radio_button_unchecked, size: 24), //
                            SizedBox(width: 4),
                            Text("Bank + Cash", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          type_pay = "bank_and_cash";
                        });
                      },
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  "Currency Type: ", //
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              // Currency Type
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(4, 4, 8, 8),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (type_currency == "usd") Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                            if (type_currency != "usd") Icon(Icons.radio_button_unchecked, size: 24), //
                            SizedBox(width: 4),
                            Text("USD", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          type_currency = "usd";
                        });
                      },
                    ),

                    SizedBox(width: 4),

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (type_currency == "khr") Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                            if (type_currency != "khr") Icon(Icons.radio_button_unchecked, size: 24), //
                            SizedBox(width: 4),
                            Text("KHR", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          type_currency = "khr";
                        });
                      },
                    ),
                    SizedBox(width: 4),

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (type_currency == "usd_and_khr") Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                            if (type_currency != "usd_and_khr") Icon(Icons.radio_button_unchecked, size: 24), //
                            SizedBox(width: 4),
                            Text("USD + KHR", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          type_currency = "usd_and_khr";
                        });
                      },
                    ),
                  ],
                ),
              ),

              //
              if (type_pay != null && (type_pay == "bank" || type_pay == "bank_and_cash"))
                if (type_currency != null && (type_currency == "usd" || type_currency == "usd_and_khr"))
                  Container(
                    width: 600,
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //
                        labelText: "Bank USD:",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),

              //
              if (type_pay != null && (type_pay == "bank" || type_pay == "bank_and_cash"))
                if (type_currency != null && (type_currency == "khr" || type_currency == "usd_and_khr"))
                  Container(
                    width: 600,
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //
                        labelText: "Bank KHR:",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),

              //
              if (type_pay != null && (type_pay == "cash" || type_pay == "bank_and_cash"))
                if (type_currency != null && (type_currency == "usd" || type_currency == "usd_and_khr"))
                  Container(
                    width: 600,
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //
                        labelText: "Cash USD:",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),

              //
              if (type_pay != null && (type_pay == "cash" || type_pay == "bank_and_cash"))
                if (type_currency != null && (type_currency == "khr" || type_currency == "usd_and_khr"))
                  Container(
                    width: 600,
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //
                        labelText: "Cash KHR:",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),

              Container(
                width: 600,
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Divider(thickness: 1, color: Colors.grey),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Amount: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${NumberFormat("#,##0.##").format(100 ?? 0)} USD", style: TextStyle(fontSize: 16)),
                        Text("or", style: TextStyle(fontSize: 16)),
                        Text("${NumberFormat("#,##0.##").format(1000000 ?? 0)} KHR", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Divider(thickness: 1, color: Colors.grey),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Paid Amount: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${NumberFormat("#,##0.##").format(100 ?? 0)} USD", style: TextStyle(fontSize: 16)),
                        Text("and", style: TextStyle(fontSize: 16)),
                        Text("${NumberFormat("#,##0.##").format(1000000 ?? 0)} KHR", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Divider(thickness: 1, color: Colors.grey),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Remaining: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${NumberFormat("#,##0.##").format(100 ?? 0)} USD", style: TextStyle(fontSize: 16)),
                        Text("or", style: TextStyle(fontSize: 16)),
                        Text("${NumberFormat("#,##0.##").format(1000000 ?? 0)} KHR", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Divider(thickness: 1, color: Colors.grey),
              ),

              //
              Container(
                padding: EdgeInsets.all(8),
                child: OutlinedButton.icon(
                  label: Text("Check In"),
                  icon: Icon(Icons.login),
                  onPressed: () {
                    print("Check In");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Summary_(
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
