import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

import 'Setup.dart';
import 'Schema.g.dart';

void main() {
  runApp(Read());
}

class Read extends StatelessWidget {
  Read({super.key});

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
      home: Read_(input: input),
    );
  }
}

class Read_ extends StatefulWidget {
  Read_({
    super.key, //
    required this.input,
  });

  Map<String, dynamic> input;

  @override
  State<Read_> createState() => _Read_State();
}

class _Read_State extends State<Read_> {
  late Map<String, dynamic> output;

  @override
  void initState() {
    super.initState();

    output = Map.from(widget.input);

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

              ...schema.map((e) {
                //
                if (["_id", "created_at", "updated_at", "deleted_at"].contains(e["alias"])) {
                  return SizedBox.shrink();
                }

                //
                if (e["type"] == "string") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
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
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
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

                //
                if (e["type"] == "datetime") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
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

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < 10; i++)
                      Container(
                        width: 100, //
                        height: 100,
                        margin: EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            // TODO: Handle image tap
                            print('Image tapped: $i');
                          },
                          child: Placeholder(),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 1000),
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
