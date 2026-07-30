import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/__variable__.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/widget/show_data.dart" as show_data;
import "package:speanmeas/page/auth/schema.g.dart" as u_schema;

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

  Map<String, dynamic> existing = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    existing = {
      for (var k in [
        schema.REVENUE_PRICE_TOTAL_USD,
        schema.REVENUE_PAID_BANK_USD,
        schema.REVENUE_PAID_CASH_USD,
        schema.REVENUE_PAID_BANK_KHR,
        schema.REVENUE_PAID_CASH_KHR,
        schema.REVENUE_PAID_TOTAL_USD,
        schema.REVENUE_RETURN_USD,
        schema.REVENUE_RETURN_KHR,
        schema.REVENUE_RETURN_TOTAL_USD,
        schema.REVENUE_BALANCE_TOTAL_USD,
        schema.REVENUE_PAID_NOTE,
        schema.REVENUE_PAID_BY,
        schema.REVENUE_PAID_AT,
      ])
      k: schema.data[k]?["value"]
    };

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final has_existing = existing[schema.REVENUE_PRICE_TOTAL_USD] != null ||
        existing[schema.REVENUE_PAID_BANK_USD] != null ||
        existing[schema.REVENUE_PAID_CASH_USD] != null ||
        existing[schema.REVENUE_PAID_BANK_KHR] != null ||
        existing[schema.REVENUE_PAID_CASH_KHR] != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Revenue Payment", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          OutlinedButton.icon(
            icon: Icon(Icons.save_outlined),
            label: Text("Save"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            onPressed: on_save, //
          ),
          SizedBox(width: 8),
        ],
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
                // existing revenue section
                if (has_existing) ...[
                  Text("Existing Revenue", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  if (existing[schema.REVENUE_PRICE_TOTAL_USD] != null)
                    show_data.Main_(
                      title: "Revenue Price (USD)", //
                      value: existing[schema.REVENUE_PRICE_TOTAL_USD].toString(),
                    ),
                  if (existing[schema.REVENUE_PAID_BANK_USD] != null || existing[schema.REVENUE_PAID_CASH_USD] != null)
                    show_data.Main_(
                      title: "Paid Total (USD)", //
                      value: existing[schema.REVENUE_PAID_TOTAL_USD]?.toString() ?? "0",
                    ),
                  if (existing[schema.REVENUE_RETURN_USD] != null || existing[schema.REVENUE_RETURN_KHR] != null)
                    show_data.Main_(
                      title: "Return Total (USD)", //
                      value: existing[schema.REVENUE_RETURN_TOTAL_USD]?.toString() ?? "0",
                    ),
                  if (existing[schema.REVENUE_BALANCE_TOTAL_USD] != null)
                    show_data.Main_(
                      title: "Balance (USD)", //
                      value: existing[schema.REVENUE_BALANCE_TOTAL_USD].toString(),
                    ),
                  if (existing[schema.REVENUE_PAID_BY] != null)
                    show_data.Main_(
                      title: "Paid By", //
                      value: existing[schema.REVENUE_PAID_BY].toString(),
                    ),
                  if (existing[schema.REVENUE_PAID_AT] != null)
                    show_data.Main_(
                      title: "Paid At", //
                      value: existing[schema.REVENUE_PAID_AT].toString(),
                    ),
                  if (existing[schema.REVENUE_PAID_NOTE] != null)
                    show_data.Main_(
                      title: "Note", //
                      value: existing[schema.REVENUE_PAID_NOTE].toString(),
                    ),
                  Divider(height: 16, thickness: 1, color: Colors.black),
                  Text("Add New", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                ],

                // revenue price
                n_input.Main_(
                  controller: c_price_total_usd,
                  title: "Revenue Price (USD)", //
                  prefixIcon: Icons.attach_money_outlined,
                  suffixText: "\$",
                  onChanged: (v) => setState(() {}),
                ),

                // total price
                Divider(height: 8, thickness: 1, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("New Price Total: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_price_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                // paid bank
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

                // paid cash
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

                // total paid
                Divider(height: 8, thickness: 1, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("New Paid Total: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_paid_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // return
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

                // total return
                Divider(height: 8, thickness: 1, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("New Return Total: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_return_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // note
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

                // combined totals
                Divider(height: 16, thickness: 2, color: Colors.black),
                Text("Combined Totals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Price Total: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_combined_price_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Paid Total: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_combined_paid_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Return Total: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${get_combined_return_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Balance: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (get_combined_balance_usd() == 0)
                      Text(
                        "0\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                      ),
                    if (get_combined_balance_usd() != 0)
                      Text(
                        "${get_combined_balance_usd().toString()}\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                      ),
                  ],
                ),

                SizedBox(height: 16),

                // save button
                Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.save_outlined), //
                    label: Text("Add Revenue Payment"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: on_save, //
                  ),
                ),

                // remove button
                if (has_existing) ...[
                  SizedBox(height: 8),
                  Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.delete_outlined), //
                      label: Text("Remove All Revenue Data"),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: on_remove, //
                    ),
                  ),
                ],
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
    double paid_total_usd = paid_bank_usd + paid_cash_usd + (paid_bank_khr + paid_cash_khr) / global.RATE;

    return paid_total_usd;
  }

  double get_return_total_usd() {
    double return_usd = double.tryParse(c_return_usd.text) ?? 0;
    double return_khr = double.tryParse(c_return_khr.text) ?? 0;

    return return_usd + (return_khr / global.RATE);
  }

  double get_balance_usd() {
    return get_price_total_usd() - get_paid_total_usd() + get_return_total_usd();
  }

  double get_existing_price_total_usd() {
    return double.tryParse(existing[schema.REVENUE_PRICE_TOTAL_USD]?.toString() ?? "") ?? 0;
  }

  double get_existing_paid_total_usd() {
    return double.tryParse(existing[schema.REVENUE_PAID_TOTAL_USD]?.toString() ?? "") ?? 0;
  }

  double get_existing_return_total_usd() {
    return double.tryParse(existing[schema.REVENUE_RETURN_TOTAL_USD]?.toString() ?? "") ?? 0;
  }

  double get_combined_price_total_usd() {
    return get_existing_price_total_usd() + get_price_total_usd();
  }

  double get_combined_paid_total_usd() {
    return get_existing_paid_total_usd() + get_paid_total_usd();
  }

  double get_combined_return_total_usd() {
    return get_existing_return_total_usd() + get_return_total_usd();
  }

  double get_combined_balance_usd() {
    return get_combined_price_total_usd() - get_combined_paid_total_usd() + get_combined_return_total_usd();
  }

  void on_save() async {
    try {
      //
      final now_response = await dio.post("/setting/now");
      if (DateTime.tryParse(now_response.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(now_response.data.toString())!;

      //
      double new_price = get_price_total_usd();
      double new_paid = get_paid_total_usd();
      double new_return = get_return_total_usd();
      double existing_price = get_existing_price_total_usd();
      double existing_paid = get_existing_paid_total_usd();
      double existing_return = get_existing_return_total_usd();

      double combine_price = existing_price + new_price;
      double combine_paid = existing_paid + new_paid;
      double combine_return = existing_return + new_return;
      double combine_balance = combine_price - combine_paid + combine_return;

      //
      double add_bank_usd = double.tryParse(c_paid_bank_usd.text) ?? 0;
      double add_cash_usd = double.tryParse(c_paid_cash_usd.text) ?? 0;
      double add_bank_khr = double.tryParse(c_paid_bank_khr.text) ?? 0;
      double add_cash_khr = double.tryParse(c_paid_cash_khr.text) ?? 0;
      double add_return_usd = double.tryParse(c_return_usd.text) ?? 0;
      double add_return_khr = double.tryParse(c_return_khr.text) ?? 0;

      double exist_bank_usd = double.tryParse(existing[schema.REVENUE_PAID_BANK_USD]?.toString() ?? "") ?? 0;
      double exist_cash_usd = double.tryParse(existing[schema.REVENUE_PAID_CASH_USD]?.toString() ?? "") ?? 0;
      double exist_bank_khr = double.tryParse(existing[schema.REVENUE_PAID_BANK_KHR]?.toString() ?? "") ?? 0;
      double exist_cash_khr = double.tryParse(existing[schema.REVENUE_PAID_CASH_KHR]?.toString() ?? "") ?? 0;
      double exist_return_usd = double.tryParse(existing[schema.REVENUE_RETURN_USD]?.toString() ?? "") ?? 0;
      double exist_return_khr = double.tryParse(existing[schema.REVENUE_RETURN_KHR]?.toString() ?? "") ?? 0;

      //
      schema.data[schema.REVENUE_PRICE_TOTAL_USD]?["value"] = combine_price;
      schema.data[schema.REVENUE_PAID_BANK_USD]?["value"] = exist_bank_usd + add_bank_usd;
      schema.data[schema.REVENUE_PAID_CASH_USD]?["value"] = exist_cash_usd + add_cash_usd;
      schema.data[schema.REVENUE_PAID_BANK_KHR]?["value"] = exist_bank_khr + add_bank_khr;
      schema.data[schema.REVENUE_PAID_CASH_KHR]?["value"] = exist_cash_khr + add_cash_khr;
      schema.data[schema.REVENUE_PAID_TOTAL_USD]?["value"] = combine_paid;
      schema.data[schema.REVENUE_RETURN_USD]?["value"] = exist_return_usd + add_return_usd;
      schema.data[schema.REVENUE_RETURN_KHR]?["value"] = exist_return_khr + add_return_khr;
      schema.data[schema.REVENUE_RETURN_TOTAL_USD]?["value"] = combine_return;
      schema.data[schema.REVENUE_BALANCE_TOTAL_USD]?["value"] = combine_balance;

      schema.data[schema.REVENUE_PAID_NOTE]?["value"] = c_note.text;
      schema.data[schema.REVENUE_PAID_BY_ID]?["value"] = u_schema.data[u_schema.ID]!["value"];
      schema.data[schema.REVENUE_PAID_BY]?["value"] = u_schema.data[u_schema.FULL_NAME]!["value"];
      schema.data[schema.REVENUE_PAID_AT]?["value"] = DateFormat(DATE_FORMAT).format(now);

      //
      final output = {for (var e in schema.data.entries) e.key: e.value["value"]};

      await dio.post(
        "/front_desk/update", //
        data: FormData.fromMap(output),
      );

      //
      Navigator.pop(context, true);

      snackbar_show(context: context, message: "Success", color: Colors.green);
      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }

  void on_remove() async {
    try {
      //
      schema.data[schema.REVENUE_PRICE_TOTAL_USD]?["value"] = null;
      schema.data[schema.REVENUE_PAID_BANK_USD]?["value"] = null;
      schema.data[schema.REVENUE_PAID_CASH_USD]?["value"] = null;
      schema.data[schema.REVENUE_PAID_BANK_KHR]?["value"] = null;
      schema.data[schema.REVENUE_PAID_CASH_KHR]?["value"] = null;
      schema.data[schema.REVENUE_PAID_TOTAL_USD]?["value"] = null;
      schema.data[schema.REVENUE_RETURN_USD]?["value"] = null;
      schema.data[schema.REVENUE_RETURN_KHR]?["value"] = null;
      schema.data[schema.REVENUE_RETURN_TOTAL_USD]?["value"] = null;
      schema.data[schema.REVENUE_BALANCE_TOTAL_USD]?["value"] = null;
      schema.data[schema.REVENUE_PAID_NOTE]?["value"] = null;
      schema.data[schema.REVENUE_PAID_BY_ID]?["value"] = null;
      schema.data[schema.REVENUE_PAID_BY]?["value"] = null;
      schema.data[schema.REVENUE_PAID_AT]?["value"] = null;

      //
      final output = {for (var e in schema.data.entries) e.key: e.value["value"]};

      await dio.post(
        "/front_desk/update", //
        data: FormData.fromMap(output),
      );

      //
      Navigator.pop(context, true);

      snackbar_show(context: context, message: "Revenue data removed.", color: Colors.orange);
      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
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
