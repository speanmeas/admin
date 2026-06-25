import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/page/front_desk/form_check_in/Step_3_Staying_Info.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '../__Setup__.dart';
import '../../guest/Schema.g.dart';

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
      home: Step_2_Guest_Info_(),
    );
  }
}

class Step_2_Guest_Info_ extends StatefulWidget {
  Step_2_Guest_Info_({super.key});

  @override
  State<Step_2_Guest_Info_> createState() => _Step_2_Guest_Info_State();
}

class _Step_2_Guest_Info_State extends State<Step_2_Guest_Info_> {
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
          "Guest - Info.", //
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
              ...schema.map((row) {
                //
                //
                //

                // phone number - search
                if (row["key"] == "phone_number") {
                  var options = List.generate(10000, (index) => "0${12000000 + index}");
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
                          // autofocus: true,
                          decoration: InputDecoration(
                            // hintText: "Search", //
                            labelText: "Phone Number:", //
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
                }

                // note
                if (row["key"] == "note") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        // hintText: "Input", //
                        labelText: "Note:", //
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        row["value"] = value; //
                      },
                    ),
                  );
                }

                //
                //
                //

                // string
                if (row["type"] == "string") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        // hintText: "Input", //
                        labelText: row['title'] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        row["value"] = value; //
                      },
                    ),
                  );
                }

                // number
                if (row["type"] == "number") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                      decoration: InputDecoration(
                        // hintText: "Input", //
                        labelText: row['title'] + ":", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        row["value"] = double.tryParse(value);
                      },
                    ),
                  );
                }

                if (row["type"] == "boolean") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        // hintText: "Select", //
                        labelText: row['title'] + ":",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
                      items: ["Yes", "No"].map((i) {
                        return DropdownMenuItem<String>(value: i, child: Text(i));
                      }).toList(),
                      onChanged: (v) {
                        if (v == "Yes") {
                          row["value"] = true;
                        } else {
                          row["value"] = false;
                        }
                        setState(() {});
                      },
                    ),
                  );
                }

                if (row["type"] == "date-time") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: row["value"] ?? ""),
                      readOnly: true,
                      decoration: InputDecoration(
                        // hintText: "Select", //
                        labelText: row['title'] + ":", //
                        border: OutlineInputBorder(), //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today, size: 20), //
                      ),
                      onTap: () async {
                        final DateTime? datetime = await datetime_picker(context);
                        if (datetime == null) return;
                        row["value"] = datetime_to_string(datetime);
                        setState(() {});
                      }, //,
                    ),
                  );
                }

                return SizedBox.shrink();
              }),

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
      MaterialPageRoute(builder: (context) => Step_3_Staying_Info_()),
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
