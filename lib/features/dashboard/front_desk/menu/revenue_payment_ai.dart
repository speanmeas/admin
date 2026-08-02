import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/features/auth/schema.g.dart" as u_schema;

import "../__config__.dart";
import "../schema.g.dart" as schema;

import "../form/check_out/widget/number_input.dart" as n_input;

class _Main_State extends State<Main_> {
  final c_price_total_usd = TextEditingController();
  final c_paid_bank_usd = TextEditingController();
  final c_paid_cash_usd = TextEditingController();
  final c_paid_bank_khr = TextEditingController();
  final c_paid_cash_khr = TextEditingController();
  final c_return_usd = TextEditingController();
  final c_return_khr = TextEditingController();
  final c_note = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    c_price_total_usd.text = schema.data[schema.REVENUE_PRICE_TOTAL_USD]?["value"]?.toString() ?? "";
    c_paid_bank_usd.text = schema.data[schema.REVENUE_PAID_BANK_USD]?["value"]?.toString() ?? "";
    c_paid_cash_usd.text = schema.data[schema.REVENUE_PAID_CASH_USD]?["value"]?.toString() ?? "";
    c_paid_bank_khr.text = schema.data[schema.REVENUE_PAID_BANK_KHR]?["value"]?.toString() ?? "";
    c_paid_cash_khr.text = schema.data[schema.REVENUE_PAID_CASH_KHR]?["value"]?.toString() ?? "";
    c_return_usd.text = schema.data[schema.REVENUE_RETURN_USD]?["value"]?.toString() ?? "";
    c_return_khr.text = schema.data[schema.REVENUE_RETURN_KHR]?["value"]?.toString() ?? "";
    c_note.text = schema.data[schema.REVENUE_PAID_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  void dispose() {
    c_price_total_usd.dispose();
    c_paid_bank_usd.dispose();
    c_paid_cash_usd.dispose();
    c_paid_bank_khr.dispose();
    c_paid_cash_khr.dispose();
    c_return_usd.dispose();
    c_return_khr.dispose();
    c_note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Revenue Payment", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: [
                //
                n_input.Main_(
                  controller: c_price_total_usd,
                  title: "Revenue Price (USD)", //
                  prefixIcon: Icons.attach_money_outlined,
                  suffixText: "\$",
                  onChanged: (v) => setState(() {}),
                ),

                Divider(height: 8, thickness: 1, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Total Price: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_price_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                //
                Row(
                  children: [
                    Expanded(
                      child: n_input.Main_(
                        controller: c_paid_bank_usd,
                        title: "Paid Bank (USD)", //
                        prefixIcon: Icons.account_balance,
                        suffixText: "\$",
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: n_input.Main_(
                        controller: c_paid_bank_khr,
                        title: "Paid Bank (KHR)", //
                        prefixIcon: Icons.account_balance,
                        suffixText: "៛",
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                //
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: n_input.Main_(
                        controller: c_paid_cash_usd,
                        title: "Paid Cash (USD)", //
                        prefixIcon: Icons.payments_outlined,
                        suffixText: "\$",
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: n_input.Main_(
                        controller: c_paid_cash_khr,
                        title: "Paid Cash (KHR)", //
                        prefixIcon: Icons.payments_outlined,
                        suffixText: "៛",
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ],
                ),

                Divider(height: 8, thickness: 1, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Total Paid: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_paid_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                //
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: n_input.Main_(
                        controller: c_return_usd,
                        title: "Return Cash (USD)", //
                        prefixIcon: Icons.payments_outlined,
                        suffixText: "\$",
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: n_input.Main_(
                        controller: c_return_khr,
                        title: "Return Cash (KHR)", //
                        prefixIcon: Icons.payments_outlined,
                        suffixText: "៛",
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ],
                ),

                Divider(height: 8, thickness: 1, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Total Return: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_return_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                //
                TextField(
                  controller: c_note,
                  decoration: InputDecoration(
                    labelText: "Note:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: 4,
                  onChanged: (v) => setState(() {}),
                ),

                //
                Divider(height: 8, thickness: 1, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Balance: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (get_balance_usd() == 0)
                      Text(
                        "0\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                      ),
                    if (get_balance_usd() != 0)
                      Text(
                        "${get_balance_usd().toString()}\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                      ),
                  ],
                ),

                SizedBox(height: 16),

                //
                SizedBox(
                  width: 600,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.save_outlined), //
                    label: Text("Save Revenue Payment"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: on_save, //
                  ),
                ),

                SizedBox(height: 8),

                SizedBox(
                  width: 600,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.clear_all_outlined), //
                    label: Text("Clear All Fields"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                    onPressed: on_clear, //
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double get_price_total_usd() {
    return double.tryParse(c_price_total_usd.text) ?? 0;
  }

  double get_paid_total_usd() {
    double paid_bank_usd = double.tryParse(c_paid_bank_usd.text) ?? 0;
    double paid_cash_usd = double.tryParse(c_paid_cash_usd.text) ?? 0;
    double paid_bank_khr = double.tryParse(c_paid_bank_khr.text) ?? 0;
    double paid_cash_khr = double.tryParse(c_paid_cash_khr.text) ?? 0;

    return paid_bank_usd + paid_cash_usd + (paid_bank_khr + paid_cash_khr) / global.RATE;
  }

  double get_return_total_usd() {
    double return_usd = double.tryParse(c_return_usd.text) ?? 0;
    double return_khr = double.tryParse(c_return_khr.text) ?? 0;

    return return_usd + (return_khr / global.RATE);
  }

  double get_balance_usd() {
    return get_price_total_usd() - get_paid_total_usd() + get_return_total_usd();
  }

  Future<void> on_save() async {
    try {
      //
      final now_response = await dio.post("/setting/now");
      if (DateTime.tryParse(now_response.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(now_response.data.toString())!;

      //
      double price = _parse_amount(c_price_total_usd.text);
      double paid_bank_usd = _parse_amount(c_paid_bank_usd.text);
      double paid_cash_usd = _parse_amount(c_paid_cash_usd.text);
      double paid_bank_khr = _parse_amount(c_paid_bank_khr.text);
      double paid_cash_khr = _parse_amount(c_paid_cash_khr.text);
      double paid_total = paid_bank_usd + paid_cash_usd + (paid_bank_khr + paid_cash_khr) / global.RATE;
      double return_usd = _parse_amount(c_return_usd.text);
      double return_khr = _parse_amount(c_return_khr.text);
      double return_total = return_usd + return_khr / global.RATE;
      double balance = price - paid_total + return_total;

      //
      schema.data[schema.REVENUE_PRICE_TOTAL_USD]?["value"] = price;
      schema.data[schema.REVENUE_PAID_BANK_USD]?["value"] = paid_bank_usd;
      schema.data[schema.REVENUE_PAID_CASH_USD]?["value"] = paid_cash_usd;
      schema.data[schema.REVENUE_PAID_BANK_KHR]?["value"] = paid_bank_khr;
      schema.data[schema.REVENUE_PAID_CASH_KHR]?["value"] = paid_cash_khr;
      schema.data[schema.REVENUE_PAID_TOTAL_USD]?["value"] = paid_total;
      schema.data[schema.REVENUE_RETURN_USD]?["value"] = return_usd;
      schema.data[schema.REVENUE_RETURN_KHR]?["value"] = return_khr;
      schema.data[schema.REVENUE_RETURN_TOTAL_USD]?["value"] = return_total;
      schema.data[schema.REVENUE_BALANCE_TOTAL_USD]?["value"] = balance;
      schema.data[schema.REVENUE_PAID_NOTE]?["value"] = c_note.text;
      schema.data[schema.REVENUE_PAID_BY_ID]?["value"] = u_schema.data[u_schema.ID]!["value"];
      schema.data[schema.REVENUE_PAID_BY]?["value"] = u_schema.data[u_schema.FULL_NAME]!["value"];
      schema.data[schema.REVENUE_PAID_AT]?["value"] = DateFormat(DATE_FORMAT).format(now);

      //
      final output = {for (var e in schema.data.entries) e.key: e.value["value"]};

      await dio.post(
        "/front_desk/update", //
        data: output,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      //
      if (!mounted) return;
      Navigator.pop(context, true);

      snackbar.view(context: context, message: "Success", color: Colors.green);
      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  double _parse_amount(String text) {
    final v = double.tryParse(text);
    return v ?? 0;
  }

  Future<void> on_clear() async {
    //
    c_price_total_usd.clear();
    c_paid_bank_usd.clear();
    c_paid_cash_usd.clear();
    c_paid_bank_khr.clear();
    c_paid_cash_khr.clear();
    c_return_usd.clear();
    c_return_khr.clear();
    c_note.clear();

    setState(() {});
    //
    // await on_save();

    // await dio.post(
    //   "/front_desk/update_none", //
    //   data: FormData.fromMap({
    //     //
    //     schema.ID: schema.data[schema.ID]?["value"] ?? "",
    //     schema.REVENUE_PRICE_TOTAL_USD: null,
    //     schema.REVENUE_PAID_BANK_USD: null,
    //     schema.REVENUE_PAID_CASH_USD: null,
    //     schema.REVENUE_PAID_BANK_KHR: null,
    //     schema.REVENUE_PAID_CASH_KHR: null,
    //     schema.REVENUE_PAID_TOTAL_USD: null,
    //     schema.REVENUE_RETURN_USD: null,
    //     schema.REVENUE_RETURN_KHR: null,
    //     schema.REVENUE_RETURN_TOTAL_USD: null,
    //     schema.REVENUE_BALANCE_TOTAL_USD: null,
    //     schema.REVENUE_PAID_NOTE: null,
    //     schema.REVENUE_PAID_BY_ID: null,
    //     schema.REVENUE_PAID_BY: null,
    //     schema.REVENUE_PAID_AT: null,
    //   }),
    // );
  }

  //
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
