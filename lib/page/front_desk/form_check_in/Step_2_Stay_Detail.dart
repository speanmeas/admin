import 'dart:convert';

import 'package:dio/dio.dart';
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

  List<Map<String, dynamic>> rooms = [];
  String? selectedStayType;

  late String? room_id = Model.data['room_id'];

  String? room_number;
  String? room_type;
  String? cooling_type;

  int? number_of_guests;

  double? price_ac_per_day_usd = 15;
  double? price_ac_per_day_khr = 60000;

  double? price_ac_per_3_hour_usd = 6;
  double? price_ac_per_3_hour_khr = 24000;

  double? price_fan_per_day_usd = 10;
  double? price_fan_per_day_khr = 40000;

  double? price_fan_per_3_hour_usd = 5;
  double? price_fan_per_3_hour_khr = 20000;

  int? duration_days = 0;
  int? duration_hours = 0;

  double? get_price_total_usd() {
    if (cooling_type == "ac") {
      return ((price_ac_per_day_usd ?? 0) * (duration_days ?? 0)) + ((price_ac_per_3_hour_usd ?? 0) * (duration_hours ?? 0) / 3);
    } else if (cooling_type == "fan") {
      return ((price_fan_per_day_usd ?? 0) * (duration_days ?? 0)) + ((price_fan_per_3_hour_usd ?? 0) * (duration_hours ?? 0) / 3);
    } else {
      return null;
    }
  }

  double? get_price_total_khr() {
    if (cooling_type == "ac") {
      return ((price_ac_per_day_khr ?? 0) * (duration_days ?? 0)) + ((price_ac_per_3_hour_khr ?? 0) * (duration_hours ?? 0) / 3);
    } else if (cooling_type == "fan") {
      return ((price_fan_per_day_khr ?? 0) * (duration_days ?? 0)) + ((price_fan_per_3_hour_khr ?? 0) * (duration_hours ?? 0) / 3);
    } else {
      return null;
    }
  }

  double? pay_by_cash_usd;
  double? pay_by_cash_khr;
  double? pay_by_bank_usd;
  double? pay_by_bank_khr;

  double? account_receivable_usd;
  double? account_receivable_khr;

  final controller_scrollbar_days = ScrollController();
  final controller_scrollbar_hours = ScrollController();

  TextEditingController? controller_days = TextEditingController();
  TextEditingController? controller_hours = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post(
          "/room/read_id",
          data: FormData.fromMap({
            "id": room_id, //
          }),
        )
        .then((r) {
          print(r.data);
          room_number = r.data['Name'].toString();
          room_type = r.data['Type'].toString();
          setState(() {});
        })
        .catchError((e) {});
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
              //
              SizedBox(height: 4),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 12, 8, 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Room Number: ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(
                      room_number ?? "",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [Text("Cooling Type: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))],
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(4, 4, 8, 8),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (cooling_type == "ac") Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                            if (cooling_type != "ac") Icon(Icons.radio_button_unchecked, size: 24), //
                            SizedBox(width: 4),
                            Text("Air-Conditioner", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          cooling_type = "ac";
                        });
                      },
                    ),

                    SizedBox(width: 4),

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (cooling_type == "fan") Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                            if (cooling_type != "fan") Icon(Icons.radio_button_unchecked, size: 24), //
                            SizedBox(width: 4),
                            Text("Fan", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          cooling_type = "fan";
                        });
                      },
                    ),
                  ],
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                child: Text(
                  "Duration (Days): ", //
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(4, 4, 8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Scrollbar(
                        controller: controller_scrollbar_days,
                        thumbVisibility: true,
                        thickness: 12, // scrollbar width
                        radius: const Radius.circular(0),
                        child: SingleChildScrollView(
                          controller: controller_scrollbar_days,
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.only(top: 4),
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                ...List.generate(31, (i) => i).map((e) {
                                  return InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (duration_days == e) Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                                          if (duration_days != e) Icon(Icons.radio_button_unchecked, size: 24), //
                                          SizedBox(width: 2),
                                          if (e == 0) //
                                            Text("None", style: TextStyle(fontSize: 16))
                                          else if (e == 1) //
                                            Text("1 Day", style: TextStyle(fontSize: 16))
                                          else //
                                            Text("$e Days", style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      duration_days = e;
                                      controller_days?.text = e.toString();
                                      setState(() {});
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 80,
                      child: TextField(
                        controller: controller_days,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Days",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) {
                          duration_days = int.tryParse(value);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.all(4),
                child: Text(
                  "Duration (Hours): ", //
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(4, 4, 8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Scrollbar(
                        controller: controller_scrollbar_hours,
                        thumbVisibility: true,
                        thickness: 12, // scrollbar width
                        radius: const Radius.circular(0),
                        child: SingleChildScrollView(
                          controller: controller_scrollbar_hours,
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.only(top: 4),
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                ...List.generate(8, (i) => i).map((e) {
                                  return InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (duration_hours == 3 * e) Icon(Icons.radio_button_checked, size: 24, color: Colors.blue), //
                                          if (duration_hours != 3 * e) Icon(Icons.radio_button_unchecked, size: 24), //
                                          SizedBox(width: 2),
                                          if (e == 0) //
                                            Text("None", style: TextStyle(fontSize: 16))
                                          else //
                                            Text("${3 * e} Hours", style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      duration_hours = 3 * e;
                                      controller_hours?.text = duration_hours.toString();
                                      setState(() {});
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 80,
                      child: TextField(
                        controller: controller_hours,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Hours",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) {
                          duration_hours = int.tryParse(value);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //
              Container(
                width: 600,
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Divider(thickness: 1, color: Colors.grey),
              ),

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
              Container(
                padding: EdgeInsets.all(8),
                child: OutlinedButton.icon(
                  label: Text("Next"),
                  icon: Icon(Icons.play_arrow_outlined, size: 32),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Payment_()));
                  }, //
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
}
