import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:speanmeas/Environment.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';

import 'Setup.dart';
import 'Schema.g.dart';

void main() {
  runApp(Form_Read());
}

class Form_Read extends StatelessWidget {
  Form_Read({super.key});

  Map<String, dynamic> input = {
    "id_": 1, //

    "text_1_": "a", //
    "text_2_": "aa", //
    "text_3_": "aaa", //
    "number_1_": 1,
    "number_2_": 11,
    "number_3_": 111,
    "datetime_1_": "2022-01-01 00:00:00",
    "datetime_2_": "2022-01-01 00:00:00",
    "datetime_3_": "2022-01-01 00:00:00",

    "created_at_": "2022-01-01 00:00:00",
    "updated_at_": "2022-01-01 00:00:00",
    "deleted_at_": "2022-01-01 00:00:00",
    "created_by_": "aaa",
    "updated_by_": "aaa",
    "deleted_by_": "aaa",
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Form_Read_(input: input),
    );
  }
}

class Form_Read_ extends StatefulWidget {
  Form_Read_({
    super.key, //
    required this.input,
  });

  Map<String, dynamic> input;

  @override
  State<Form_Read_> createState() => _Form_Read_State();
}

class _Form_Read_State extends State<Form_Read_> {
  late Map<String, dynamic> output;

  final ScrollController controller_audios = ScrollController();
  final ScrollController controller_images = ScrollController();
  final ScrollController controller_videos = ScrollController();

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

              ...schema.map((row) {
                //
                if (row["is_exclude"] == 1) {
                  return SizedBox.shrink();
                }

                //
                if (row["type"] == "text") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
                    ),
                  );
                }

                //
                if (row["type"] == "number") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]]?.toString() ?? '0'),
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
                    ),
                  );
                }

                //
                if (row["type"] == "datetime") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: row['title'], //
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

              if (output["images_"] != null)
                Container(
                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Text(
                    "Images:", //
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

              if (output["images_"] != null)
                Scrollbar(
                  controller: controller_images,
                  thumbVisibility: true,
                  // notificationPredicate: (_) => true,
                  thickness: 12, // scrollbar width
                  radius: const Radius.circular(0),
                  // interactive: true,
                  // scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    controller: controller_images,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < 10; i++) ...[
                          if (output["images_"][i.toString()] != null)
                            Container(
                              width: 100, //
                              height: 100,
                              margin: EdgeInsets.fromLTRB(4, 4, 4, 20),
                              child: InkWell(
                                onTap: () {
                                  // TODO: Handle image tap
                                  print('Image tapped: $i');
                                },
                                child: output["images_"] != null && output["images_"][i.toString()] != null
                                    ? Image.network(
                                        "$MINIO_PUBLIC/200/images/${output["images_"][i.toString()]}", //
                                        fit: BoxFit.cover, //
                                      )
                                    // : Placeholder(),
                                    : Placeholder(),
                              ),
                            ),
                        ],
                      ],
                    ),
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
