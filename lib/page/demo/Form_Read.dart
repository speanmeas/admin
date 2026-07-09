import "package:dio/dio.dart";
import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Global.dart";
import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/Environment.dart";
import "package:speanmeas/theme/Theme_Data.dart";

import "_Setup.dart";
import "schema.g.dart" as schema;

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
      home: Main_(input: {}),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key, required this.input});

  final Map<String, dynamic> input;

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //

  Map<String, dynamic> output = {};

  @override
  void initState() {
    super.initState();
    output = Map<String, dynamic>.from(widget.input);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Read - $HEADER", //
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
              ...schema.data.where((s) => s["hide"] == false).map((s) {
                //
                //
                //

                if (s["key"].toString().contains("note")) {
                  String value = output[s["key"]]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s["title"] + ": ", //
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
                }

                //
                //
                //

                //
                if (s["type"] == "string") {
                  String value = output[s["key"]]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s["title"] + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
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
                }

                //
                if (s["type"] == "number") {
                  String value = output[s["key"]]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s["title"] + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
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
                }

                //
                if (s["type"] == "boolean") {
                  String value = "";
                  if (output[s["key"]] == true) value = "Yes";
                  if (output[s["key"]] == false) value = "No";
                  if (output[s["key"]] == "Yes" || output[s["key"]] == "No") value = output[s["key"]].toString();
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s["title"] + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
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
                }

                //
                if (s["type"] == "date-time") {
                  String value = output[s["key"]]?.toString() ?? "";
                  if (value.isNotEmpty) {
                    DateTime? tmp = DateTime.tryParse(value);
                    if (tmp != null) {
                      value = DateFormat(DATE_FORMAT).format(tmp.toLocal());
                    }
                  }
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s["title"] + ": ", style: TextStyle(fontWeight: FontWeight.bold)),
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
                }

                //
                return SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
