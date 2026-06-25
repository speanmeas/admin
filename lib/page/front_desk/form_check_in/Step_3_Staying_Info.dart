import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_4_Payment_Info.dart';

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
      home: Step_3_Staying_Info_(),
    );
  }
}

class Step_3_Staying_Info_ extends StatefulWidget {
  Step_3_Staying_Info_({super.key});

  @override
  State<Step_3_Staying_Info_> createState() => _Step_3_Staying_Info_State();
}

class _Step_3_Staying_Info_State extends State<Step_3_Staying_Info_> {
  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Staying - Info.", //
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
              // number of guests
              (() {
                var options = List.generate(10, (index) => index + 1);
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Autocomplete<int>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      // if (textEditingValue.text.isEmpty) {
                      //   return const Iterable<int>.empty();
                      // }
                      return options.where((option) => option.toString().toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    optionsMaxHeight: double.infinity,
                    onSelected: (int selection) {
                      // row["value"] = selection;
                      print('You just selected $selection');
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          // hintText: "Select | Input", //
                          labelText: "Number of Guests:", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.clear, size: 24, color: Colors.red), //
                              onPressed: () {
                                controller.clear();
                                // row["value"] = "";
                              },
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          // row["value"] = value;
                        },
                        onSubmitted: (_) => onFieldSubmitted(),
                      );
                    },
                  ),
                );
              })(),

              // stay duration days
              (() {
                var options = List.generate(31, (index) => index);
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Autocomplete<int>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      // if (textEditingValue.text.isEmpty) {
                      //   return const Iterable<int>.empty();
                      // }
                      return options.where((option) => option.toString().toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    optionsMaxHeight: double.infinity,
                    onSelected: (int selection) {
                      // row["value"] = selection;
                      print('You just selected $selection');
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          // hintText: "Select | Input", //
                          labelText: "Stay Duration (Days):", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.clear, size: 24, color: Colors.red), //
                              onPressed: () {
                                controller.clear();
                                // row["value"] = "";
                              },
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          // row["value"] = value;
                        },
                        onSubmitted: (_) => onFieldSubmitted(),
                      );
                    },
                  ),
                );
              })(),

              // stay duration hour
              (() {
                var options = [0, 3, 6, 9, 12];
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Autocomplete<int>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      // if (textEditingValue.text.isEmpty) {
                      //   return const Iterable<int>.empty();
                      // }
                      return options.where((option) => option.toString().toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    optionsMaxHeight: double.infinity,
                    onSelected: (int selection) {
                      // row["value"] = selection;
                      print('You just selected $selection');
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(
                          // hintText: "Select | Input", //
                          labelText: "Stay Duration (Hours):", //
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: IconButton(
                              icon: Icon(Icons.clear, size: 24, color: Colors.red), //
                              onPressed: () {
                                controller.clear();
                                // row["value"] = "";
                              },
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          // row["value"] = value;
                        },
                        onSubmitted: (_) => onFieldSubmitted(),
                      );
                    },
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
      MaterialPageRoute(builder: (context) => Step_4_Payment_Info_()),
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
