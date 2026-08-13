import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ColumnFooterScreen extends StatefulWidget {
  const ColumnFooterScreen({super.key});

  @override
  _ColumnFooterScreenState createState() => _ColumnFooterScreenState();
}

class _ColumnFooterScreenState extends State<ColumnFooterScreen> {
  late List<PlutoColumn> columns;

  late List<PlutoRow> rows;

  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns = [
      PlutoColumn(
        title: 'column1',
        field: 'column1',
        type: PlutoColumnType.text(),
        enableRowChecked: true,
        // footerRenderer: (rendererContext) {
        //   return PlutoAggregateColumnFooter(
        //     rendererContext: rendererContext,
        //     type: PlutoAggregateColumnType.count,
        //     format: 'Checked : #,###.###',
        //     filter: (cell) => cell.row.checked == true,
        //     alignment: Alignment.center,
        //   );
        // },
      ),
      PlutoColumn(
        title: 'column2',
        field: 'column2',
        type: PlutoColumnType.number(),
        textAlign: PlutoColumnTextAlign.end,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            format: '#,###',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              return [
                const TextSpan(
                  text: 'Sum',
                  style: TextStyle(color: Colors.red),
                ),
                const TextSpan(text: ' : '),
                TextSpan(text: text),
              ];
            },
          );
        },
      ),
      PlutoColumn(
        title: 'column3',
        field: 'column3',
        type: PlutoColumnType.number(format: '#,###.###'),
        textAlign: PlutoColumnTextAlign.right,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.average,
            format: '#,###.###',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              return [const TextSpan(text: 'Average : '), TextSpan(text: text)];
            },
          );
        },
      ),
      PlutoColumn(
        title: 'column4',
        field: 'column4',
        type: PlutoColumnType.number(),
        textAlign: PlutoColumnTextAlign.right,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.min,
            format: '#,###',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              return [const TextSpan(text: 'Min : '), TextSpan(text: text)];
            },
          );
        },
      ),
      PlutoColumn(
        title: 'column5',
        field: 'column5',
        type: PlutoColumnType.number(),
        textAlign: PlutoColumnTextAlign.right,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.max,
            format: '#,###',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              return [const TextSpan(text: 'Max : '), TextSpan(text: text)];
            },
          );
        },
      ),
      PlutoColumn(
        title: 'column6',
        field: 'column6',
        type: PlutoColumnType.select(['Android', 'iOS', 'Windows', 'Linux']),
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(rendererContext: rendererContext, type: PlutoAggregateColumnType.count, filter: (cell) => cell.value == 'Android', format: 'Android : #,###', alignment: Alignment.center);
        },
      ),
    ];

    final random = Random();

    rows = List.generate(100, (i) {
      return PlutoRow(
        checked: random.nextBool(),
        cells: {
          'column1': PlutoCell(value: 'Item ${i + 1}'),
          'column2': PlutoCell(value: random.nextInt(1000)),
          'column3': PlutoCell(value: (random.nextInt(1000) + random.nextDouble()).toStringAsFixed(3)),
          'column4': PlutoCell(value: random.nextInt(100)),
          'column5': PlutoCell(value: random.nextInt(5000)),
          'column6': PlutoCell(value: const ['Android', 'iOS', 'Windows', 'Linux'][random.nextInt(4)]),
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column Footer')),
      body: PlutoGrid(
        columns: columns,
        rows: rows,
        onChanged: (PlutoGridOnChangedEvent event) {
          print(event);
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
          stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
          stateManager.setShowColumnFilter(true);
        },
        configuration: PlutoGridConfiguration(),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: ColumnFooterScreen(), //
    ),
  );
}
