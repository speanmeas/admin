import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_2_Guest_Info.dart';

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
      home: Step_1_Room_Info_(),
    );
  }
}

class Step_1_Room_Info_ extends StatefulWidget {
  Step_1_Room_Info_({super.key});

  @override
  State<Step_1_Room_Info_> createState() => _Step_1_Room_Info_State();
}

class _Step_1_Room_Info_State extends State<Step_1_Room_Info_> {
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
          "Room - Info.", //
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
              (() {
                var options = List.generate(100, (index) => (100 + index).toString());
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      // if (textEditingValue.text.isEmpty) {
                      //   return const Iterable<String>.empty();
                      // }
                      return options.where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    optionsMaxHeight: double.infinity,
                    onSelected: (String selection) {
                      // row["value"] = selection;
                      print('You just selected $selection');
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: true,
                        decoration: InputDecoration(
                          // hintText: "Search", //
                          labelText: "Room Number:", //
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

              (() {
                // String value = output[row["key"]]?.toString() ?? "";
                String value = "Deluxe Room"; //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Room Type: ", //
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                );
              })(),

              (() {
                // String value = output[row["key"]]?.toString() ?? "";
                String value = "15"; //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Room Price/Day: ", //
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                );
              })(),

              (() {
                // String value = output[row["key"]]?.toString() ?? "";
                String value = "8"; //
                return Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Room Price/3H: ", //
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 4,
                        ),
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
    Navigator.push(
      context, //
      MaterialPageRoute(builder: (context) => Step_2_Guest_Info_()),
    );

    //

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
