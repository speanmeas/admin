import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/page/front_desk/form_check_in/__Model__.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_3_Payment.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Stay_Detail(),
    ),
  );
}

class Stay_Detail extends StatelessWidget {
  const Stay_Detail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Stay_Detail_(),
    );
  }
}

class Stay_Detail_ extends StatefulWidget {
  const Stay_Detail_({super.key});

  @override
  State<Stay_Detail_> createState() => _Stay_Detail_State();
}

class _Stay_Detail_State extends State<Stay_Detail_> {
  //

  final scroll_number_of_days = ScrollController();
  final controller_number_of_days = TextEditingController(text: "0");
  final scroll_number_of_hours = ScrollController();
  final controller_number_of_hours = TextEditingController(text: "0");
  final controller_price_usd = TextEditingController();
  final controller_price_khr = TextEditingController();

  final stay_duration_day_options = const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final stay_duration_hour_options = const [0, 3, 6, 9, 12];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check In - Stay Detail", //
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

              // stay duration days
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: DropdownButtonFormField<int>(
                  initialValue: stay_duration_day_options.first,
                  decoration: InputDecoration(
                    labelText: "Duration (Days):",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  items: stay_duration_day_options.map((i) {
                    return DropdownMenuItem<int>(value: i, child: Text(i.toString()));
                  }).toList(),
                  onChanged: (v) {
                    Model.stay_duration_day = v ?? 0;
                    setState(() {});
                  },
                ),
              ),

              // stay duration hours
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: DropdownButtonFormField<int>(
                  initialValue: stay_duration_hour_options.first,
                  decoration: InputDecoration(
                    labelText: "Duration (Hours):",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  items: stay_duration_hour_options.map((i) {
                    return DropdownMenuItem<int>(value: i, child: Text(i.toString()));
                  }).toList(),
                  onChanged: (v) {
                    Model.stay_duration_hour = v ?? 0;
                    setState(() {});
                  },
                ),
              ),

              // price USD
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_price_usd,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: const InputDecoration(
                    labelText: "Price (USD):", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    if (v.isEmpty) {
                      Model.price_total_usd = 0;
                      controller_price_khr.text = "";
                      setState(() {});
                      return;
                    }

                    if (double.tryParse(v) == null) {
                      controller_price_usd.text = v.substring(0, v.length - 1);
                      controller_price_usd.selection = TextSelection.fromPosition(TextPosition(offset: controller_price_usd.text.length));
                      return;
                    }

                    Model.price_total_usd = double.tryParse(v) ?? 0;
                    Model.price_total_khr = Model.price_total_usd * Global.RATE;
                    controller_price_khr.text = (Model.price_total_usd * Global.RATE).toString();
                    setState(() {});
                  },
                ),
              ),

              // price KHR
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: controller_price_khr,
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                  decoration: InputDecoration(
                    labelText: "Price (KHR):",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    if (v.isEmpty) {
                      Model.price_total_khr = 0;
                      controller_price_usd.text = "";
                      setState(() {});
                      return;
                    }

                    if (double.tryParse(v) == null) {
                      controller_price_khr.text = v.substring(0, v.length - 1);
                      controller_price_khr.selection = TextSelection.fromPosition(TextPosition(offset: controller_price_khr.text.length));
                      return;
                    }

                    Model.price_total_khr = double.tryParse(v) ?? 0;
                    Model.price_total_usd = Model.price_total_khr / Global.RATE;

                    controller_price_usd.text = (Model.price_total_khr / Global.RATE).toString();
                    setState(() {});
                  },
                ),
              ),

              // button next
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
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Payment_()),
    );
  }
}
