import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';

import 'Form_1_Create.dart';
import 'Form_2_Read.dart';
import 'Form_3_Update.dart';
import 'Form_4_Delete.dart';
import 'Filter_1_String.dart';
import 'Filter_2_Number.dart';
import 'Filter_3_Datetime.dart';
import 'Filter_Visibility.dart';

import 'Main_Widget.dart';
import 'Schema.g.dart';
import '__Setup__.dart';

void main() {
  runApp(const Guest_Info());
}

class Guest_Info extends StatelessWidget {
  const Guest_Info({super.key});

  final id = "69f984897186bcf74f8a5dde"; //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  //
  //

  bool is_admin = false; // todo: check admin role from secure storage
  bool has_more = false;
  bool is_filter = false;

  // todo: check secure_storage -> Schema.g.dart
  List<Map<String, dynamic>> _schema = schema;

  List<Map<String, dynamic>> data = [];

  String? id;
  String? key;
  String? query;
  double? min;
  double? max;
  String? start;
  String? end;
  String? order;
  int? limit = 1000;
  String? autocomplete;

  int counter = 0;

  ScrollController controller_scrollbar = ScrollController();
  ScrollController controller_table = ScrollController();

  @override
  void initState() {
    super.initState();

    // add access_token to dio
    Future.microtask(() {
      secure_storage
          .read(key: 'access_token') //
          .then((access_token) {
            if (access_token != null) {
              dio.options.headers['Authorization'] = 'Bearer $access_token';
              setState(() {});
              print("Access token found: $access_token");
            } else {
              print("No access token found.");
            }
          })
          .catchError((e) {});
    });

    init();
  }

