import "package:dio/dio.dart";
import "package:flutter/material.dart";
// import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "../../__config__.dart";

import "../../schema.w.dart" as schema_w;

import "package:speanmeas/page/auth/schema.r.dart" as user_r;

import "4_summary.dart" as step_4;

import "widget/input_number.dart" as input_number;

class _Main_State extends State<Main_> {
  final c_room_price_total_usd = TextEditingController();
  final c_paid_bank_usd = TextEditingController();
  final c_paid_bank_khr = TextEditingController();
  final c_paid_cash_usd = TextEditingController();
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
    c_room_price_total_usd.text = schema_w.data[schema_w.ROOM_PRICE_TOTAL_USD]?["value"]?.toString() ?? "";
    c_paid_bank_usd.text = schema_w.data[schema_w.ROOM_PAID_BANK_USD]?["value"]?.toString() ?? "";
    c_paid_bank_khr.text = schema_w.data[schema_w.ROOM_PAID_BANK_KHR]?["value"]?.toString() ?? "";
    c_paid_cash_usd.text = schema_w.data[schema_w.ROOM_PAID_CASH_USD]?["value"]?.toString() ?? "";
    c_paid_cash_khr.text = schema_w.data[schema_w.ROOM_PAID_CASH_KHR]?["value"]?.toString() ?? "";
    c_return_usd.text = schema_w.data[schema_w.ROOM_RETURN_USD]?["value"]?.toString() ?? "";
    c_return_khr.text = schema_w.data[schema_w.ROOM_RETURN_KHR]?["value"]?.toString() ?? "";
    c_note.text = schema_w.data[schema_w.ROOM_PAID_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "3. Room Payment", //
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
              onPressed: on_next,
            ),
          ),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2), //
          child: LinearProgressIndicator(value: 3 / 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // room price
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: input_number.Main_(
                  controller: c_room_price_total_usd,
                  title: "Room Price (USD):",
                  prefixIcon: Icons.bed_outlined,
                  suffixText: "\$",
                  onChanged: (v) {
                    schema_w.data[schema_w.ROOM_PRICE_TOTAL_USD]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),

              // total price
              Container(
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
                      "${get_price_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
              ),

              // paid bank
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // paid bank usd
                    Expanded(
                      child: input_number.Main_(
                        controller: c_paid_bank_usd,
                        title: "Paid Bank (USD):",
                        prefixIcon: Icons.account_balance,
                        suffixText: "\$",
                        onChanged: (v) {
                          schema_w.data[schema_w.ROOM_PAID_BANK_USD]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    // paid bank khr
                    Expanded(
                      child: input_number.Main_(
                        controller: c_paid_bank_khr,
                        title: "Paid Bank (KHR):",
                        prefixIcon: Icons.account_balance,
                        suffixText: "៛",
                        onChanged: (v) {
                          schema_w.data[schema_w.ROOM_PAID_BANK_KHR]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // paid cash
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // paid cash usd
                    Expanded(
                      child: input_number.Main_(
                        controller: c_paid_cash_usd,
                        title: "Paid Cash (USD):",
                        prefixIcon: Icons.account_balance_wallet_outlined,
                        suffixText: "\$",
                        onChanged: (v) {
                          schema_w.data[schema_w.ROOM_PAID_CASH_USD]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    // paid cash khr
                    Expanded(
                      child: input_number.Main_(
                        controller: c_paid_cash_khr,
                        title: "Paid Cash (KHR):",
                        prefixIcon: Icons.account_balance_wallet_outlined,
                        suffixText: "៛",
                        onChanged: (v) {
                          schema_w.data[schema_w.ROOM_PAID_CASH_KHR]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // total paid
              Container(
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
                      "${get_paid_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
              ),

              // return
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // return usd
                    Expanded(
                      child: input_number.Main_(
                        controller: c_return_usd,
                        title: "Return Cash (USD):",
                        prefixIcon: Icons.account_balance_wallet_outlined,
                        suffixText: "\$",
                        onChanged: (v) {
                          schema_w.data[schema_w.ROOM_RETURN_USD]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    // return khr
                    Expanded(
                      child: input_number.Main_(
                        controller: c_return_khr,
                        title: "Return Cash (KHR):",
                        prefixIcon: Icons.account_balance_wallet_outlined,
                        suffixText: "៛",
                        onChanged: (v) {
                          schema_w.data[schema_w.ROOM_RETURN_KHR]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // total return
              Container(
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
                      "${get_return_total_usd().toString()}\$",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
              ),

              // note
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: c_note,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Note:",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    schema_w.data[schema_w.ROOM_PAID_NOTE]?["value"] = v;
                    setState(() {});
                  },
                ),
              ),

              // balance
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 4, 8, 16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black)),
                ),
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get_price_total_usd() {
    double price_total_usd = schema_w.data[schema_w.ROOM_PRICE_TOTAL_USD]?["value"] ?? 0;
    return price_total_usd;
  }

  double get_paid_total_usd() {
    double paid_bank_usd = schema_w.data[schema_w.ROOM_PAID_BANK_USD]?["value"] ?? 0;
    double paid_cash_usd = schema_w.data[schema_w.ROOM_PAID_CASH_USD]?["value"] ?? 0;
    double paid_bank_khr = schema_w.data[schema_w.ROOM_PAID_BANK_KHR]?["value"] ?? 0;
    double paid_cash_khr = schema_w.data[schema_w.ROOM_PAID_CASH_KHR]?["value"] ?? 0;
    double paid_total_usd = paid_bank_usd + paid_cash_usd + (paid_bank_khr + paid_cash_khr) / global.RATE;

    return paid_total_usd;
  }

  double get_return_total_usd() {
    double return_usd = schema_w.data[schema_w.ROOM_RETURN_USD]?["value"] ?? 0;
    double return_khr = schema_w.data[schema_w.ROOM_RETURN_KHR]?["value"] ?? 0;

    double return_total_usd = return_usd + (return_khr / global.RATE);

    return return_total_usd;
  }

  double get_balance_usd() {
    double price_total_usd = get_price_total_usd();
    double paid_total_usd = get_paid_total_usd();
    double return_total_usd = get_return_total_usd();

    double balance_usd = price_total_usd - paid_total_usd + return_total_usd;

    return balance_usd;
  }

  void on_next() async {
    try {
      schema_w.data[schema_w.ROOM_PAID_TOTAL_USD]?["value"] = get_paid_total_usd();
      schema_w.data[schema_w.ROOM_RETURN_TOTAL_USD]?["value"] = get_return_total_usd();
      schema_w.data[schema_w.ROOM_BALANCE_TOTAL_USD]?["value"] = get_balance_usd();

      //
      if (get_balance_usd() == 0) {
        final r = await dio.post("/setting/now");
        if (DateTime.tryParse(r.data.toString()) == null) throw Exception("Invalid date time from server.");
        DateTime now = DateTime.tryParse(r.data.toString())!;

        //
        schema_w.data[schema_w.ROOM_PAID_AT]?["value"] = DateFormat(DATE_FORMAT).format(now);
        if (user_r.data[user_r.ID]!["value"] != null) //
          schema_w.data[schema_w.ROOM_PAID_BY_LINK]?["value"] = user_r.data[user_r.ID]!["value"];
      }
      // clear data if no payment
      else {
        schema_w.data[schema_w.ROOM_PAID_BANK_USD]?["value"] = null;
        schema_w.data[schema_w.ROOM_PAID_CASH_USD]?["value"] = null;
        schema_w.data[schema_w.ROOM_PAID_BANK_KHR]?["value"] = null;
        schema_w.data[schema_w.ROOM_PAID_CASH_KHR]?["value"] = null;
        schema_w.data[schema_w.ROOM_RETURN_USD]?["value"] = null;
        schema_w.data[schema_w.ROOM_RETURN_KHR]?["value"] = null;
        schema_w.data[schema_w.ROOM_RETURN_TOTAL_USD]?["value"] = null;
        schema_w.data[schema_w.ROOM_PAID_TOTAL_USD]?["value"] = null;
        schema_w.data[schema_w.ROOM_PAID_BY_LINK]?["value"] = null;
        schema_w.data[schema_w.ROOM_PAID_AT]?["value"] = null;
      }

      // move to next page
      await Navigator.push(context, MaterialPageRoute(builder: (context) => step_4.Main_()));

      //
      init();
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
