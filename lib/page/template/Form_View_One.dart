import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

import 'Initialize.dart';
import 'Schema.g.dart';

void main() {
  runApp(View_One());
}

class View_One extends StatelessWidget {
  View_One({super.key});

  Map<String, dynamic> input = {
    "_id": 1, //
    "name": "Room 1", //
    "type": null, //
    "capacity": 10,
    "ac_or_fan": "AC",
    "price": null,
    "status": "Active",
    "created_at": "2022-01-01 00:00:00",
    "updated_at": "2022-01-01 00:00:00",
    "deleted_at": null,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: View_One_(schema: schema, input: input),
    );
  }
}

class View_One_ extends StatefulWidget {
  View_One_({
    super.key, //
    required this.schema,
    required this.input,
  });

  List<Map<String, dynamic>> schema;
  Map<String, dynamic> input;

  @override
  State<View_One_> createState() => _View_One_State();
}

class _View_One_State extends State<View_One_> {
  late Map<String, dynamic> output;

  @override
  void initState() {
    super.initState();

    output = Map.from(widget.input);

    // for (var e in widget.schema.sublist(0, widget.schema.length - 3)) {
    //   output[e["alias"]] = null;
    // }

    print(output);

    // print(output);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View $HEADER", //
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
      body: Center(
        child: Container(
          width: 600,
          // alignment: Alignment.bottomCenter,
          child: ListView(
            children: [
              SizedBox(height: 16),

              Center(
                child: Container(
                  width: 200,
                  height: 200, //
                  child: Placeholder(),
                ),
              ),

              SizedBox(height: 16),

              ...widget.schema.map((e) {
                //
                if (["_id", "created_at", "updated_at", "deleted_at"].contains(e["alias"])) {
                  return SizedBox.shrink();
                }

                //
                if (e["type"] == "string") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: e['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
                    ),
                  );
                }

                //
                if (e["type"] == "number") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? '0'),
                      decoration: InputDecoration(
                        labelText: e['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
                    ),
                  );
                }

                // TODO: later
                if (e["type"] == "date-time") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[e['alias']]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: e['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
                    ),
                  );
                }

                //
                return SizedBox.shrink();
              }),

              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

void show_snackbar({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