  void init() async {
    await dio
        .post(
          '$PATH/data_read',
          data: FormData.fromMap({
            "id": id, //
            "key": key, //
            "query": query,
            "min": min,
            "max": max,
            "start": start,
            "end": end,
            "order": order,
            "limit": limit,
            "offset": null,
            "autocomplete": autocomplete,
          }),
        ) //
        .then((r) {
          setState(() {
            // print(r.data.length);
            has_more = r.data.length == limit;
            data = List<Map<String, dynamic>>.from(r.data);
            // print(data);
          });
        })
        .catchError((e) {});

    // move to top
    // controller_table.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void load_more() async {
    await dio
        .post(
          '$PATH/read',
          data: FormData.fromMap({
            "id": null, //
            "key": key, //
            "query": query,
            "min": min,
            "max": max,
            "start": start,
            "end": end,
            "order": order,
            "limit": limit,
            "offset": data.length,
            "autocomplete": autocomplete,
          }),
        ) //
        .then((r) {
          // print(r.data);
          has_more = r.data.length == limit;
          data.addAll(List<Map<String, dynamic>>.from(r.data));
          // print(data);
          setState(() {});
        })
        .catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      children_header: [
        // No.
        Header_No(),

        // sort mode
        if (!is_filter)
          ..._schema.map((row) {
            //
            if (row["is_visible"] != 1) return const SizedBox();

            // sort mode
            return Header_Sort_Mode(
              row: row, //
              key: key ?? "",
              order: order ?? "",
              onPressed: () => sort_mode_pressed(row),
            );
          }),

        // search mode
        if (is_filter)
          ..._schema.where((row) => row["is_visible"] == 1).map((row) {
            // header search text
            if (row["kind"] == "text") {
              return Header_Search_Text(
                row: row, //
                onPressed: () => filter_text_pressed(row),
              );
            }

            // header search number
            if (row["kind"] == "number") {
              return Header_Search_Number(
                row: row, //
                onPressed: () => filter_number_pressed(row),
              );
            }

            // header search datetime
            if (row["kind"] == "datetime") {
              return Header_Search_Datetime(
                row: row, //
                onPressed: () => filter_datetime_pressed(row),
              );
            }

            //
            return const SizedBox();
          }),

        // actions column
        if (is_admin) Header_Action(),
      ],

      children_body: (index) => [
        //
        Container_Index(index),

        ..._schema.where((row) => row["is_visible"] == 1).map((row) {
          // case price
          if (row["key"] == "price") return Cell_Price(data[index][row["key"]]);

          // case password
          if (row["key"] == "password_hash") return Cell_General("**********");

          // case datetime
          if (row["kind"] == "datetime") {
            return Cell_Datetime(data[index][row["key"]] ?? "");
          }

          // default
          return Cell_General("${data[index][row["key"]] ?? ""}");
        }),

        if (is_admin) ...[
          // update
          Button_Update(onPressed: () => button_update_pressed(index)), //
          // delete
          Button_Delete(onPressed: () => button_delete_pressed(index)),
        ],
      ],

      children_floating: [
        Spacer(),

        Footer_Export(onPressed: () {}),

        Footer_Filter(is_filter: is_filter, onPressed: float_filter_pressed),

        Footer_Visibility(onPressed: float_visible_pressed),

        Footer_Add(onPressed: float_add_pressed),
      ],
    );
  }

  void read_item_pressed(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Form_Read_(
          id: data[index]["id"], //
        ),
      ),
    );
  }

  void filter_datetime_pressed(Map<String, dynamic> row) {
    // print("${row["key"]}");
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
        order = "1";
        init();
        controller_table.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void filter_number_pressed(Map<String, dynamic> row) {
    // print("${row["key"]}");
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
        order = "1";
        // query = value;
        init();
        controller_table.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void filter_text_pressed(Map<String, dynamic> row) {
    // print("${row["key"]}");

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
        order = "1";
        init();
        controller_table.animateTo(
          0, //
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sort_mode_pressed(Map<String, dynamic> row) {
    setState(() {
      //

      if (key != row["key"]) {
        counter = 0;
        order = null;
      }

      key = row["key"] as String;

      counter += 1;

      if (counter % 3 == 0) {
        key = null;
        order = null;
      }

      if (counter % 3 == 1) {
        order = "-1";
      }

      if (counter % 3 == 2) {
        order = "1";
      }

      init();

      // move to top
      controller_table.animateTo(
        0, //
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void float_add_pressed() {
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
  }

  void float_visible_pressed() {
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
  }

  void float_filter_pressed() {
    is_filter = !is_filter;

    if (is_filter == false) {
      key = null;
      query = null;
      min = null;
      max = null;
      start = null;
      end = null;
      order = null;
      init();
    }
    setState(() {});
  }

  void button_update_pressed(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Form_Update_(
          id: data[index]["id"], //
        ),
      ),
    ).then((value) {
      if (value != null) {
        init();
      }
    });
  }

  void button_delete_pressed(int index) {
    Navigator.push(
      context, //
      MaterialPageRoute(
        builder: (context) => Form_Delete_(
          id: data[index]["id"], //
        ),
      ),
    ).then((value) {
      if (value != null) {
        data.removeAt(index);
        setState(() {});
      }
    });
  }

  double get_width() {
    return NUMBER_COLUMN_WIDTH + //
        _schema.where((e) => e["is_visible"] == 1).length * COLUMN_WIDTH + //
        48;
  }

  Widget Layout({
    required List<Widget> children_header, //
    required List<Widget> Function(int index) children_body,
    required List<Widget> children_floating,
  }) {
    return Scaffold(
      body: Scrollbar(
        controller: controller_scrollbar,
        thumbVisibility: true,
        thickness: 12, // scrollbar width
        radius: const Radius.circular(0),
        child: SingleChildScrollView(
          controller: controller_scrollbar,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: is_admin ? get_width() + 90 : get_width(),
            child: Column(
              children: [
                // header
                Row(children: children_header),

                // body
                Expanded(
                  child: ListView.builder(
                    controller: controller_table,
                    itemCount: data.length + 1,
                    itemBuilder: (context, index) {
                      if (index == data.length) {
                        if (has_more) {
                          // print("Last item");
                          Future.delayed(const Duration(milliseconds: 300), () {
                            load_more();
                          });
                          return Container_Loading();
                        } else {
                          return Container_Total(data.length);
                        }
                      }
                      return InkWell(
                        child: Container(
                          height: ROW_HEIGHT, //
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                          ),
                          child: Row(children: children_body(index)),
                        ),
                        onTap: () => read_item_pressed(index),
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
            children: children_floating, //
          ),

          SizedBox(width: 4),
        ],
      ),
    );
  }
}
