import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/theme/Theme_Data.dart';

import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '__Setup__.dart';
import 'Schema.g.dart';

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
      home: Form_Create_(),
    );
  }
}

class Form_Create_ extends StatefulWidget {
  Form_Create_({
    super.key, //
  });

  @override
  State<Form_Create_> createState() => _Form_Create_State();
}

class _Form_Create_State extends State<Form_Create_> {
  //

  TextEditingController controller_nationality = TextEditingController();
  List<String> option_nationalities = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post('/nationality/data_read', data: FormData.fromMap({}))
        .then((r) {
          option_nationalities = List<String>.from(r.data.map((e) => e["nationality"]));
          option_nationalities.sort((a, b) => a.compareTo(b));
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create - $HEADER", //
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

                // finite list of options
                if (row["key"] == "guest_nationality") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TypeAheadField<String>(
                      controller: controller_nationality,
                      suggestionsCallback: (query) {
                        List<String> result = [];
                        for (var e in option_nationalities) {
                          if (e.toLowerCase().contains(query.toLowerCase())) {
                            result.add(e);
                          }
                        }
                        return result;
                      },
                      builder: (context, controller, focusNode) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: row['title'] + ":",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: IconButton(
                                icon: Icon(Icons.clear, size: 24, color: Colors.red), //
                                onPressed: controller.clear,
                              ),
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context, item) {
                        return ListTile(title: Text(item));
                      },
                      onSelected: (selected) {
                        row["value"] = selected; //
                        controller_nationality.text = selected;
                        setState(() {});
                      },
                    ),
                  );
                }

                // gender
                if (row["key"] == "guest_gender") {
                  List<String> options = ["Male", "Female", "Other"];
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: row['title'] + ":",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
                      items: options.map((i) {
                        return DropdownMenuItem<String>(value: i, child: Text(i));
                      }).toList(),
                      onChanged: (v) {
                        row["value"] = v; //
                        setState(() {});
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
                  List<String> options = ["Yes", "No"];
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
                      items: options.map((i) {
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
                        row["value"] = DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime);
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
                  icon: Icon(Icons.check),
                  label: Text("Create"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: on_create,
                ),
              ),

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }

  void on_create() async {
    //

    Map<String, dynamic> output = {};
    for (var s in schema) {
      output[s["key"]] = s["value"];
    }

    await dio
        .post('$PATH/data_create', data: FormData.fromMap({...output}))
        .then((r) {
          output["id"] = r.data["id"]; // NOTE: support to update and delete
          snackbar_show(context: context, message: "$HEADER create successfully.", color: Colors.green);
          Navigator.pop(context, output);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "$HEADER create failed.", color: Colors.red);
        });
  }
}
