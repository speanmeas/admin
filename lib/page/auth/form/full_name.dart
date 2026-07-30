import "package:flutter/material.dart";
import "package:dio/dio.dart";

import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  final c_full_name = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (schema.data[schema.FULL_NAME]!["value"] != null) //
      c_full_name.text = schema.data[schema.FULL_NAME]!["value"];

    setState(() {});
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update - Full Name", //
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
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: c_full_name,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Name:", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.blue),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          c_full_name.text = "";
                          setState(() {});
                        },
                      ), //
                    ),
                  ),
                  onSubmitted: (v) => on_update(),
                ),
              ),

              // button update
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.check), //
                  label: Text("Update"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: on_update,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void on_update() async {
    try {
      //

      String? full_name;
      if (c_full_name.text.trim().isNotEmpty) //
        full_name = c_full_name.text.trim();

      //
      final r = await dio.post(
        "/user/update_field", //
        data: FormData.fromMap({
          "_id": schema.data[schema.ID]!["value"], //
          "key": schema.FULL_NAME, //
          "value": full_name, //
        }),
      );

      //
      schema.data[schema.FULL_NAME]!["value"] = r.data[schema.FULL_NAME];
      Navigator.pop(context, true);

      //
      snackbar_show(context: context, message: "Success.", color: Colors.green);

      //
    } catch (e) {
      snackbar_show(context: context, message: e.toString(), color: Colors.red);
    }
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
