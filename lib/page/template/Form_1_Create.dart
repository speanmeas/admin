import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '__Setup__.dart';
import 'Schema.g.dart';

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
  //
  Map<String, dynamic> output = {};

  @override
  void initState() {
    super.initState();

    for (var e in schema) {
      output[e["key"]] = null;
    }
  }

  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create $HEADER", //
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
          ),
          SizedBox(width: 8),
        ],
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ...schema.map((row) {
                // print(row);

                // todo: handle foreign key

                // note - multi-line text
                if (row["key"] == "note") {
                  return Container(
                    width: 600,
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        // hintText: "Enter text...", //
                        border: OutlineInputBorder(),
                        labelText: "Note:", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row["key"]] = value; //
                      },
                    ),
                  );
                }

                // string
                if (row["kind"] == "string") {
                  return Container(
                    width: 600,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row["key"]] = value; //
                      },
                    ),
                  );
                }

                // number
                if (row["kind"] == "number") {
                  return Container(
                    width: 600,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row["key"]] = double.tryParse(value);
                      },
                    ),
                  );
                }

                if (row["kind"] == "boolean") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: DropdownButtonFormField<String>(
                      initialValue: "No",
                      decoration: InputDecoration(
                        labelText: row['title'],
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
                      ),
                      items: ["Yes", "No"].map((i) {
                        return DropdownMenuItem<String>(value: i, child: Text(i));
                      }).toList(),
                      onChanged: (v) {
                        if (v == "Yes") {
                          output[row["key"]] = true;
                        } else {
                          output[row["key"]] = false;
                        }
                        setState(() {});
                      },
                    ),
                  );
                }

                if (row["kind"] == "date-time") {
                  return Container(
                    width: 600,
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]] ?? ""),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //
                        labelText: row['title'], //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today), //
                      ),
                      onTap: () async {
                        final DateTime? datetime = await datetime_picker(context);
                        if (datetime == null) return;
                        output[row["key"]] = datetime_to_string(datetime);
                        setState(() {});
                      }, //,
                    ),
                  );
                }

                return SizedBox.shrink();
              }),

              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text("Create"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: create_pressed,
                  ),
                ],
              ),

              SizedBox(height: screen_height - 120),
            ],
          ),
        ),
      ),
    );
  }

  void create_pressed() async {
    //

    await dio
        .post(
          '$PATH/data_create',
          data: FormData.fromMap({
            ...output, //
          }),
        )
        .then((value) {
          // print(value);
          snackbar_show(context: context, message: "$HEADER create successfully.", color: Colors.green);
          Navigator.pop(context, true);
        })
        .catchError((error) {
          // print(error);
          snackbar_show(context: context, message: "$HEADER create failed.", color: Colors.red);
        });
  }
}
