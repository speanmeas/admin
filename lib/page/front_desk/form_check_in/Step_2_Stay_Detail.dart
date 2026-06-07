import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  TextEditingController controller_cool = TextEditingController();
  TextEditingController controller_duration_days = SearchController();
  TextEditingController controller_duration_hours = SearchController();

  ScrollController scroll_number_of_days = ScrollController();
  TextEditingController controller_number_of_days = TextEditingController(text: "0");

  ScrollController scroll_number_of_hours = ScrollController();
  TextEditingController controller_number_of_hours = TextEditingController(text: "0");

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
                padding: EdgeInsets.fromLTRB(8, 12, 8, 4),
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

              // input cooling type
              if (kDebugMode && false)
                Container(
                  width: 600,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller_cool,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), //
                            labelText: "Cooling Type:",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),

                      // ac
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.ac_unit), //
                          label: Text("AC"), //
                          onPressed: () {
                            controller_cool.text = "Air-Conditioner";
                            setState(() {});
                          }, //
                        ),
                      ),

                      // fan
                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.mode_fan_off_outlined), // todo: change icon to fan
                          label: Text("Fan"), //
                          onPressed: () {
                            controller_cool.text = "Fan";
                            setState(() {});
                          }, //
                        ),
                      ),
                    ],
                  ),
                ),

              // duration - number of days
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Column(
                  children: [
                    TextField(
                      controller: controller_number_of_days,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Duration (Days):",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),

                    SizedBox(height: 4),

                    //
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Scrollbar(
                            controller: scroll_number_of_days,
                            thumbVisibility: true,
                            thickness: 12, // scrollbar width
                            radius: const Radius.circular(0),
                            child: SingleChildScrollView(
                              controller: scroll_number_of_days,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                height: 50,
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    ...List.generate(30, (i) => i).map((e) {
                                      return Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            controller_number_of_days.text = e.toString();
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.nights_stay_outlined), //
                                          label: Text("$e"),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // duration - number of hours
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Column(
                  children: [
                    TextField(
                      controller: controller_number_of_hours,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Duration (Hours):",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),

                    SizedBox(height: 4),

                    //
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Scrollbar(
                            controller: scroll_number_of_hours,
                            thumbVisibility: true,
                            thickness: 12, // scrollbar width
                            radius: const Radius.circular(0),
                            child: SingleChildScrollView(
                              controller: scroll_number_of_hours,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                height: 50,
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    ...[0, 3, 6, 9, 12, 15, 18, 21].map((e) {
                                      return Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            controller_number_of_hours.text = e.toString();
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.timer_outlined), //
                                          label: Text("$e"),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //
              Divider(thickness: 1, color: Colors.grey),

              //
              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${NumberFormat("#,##0.##").format(get_price_total_usd() ?? 0)} USD", style: TextStyle(fontSize: 16)),
                        Text("or  ${NumberFormat("#,##0.##").format(get_price_total_khr() ?? 0)} KHR", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),

              //
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
    //
    Model_Check_In.stay_duration_day = controller_number_of_days.text;
    Model_Check_In.stay_duration_hour = controller_number_of_hours.text;

    //
    Model_Check_In.price_total_usd = get_price_total_usd()?.toString();
    Model_Check_In.price_total_khr = get_price_total_khr()?.toString();

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (_) => Payment_()),
    );
  }

  double? get_price_total_usd() {
    final days = int.tryParse(controller_number_of_days.text) ?? 0;
    final hours = int.tryParse(controller_number_of_hours.text) ?? 0;

    final price_per_day = double.tryParse(Model_Check_In.price_per_day?.toString() ?? '0') ?? 0;
    final price_per_3_hour = double.tryParse(Model_Check_In.price_per_3_hour?.toString() ?? '0') ?? 0;

    final total = (days * price_per_day) + ((hours / 3).ceil() * price_per_3_hour);

    return total;
  }

  double? get_price_total_khr() {
    final total_usd = get_price_total_usd() ?? 0;
    return total_usd * Global.RATE;
  }
}
