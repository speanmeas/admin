import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/schema/demo_1.g.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  void init() async {
    try {
      sm_demo_1.clear();

      tmp = await dio.post(
        endpoint.DEMO_1_READ_ID, //
        data: {sm_demo_1.ID: widget.id},
      );
      for (var e in sm_demo_1.data.entries) e.value["value"] = tmp.data[0][e.key];

      setState(() {});
      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Read", //
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 8),
              for (var e in sm_demo_1.data.entries)
                (() {
                  if (e.value["type"] == "string") {
                    String value = "";
                    if (e.value["value"] != null) value = e.value["value"].toString();
                    if (e.key.contains("password")) value = "**********";
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Show_Data(
                        title: e.value["title"], //
                        value: value,
                        max_lines: e.key.contains("note") ? 4 : 1,
                      ),
                    );
                  }

                  //
                  if (e.value["type"] == "number") {
                    String value = "";
                    if (e.value["value"] != null) value = e.value["value"].toStringAsFixed(2);
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Show_Data(
                        title: e.value["title"], //
                        value: value,
                      ),
                    );
                  }

                  //
                  // * ថ្ងៃខែឆ្នាំ និង ម៉ោង
                  if (e.value["type"] == "date-time") {
                    String value = "";
                    if (e.value["value"] != null) {
                      final tmp = DateTime.tryParse(e.value["value"].toString());
                      if (tmp != null) value = DateFormat(DEFAULT_DATE_FORMAT).format(tmp.toLocal());
                    }
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Show_Data(
                        title: e.value["title"], //
                        value: value,
                      ),
                    );
                  }

                  //
                  if (e.value["type"] == "boolean") {
                    String value = "";
                    if (e.value["value"] != null) {
                      if (e.value["value"] == true) value = "Yes";
                      if (e.value["value"] == false) value = "No";
                    }
                    return Container(
                      width: 600,
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Show_Data(
                        title: e.value["title"], //
                        value: value,
                      ),
                    );
                  }
                  //
                  return SizedBox();
                })(),

              SizedBox(height: height - 100),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id,
  });

  final String id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(id: "1"),
      debugShowCheckedModeBanner: false,
    ),
  );
}
