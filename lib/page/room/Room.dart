import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/page/room/Room_Column_Visibility.dart';
import 'package:speanmeas/page/room/Room_Create.dart';
import 'package:speanmeas/page/room/Room_Delete.dart';
import 'package:speanmeas/page/room/Room_Filter_Datetime.dart';
import 'package:speanmeas/page/room/Room_Filter_Number.dart';
import 'package:speanmeas/page/room/Room_Filter_String.dart';
import 'package:speanmeas/page/room/Schema.g.dart';

import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';

import 'package:speanmeas/page/room/Room_Update.dart';
import 'package:speanmeas/page/room/Room_Read.dart';
import 'package:speanmeas/theme/Theme_Data.dart';

void main() {
  runApp(const Room());
}

class Room extends StatelessWidget {
  const Room({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room', //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Room_(),
    );
  }
}

class Room_ extends StatefulWidget {
  const Room_({super.key});

  @override
  State<Room_> createState() => _Room_State();
}

class _Room_State extends State<Room_> {
  //
  //

  bool is_admin = true;

  double header_height = 40.0;
  double row_height = 40.0;
  double column_width = 120.0;
  double number_column_width = 60.0;

  // schema
  // note: check secure_storage -> Schema.g.dart
  List<Map<String, dynamic>> schema = [
    {"alias": "_id", "title": "ID", "type": "string", "visible": 0},
    {"alias": "name", "title": "Room No.", "type": "string", "visible": 1},
    {"alias": "type", "title": "Room Type", "type": "string", "visible": 1},
    {"alias": "capacity", "title": "Capacity", "type": "number", "visible": 1},
    {"alias": "ac_or_fan", "title": "AC or Fan", "type": "string", "visible": 1},
    {"alias": "price", "title": "Price", "type": "number", "visible": 1},
    {"alias": "status", "title": "Status", "type": "string", "visible": 1},
    {"alias": "created_at", "title": "Created At", "type": "datetime", "visible": 1},
    {"alias": "updated_at", "title": "Updated At", "type": "datetime", "visible": 0},
    {"alias": "deleted_at", "title": "Deleted At", "type": "datetime", "visible": 0},
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  List<Map<String, dynamic>> data = [];

  bool has_more = false;

  bool is_filter = false;

  String? key;
  String? query;
  double? min;
  double? max;
  String? start;
  String? end;
  int? limit = 100;
  int sort_order = 0;

  void init() async {
    await dio
        .post(
          '/room/read',
          data: FormData.fromMap({
            "key": key, //
            "query": query,
            "min": min,
            "max": max,
            "start": start,
            "end": end,
            "order": sort_order == 0 ? null : sort_order,
            "limit": limit,
            "offset": null,
          }),
        ) //
        .then((r) {
          setState(() {
            // print(r.data.length);
            has_more = r.data.length == 100;
            data = List<Map<String, dynamic>>.from(r.data);
            // print(data);
          });
        });
  }

  void load_more() async {
    await dio
        .post(
          '/room/read',
          data: FormData.fromMap({
            "key": key, //
            "query": query,
            "min": min,
            "max": max,
            "start": start,
            "end": end,
            "order": sort_order == 0 ? null : sort_order,
            "limit": limit,
            "offset": data.length,
          }),
        ) //
        .then((r) {
          setState(() {
            // print(r.data);
            data.addAll(List<Map<String, dynamic>>.from(r.data));
            // print(data);
            has_more = r.data.length == 100;
          });
        });
  }

  // Timer? _debounce;

  double get_width() {
    return number_column_width + schema.where((e) => e["visible"] == 1).length * column_width;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // button filter
            IconButton(
              onPressed: () {
                //
                is_filter = !is_filter;
                //
                if (is_filter == false) {
                  key = null;
                  query = null;
                  min = null;
                  max = null;
                  start = null;
                  end = null;
                  sort_order = 0;
                  init();
                }
                setState(() {});
              },
              icon: is_filter ? Icon(Icons.filter_alt_off_outlined) : Icon(Icons.filter_alt_outlined),
              tooltip: is_filter ? "Off Filter" : "On Filter",
            ),

            // button view column
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Room_Select_Column_Visibility_(schema: schema), //
                  ),
                ).then((value) {
                  if (value != null) {
                    schema = value;
                    setState(() {});
                  }
                });
              },
              icon: Icon(Icons.view_column_outlined),
              tooltip: "View Column",
            ),

            Spacer(),

            // button add
            if (is_admin)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Room_Create_(
                        schema: schema, //
                      ),
                    ),
                  ).then((value) {
                    if (value != null) {
                      init();
                    }
                  });
                },
                icon: Icon(Icons.add),
                tooltip: "Add",
              ),

            // button export
            // IconButton(
            //   onPressed: () {
            //     //
            //   },
            //   icon: Icon(Icons.download_outlined),
            //   tooltip: "Export",
            // ),
          ],
        ),
        toolbarHeight: 40,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
      ),

      //
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: is_admin ? get_width() + 90 : get_width(),
          child: Column(
            children: [
              // header
              Row(
                children: [
                  // number column
                  Container(
                    height: header_height, //
                    width: number_column_width, //
                    alignment: Alignment.center,
                    child: Text(
                      "No.", //
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // sort mode
                  if (!is_filter)
                    ...schema.map((row) {
                      if (row["visible"] != 1) return const SizedBox();
                      return Container(
                        height: header_height, //
                        width: column_width, //
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              //

                              if (row["alias"] == key) {
                                final current_index = [-1, 0, 1].indexOf(sort_order);
                                sort_order = [-1, 0, 1][(current_index - 1) % 3];
                              } else {
                                sort_order = -1;
                              }

                              if (sort_order == 0) {
                                key = null;
                              } else {
                                key = row["alias"] as String;
                              }

                              print("key: $key");
                              print("sort_order: $sort_order");
                              init();
                            });
                          },

                          child: Row(
                            children: [
                              Spacer(),
                              Text(
                                row["title"], //
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              key == row["alias"] ? Icon(sort_order == -1 ? Icons.arrow_downward : Icons.arrow_upward, size: 20) : const Icon(Icons.unfold_more, size: 20),
                            ],
                          ),
                        ),
                      );
                    }),

                  // search mode
                  if (is_filter)
                    ...schema.where((row) => row["visible"] == 1).map((row) {
                      // if (row["type"] == "string") {
                      //   return Container(
                      //     height: header_height, //
                      //     width: column_width, //
                      //     padding: const EdgeInsets.fromLTRB(1, 8, 1, 0),
                      //     child: TextField(
                      //       decoration: InputDecoration(
                      //         hintText: "Search", //
                      //         labelText: row["title"] as String?,
                      //         floatingLabelBehavior: FloatingLabelBehavior.always,
                      //         contentPadding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                      //         border: OutlineInputBorder(),
                      //       ),
                      //       style: const TextStyle(fontSize: 14),
                      //       onChanged: (value) {
                      //         if (_debounce?.isActive ?? false) _debounce!.cancel();
                      //         _debounce = Timer(const Duration(milliseconds: 200), () async {
                      //           key = row['alias'] as String;
                      //           query = value;
                      //           sort_order = 0;
                      //           init();
                      //         });
                      //       },
                      //     ),
                      //   );
                      // }

                      if (row["type"] == "string") {
                        return Container(
                          height: header_height, //
                          width: column_width, //
                          padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement range selection
                              print("${row["alias"]}");

                              key = row['alias'];
                              query = null;
                              min = null;
                              max = null;
                              start = null;
                              end = null;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Room_Filter_String_(), //
                                ),
                              ).then((value) {
                                if (value != null) {
                                  query = value;
                                  init();
                                }
                              });
                            },
                            icon: const Icon(Icons.search),
                            label: Text(
                              row["title"] as String? ?? "", //
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis, //
                              ),
                            ),
                          ),
                        );
                      }

                      if (row["type"] == "number") {
                        return Container(
                          height: header_height, //
                          width: column_width, //
                          padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement range selection
                              print("${row["alias"]}");
                              key = row['alias'];
                              query = null;
                              min = null;
                              max = null;
                              start = null;
                              end = null;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Room_Filter_Number_(
                                    key_: row['alias'], //
                                  ),
                                ),
                              ).then((value) {
                                print("value: $value");
                                if (value != null) {
                                  min = value["min"];
                                  max = value["max"];

                                  // query = value;
                                  init();
                                }
                              });
                            },
                            icon: const Icon(Icons.tune),
                            label: Text(
                              row["title"] as String? ?? "", //
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis, //
                              ),
                            ),
                          ),
                        );
                      }

                      if (row["type"] == "datetime") {
                        return Container(
                          height: header_height, //
                          width: column_width, //
                          padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement range selection
                              print("${row["alias"]}");
                              key = row['alias'];
                              query = null;
                              min = null;
                              max = null;
                              start = null;
                              end = null;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Room_Filter_Datetime_(
                                    schema: schema,
                                    input: {
                                      "min": 0, //
                                      "max": 100,
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.date_range),
                            label: Text(
                              row["title"] as String? ?? "", //
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis, //
                              ),
                            ),
                          ),
                        );
                      }

                      return const SizedBox();
                    }),

                  // actions column
                  if (is_admin)
                    Container(
                      height: header_height, //
                      width: 80, //
                      child: Row(
                        children: [
                          Spacer(),
                          Text("Actions", style: const TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 4), //
                          Spacer(),
                        ],
                      ),
                    ),
                ],
              ),

              // body
              Expanded(
                child: ListView.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == data.length) {
                      if (has_more) {
                        print("Last item");
                        Future.delayed(const Duration(milliseconds: 300), () {
                          load_more();
                        });
                        return Container(
                          height: row_height, //
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return Container(
                          height: row_height, //
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          child: const Center(child: Text("No more data")),
                        );
                      }
                    }
                    return InkWell(
                      child: Container(
                        height: row_height, //
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: number_column_width, //
                              alignment: Alignment.center,
                              child: Text(
                                "${index + 1}", //
                              ),
                            ),

                            ...schema.where((row) => row["visible"] == 1).map((row) {
                              if (row["alias"] == "_id") {
                                return Container(
                                  width: column_width, //
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${data[index][row["alias"]] ?? ""}", //
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                );
                              }

                              if (row["alias"] == "price") {
                                final priceValue = data[index][row["alias"]];
                                final price = priceValue is num ? priceValue.toDouble() : double.tryParse(priceValue?.toString() ?? "0.0") ?? 0.0;
                                return Container(
                                  width: column_width, //
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${price.toStringAsFixed(2)} \$", //
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                );
                              }

                              // Handle MongoDB date format: {"$date": "2024-01-15T10:30:00.000Z"}
                              if (row["alias"] == "created_at" || row["alias"] == "updated_at") {
                                final output = data[index][row["alias"]];
                                String displayText = "-";

                                try {
                                  String? dateStr;
                                  if (output is Map && output.containsKey(r"$date")) {
                                    dateStr = output[r"$date"] as String?;
                                  } else if (output is String) {
                                    dateStr = output;
                                  }

                                  if (dateStr != null) {
                                    final date = DateTime.parse(dateStr).toLocal();
                                    displayText = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                                  }
                                } catch (e) {
                                  displayText = output?.toString() ?? "-";
                                }

                                return Container(
                                  width: column_width,
                                  alignment: Alignment.center,
                                  child: Text(displayText, overflow: TextOverflow.ellipsis, maxLines: 2, softWrap: true),
                                );
                              }

                              // general case
                              return Container(
                                width: column_width, //
                                alignment: Alignment.center,
                                child: Text(
                                  "${data[index][row["alias"]] ?? ""}", //
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              );
                            }),

                            if (is_admin) ...[
                              // button edit
                              SizedBox(
                                width: row_height, //
                                child: IconButton(
                                  icon: const Icon(Icons.edit_outlined), //
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Room_Update_(
                                          schema: schema, //
                                          input: data[index],
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        init();
                                      }
                                    });
                                  },
                                  tooltip: "Edit",
                                ),
                              ),

                              // button delete
                              SizedBox(
                                width: row_height, //
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    print('Delete room ${data[index]["_id"]}');

                                    Navigator.push(
                                      context, //
                                      MaterialPageRoute(
                                        builder: (context) => Room_Delete_(
                                          input: {
                                            "_id": data[index]["_id"], //
                                            "name": data[index]["name"],
                                          },
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        // data.removeAt(index);
                                        // print('Delete room ${data[index]["_id"]} success');
                                        // setState(() {});
                                        init();
                                      }
                                    });

                                    // await dio
                                    //     .post("/room/delete", data: {"id": data[index]["_id"]})
                                    //     .then((value) {
                                    //       print('Delete room ${data[index]["_id"]} success');
                                    //       data.removeAt(index);
                                    //       show_snackbar(context: context, message: 'Room deleted successfully', color: Colors.green);
                                    //       setState(() {});
                                    //     })
                                    //     .catchError((error) {
                                    //       print('Delete room ${data[index]["_id"]} failed: $error');
                                    //     });
                                  },
                                  tooltip: "Delete",
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Room_Read_(
                              schema: schema, //
                              input: data[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
