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

  String id = "69f984897186bcf74f8a5dde"; //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Form_Read_(id: id),
    );
  }
}

class Form_Read_ extends StatefulWidget {
  Form_Read_({
    super.key, //
    required this.id,
  });

  String id;

  @override
  State<Form_Read_> createState() => _Form_Read_State();
}

class _Form_Read_State extends State<Form_Read_> {
  Map<String, dynamic> output = {};

  final ScrollController controller_audios = ScrollController();
  final ScrollController controller_images = ScrollController();
  final ScrollController controller_videos = ScrollController();

  @override
  void initState() {
    super.initState();

    // output = Map.from(widget.input);

    // print(output);

    // print(output);
    // setState(() {});
    init();
  }

  void init() async {
    await dio
        .post(
          '$PATH/read',
          data: FormData.fromMap({
            "id_": widget.id, //
          }),
        ) //
        .then((r) {
          output = Map.from(r.data[0] ?? {});
          setState(() {});
        })
        .catchError((e) {
          print(e);
        });
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

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
                if (row["kind"] == "text") {
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
                if (row["kind"] == "number") {
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
                if (row["kind"] == "datetime") {
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

              if (output["images_"] != null && output["images_"].isNotEmpty)
                Container(
                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Text(
                    "Images:", //
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

              if (output["images_"] != null && output["images_"].isNotEmpty)
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

              SizedBox(height: screen_height - 120),
            ],
          ),
        ),
      ),
    );
  }
}
