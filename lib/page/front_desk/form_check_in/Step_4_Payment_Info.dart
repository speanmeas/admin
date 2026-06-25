import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_5_Summary.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '../__Setup__.dart';
import '../Schema.g.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
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
      home: Step_4_Payment_Info_(),
    );
  }
}

class Step_4_Payment_Info_ extends StatefulWidget {
  Step_4_Payment_Info_({super.key});

  @override
  State<Step_4_Payment_Info_> createState() => _Step_4_Payment_Info_State();
}

class _Step_4_Payment_Info_State extends State<Step_4_Payment_Info_> {
  TextEditingController? controller_paid_bank_usd;
  TextEditingController? controller_paid_bank_khr;

  // List<Map<String, dynamic>> rooms = [
  //   {"room_number": "101", "room_type": "Deluxe Room"},
  //   {"room_number": "102", "room_type": "Deluxe Room"},
  //   {"room_number": "103", "room_type": "Standard Room"},
  //   {"room_number": "104", "room_type": "Standard Room"},
  //   {"room_number": "105", "room_type": "Suite Room"},
  //   {"room_number": "106", "room_type": "Suite Room"},
  //   {"room_number": "107", "room_type": "Single Room"},
  //   {"room_number": "108", "room_type": "Single Room"},
  // ];

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment - Info.", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                  decoration: InputDecoration(
                    labelText: "Paid Bank (USD):",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(Icons.bed_outlined, size: 20, color: Colors.black),
                    suffixText: "\$",
                  ),
                  onChanged: (value) {
                    // row["value"] = double.tryParse(value);
                  },
                ),
              ),

              (() {
                String value = "8"; //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Price Total: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "$value\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                );
              })(),

              // paid bank usd and khr
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Bank (USD):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.account_balance, size: 20, color: Colors.black),
                          suffixText: "\$",
                        ),
                        onChanged: (v) {
                          // if (v.isEmpty) {
                          //   Model.paid_bank_usd = 0;
                          //   setState(() {});
                          //   return;
                          // }

                          // if (double.tryParse(v) == null) {
                          //   controller_paid_bank_usd.text = v.substring(0, v.length - 1);
                          //   controller_paid_bank_usd.selection = TextSelection.collapsed(offset: controller_paid_bank_usd.text.length);
                          // }

                          // Model.paid_bank_usd = double.tryParse(v) ?? 0;
                          // setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Bank (KHR):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.account_balance, size: 20, color: Colors.black), //
                          suffixText: "៛",
                        ),
                        onChanged: (v) {
                          // if (double.tryParse(v) == null) {
                          //   controller_paid_bank_khr.text = v.substring(0, v.length - 1);
                          //   controller_paid_bank_khr.selection = TextSelection.collapsed(offset: controller_paid_bank_khr.text.length);
                          // }

                          // Model.paid_bank_khr = double.tryParse(v) ?? 0;
                          // setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // paid bank usd and khr
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Cash (USD):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.payments_outlined, size: 20, color: Colors.black), //
                          suffixText: "\$",
                        ),
                        onChanged: (v) {
                          // if (v.isEmpty) {
                          //   Model.paid_bank_usd = 0;
                          //   setState(() {});
                          //   return;
                          // }

                          // if (double.tryParse(v) == null) {
                          //   controller_paid_bank_usd.text = v.substring(0, v.length - 1);
                          //   controller_paid_bank_usd.selection = TextSelection.collapsed(offset: controller_paid_bank_usd.text.length);
                          // }

                          // Model.paid_bank_usd = double.tryParse(v) ?? 0;
                          // setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Paid Cash (KHR):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.payments_outlined, size: 20, color: Colors.black), //
                          suffixText: "៛",
                        ),
                        onChanged: (v) {
                          // if (double.tryParse(v) == null) {
                          //   controller_paid_bank_khr.text = v.substring(0, v.length - 1);
                          //   controller_paid_bank_khr.selection = TextSelection.collapsed(offset: controller_paid_bank_khr.text.length);
                          // }

                          // Model.paid_bank_khr = double.tryParse(v) ?? 0;
                          // setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              (() {
                String value = "8"; //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Paid Total: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "$value\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                );
              })(),

              // return  usd and khr
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_usd,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          labelText: "Return (USD):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.payments_outlined, size: 20, color: Colors.black), //
                          suffixText: "\$",
                        ),
                        onChanged: (v) {
                          // if (v.isEmpty) {
                          //   Model.paid_bank_usd = 0;
                          //   setState(() {});
                          //   return;
                          // }

                          // if (double.tryParse(v) == null) {
                          //   controller_paid_bank_usd.text = v.substring(0, v.length - 1);
                          //   controller_paid_bank_usd.selection = TextSelection.collapsed(offset: controller_paid_bank_usd.text.length);
                          // }

                          // Model.paid_bank_usd = double.tryParse(v) ?? 0;
                          // setState(() {});
                        },
                      ),
                    ),

                    SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        controller: controller_paid_bank_khr,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: "Return (KHR):",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.payments_outlined, size: 20, color: Colors.black), //
                          suffixText: "៛",
                        ),
                        onChanged: (v) {
                          // if (double.tryParse(v) == null) {
                          //   controller_paid_bank_khr.text = v.substring(0, v.length - 1);
                          //   controller_paid_bank_khr.selection = TextSelection.collapsed(offset: controller_paid_bank_khr.text.length);
                          // }

                          // Model.paid_bank_khr = double.tryParse(v) ?? 0;
                          // setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              (() {
                String value = "8"; //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Return Total: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "$value\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                );
              })(),

              (() {
                String value = "8"; //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("A/R Total: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "$value\$",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                );
              })(),

              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.arrow_right_alt_outlined),
                  label: Text("Next"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: on_next,
                ),
              ),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void on_next() async {
    //

    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => Step_5_Summary_()),
    );

    //   Map<String, dynamic> output = {for (var s in schema) s["key"]: s["value"]};

    //   await dio
    //       .post('$PATH/data_create', data: FormData.fromMap({...output}))
    //       .then((r) {
    //         // output["id"] = r.data["id"]; //
    //         snackbar_show(context: context, message: "$HEADER create successfully.", color: Colors.green);
    //         Navigator.pop(context, output);
    //       })
    //       .catchError((error) {
    //         snackbar_show(context: context, message: "$HEADER create failed.", color: Colors.red);
    //       });
  }
}
