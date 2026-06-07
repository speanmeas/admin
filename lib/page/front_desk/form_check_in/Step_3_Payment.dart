import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_4_Summary.dart';
import 'package:speanmeas/page/front_desk/form_check_in/__Model__.dart';
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

  TextEditingController controller_payment_type = TextEditingController(text: "Bank");
  TextEditingController controller_currency_type = TextEditingController(text: "USD");

  TextEditingController controller_bank_usd = TextEditingController();
  TextEditingController controller_bank_khr = TextEditingController();
  TextEditingController controller_cash_usd = TextEditingController();
  TextEditingController controller_cash_khr = TextEditingController();

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
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
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

              // select payment type
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    // payment type
                    Expanded(
                      child: TextField(
                        controller: controller_payment_type,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(), //
                          labelText: "Payment Type:",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),

                    // bank
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.account_balance_outlined), //
                        label: Text("Bank"), //
                        onPressed: () {
                          controller_payment_type.text = "Bank";
                          setState(() {});
                        }, //
                      ),
                    ),

                    // cash
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.monetization_on_outlined), //
                        label: Text("Cash"), //
                        onPressed: () {
                          controller_payment_type.text = "Cash";
                          setState(() {});
                        }, //
                      ),
                    ),

                    // bank + cash
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.account_balance_wallet_outlined), //
                        label: Text("Bank + Cash"), //
                        onPressed: () {
                          controller_payment_type.text = "Bank + Cash";
                          setState(() {});
                        }, //
                      ),
                    ),
                  ],
                ),
              ),

              // select currency Type
              Container(
                width: 600,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    // currency type
                    Expanded(
                      child: TextField(
                        controller: controller_currency_type,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(), //
                          labelText: "Currency Type:",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),

                    // bank
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.account_balance_outlined), //
                        label: Text("USD"), //
                        onPressed: () {
                          controller_currency_type.text = "USD";
                          setState(() {});
                        }, //
                      ),
                    ),

                    // cash
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.monetization_on_outlined), //
                        label: Text("KHR"), //
                        onPressed: () {
                          controller_currency_type.text = "KHR";
                          setState(() {});
                        }, //
                      ),
                    ),

                    // bank + cash
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.account_balance_wallet_outlined), //
                        label: Text("USD + KHR"), //
                        onPressed: () {
                          controller_currency_type.text = "USD + KHR";
                          setState(() {});
                        }, //
                      ),
                    ),
                  ],
                ),
              ),

              // payment details
              Container(
                width: 600,
                padding: EdgeInsets.all(8),

                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 250,
                          height: 50,
                          child: controller_payment_type.text.contains("Bank") && controller_currency_type.text.contains("USD")
                              ? TextField(
                                  controller: controller_bank_usd,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(), //
                                    labelText: "Bank USD:",
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                )
                              : SizedBox(),
                        ),

                        SizedBox(width: 8),

                        Container(
                          width: 250,
                          height: 50,
                          child: controller_payment_type.text.contains("Bank") && controller_currency_type.text.contains("KHR")
                              ? TextField(
                                  controller: controller_bank_khr,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(), //
                                    labelText: "Bank KHR:",
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                )
                              : SizedBox(),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    Row(
                      children: [
                        Container(
                          width: 250,
                          height: 50,
                          child: controller_payment_type.text.contains("Cash") && controller_currency_type.text.contains("USD")
                              ? TextField(
                                  controller: controller_cash_usd,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(), //
                                    labelText: "Cash USD:",
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                )
                              : SizedBox(),
                        ),

                        SizedBox(width: 8),

                        Container(
                          width: 250,
                          height: 50,
                          child: controller_payment_type.text.contains("Cash") && controller_currency_type.text.contains("KHR")
                              ? TextField(
                                  controller: controller_cash_khr,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(), //
                                    labelText: "Cash KHR:",
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                )
                              : SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            style: TextStyle(fontSize: 16),
                            "${NumberFormat("#,##0.00").format(get_price_total_usd() ?? 0)} USD", //
                          ),
                          Text(
                            style: TextStyle(fontSize: 16),
                            "or ${NumberFormat("#,##0.##").format(get_price_total_khr() ?? 0)} KHR", //
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Paid: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            style: TextStyle(fontSize: 16),
                            "${NumberFormat("#,##0.00").format(get_paid_bank_usd() ?? 0)} USD", //
                          ),
                          Text(
                            style: TextStyle(fontSize: 16),
                            "and ${NumberFormat("#,##0.##").format(get_paid_bank_khr() ?? 0)} KHR", //
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // return amount
              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Return: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if ((get_return_usd() ?? 0) < 0)
                            Text(
                              style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                              "${NumberFormat("#,##0.00").format(get_return_usd() ?? 0)} USD", //
                            ),
                          if ((get_return_usd() ?? 0) == 0)
                            Text(
                              style: TextStyle(fontSize: 16),
                              "${NumberFormat("#,##0.00").format(get_return_usd() ?? 0)} USD", //
                            ),
                          if ((get_return_khr() ?? 0) < 0)
                            Text(
                              style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                              "or ${NumberFormat("#,##0.##").format(get_return_khr() ?? 0)} KHR", //
                            ),
                          if ((get_return_khr() ?? 0) == 0)
                            Text(
                              style: TextStyle(fontSize: 16),
                              "or ${NumberFormat("#,##0.##").format(get_return_khr() ?? 0)} KHR", //
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // remaining
              Container(
                width: 600,
                padding: EdgeInsets.all(4),

                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey), //
                    bottom: BorderSide(color: Colors.grey), //
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Remaining: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if ((get_remaining_usd() ?? 0) > 0)
                            Text(
                              style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                              "${NumberFormat("#,##0.00").format(get_remaining_usd() ?? 0)} USD", //
                            ),
                          if ((get_remaining_usd() ?? 0) == 0)
                            Text(
                              style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                              "${NumberFormat("#,##0.00").format(get_remaining_usd() ?? 0)} USD", //
                            ),

                          if (get_remaining_khr() != null && get_remaining_khr()! > 0)
                            Text(
                              style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                              "or ${NumberFormat("#,##0.##").format(get_remaining_khr() ?? 0)} KHR", //
                            ),

                          if (get_remaining_khr() != null && get_remaining_khr()! == 0)
                            Text(
                              style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                              "or ${NumberFormat("#,##0.##").format(get_remaining_khr() ?? 0)} KHR", //
                            ),
                        ],
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
    Model_Check_In.paid_bank_usd = get_paid_bank_usd()?.toString();
    Model_Check_In.paid_bank_khr = get_paid_bank_khr()?.toString();
    Model_Check_In.paid_cash_usd = get_paid_cash_usd()?.toString();
    Model_Check_In.paid_cash_khr = get_paid_cash_khr()?.toString();

    // Model.paid_total_usd = get_paid_as_usd()?.toString();
    // Model.paid_total_khr = get_paid_as_khr()?.toString();

    Model_Check_In.return_usd = get_return_usd()?.toString();
    Model_Check_In.return_khr = get_return_khr()?.toString();

    Model_Check_In.remain_usd = get_remaining_usd()?.toString();
    Model_Check_In.remain_khr = get_remaining_khr()?.toString();

    //
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Summary_()),
    );
  }

  double? get_price_total_usd() {
    double total_usd = double.tryParse(Model_Check_In.price_total_usd!) ?? 0;
    return total_usd;
  }

  double? get_price_total_khr() {
    double total_usd = double.tryParse(Model_Check_In.price_total_usd!) ?? 0;
    return total_usd * Global.RATE;
  }

  double? get_paid_bank_usd() {
    if (controller_payment_type.text.contains("Bank") && controller_currency_type.text.contains("USD")) {
      double paid_bank_usd = double.tryParse(controller_bank_usd.text) ?? 0;
      return paid_bank_usd;
    }
    return null;
  }

  double? get_paid_bank_khr() {
    if (controller_payment_type.text.contains("Bank") && controller_currency_type.text.contains("KHR")) {
      double paid_bank_khr = double.tryParse(controller_bank_khr.text) ?? 0;
      return paid_bank_khr;
    }
    return null;
  }

  double? get_paid_cash_usd() {
    if (controller_payment_type.text.contains("Cash") && controller_currency_type.text.contains("USD")) {
      double paid_cash_usd = double.tryParse(controller_cash_usd.text) ?? 0;
      return paid_cash_usd;
    }
    return null;
  }

  double? get_paid_cash_khr() {
    if (controller_payment_type.text.contains("Cash") && controller_currency_type.text.contains("KHR")) {
      double paid_cash_khr = double.tryParse(controller_cash_khr.text) ?? 0;
      return paid_cash_khr;
    }
    return null;
  }

  double? get_paid_as_usd() {
    double paid_total_usd = (get_paid_bank_usd() ?? 0) + (get_paid_cash_usd() ?? 0);
    return paid_total_usd;
  }

  double? get_paid_as_khr() {
    double paid_total_khr = (get_paid_bank_khr() ?? 0) + (get_paid_cash_khr() ?? 0);
    return paid_total_khr;
  }

  double? get_return_usd() {
    double total_usd = get_price_total_usd() ?? 0;
    double paid_total_usd = get_paid_as_usd() ?? 0;
    double paid_total_khr_as_usd = (get_paid_as_khr() ?? 0) / Global.RATE;
    double total_paid_as_usd = paid_total_usd + paid_total_khr_as_usd;

    if (total_usd < total_paid_as_usd) {
      return total_usd - total_paid_as_usd;
    } else {
      return 0;
    }
  }

  double? get_return_khr() {
    double total_usd = get_price_total_usd() ?? 0;
    double paid_total_usd = get_paid_as_usd() ?? 0;
    double paid_total_khr_as_usd = (get_paid_as_khr() ?? 0) / Global.RATE;
    double total_paid_as_usd = paid_total_usd + paid_total_khr_as_usd;

    if (total_usd < total_paid_as_usd) {
      return (total_usd - total_paid_as_usd) * Global.RATE;
    } else {
      return 0;
    }
  }

  double? get_remaining_usd() {
    double total_usd = get_price_total_usd() ?? 0;
    double paid_total_usd = get_paid_as_usd() ?? 0;
    double paid_total_khr_as_usd = (get_paid_as_khr() ?? 0) / Global.RATE;
    double total_paid_as_usd = paid_total_usd + paid_total_khr_as_usd;

    if (total_usd > total_paid_as_usd) {
      return total_usd - total_paid_as_usd;
    } else {
      return 0;
    }
  }

  double? get_remaining_khr() {
    double total_usd = get_price_total_usd() ?? 0;
    double paid_total_usd = get_paid_as_usd() ?? 0;
    double paid_total_khr_as_usd = (get_paid_as_khr() ?? 0) / Global.RATE;
    double total_paid_as_usd = paid_total_usd + paid_total_khr_as_usd;

    if (total_usd > total_paid_as_usd) {
      return (total_usd - total_paid_as_usd) * Global.RATE;
    } else {
      return 0;
    }
  }
}
