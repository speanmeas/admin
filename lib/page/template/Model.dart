import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';

import 'Filter_Visibility.dart';
import 'Form_Create.dart';
import 'Form_Delete.dart';
import 'Filter_Datetime.dart';
import 'Filter_Number.dart';
import 'Filter_String.dart';
import 'Form_Update.dart';
import 'Form_Read.dart';

import 'Setup.dart';
import 'Schema.g.dart';

void main() {
  runApp(const Template());
}

class Template extends StatelessWidget {
  const Template({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HEADER, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Model_(),
    );
  }
}

class Model_ extends StatefulWidget {
  const Model_({super.key});

  @override
  State<Model_> createState() => _Model_State();
}

class _Model_State extends State<Model_> {
  //
  //

  bool _is_admin = true;

  double _header_height = 40.0;
  double _row_height = 40.0;
  double _column_width = 120.0;
  double _number_column_width = 60.0;

  // schema
  // todo: check secure_storage -> Schema.g.dart
  List<Map<String, dynamic>> _schema = schema;

  List<Map<String, dynamic>> data = [];

  bool has_more = false;

  bool is_filter = false;

  String? key;
  String? query;
  double? min;
  double? max;
  String? start;
  String? end;
  int? limit = 1000;
  int sort_order = 0;

  ScrollController controller_scrollbar = ScrollController();

  ScrollController controller_table = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post(
          '$PATH/read',
          data: FormData.fromMap({
            "key_": key, //
            "query_": query,
            "min_": min,
            "max_": max,
            "start_": start,
            "end_": end,
            "order_": sort_order == 0 ? null : sort_order,
            "limit_": limit,
            "offset_": null,
            "distinct_": null,
          }),
        ) //
        .then((r) {
          setState(() {
            // print(r.data.length);
            has_more = r.data.length == 100;
            data = List<Map<String, dynamic>>.from(r.data);
            // print(data);
          });
        })
        .catchError((e) {
          print(e);
        });

