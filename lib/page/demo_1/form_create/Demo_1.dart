import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '../__Setup__.dart';
import '../Schema.g.dart';

import 'Demo_1A.dart' as demo_1a;

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

                // skip _id
                if (row["key"].toString().contains("_id")) return SizedBox.shrink();

                // note
                if (row["key"] == "note") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Input", //
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
                        hintText: "Input", //
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
                        hintText: "Input", //
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

                // boolean
                if (row["type"] == "boolean") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: "Select", //
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

                // datetime
                if (row["type"] == "date-time") {
                  String value = row["value"]?.toString() ?? "";
                  if (value.isNotEmpty) {
                    DateTime? tmp = DateTime.tryParse(value);
                    if (tmp != null) {
                      value = DateFormat('yyyy-MM-dd HH:mm:ss').format(tmp.toLocal());
                    }
                  }
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: value), //
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Select", //
                        labelText: row['title'] + ":", //
                        border: OutlineInputBorder(), //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today, size: 20), //
                      ),
                      onTap: () async {
                        final DateTime? datetime = await datetime_picker(context);
                        if (datetime == null) return;
                        row["value"] = datetime.toIso8601String();
                        setState(() {});
                      }, //,
                    ),
                  );
                }

                // default
                return SizedBox.shrink();
              }),

              // button next
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

  void on_next() async {
    //

    print(schema);

    Navigator.push(
      context, //
      MaterialPageRoute(
        builder: (context) => demo_1a.Form_Create_(), //
      ),
    );
  }
}
