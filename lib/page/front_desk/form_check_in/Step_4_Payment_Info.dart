import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/page/main/User.g.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '../__Setup__.dart';
import '../Schema.g.dart';

import 'Step_5_Summary.dart' as summary;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  // keys
  var PRICE_TOTAL = "price_total_usd";
  var PAID_BANK_USD = "paid_bank_usd";
  var PAID_BANK_KHR = "paid_bank_khr";
  var PAID_CASH_USD = "paid_cash_usd";
  var PAID_CASH_KHR = "paid_cash_khr";
  var PAID_TOTAL_USD = "paid_total_usd";
  var RETURN_USD = "return_usd";
  var RETURN_KHR = "return_khr";
  var RETURN_TOTAL_USD = "return_total_usd";
  var AR_TOTAL_USD = "ar_total_usd";
  var GET_PAID_DATE = "payment_date";
  var GET_PAID_BY = "payment_by";
  var GET_PAID_BY_ID = "payment_by_id";

  // controllers
  TextEditingController controller_price_usd = TextEditingController();

  TextEditingController controller_paid_bank_usd = TextEditingController();
  TextEditingController controller_paid_bank_khr = TextEditingController();

  TextEditingController controller_paid_cash_usd = TextEditingController();
  TextEditingController controller_paid_cash_khr = TextEditingController();

  TextEditingController controller_return_usd = TextEditingController();
  TextEditingController controller_return_khr = TextEditingController();

  TextEditingController controller_payment_note = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    for (var s in schema) {
      if (s["key"] == PRICE_TOTAL) controller_price_usd.text = (s["value"] ?? "").toString();
      if (s["key"] == PAID_BANK_USD) controller_paid_bank_usd.text = (s["value"] ?? "").toString();
      if (s["key"] == PAID_BANK_KHR) controller_paid_bank_khr.text = (s["value"] ?? "").toString();
      if (s["key"] == PAID_CASH_USD) controller_paid_cash_usd.text = (s["value"] ?? "").toString();
      if (s["key"] == PAID_CASH_KHR) controller_paid_cash_khr.text = (s["value"] ?? "").toString();
      if (s["key"] == RETURN_USD) controller_return_usd.text = (s["value"] ?? "").toString();
      if (s["key"] == RETURN_KHR) controller_return_khr.text = (s["value"] ?? "").toString();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // if (can_next())
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: OutlinedButton.icon(
              icon: Icon(Icons.arrow_right_alt_outlined),
              label: Text("Next"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: on_next,
            ),
          ),
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
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_price_usd,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                  decoration: InputDecoration(
                    labelText: "Price (USD):",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(Icons.bed_outlined, size: 20, color: Colors.black),
                    suffixText: "\$",
                  ),
                  onChanged: (v) => setState(() {}),
                ),
              ),

              (() {
                String value = get_price_total_usd().toString(); //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 32),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Total Price: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        "$value\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                      ),
                    ],
                  ),
                );
              })(),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // paid bank usd
                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Bank (USD):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.account_balance, size: 20, color: Colors.black),
                          suffixText: "\$",
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),

                    SizedBox(width: 8),

                    // paid bank khr
                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Bank (KHR):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.account_balance, size: 20, color: Colors.black), //
                          suffixText: "៛",
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // paid cash usd
                    Expanded(
                      child: TextField(
                        controller: controller_paid_cash_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Cash (USD):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.payments_outlined, size: 20, color: Colors.black), //
                          suffixText: "\$",
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),

                    SizedBox(width: 8),

                    // paid cash khr
                    Expanded(
                      child: TextField(
                        controller: controller_paid_cash_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Cash (KHR):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.payments_outlined, size: 20, color: Colors.black), //
                          suffixText: "៛",
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),

              (() {
                String value = get_paid_total_usd().toString(); //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 32),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Total Paid: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        "$value\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                      ),
                    ],
                  ),
                );
              })(),

              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // return usd
                    Expanded(
                      child: TextField(
                        controller: controller_return_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: "Return (USD):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.payments_outlined, size: 20, color: Colors.black), //
                          suffixText: "\$",
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),

                    SizedBox(width: 8),

                    // return khr
                    Expanded(
                      child: TextField(
                        controller: controller_return_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Return (KHR):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.payments_outlined, size: 20, color: Colors.black), //
                          suffixText: "៛",
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),

              (() {
                String value = get_return_total_usd().toString(); //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 32),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Total Return: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        "$value\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                      ),
                    ],
                  ),
                );
              })(),

              (() {
                String value = get_ar_total_usd().toString(); //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Total A/R: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                      if (get_ar_total_usd() == 0)
                        Text(
                          "$value\$",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                        ),
                      if (get_ar_total_usd() != 0)
                        Text(
                          "$value\$",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                        ),
                    ],
                  ),
                );
              })(),
            ],
          ),
        ),
      ),
    );
  }

  double get_price_total_usd() {
    double price_total_usd = double.tryParse(controller_price_usd.text) ?? 0;
    return price_total_usd;
  }

  double get_paid_total_usd() {
    double paid_bank_usd = double.tryParse(controller_paid_bank_usd.text) ?? 0;
    double paid_cash_usd = double.tryParse(controller_paid_cash_usd.text) ?? 0;
    double paid_bank_khr = double.tryParse(controller_paid_bank_khr.text) ?? 0;
    double paid_cash_khr = double.tryParse(controller_paid_cash_khr.text) ?? 0;
    double paid_total_usd = paid_bank_usd + paid_cash_usd + (paid_bank_khr + paid_cash_khr) / Global.variable.RATE;

    return paid_total_usd;
  }

  double get_return_total_usd() {
    double return_usd = double.tryParse(controller_return_usd.text) ?? 0;
    double return_khr = double.tryParse(controller_return_khr.text) ?? 0;

    double return_total_usd = return_usd + (return_khr / Global.variable.RATE);

    return return_total_usd;
  }

  double get_ar_total_usd() {
    double price_total_usd = get_price_total_usd();
    double paid_total_usd = get_paid_total_usd();
    double return_total_usd = get_return_total_usd();

    double ar_total_usd = price_total_usd - paid_total_usd + return_total_usd;

    return ar_total_usd;
  }

  bool can_next() {
    if (get_paid_total_usd() == 0) {
      if (get_return_total_usd() == 0) {
        return true;
      }
    }

    if (get_paid_total_usd() == get_price_total_usd()) {
      if (get_return_total_usd() == 0) {
        return true;
      }
    }

    if (get_paid_total_usd() > get_price_total_usd()) {
      if (get_ar_total_usd() == 0) {
        return true;
      }
    }

    return false;
  }

  void on_next() async {
    //

    double paid_bank_usd = double.tryParse(controller_paid_bank_usd.text) ?? 0;
    double paid_cash_usd = double.tryParse(controller_paid_cash_usd.text) ?? 0;
    double paid_bank_khr = double.tryParse(controller_paid_bank_khr.text) ?? 0;
    double paid_cash_khr = double.tryParse(controller_paid_cash_khr.text) ?? 0;

    double return_usd = double.tryParse(controller_return_usd.text) ?? 0;
    double return_khr = double.tryParse(controller_return_khr.text) ?? 0;

    DateTime? get_paid_date;
    if (get_paid_total_usd() > 0) {
      if (get_ar_total_usd() == 0) {
        get_paid_date = DateTime.now();
      }
    }

    for (var s in schema) {
      if (s["key"] == PRICE_TOTAL) s["value"] = get_price_total_usd();
      if (s["key"] == PAID_BANK_USD) s["value"] = paid_bank_usd == 0 ? null : paid_bank_usd;
      if (s["key"] == PAID_BANK_KHR) s["value"] = paid_bank_khr == 0 ? null : paid_bank_khr;
      if (s["key"] == PAID_CASH_USD) s["value"] = paid_cash_usd == 0 ? null : paid_cash_usd;
      if (s["key"] == PAID_CASH_KHR) s["value"] = paid_cash_khr == 0 ? null : paid_cash_khr;
      if (s["key"] == PAID_TOTAL_USD) s["value"] = get_paid_total_usd();
      if (s["key"] == RETURN_USD) s["value"] = return_usd == 0 ? null : return_usd;
      if (s["key"] == RETURN_KHR) s["value"] = return_khr == 0 ? null : return_khr;
      if (s["key"] == RETURN_TOTAL_USD) s["value"] = get_return_total_usd();
      if (s["key"] == AR_TOTAL_USD) s["value"] = get_ar_total_usd();
      if (s["key"] == GET_PAID_DATE && get_paid_date != null) s["value"] = get_paid_date.toIso8601String();
      if (s["key"] == GET_PAID_BY && get_paid_date != null) s["value"] = user["full_name"]!["value"];
      if (s["key"] == GET_PAID_BY_ID && get_paid_date != null) s["value"] = user["id"]!["value"];
    }

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => summary.Main_()),
    );
  }
}