    // move to top
    // controller_table.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void load_more() async {
    await dio
        .post(
          '$PATH/read',
          data: FormData.fromMap({
            "key_": key, //
            "query_": query,
            "min_": min,
            "max_": max,
            "start_": start,
            "end_": end,
            "order_": sort_order == 0 ? null : sort_order,
            "limit_": limit,
            "offset_": data.length,
            "distinct_": null,
          }),
        ) //
        .then((r) {
          setState(() {
            // print(r.data);
            data.addAll(List<Map<String, dynamic>>.from(r.data));
            // print(data);
            has_more = r.data.length == 100;
          });
        })
        .catchError((e) {
          print(e);
        });
  }

  // Timer? _debounce;

  double get_width() {
    return _number_column_width + _schema.where((e) => e["is_visible"] == 1).length * _column_width + 48;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: Scrollbar(
        controller: controller_scrollbar,
        thumbVisibility: true,
        // notificationPredicate: (_) => true,
        thickness: 12, // scrollbar width
        radius: const Radius.circular(0),
        // interactive: true,
        // scrollbarOrientation: ScrollbarOrientation.bottom,
        child: SingleChildScrollView(
          controller: controller_scrollbar,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _is_admin ? get_width() + 90 : get_width(),
            child: Column(
              children: [
                // header
                Container(
                  // decoration: BoxDecoration(color: Colors.blue[50]),
                  child: Row(
                    children: [
                      // number column
                      Container(
                        height: _header_height, //
                        width: _number_column_width, //
                        // color: Colors.blue[50],
                        alignment: Alignment.center,
                        child: Text(
                          "No.", //
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // sort mode
                      if (!is_filter)
                        ..._schema.map((row) {
                          if (row["is_visible"] != 1) return const SizedBox();
                          return Container(
                            height: _header_height, //
                            width: _column_width, //
                            // color: Colors.blue[50],
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  //

                                  if (row["key"] == key) {
                                    final current_index = [-1, 0, 1].indexOf(sort_order);
                                    sort_order = [-1, 0, 1][(current_index - 1) % 3];
                                  } else {
                                    sort_order = -1;
                                  }

                                  if (sort_order == 0) {
                                    key = null;
                                  } else {
                                    key = row["key"] as String;
                                  }

                                  print("key: $key");
                                  print("sort_order: $sort_order");
                                  init();
                                  controller_table.animateTo(
                                    0, //
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                });
                              },

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  key == row["key"]
                                      ? //
                                        Icon(sort_order == -1 ? Icons.arrow_downward : Icons.arrow_upward, size: 20, color: Colors.blue)
                                      : const Icon(Icons.unfold_more, size: 20, color: Colors.blue),

                                  SizedBox(width: 4),

                                  Text(
                                    row["title"], //

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold, //
                                      color: Colors.blue,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                      // search mode
                      if (is_filter)
                        ..._schema.where((row) => row["is_visible"] == 1).map((row) {
                          //
                          if (row["type"] == "text") {
                            return Container(
                              height: _header_height, //
                              width: _column_width, //
                              child: InkWell(
                                onTap: () {
                                  print("${row["key"]}");

                                  key = row["key"];
                                  query = null;
                                  min = null;
                                  max = null;
                                  start = null;
                                  end = null;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Filter_String_(), //
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      query = value;
                                      init();
                                      controller_table.animateTo(
                                        0, //
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  });
                                },

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.filter_alt_outlined, size: 20, color: Colors.blue),
                                    const SizedBox(width: 4),
                                    Text(
                                      row["title"], //
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          //
                          if (row["type"] == "number") {
                            return Container(
                              height: _header_height, //
                              width: _column_width, //
                              child: InkWell(
                                onTap: () {
                                  print("${row["key"]}");
                                  key = row["key"];
                                  query = null;
                                  min = null;
                                  max = null;
                                  start = null;
                                  end = null;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Filter_Number_(
                                        key_: row["key"], //
                                      ),
                                    ),
                                  ).then((value) {
                                    print("value: $value");
                                    if (value != null) {
                                      min = value["min"];
                                      max = value["max"];

                                      // query = value;
                                      init();
                                      controller_table.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                                    }
                                  });
                                },

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.tune, size: 20, color: Colors.blue),
                                    const SizedBox(width: 4),
                                    Text(
                                      row["title"], //
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          //
                          if (row["type"] == "datetime") {
                            return Container(
                              height: _header_height, //
                              width: _column_width, //
                              child: InkWell(
                                onTap: () {
                                  // TODO: Implement range selection
                                  print("${row["key"]}");
                                  key = row["key"];
                                  query = null;
                                  min = null;
                                  max = null;
                                  start = null;
                                  end = null;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Filter_Datetime_(), //
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      start = value["start"];
                                      end = value["end"];
                                      init();
                                      controller_table.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                                    }
                                  });
                                },

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.date_range, size: 20, color: Colors.blue),
                                    const SizedBox(width: 4),
                                    Text(
                                      row["title"], //
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          //
                          return const SizedBox();
                        }),

                      // actions column
                      if (_is_admin)
                        Container(
                          height: _header_height, //
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
                ),

                // body
                Expanded(
                  child: ListView.builder(
                    controller: controller_table,
                    itemCount: data.length + 1,
                    itemBuilder: (context, index) {
                      if (index == data.length) {
                        if (has_more) {
                          print("Last item");
                          Future.delayed(const Duration(milliseconds: 300), () {
                            load_more();
                          });
                          return Container(
                            height: _row_height, //
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                            ),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return Container(
                            height: _row_height, //
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                            ),
                            child: Center(child: Text("Total: ${data.length} rows")),
                          );
                        }
                      }
                      return InkWell(
                        child: Container(
                          height: _row_height, //
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: _number_column_width, //
                                alignment: Alignment.center,
                                child: Text(
                                  "${index + 1}", //
                                ),
                              ),

                              ..._schema.where((row) => row["is_visible"] == 1).map((row) {
                                if (row["key"] == "id_") {
                                  return Container(
                                    width: _column_width, //
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${data[index][row["key"]] ?? ""}", //
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: true,
                                    ),
                                  );
                                }

                                if (row["key"] == "price") {
                                  final priceValue = data[index][row["key"]];
                                  final price = priceValue is num ? priceValue.toDouble() : double.tryParse(priceValue?.toString() ?? "0.0") ?? 0.0;
                                  return Container(
                                    width: _column_width, //
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
                                if (row["key"] == "created_at" || row["key"] == "updated_at") {
                                  final output = data[index][row["key"]];
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
                                    width: _column_width,
                                    alignment: Alignment.center,
                                    child: Text(
                                      displayText, //
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: true,
                                    ),
                                  );
                                }

                                // general case
                                return Container(
                                  width: _column_width, //
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${data[index][row["key"]] ?? ""}", //
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                );
                              }),

                              if (_is_admin) ...[
                                // button edit
                                SizedBox(
                                  width: _row_height, //
                                  child: IconButton(
                                    icon: const Icon(Icons.edit_outlined), //
                                    onPressed: () {
                                      // print(data[index]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Form_Update_(
                                            input: data[index], //
                                          ),
                                        ),
                                      ).then((value) {
                                        if (value != null) {
                                          // print(value);
                                          data[index] = value;
                                          setState(() {});
                                          // init();
                                        }
                                      });
                                    },
                                    tooltip: "Edit",
                                  ),
                                ),

                                // button delete
                                SizedBox(
                                  width: _row_height, //
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      print('Delete room ${data[index]["id_"]}');

                                      Navigator.push(
                                        context, //
                                        MaterialPageRoute(
                                          builder: (context) => Form_Delete_(
                                            id: data[index]["id_"], //
                                          ),
                                        ),
                                      ).then((value) {
                                        if (value != null) {
                                          // init();
                                          data.removeAt(index);
                                          setState(() {});
                                        }
                                      });
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
                              builder: (context) => Form_Read_(
                                input: data[index], //
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Spacer(),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  onPressed: () {
                    is_filter = !is_filter;

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
                  }, //
                  icon: Icon(
                    is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, //
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 4),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Filter_Visibility_(schema: _schema), //
                      ),
                    ).then((value) {
                      if (value != null) {
                        _schema = value;
                        setState(() {});
                      }
                    });
                  }, //
                  icon: Icon(Icons.view_column_outlined, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 4),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Form_Create_(), //
                      ),
                    ).then((value) {
                      if (value != null) {
                        init();
                      }
                    });
                  }, //
                  icon: Icon(Icons.add, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 4),
            ],
          ),

          SizedBox(width: 4),
        ],
      ),
    );
  }
}
