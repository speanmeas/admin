import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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

  String id = "69f984897186bcf74f8a5dde";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Form_Update_(id: id),
    );
  }
}

class Form_Update_ extends StatefulWidget {
  Form_Update_({
    super.key, //
    required this.id,
  });

  String id;

  @override
  State<Form_Update_> createState() => _Form_Update_State();
}

class _Form_Update_State extends State<Form_Update_> {
  Map<String, dynamic> output = {};

  final ScrollController controller_audios = ScrollController();
  final ScrollController controller_images = ScrollController();
  final ScrollController controller_videos = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile?> selectedImages = List<XFile?>.filled(10, null);

  Future<void> pickImage(int index, {required ImageSource source}) async {
    final XFile? file = await _imagePicker.pickImage(source: source);
    if (file == null) return;
    setState(() {
      selectedImages[index] = file;
      output['image_${index + 1}_path'] = file.path;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post(
          '$PATH/data_read',
          data: FormData.fromMap({
            "id": widget.id, //
          }),
        ) //
        .then((r) {
          output = Map.from(r.data[0] ?? {});
          // print("Output: $output");
          setState(() {});
        })
        .catchError((_) {});
  }

  double screen_height = 0;

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ...schema.map((row) {
                //
                if (row["key"] == "note") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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

                //
                if (row["key"] == "password") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        hintText: "Enter new password", //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        output[row["key"]] = value; //
                      },
                    ),
                  );
                }

                //
                if (row["kind"] == "string") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]]?.toString() ?? ''),
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

                // edit number
                if (row["kind"] == "number") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: TextField(
                      controller: TextEditingController(text: output[row["key"]]?.toString() ?? ''),
                      decoration: InputDecoration(
                        labelText: row['title'], //
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                        final DateTime? datetime = await datetime_picker(
                          context, //
                          initial_datetime: output[row["key"]] != null ? DateTime.tryParse(output[row["key"]]) : null,
                        );
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

              // Images Upload
              // if (output["images_"] != null)
              Container(
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Images:", //
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),

              if (output["images"] != null)
                Container(
                  width: 600,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Scrollbar(
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
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
                                    builder: (BuildContext c) {
                                      return Wrap(
                                        children: [
                                          // ListTile(
                                          //   leading: Icon(Icons.camera_alt_outlined),
                                          //   title: Text('Open Camera'),
                                          //   onTap: () async {
                                          //     Navigator.pop(c);
                                          //   },
                                          // ),
                                          ListTile(
                                            leading: Icon(Icons.upload_outlined, color: Colors.blue),
                                            title: Text('Upload', style: TextStyle(color: Colors.blue)),
                                            onTap: () async {
                                              // hide bottom sheet
                                              Navigator.pop(c);

                                              final id = widget.id;
                                              final key = i.toString();

                                              // print('Upload image at index: $id, key: $key');

                                              final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

                                              // if no image selected
                                              if (image == null) return;

                                              // upload image to server
                                              await dio
                                                  .post(
                                                    '$PATH/file_upload', //
                                                    data: FormData.fromMap({
                                                      "id": id, //
                                                      "image_key": key, //
                                                      'image_value': MultipartFile.fromBytes(
                                                        await image.readAsBytes(), //
                                                        filename: image.name,
                                                      ),
                                                    }),
                                                  )
                                                  .then((r) {
                                                    init();
                                                    snackbar_show(context: context, message: "Uploaded", color: Colors.green);
                                                  })
                                                  .catchError((e) {
                                                    snackbar_show(context: context, message: 'Upload Failed.', color: Colors.red);
                                                  });
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.delete_outlined, color: Colors.red),
                                            title: Text('Delete', style: TextStyle(color: Colors.red)),
                                            onTap: () async {
                                              Navigator.pop(c);

                                              final id = widget.id;
                                              final key = i.toString();

                                              // print('Delete image at index: $id, key: $key');

                                              // delete image from server
                                              await dio
                                                  .post(
                                                    '$PATH/file_delete', //
                                                    data: FormData.fromMap({
                                                      "id": id, //
                                                      "image_key": key, //
                                                    }),
                                                  )
                                                  .then((r) {
                                                    init();
                                                    snackbar_show(context: context, message: "Image deleted", color: Colors.green);
                                                  })
                                                  .catchError((e) {
                                                    snackbar_show(context: context, message: 'Delete Failed.', color: Colors.red);
                                                  });

                                              //
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: output["images"][i.toString()] != null
                                    ? Image.network(
                                        "$MINIO_PUBLIC/200/images/${output["images"][i.toString()]}", //
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child: Icon(Icons.upload_outlined, color: Colors.blue, size: 24),
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Save button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.check), //
                    label: Text("Update"),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                    onPressed: on_update,
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

  void on_update() async {
    print("Output: $output");
    await dio
        .post('$PATH/data_update', data: FormData.fromMap({...output}))
        .then((value) {
          snackbar_show(context: context, message: "$HEADER update successfully", color: Colors.green);
          Navigator.pop(context, output);
        })
        .catchError((error) {
          snackbar_show(context: context, message: "$HEADER update failed", color: Colors.red);
        });
  }
}
