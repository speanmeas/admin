import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import '__Model__.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Payment_(),
    );
  }
}

class Payment_ extends StatefulWidget {
  const Payment_({super.key});

  @override
  State<Payment_> createState() => _Payment_State();
}

class _Payment_State extends State<Payment_> {
  //

  final controller_price_total_usd = TextEditingController();
  final controller_price_total_khr = TextEditingController();

  final controller_paid_bank_usd = TextEditingController();
  final controller_paid_bank_khr = TextEditingController();
  final controller_paid_cash_usd = TextEditingController();
  final controller_paid_cash_khr = TextEditingController();

  final controller_return_usd = TextEditingController();
  final controller_return_khr = TextEditingController();

  final controller_ar_usd = TextEditingController();
  final controller_ar_khr = TextEditingController();

  @override
  initState() {
    super.initState();

    controller_price_total_usd.text = NumberFormat("#,##0.##").format(double.parse(Model.price_total_usd.toString()));
    controller_price_total_khr.text = NumberFormat("#,##0.##").format(double.parse(Model.price_total_khr.toString()));
    controller_paid_bank_usd.text = Model.paid_bank_usd.toString();
    controller_paid_bank_khr.text = Model.paid_bank_khr.toString();
    controller_paid_cash_usd.text = Model.paid_cash_usd.toString();
    controller_paid_cash_khr.text = Model.paid_cash_khr.toString();
    controller_return_usd.text = Model.return_usd.toString();
    controller_return_khr.text = Model.return_khr.toString();

    controller_ar_usd.text = NumberFormat("#,##0.##").format(get_ar_usd());
    controller_ar_khr.text = NumberFormat("#,##0.##").format(get_ar_usd() * Global.RATE);
  }

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

              // price total usd and khr
              Container(
                width: 600,
                height: 40,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    Text("Price Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      Model.price_total_usd.toString(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(" USD = ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      Model.price_total_khr.toString(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(" KHR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // paid bank usd and khr
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Bank (USD):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (v) {
                          if (v.isEmpty) {
                            Model.paid_bank_usd = 0;
                            setState(() {});
                            return;
                          }

                          if (double.tryParse(v) == null) {
                            controller_paid_bank_usd.text = v.substring(0, v.length - 1);
                            controller_paid_bank_usd.selection = TextSelection.collapsed(offset: controller_paid_bank_usd.text.length);
                          }

                          Model.paid_bank_usd = double.tryParse(v) ?? 0;
                          setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Bank (KHR):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (v) {
                          if (double.tryParse(v) == null) {
                            controller_paid_bank_khr.text = v.substring(0, v.length - 1);
                            controller_paid_bank_khr.selection = TextSelection.collapsed(offset: controller_paid_bank_khr.text.length);
                          }

                          Model.paid_bank_khr = double.tryParse(v) ?? 0;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // payment details
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller_paid_cash_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Cash (USD):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (v) {
                          if (v.isEmpty) {
                            Model.paid_cash_usd = 0;
                            setState(() {});
                            return;
                          }

                          if (double.tryParse(v) == null) {
                            controller_paid_cash_usd.text = v.substring(0, v.length - 1);
                            controller_paid_cash_usd.selection = TextSelection.collapsed(offset: controller_paid_cash_usd.text.length);
                          }

                          Model.paid_cash_usd = double.tryParse(v) ?? 0;
                          setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        controller: controller_paid_cash_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Cash (KHR):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (v) {
                          if (v.isEmpty) {
                            Model.paid_cash_khr = 0;
                            setState(() {});
                            return;
                          }

                          if (double.tryParse(v) == null) {
                            controller_paid_cash_khr.text = v.substring(0, v.length - 1);
                            controller_paid_cash_khr.selection = TextSelection.collapsed(offset: controller_paid_cash_khr.text.length);
                          }

                          Model.paid_cash_khr = double.tryParse(v) ?? 0;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // return details
              if (get_ar_usd() > 0)
                Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller_return_usd,
                          decoration: InputDecoration(
                            labelText: "Return (USD):",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                          onChanged: (v) {
                            if (v.isEmpty) {
                              Model.return_usd = 0;
                              setState(() {});
                              return;
                            }

                            if (double.tryParse(v) == null) {
                              controller_return_usd.text = v.substring(0, v.length - 1);
                              controller_return_usd.selection = TextSelection.collapsed(offset: controller_return_usd.text.length);
                            }

                            Model.return_usd = double.tryParse(v) ?? 0;
                            setState(() {});
                          },
                        ),
                      ),

                      SizedBox(width: 8),

                      Expanded(
                        child: TextField(
                          controller: controller_return_khr,
                          decoration: InputDecoration(
                            labelText: "Return (KHR):",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: false),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                          onChanged: (v) {
                            if (v.isEmpty) {
                              Model.return_khr = 0;
                              setState(() {});
                              return;
                            }

                            if (double.tryParse(v) == null) {
                              controller_return_khr.text = v.substring(0, v.length - 1);
                              controller_return_khr.selection = TextSelection.collapsed(offset: controller_return_khr.text.length);
                            }

                            Model.return_khr = double.tryParse(v) ?? 0;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // price total usd and khr
              Container(
                width: 600,
                height: 40,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    Text("Balance: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      get_ar_usd().toString(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(" USD = ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      (get_ar_usd() * Global.RATE).toString(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Text(" KHR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Summary_()),
    );
  }

  double get_ar_usd() {
    double paid_total_usd = Model.paid_bank_usd + Model.paid_cash_usd + (Model.paid_bank_khr + Model.paid_cash_khr) / Global.RATE;

    double return_total_usd = Model.return_usd + Model.return_khr / Global.RATE;

    Model.balance_usd = paid_total_usd - return_total_usd - Model.price_total_usd;
    Model.balance_khr = Model.balance_usd * Global.RATE;

    return Model.balance_usd;
  }
}
