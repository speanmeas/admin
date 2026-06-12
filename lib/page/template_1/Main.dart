import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/layout/Layout.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

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

  PlutoGridStateManager? stateManager;

  bool isLoading = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  List<Map<String, dynamic>> schema = [
    {"name": "boolean_1", "title": "Logic 1", "type": "boolean"}, //
    {"name": "boolean_2", "title": "Logic 2", "type": "boolean"},
    {"name": "text_1", "title": "Text 1", "type": "string"}, //
    {"name": "text_2", "title": "Text 2", "type": "string"},
    {"name": "number_1", "title": "Number 1", "type": "number"},
    {"name": "number_2", "title": "Number 2", "type": "number"},
    {"name": "datetime_1", "title": "Datetime 1", "type": "date-time"},
    {"name": "datetime_2", "title": "Datetime 2", "type": "date-time"},
  ];

  @override
  void initState() {
    super.initState();

    columns = [
      ...schema.map((row) {
        return build_plutocolumn(
          title: row['title']!,
          field: row['name']!,
          type: row['type'] == 'number' ? PlutoColumnType.number() : PlutoColumnType.text(),
          on_filter: () {
            print("Filter ${row['name']}");
          },
        );
      }),
    ];

    rows = [
      for (int i = 0; i < 10000; i++)
        PlutoRow(
          cells: {
            'boolean_1': PlutoCell(value: 'Yes'),
            'boolean_2': PlutoCell(value: 'No'),
            'text_1': PlutoCell(value: 'Text 1 - $i'),
            'text_2': PlutoCell(value: 'Text 2 - $i'),
            'number_1': PlutoCell(value: i * 10),
            'number_2': PlutoCell(value: i * 20),
            'datetime_1': PlutoCell(value: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(Duration(days: i)))),
            'datetime_2': PlutoCell(value: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(Duration(days: i * 2)))),
          },
        ),
    ];
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
              columns: columns, //
              // [
              //   build_plutocolumn(
              //     title: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              //     field: 'room',
              //     type: PlutoColumnType.number(),
              //     on_filter: () {
              //       print("Filter room");
              //     },
              //   ),

              //   build_plutocolumn(
              //     title: 'Guest',
              //     field: 'guest',
              //     type: PlutoColumnType.text(),
              //     on_filter: () {
              //       print("Filter guest");
              //     },
              //   ),

              //   build_plutocolumn(
              //     title: 'Check In',
              //     field: 'check_in',
              //     type: PlutoColumnType.text(),
              //     on_filter: () {
              //       print("Filter check_in");
              //     },
              //   ),

              //   build_plutocolumn(
              //     title: 'Check Out',
              //     field: 'check_out',
              //     type: PlutoColumnType.text(),
              //     on_filter: () {
              //       print("Filter check_out");
              //     },
              //   ),

              //   build_plutocolumn(
              //     title: 'Status',
              //     field: 'status',
              //     type: PlutoColumnType.text(),
              //     on_filter: () {
              //       print("Filter status");
              //     },
              //   ),

              //   build_plutocolumn(
              //     title: 'Payment',
              //     field: 'payment',
              //     type: PlutoColumnType.number(),
              //     on_filter: () {
              //       print("Filter payment");
              //     },
              //   ),
              // ],
              //
              rows: rows,
              //
              configuration: PlutoGridConfiguration(
                scrollbar: PlutoGridScrollbarConfig(
                  scrollbarThickness: 12, //
                  scrollbarThicknessWhileDragging: 12,
                  isAlwaysShown: true,
                ),
                style: PlutoGridStyleConfig(
                  rowHeight: 24, //
                  columnHeight: 32,
                ),
              ),
              onLoaded: (event) {
                stateManager = event.stateManager;

                stateManager!.scroll.bodyRowsVertical!.addListener(() {
                  final position = stateManager!.scroll.bodyRowsVertical!.position;

                  if (position.pixels >= position.maxScrollExtent) {
                    print('Reached bottom');
                    isLoading = true;
                    setState(() {});
                  }
                });
              },
              onRowDoubleTap: (event) {
                print("Row double tapped: ${event.row.cells['room']!.value}");

                // show options: view, edit, delete
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.visibility_outlined),
                          title: Text("View"),
                          onTap: () {
                            print("View room ${event.row.cells['room']!.value}");
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text("Edit"),
                          onTap: () {
                            print("Edit room ${event.row.cells['room']!.value}");
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text("Delete"),
                          onTap: () {
                            print("Delete room ${event.row.cells['room']!.value}");
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

          if (isLoading)
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

      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Spacer(),

              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  icon: Icon(Icons.add, fontWeight: FontWeight.bold),
                  onPressed: () {
                    print("Add");
                    snackbar_show(context: context, message: "Test", color: Colors.green);
                  },
                ),
              ),
            ], //
          ),

          SizedBox(width: 4),
        ],
      ),
    );
  }
}

build_plutocolumn({
  required String title, //
  required String field,
  required PlutoColumnType type,
  required VoidCallback on_filter,
}) {
  return PlutoColumn(
    title: title,
    field: field,
    type: type,
    width: 160,
    minWidth: 100,
    readOnly: true,
    enableFilterMenuItem: false,
    titleSpan: WidgetSpan(
      child: Row(
        children: [
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
