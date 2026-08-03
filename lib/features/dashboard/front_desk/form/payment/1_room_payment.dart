import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/features/auth/schema.g.dart" as u_schema;

import "../../__config__.dart";
import "../../schema.g.dart" as schema;

import "2_summary.dart" as step_2;
import "widget/number_input.dart" as n_input;

class _Main_State extends State<Main_> {
  final c_room_price_total_usd = TextEditingController();
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
    c_room_price_total_usd.text = schema.data[schema.ROOM_PRICE_TOTAL_USD]?["value"]?.toString() ?? "";
    c_paid_bank_usd.text = schema.data[schema.ROOM_PAID_BANK_USD]?["value"]?.toString() ?? "";
    c_paid_cash_usd.text = schema.data[schema.ROOM_PAID_CASH_USD]?["value"]?.toString() ?? "";
    c_paid_bank_khr.text = schema.data[schema.ROOM_PAID_BANK_KHR]?["value"]?.toString() ?? "";
    c_paid_cash_khr.text = schema.data[schema.ROOM_PAID_CASH_KHR]?["value"]?.toString() ?? "";
    c_return_usd.text = schema.data[schema.ROOM_RETURN_USD]?["value"]?.toString() ?? "";
    c_return_khr.text = schema.data[schema.ROOM_RETURN_KHR]?["value"]?.toString() ?? "";
    c_note.text = schema.data[schema.ROOM_PAID_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1. Payment - Room", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          OutlinedButton.icon(
            icon: Icon(Icons.arrow_right_alt_outlined),
            label: Text("Next"),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            onPressed: can_next() ? on_next : null, //
          ),
          SizedBox(width: 8),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
        //
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2), //
          child: LinearProgressIndicator(value: 1 / 2),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            alignment: Alignment.center,
            child: Column(
              children: [
                //

                // room price
                n_input.Main_(
                  controller: c_room_price_total_usd,
                  title: "Room Price (USD)", //
                  prefixIcon: Icons.attach_money_outlined,
                  suffixText: "\$",
                  onChanged: (v) => setState(() {}),
                ),

                // total price
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

                    // paid bank khr
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
                    // paid cash usd
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

                    // paid cash khr
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
                    Text("Total Paid: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                    // return usd
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

                    // return khr
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
                    Text("Total Return: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

                // balance
                Divider(height: 8, thickness: 1, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Balance : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

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
              ],
            ),
          ),
        ),
      ),
    );
  }

  double get_price_total_usd() {
    double price_total_usd = double.tryParse(c_room_price_total_usd.text) ?? 0;
    return price_total_usd;
  }

  double get_paid_total_usd() {
    double paid_bank_usd = double.tryParse(c_paid_bank_usd.text) ?? 0;
    double paid_cash_usd = double.tryParse(c_paid_cash_usd.text) ?? 0;
    double paid_bank_khr = double.tryParse(c_paid_bank_khr.text) ?? 0;
    double paid_cash_khr = double.tryParse(c_paid_cash_khr.text) ?? 0;
    double paid_total_usd = paid_bank_usd + paid_cash_usd + (paid_bank_khr + paid_cash_khr) / glob.RATE;

    return paid_total_usd;
  }

  double get_return_total_usd() {
    double return_usd = double.tryParse(c_return_usd.text) ?? 0;
    double return_khr = double.tryParse(c_return_khr.text) ?? 0;

    double return_total_usd = return_usd + (return_khr / glob.RATE);

    return return_total_usd;
  }

  double get_balance_usd() {
    double price_total_usd = get_price_total_usd();
    double paid_total_usd = get_paid_total_usd();
    double return_total_usd = get_return_total_usd();

    double balance_usd = price_total_usd - paid_total_usd + return_total_usd;

    return balance_usd;
  }

  bool can_next() {
    if (get_price_total_usd() > 0 && get_balance_usd() == 0) return true;

    return false;
  }

  void on_next() async {
    try {
      //
      final n = await dio.post("/setting/now");
      if (DateTime.tryParse(n.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(n.data.toString())!;

      schema.data[schema.ROOM_PRICE_TOTAL_USD]?["value"] = get_price_total_usd();
      schema.data[schema.ROOM_PAID_BANK_USD]?["value"] = double.tryParse(c_paid_bank_usd.text);
      schema.data[schema.ROOM_PAID_CASH_USD]?["value"] = double.tryParse(c_paid_cash_usd.text);
      schema.data[schema.ROOM_PAID_BANK_KHR]?["value"] = double.tryParse(c_paid_bank_khr.text);
      schema.data[schema.ROOM_PAID_CASH_KHR]?["value"] = double.tryParse(c_paid_cash_khr.text);
      schema.data[schema.ROOM_PAID_TOTAL_USD]?["value"] = get_paid_total_usd();
      schema.data[schema.ROOM_RETURN_USD]?["value"] = double.tryParse(c_return_usd.text);
      schema.data[schema.ROOM_RETURN_KHR]?["value"] = double.tryParse(c_return_khr.text);
      schema.data[schema.ROOM_RETURN_TOTAL_USD]?["value"] = get_return_total_usd();
      schema.data[schema.ROOM_BALANCE_TOTAL_USD]?["value"] = get_balance_usd();
      schema.data[schema.ROOM_PAID_NOTE]?["value"] = c_note.text;
      schema.data[schema.ROOM_PAID_BY_ID]?["value"] = u_schema.data[u_schema.ID]!["value"];
      schema.data[schema.ROOM_PAID_BY]?["value"] = u_schema.data[u_schema.FULL_NAME]!["value"];
      schema.data[schema.ROOM_PAID_AT]?["value"] = DateFormat(DATE_FORMAT).format(now);

      await Navigator.push(context, MaterialPageRoute(builder: (context) => step_2.Main_()));

      init();
      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
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
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
