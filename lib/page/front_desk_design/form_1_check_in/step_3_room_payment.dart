import "package:dio/dio.dart";
import "package:flutter/material.dart";
// import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

import "package:speanmeas/environment.dart";
import "package:speanmeas/global.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";
import "package:speanmeas/page/auth/user.g.dart" as user;

import "../_setup.dart";
import "../schema.g.dart" as schema;

import "step_4_summary.dart" as step_4;

import "widget/input_room_price.dart" as input_room_price;
import "widget/input_paid_bank_usd.dart" as input_paid_bank_usd;
import "widget/input_paid_cash_usd.dart" as input_paid_cash_usd;
import "widget/input_paid_bank_khr.dart" as input_paid_bank_khr;
import "widget/input_paid_cash_khr.dart" as input_paid_cash_khr;
import "widget/input_return_cash_usd.dart" as input_return_cash_usd;
import "widget/input_return_cash_khr.dart" as input_return_cash_khr;
import "widget/input_note.dart" as input_note;

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "3. Check In - Room Payment", //
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // room price
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: input_room_price.Main_(
                  initialValue: schema.data[schema.ROOM_PRICE_TOTAL_USD]?["value"],
                  onChanged: (v) {
                    schema.data[schema.ROOM_PRICE_TOTAL_USD]?["value"] = v;
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
                      child: input_paid_bank_usd.Main_(
                        initialValue: schema.data[schema.ROOM_PAID_BANK_USD]?["value"],
                        onChanged: (v) {
                          schema.data[schema.ROOM_PAID_BANK_USD]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    // paid bank khr
                    Expanded(
                      child: input_paid_bank_khr.Main_(
                        initialValue: schema.data[schema.ROOM_PAID_BANK_KHR]?["value"],
                        onChanged: (v) {
                          schema.data[schema.ROOM_PAID_BANK_KHR]?["value"] = v;
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
                      child: input_paid_cash_usd.Main_(
                        initialValue: schema.data[schema.ROOM_PAID_CASH_USD]?["value"],
                        onChanged: (v) {
                          schema.data[schema.ROOM_PAID_CASH_USD]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    // paid cash khr
                    Expanded(
                      child: input_paid_cash_khr.Main_(
                        initialValue: schema.data[schema.ROOM_PAID_CASH_KHR]?["value"],
                        onChanged: (v) {
                          schema.data[schema.ROOM_PAID_CASH_KHR]?["value"] = v;
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
                      child: input_return_cash_usd.Main_(
                        initialValue: schema.data[schema.ROOM_RETURN_USD]?["value"],
                        onChanged: (v) {
                          schema.data[schema.ROOM_RETURN_USD]?["value"] = v;
                          setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    // return khr
                    Expanded(
                      child: input_return_cash_khr.Main_(
                        initialValue: schema.data[schema.ROOM_RETURN_KHR]?["value"],
                        onChanged: (v) {
                          schema.data[schema.ROOM_RETURN_KHR]?["value"] = v;
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
                child: input_note.Main_(
                  initialValue: schema.data[schema.ROOM_PAYMENT_NOTE]?["value"]?.toString(),
                  onChanged: (v) {
                    schema.data[schema.ROOM_PAYMENT_NOTE]?["value"] = v;
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
    double price_total_usd = schema.data[schema.ROOM_PRICE_TOTAL_USD]?["value"] ?? 0;
    return price_total_usd;
  }

  double get_paid_total_usd() {
    double paid_bank_usd = schema.data[schema.ROOM_PAID_BANK_USD]?["value"] ?? 0;
    double paid_cash_usd = schema.data[schema.ROOM_PAID_CASH_USD]?["value"] ?? 0;
    double paid_bank_khr = schema.data[schema.ROOM_PAID_BANK_KHR]?["value"] ?? 0;
    double paid_cash_khr = schema.data[schema.ROOM_PAID_CASH_KHR]?["value"] ?? 0;
    double paid_total_usd = paid_bank_usd + paid_cash_usd + (paid_bank_khr + paid_cash_khr) / Global.variable.RATE;

    return paid_total_usd;
  }

  double get_return_total_usd() {
    double return_usd = schema.data[schema.ROOM_RETURN_USD]?["value"] ?? 0;
    double return_khr = schema.data[schema.ROOM_RETURN_KHR]?["value"] ?? 0;

    double return_total_usd = return_usd + (return_khr / Global.variable.RATE);

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
      //
      final response = await dio.post("/variable/datetime_now");
      if (DateTime.tryParse(response.data.toString()) == null) throw Exception("Invalid date time from server.");
      DateTime now = DateTime.tryParse(response.data.toString())!;

      //
      schema.data[schema.ROOM_PAID_TOTAL_USD]?["value"] = get_paid_total_usd();
      schema.data[schema.ROOM_RETURN_TOTAL_USD]?["value"] = get_return_total_usd();
      schema.data[schema.ROOM_BALANCE_TOTAL_USD]?["value"] = get_balance_usd();
      schema.data[schema.ROOM_PAYMENT_AT]?["value"] = DateFormat(DATE_FORMAT).format(now);

      // clear if no payment
      if (get_balance_usd() != 0) {
        schema.data[schema.ROOM_PAID_BANK_USD]?["value"] = null;
        schema.data[schema.ROOM_PAID_CASH_USD]?["value"] = null;
        schema.data[schema.ROOM_PAID_BANK_KHR]?["value"] = null;
        schema.data[schema.ROOM_PAID_CASH_KHR]?["value"] = null;
        schema.data[schema.ROOM_RETURN_USD]?["value"] = null;
        schema.data[schema.ROOM_RETURN_KHR]?["value"] = null;
        schema.data[schema.ROOM_RETURN_TOTAL_USD]?["value"] = null;
        schema.data[schema.ROOM_PAID_TOTAL_USD]?["value"] = null;
        schema.data[schema.ROOM_BALANCE_TOTAL_USD]?["value"] = null;
        schema.data[schema.ROOM_PAYMENT_AT]?["value"] = null;
      }

      if (user.data[user.ID]!["value"] != null) //
        schema.data[schema.ROOM_PAYMENT_BY_ID]?["value"] = user.data[user.ID]!["value"];
      if (user.data[user.USER_FULL_NAME]!["value"] != null) //
        schema.data[schema.ROOM_PAYMENT_BY]?["value"] = user.data[user.USER_FULL_NAME]!["value"];

      //
      Navigator.push(context, MaterialPageRoute(builder: (context) => step_4.Main_()));

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
