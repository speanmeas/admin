import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/page/main/User.g.dart";
import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/widget/Datetime_Picker.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "../../Schema.g.dart";
import "Step_5_Summary.dart" as step_5;

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

  var PRICE_DAY = "room_price_per_day_usd";
  var PRICE_3H = "room_price_per_3h_usd";

  var STAY_DAYS = "stay_duration_day";
  var STAY_HOURS = "stay_duration_hour";

  var PAID_BANK_USD = "paid_bank_usd";
  var PAID_BANK_KHR = "paid_bank_khr";
  var PAID_CASH_USD = "paid_cash_usd";
  var PAID_CASH_KHR = "paid_cash_khr";
  var PAID_TOTAL_USD = "paid_total_usd";
  var RETURN_USD = "return_usd";
  var RETURN_KHR = "return_khr";
  var RETURN_TOTAL_USD = "return_total_usd";
  var AR_TOTAL_USD = "ar_total_usd";

  var GET_PAID_DATE = "payment_at";
  var GET_PAID_BY = "payment_by";
  var GET_PAID_BY_ID = "payment_by_id";

  // controllers
  TextEditingController c_price_usd = TextEditingController();

  TextEditingController c_paid_bank_usd = TextEditingController();
  TextEditingController c_paid_bank_khr = TextEditingController();

  TextEditingController c_paid_cash_usd = TextEditingController();
  TextEditingController c_paid_cash_khr = TextEditingController();

  TextEditingController c_return_usd = TextEditingController();
  TextEditingController c_return_khr = TextEditingController();

  TextEditingController c_payment_note = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    double price_per_day_usd = 0;
    double price_per_3h_usd = 0;
    double stay_duration_days = 0;
    double stay_duration_hours = 0;

    for (var s in schema) {
      if (s["key"] == PRICE_DAY) price_per_day_usd = double.tryParse("${s["value"] ?? 0}") ?? 0;
      if (s["key"] == PRICE_3H) price_per_3h_usd = double.tryParse("${s["value"] ?? 0}") ?? 0;
      if (s["key"] == STAY_DAYS) stay_duration_days = double.tryParse("${s["value"] ?? 0}") ?? 0;
      if (s["key"] == STAY_HOURS) stay_duration_hours = double.tryParse("${s["value"] ?? 0}") ?? 0;
    }

    double price_total_usd = (stay_duration_days * price_per_day_usd) + ((stay_duration_hours / 3) * price_per_3h_usd);

    for (var s in schema) {
      if (s["key"] == PRICE_TOTAL) c_price_usd.text = price_total_usd.toString();
      if (s["key"] == PAID_BANK_USD) c_paid_bank_usd.text = (s["value"] ?? "").toString();
      if (s["key"] == PAID_BANK_KHR) c_paid_bank_khr.text = (s["value"] ?? "").toString();
      if (s["key"] == PAID_CASH_USD) c_paid_cash_usd.text = (s["value"] ?? "").toString();
      if (s["key"] == PAID_CASH_KHR) c_paid_cash_khr.text = (s["value"] ?? "").toString();
      if (s["key"] == RETURN_USD) c_return_usd.text = (s["value"] ?? "").toString();
      if (s["key"] == RETURN_KHR) c_return_khr.text = (s["value"] ?? "").toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "4. Check In - Payment", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: OutlinedButton.icon(
              icon: Icon(Icons.arrow_right_alt_outlined),
              label: Text("Next"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () {
                print("on_next()");
              },
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
                  controller: c_price_usd,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
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
                        controller: c_paid_bank_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
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
                        controller: c_paid_bank_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
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
                        controller: c_paid_cash_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
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
                        controller: c_paid_cash_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
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
                        controller: c_return_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))],
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
                        controller: c_return_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))],
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

              // note
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: c_payment_note,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Note:", //
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {},
                ),
              ),

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
                      Text("Balance : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

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
    double price_total_usd = double.tryParse(c_price_usd.text) ?? 0;
    return price_total_usd;
  }

  double get_paid_total_usd() {
    double paid_bank_usd = double.tryParse(c_paid_bank_usd.text) ?? 0;
    double paid_cash_usd = double.tryParse(c_paid_cash_usd.text) ?? 0;
    double paid_bank_khr = double.tryParse(c_paid_bank_khr.text) ?? 0;
    double paid_cash_khr = double.tryParse(c_paid_cash_khr.text) ?? 0;
    double paid_total_usd = paid_bank_usd + paid_cash_usd + (paid_bank_khr + paid_cash_khr) / Global.variable.RATE;

    return paid_total_usd;
  }

  double get_return_total_usd() {
    double return_usd = double.tryParse(c_return_usd.text) ?? 0;
    double return_khr = double.tryParse(c_return_khr.text) ?? 0;

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

    print("on_next()");

    double paid_bank_usd = double.tryParse(c_paid_bank_usd.text) ?? 0;
    double paid_cash_usd = double.tryParse(c_paid_cash_usd.text) ?? 0;
    double paid_bank_khr = double.tryParse(c_paid_bank_khr.text) ?? 0;
    double paid_cash_khr = double.tryParse(c_paid_cash_khr.text) ?? 0;

    double return_usd = double.tryParse(c_return_usd.text) ?? 0;
    double return_khr = double.tryParse(c_return_khr.text) ?? 0;

    DateTime? get_paid_date;
    if (get_paid_total_usd() > 0) {
      if (get_ar_total_usd() == 0) {
        get_paid_date = DateTime.now();
      }
    }

    // for (var s in schema) {
    //   if (s["key"] == PRICE_TOTAL) s["value"] = get_price_total_usd();
    //   if (s["key"] == PAID_BANK_USD) s["value"] = paid_bank_usd == 0 ? null : paid_bank_usd;
    //   if (s["key"] == PAID_BANK_KHR) s["value"] = paid_bank_khr == 0 ? null : paid_bank_khr;
    //   if (s["key"] == PAID_CASH_USD) s["value"] = paid_cash_usd == 0 ? null : paid_cash_usd;
    //   if (s["key"] == PAID_CASH_KHR) s["value"] = paid_cash_khr == 0 ? null : paid_cash_khr;
    //   if (s["key"] == PAID_TOTAL_USD) s["value"] = get_paid_total_usd();
    //   if (s["key"] == RETURN_USD) s["value"] = return_usd == 0 ? null : return_usd;
    //   if (s["key"] == RETURN_KHR) s["value"] = return_khr == 0 ? null : return_khr;
    //   if (s["key"] == RETURN_TOTAL_USD) s["value"] = get_return_total_usd();
    //   if (s["key"] == AR_TOTAL_USD) s["value"] = get_ar_total_usd();

    //   if (get_paid_total_usd() > 0) {
    //     if (s["key"] == GET_PAID_DATE) s["value"] = get_paid_date?.toIso8601String();
    //     if (s["key"] == GET_PAID_BY && user["full_name"] != null) s["value"] = user["full_name"]!;
    //     if (s["key"] == GET_PAID_BY_ID && user["_id"] != null) s["value"] = user["_id"]!;
    //   }
    // }

    for (var s in schema) print(s);

    // Navigator.push(
    //   context, //
    //   MaterialPageRoute(builder: (context) => step_5.Main_()),
    // );
  }
}
