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

  late List<PlutoRow> rows;

  @override
  void initState() {
    super.initState();

    rows = [
      for (int i = 0; i < 10000; i++)
        PlutoRow(
          cells: {
            'room': PlutoCell(value: '$i'),
            'guest': PlutoCell(value: 'John'),
            'check_in': PlutoCell(value: '2026-06-10 12:34:56'), //
            'check_out': PlutoCell(value: '2026-06-10 12:34:56'),
            'status': PlutoCell(value: 'Occupied'),
            'payment': PlutoCell(value: i * 100),
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
              columns: [
                build_plutocolumn(
                  title: 'Room',
                  field: 'room',
                  type: PlutoColumnType.text(), //
                  on_filter: () {
                    print("Filter room");
                  },
                  on_sort: () {
                    print("Sort room");
                  },
                ),

                build_plutocolumn(
                  title: 'Guest',
                  field: 'guest',
                  type: PlutoColumnType.text(), //
                  on_filter: () {
                    print("Filter guest");
                  },
                  on_sort: () {
                    print("Sort guest");
                  },
                ),

                build_plutocolumn(
                  title: 'Check In',
                  field: 'check_in',
                  type: PlutoColumnType.text(), //
                  on_filter: () {
                    print("Filter check_in");
                  },
                  on_sort: () {
                    print("Sort check_in");
                  },
                ),

                build_plutocolumn(
                  title: 'Check Out',
                  field: 'check_out',
                  type: PlutoColumnType.text(), //
                  on_filter: () {
                    print("Filter check_out");
                  },
                  on_sort: () {
                    print("Sort check_out");
                  },
                ),

                build_plutocolumn(
                  title: 'Status',
                  field: 'status',
                  type: PlutoColumnType.text(), //
                  on_filter: () {
                    print("Filter status");
                  },
                  on_sort: () {
                    print("Sort status");
                  },
                ),

                build_plutocolumn(
                  title: 'Payment',
                  field: 'payment',
                  type: PlutoColumnType.number(), //
                  on_filter: () {
                    print("Filter payment");
                  },
                  on_sort: () {
                    print("Sort payment");
                  },
                ),
              ],
              rows: rows,
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
                margin: EdgeInsets.fromLTRB(0, 0, 20, 16),
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

      // floatingActionButton: FloatingActionButton(
      //   elevation: 10,
      //   child: Icon(Icons.add, size: 32),
      //   onPressed: () {
      //     print("Add");
      //     snackbar_show(context: context, message: "Test", color: Colors.green);
      //   },
      // ),
    );
  }
}

build_plutocolumn({
  required String title, //
  required String field, //
  required PlutoColumnType type,
  required VoidCallback on_filter,
  required VoidCallback on_sort,
}) {
  return PlutoColumn(
    title: title,
    field: field,
    type: type,
    width: 160,
    minWidth: 100,
    readOnly: true,
    enableFilterMenuItem: false,
    enableSorting: false,
    titleSpan: WidgetSpan(
      child: Row(
        children: [
          InkWell(
            onTap: on_filter,
            child: Icon(Icons.filter_alt_outlined, size: 20, color: Colors.blue),
          ),

          SizedBox(width: 8),

          Expanded(
            child: InkWell(
              onTap: on_sort,
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ), //
            ),
          ),

          SizedBox(width: 20),
        ],
      ),
    ),
  );
}
