import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Setup.dart';
import 'Schema.g.dart';

void main() {
  runApp(Form_Update());
}

class Form_Update extends StatelessWidget {
  Form_Update({super.key});

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
      home: Form_Update_(input: input),
    );
  }
}

class Form_Update_ extends StatefulWidget {
  Form_Update_({
    super.key, //
    required this.input,
  });

  Map<String, dynamic> input;

  @override
  State<Form_Update_> createState() => _Form_Update_State();
}

class _Form_Update_State extends State<Form_Update_> {
  late Map<String, dynamic> output;

  final ScrollController controller_audios = ScrollController();
  final ScrollController controller_images = ScrollController();
  final ScrollController controller_videos = ScrollController();

  @override
  void initState() {
    super.initState();
    output = Map.from(widget.input);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update $HEADER", //
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
              ...schema.map((row) {
                if (row["is_exclude"] == 1) {
                  return SizedBox.shrink();
                }

                // edit string
                if (row["type"] == "text") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row["key"]] = value; //
                      },
                    ),
                  );
                }

                // edit number
                if (row["type"] == "number") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                      onChanged: (value) {
                        output[row["key"]] = double.tryParse(value);
                      },
                    ),
                  );
                }

                // edit datetime
                if (row["type"] == "datetime") {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                    child: Row(
                      children: [
                        Text("${row['title'] ?? ""} : "),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final DateTime? datetime = await datetime_picker(context);

                              if (datetime == null) return;

                              output[row["key"]] = datetime_to_string(datetime);

                              setState(() {});
                            },
                            label: Text(output[row["key"]] == null ? "Select Datetime" : output[row["key"]]!),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
              }),

              SizedBox(height: 8),

              Container(
                padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text(
                  "Audios:", //
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              Scrollbar(
                controller: controller_audios,
                thumbVisibility: true,
                // notificationPredicate: (_) => true,
                thickness: 12, // scrollbar width
                radius: const Radius.circular(0),
                // interactive: true,
                // scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  controller: controller_audios,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 10; i++)
                        Container(
                          width: 100, //
                          height: 100,
                          margin: EdgeInsets.fromLTRB(4, 4, 4, 20),
                          child: InkWell(
                            onTap: () {
                              // TODO: Handle image tap
                              print('Audio tapped: $i');
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
                                builder: (BuildContext context) {
                                  return Wrap(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.mic_external_on_sharp),
                                        title: Text('Open Audio Recorder'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.upload_outlined),
                                        title: Text('Upload'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.delete_outlined),
                                        title: Text('Delete'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Placeholder(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8),

              Container(
                padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text(
                  "Images:", //
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

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
                      for (int i = 0; i < 10; i++)
                        Container(
                          width: 100, //
                          height: 100,
                          margin: EdgeInsets.fromLTRB(4, 4, 4, 20),
                          child: InkWell(
                            onTap: () {
                              // TODO: Handle image tap
                              print('Image tapped: $i');
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
                                builder: (BuildContext context) {
                                  return Wrap(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera_alt_outlined),
                                        title: Text('Open Camera'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.upload_outlined),
                                        title: Text('Upload'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.delete_outlined),
                                        title: Text('Delete'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Placeholder(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8),

              Container(
                padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text(
                  "Videos:", //
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              Scrollbar(
                controller: controller_videos,
                thumbVisibility: true,
                // notificationPredicate: (_) => true,
                thickness: 12, // scrollbar width
                radius: const Radius.circular(0),
                // interactive: true,
                // scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  controller: controller_videos,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 10; i++)
                        Container(
                          width: 100, //
                          height: 100,
                          margin: EdgeInsets.fromLTRB(4, 4, 4, 20),
                          child: InkWell(
                            onTap: () {
                              // TODO: Handle video tap
                              print('Video tapped: $i');
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
                                builder: (BuildContext context) {
                                  return Wrap(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.video_camera_back_outlined),
                                        title: Text('Open Camera'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.upload_outlined),
                                        title: Text('Upload'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.delete_outlined),
                                        title: Text('Delete'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Placeholder(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.edit_outlined),
                    label: Text("Update"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: () async {
                      print(output);
                      await dio
                          .post(
                            '$PATH/update',
                            data: FormData.fromMap({
                              ...output, //
                            }),
                          )
                          .then((value) {
                            // print(value);
                            snackbar_show(
                              context: context, //
                              message: "Room update successfully",
                              color: Colors.green,
                            );
                            Navigator.pop(context, output);
                          })
                          .catchError((error) {
                            // print(error);
                            snackbar_show(
                              context: context, //
                              message: "Room update failed",
                              color: Colors.red,
                            );
                          });
                    },
                  ),
                ],
              ),

              SizedBox(height: 1000),
            ],
          ),
        ),
      ),
    );
  }
}
