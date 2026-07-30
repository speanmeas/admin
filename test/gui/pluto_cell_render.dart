import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:math';

class _Main_State extends State<Main_> {
  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: 'No.', //
        field: 'index',
        type: PlutoColumnType.text(),
        width: 80,
        readOnly: true,
        enableEditingMode: false,
      ),

      PlutoColumn(
        title: 'Text 1', //
        field: 'text_1',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
      ),

      PlutoColumn(
        title: 'Text 2', //
        field: 'text_2',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
      ),

      PlutoColumn(
        title: '',
        field: 'action',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        enableContextMenu: false,
        enableDropToResize: false,
        readOnly: true,
        frozen: PlutoColumnFrozen.end,
        width: 60,
        minWidth: 60,
        titleSpan: WidgetSpan(
          child: IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: Colors.green,
            onPressed: () {
              print('Add button pressed');
            },
          ),
        ),
        renderer: (rendererContext) {
          return IconButton(
            icon: Icon(Icons.delete_outline),
            color: Colors.red,
            onPressed: () {
              rendererContext.stateManager.removeRows([rendererContext.row]);
            },
          );
        },
      ),
    ]);

    final random = Random();
    rows.addAll(
      List.generate(10, (index) {
        return PlutoRow(
          cells: {
            'index': PlutoCell(value: '${index + 1}'),
            'text_1': PlutoCell(value: 'item_${random.nextInt(1000)}'),
            'text_2': PlutoCell(value: 'item_${random.nextInt(1000)}'),
            'action': PlutoCell(value: ''),
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlutoGrid(
        columns: columns,
        rows: rows,
        onSelected: (PlutoGridOnSelectedEvent event) {
          print(event);
          if (event.row != null) {
            openDetail(event.row);
          }
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          print(event);
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
          stateManager = event.stateManager;
        },
      ),
    );
  }

  void openDetail(PlutoRow? row) async {
    String? value = await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final textController = TextEditingController();
        return Dialog(
          child: LayoutBuilder(
            builder: (ctx, size) {
              return Container(
                padding: const EdgeInsets.all(15),
                width: 400,
                // height: 500,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Input some text, and Press Update Button.'),

                      TextField(controller: textController, autofocus: true),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            child: Text('Cancel.'),
                            onPressed: () {
                              Navigator.pop(ctx, null);
                            },
                          ),

                          SizedBox(width: 10),

                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(ctx, textController.text);
                            },
                            child: Text('Update.'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    if (value == null || value.isEmpty) {
      return;
    }

    stateManager.changeCellValue(stateManager.currentRow!.cells['column_1']!, value, force: true);
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Dev", //
      home: const Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
