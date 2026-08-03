import "package:flutter/material.dart";
import "package:dio/dio.dart";

import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;

import "../schema.g.dart" as schema;

class _Main_State extends State<Main_> {
  String username = schema.data[schema.USERNAME]!["value"] ?? "";
  final c_username = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (schema.data[schema.USERNAME]!["value"] != null) //
      c_username.text = schema.data[schema.USERNAME]!["value"];

    setState(() {});
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update - Username", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black),
        ),
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
                  controller: c_username,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Username:", //
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.blue),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          c_username.text = "";
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
    // todo: validation
    try {
      //
      String? username;
      if (c_username.text.isNotEmpty) //
        username = c_username.text;

      //
      final r = await dio.post(
        "/user/update_field", //
        data: FormData.fromMap({
          "_id": schema.data[schema.ID]!["value"], //
          "key": schema.USERNAME, //
          "value": username, //
        }),
      );

      //
      schema.data[schema.USERNAME]!["value"] = r.data[schema.USERNAME];
      Navigator.pop(context, true);

      //
      snackbar.view(context: context, message: "Success", color: Colors.green);

      //
    } catch (e) {
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
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
      theme: data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
