import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";

import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/utility/Dio.dart";

import "../__Setup__.dart";
import "../Schema.g.dart";

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

  Map<String, dynamic> input = {
    "text_1": "a", //
    "text_2": "aa",
    "number_1": 1,
    "number_2": 11,
    "datetime_1": "2024-01-01T00:00:00Z",
    "datetime_2": "2024-02-02T00:00:00Z",
    "boolean_1": true,
    "boolean_2": false,
    "note": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry",
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
  Form_Read_({super.key, required this.input});

  Map<String, dynamic> input;

  @override
  State<Form_Read_> createState() => _Form_Read_State();
}

class _Form_Read_State extends State<Form_Read_> {
  //
  Map<String, dynamic> output = {};

  final ScrollController controller_audios = ScrollController();
  final ScrollController controller_images = ScrollController();
  final ScrollController controller_videos = ScrollController();

  @override
  void initState() {
    super.initState();

    output = widget.input;
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Read", //
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
              ...schema.map((row) {
                //
                //
                //

                if (row["key"] == "note") {
                  String value = output[row["key"]]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
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

                if (row["key"] == "password") {
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      children: [
                        Text(
                          row["title"] + ": ", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "••••••••••",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  );
                }

                //
                //
                //

                //
                if (row["type"] == "string") {
                  String value = output[row["key"]]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
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
                if (row["type"] == "number") {
                  String value = output[row["key"]]?.toString() ?? "";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
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
                if (row["type"] == "boolean") {
                  String value = output[row["key"]]?.toString() ?? "false";
                  value = value.toLowerCase() == "true" ? "Yes" : "No";
                  return Container(
                    width: 600,
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row["title"] + ": ", //
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
                if (row["type"] == "date-time") {
                  String value = output[row["key"]]?.toString() ?? "";
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
                        Text(
                          row["title"] + ": ", //
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
                return SizedBox.shrink();
              }),

              // todo: handle images, videos, audios, and files

              // if (output["images"] != null && output["images"].isNotEmpty)
              //   Container(
              //     margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
              //     child: Text(
              //       "Images:", //
              //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //     ),
              //   ),
              // if (output["images"] != null && output["images"].isNotEmpty)
              //   Scrollbar(
              //     controller: controller_images,
              //     thumbVisibility: true,
              //     // notificationPredicate: (_) => true,
              //     thickness: 12, // scrollbar width
              //     radius: const Radius.circular(0),
              //     // interactive: true,
              //     // scrollbarOrientation: ScrollbarOrientation.bottom,
              //     child: SingleChildScrollView(
              //       controller: controller_images,
              //       scrollDirection: Axis.horizontal,
              //       child: Row(
              //         children: [
              //           for (int i = 0; i < 10; i++) ...[
              //             if (output["images"][i.toString()] != null)
              //               Container(
              //                 width: 100, //
              //                 height: 100,
              //                 margin: EdgeInsets.fromLTRB(4, 4, 4, 20),
              //                 child: InkWell(
              //                   onTap: () {
              //                     // todo: Handle image tap
              //                     print("Image tapped: $i");
              //                   },
              //                   child: output["images"] != null && output["images"][i.toString()] != null
              //                       ? Image.network(
              //                           "$MINIO_PUBLIC/200/images/${output["images"][i.toString()]}", //
              //                           fit: BoxFit.cover, //
              //                         )
              //                       // : Placeholder(),
              //                       : Placeholder(),
              //                 ),
              //               ),
              //           ],
              //         ],
              //       ),
              //     ),
              //   ),

              // more space
              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }
}
