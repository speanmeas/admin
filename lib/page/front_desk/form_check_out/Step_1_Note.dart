import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/page/main/User.g.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '../__Setup__.dart';
import '../Schema.g.dart';

import 'Step_2_Summary.dart' as summary;

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
  var GET_PAID_DATE = "get_paid_date";
  var GET_PAID_BY = "get_paid_by";
  var CHECK_OUT_DATE = "check_out_date";
  var CHECK_OUT_BY = "check_out_by";
  var CHECK_OUT_BY_ID = "check_out_by_id";
  var check_out_note = "check_out_note";

  TextEditingController controller_note = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check Out - Note", //
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
              // note
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_note,
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
            ],
          ),
        ),
      ),
    );
  }

  void on_next() async {
    for (var s in schema) {
      if (s["key"] == CHECK_OUT_DATE) s["value"] = DateTime.now().toIso8601String();
      if (s["key"] == CHECK_OUT_BY) s["value"] = user["full_name"]!;
      if (s["key"] == CHECK_OUT_BY_ID) s["value"] = user["_id"]!["\$oid"]!;
      if (s["key"] == check_out_note) s["value"] = controller_note.text;
    }

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => summary.Main_()),
    );
  }
}
