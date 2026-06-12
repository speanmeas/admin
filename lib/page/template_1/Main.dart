import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import 'Filter_String.dart';
import 'Filter_Number.dart';
import 'Filter_Boolean.dart';
import 'Filter_Datetime.dart';

import '__Setup__.dart';
import 'Schema.g.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: const Main_(),
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

  late PlutoGridStateManager state_manager;

  bool is_loading = false;
  //   bool has_more = false;

  String? key;
  bool? has;
  String? query;
  double? min;
  double? max;
  String? start;
  String? end;
  String? order;
  int? limit = 1000;

  int counter = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              // todo: add menu
            ],
          ),
          Expanded(
            child: PlutoGrid(
              columns: [
                ...schema.map((row) {
                  return build_plutocolumn(
                    field: row['key']!,
                    title: row['title']!,
                    type: row['type'],
                    on_filter: () {
                      print("Filter ${row['key']}");

                      if (row['type'] == 'string') {
                        Navigator.push(
                          context, //
                          MaterialPageRoute(builder: (context) => Filter_String_()),
                        );
                      } else if (row['type'] == 'number') {
                        Navigator.push(
                          context, //
                          MaterialPageRoute(builder: (context) => Filter_Number_()),
                        );
                      } else if (row['type'] == 'date-time') {
                        Navigator.push(
                          context, //
                          MaterialPageRoute(builder: (context) => Filter_Datetime_()),
                        );
                      } else if (row['type'] == 'boolean') {
                        Navigator.push(
                          context, //
                          MaterialPageRoute(builder: (context) => Filter_Boolean_()),
                        );
                      }
                    },
                  );
                }),
              ], //
              //
              rows: [],
              //
              configuration: PlutoGridConfiguration(
                scrollbar: PlutoGridScrollbarConfig(
                  scrollbarThickness: 12, //
                  scrollbarThicknessWhileDragging: 12,
                  isAlwaysShown: true,
                ),
                style: PlutoGridStyleConfig(
                  rowHeight: 28, //
                  columnHeight: 32,
                ),
              ),
              onChanged: (PlutoGridOnChangedEvent event) {
                state_manager.notifyListeners();
              },
              onLoaded: (event) {
                state_manager = event.stateManager;

                state_manager.scroll.bodyRowsVertical!.addListener(() {
                  final position = state_manager.scroll.bodyRowsVertical!.position;

                  if (!is_loading) {
                    if (position.pixels >= position.maxScrollExtent) {
                      print('Reached bottom');
                      is_loading = true;
                      on_load_more();
                      setState(() {});
                    }
                  }
                });
              },

              onRowDoubleTap: (event) {
                // show options: view, edit, delete
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
                  builder: (context) {
                    int row_number = event.rowIdx;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.add_circle_outline),
                          title: Text("Create"),
                          onTap: () {
                            print("Create row $row_number");
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.visibility_outlined),
                          title: Text("Read"),
                          onTap: () {
                            print("Read row $row_number");
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text("Update"),
                          onTap: () {
                            print("Update row $row_number");
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete_outline, color: Colors.red),
                          title: Text("Delete", style: TextStyle(color: Colors.red)),
                          onTap: () {
                            print("Delete row $row_number");
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          if (is_loading)
            Container(
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20, //
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 16),
                  Text('Loading more...'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void init() async {
    await dio
        .post(
          '$PATH/data_read',
          data: FormData.fromMap({
            "limit": 100, //
          }),
        ) //
        .then((r) {
          final data = List<Map<String, dynamic>>.from(r.data);

          state_manager.removeAllRows();

          state_manager.appendRows([
            for (var d in data)
              PlutoRow(
                cells: {
                  for (var s in schema)
                    if (s['type'] == 'date-time') //
                      s['key']!: PlutoCell(value: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(d[s['key']].toString()).toLocal()))
                    else
                      s['key']!: PlutoCell(value: d[s['key']].toString()),
                },
              ),
          ]);

          setState(() {});
        })
        .catchError((e) {});

    // print length of state_manager.rows
    print(state_manager.rows.length);
  }

  void on_load_more() async {
    await dio
        .post(
          '$PATH/data_read',
          data: FormData.fromMap({
            "limit": 100, //
            "offset": state_manager.rows.length, //
          }),
        ) //
        .then((r) {
          final data = List<Map<String, dynamic>>.from(r.data);

          state_manager.appendRows([
            for (var d in data)
              PlutoRow(
                cells: {
                  for (var s in schema)
                    if (s['type'] == 'date-time') //
                      s['key']!: PlutoCell(value: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(d[s['key']].toString()).toLocal()))
                    else
                      s['key']!: PlutoCell(value: d[s['key']].toString()),
                },
              ),
          ]);

          is_loading = false;

          setState(() {});
        })
        .catchError((e) {});
  }

  build_plutocolumn({
    required String title, //
    required String field,
    required String type,
    required VoidCallback on_filter,
  }) {
    //
    PlutoColumnType column_type = PlutoColumnType.text();
    //
    if (type == 'number') {
      column_type = PlutoColumnType.number();
    }
    //
    return PlutoColumn(
      title: title,
      field: field,
      type: column_type,
      width: 160,
      minWidth: 100,
      readOnly: true,
      enableFilterMenuItem: false,
      titleSpan: WidgetSpan(
        child: Row(
          children: [
            if (type == "number")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.tune, size: 20, color: Colors.blue),
              )
            else if (type == "boolean")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.toggle_on_outlined, size: 20, color: Colors.blue),
              )
            else if (type == "date-time")
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.date_range, size: 20, color: Colors.blue),
              )
            else
              InkWell(
                onTap: on_filter,
                child: Icon(Icons.filter_alt_outlined, size: 20, color: Colors.blue),
              ),

            SizedBox(width: 4),

            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
