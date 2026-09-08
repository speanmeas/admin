import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:speanmeas/core/utility/all.dart';

// * បង្កើតទិន្នន័យសាកល្បង 30 rows ដោយចៃដន្យ
class DummyData {
  static final List<String> _names = ['Sokha', 'Dara', 'Srey Leak', 'Bunthoeun', 'Channary', 'Rithy', 'Malis', 'Vichea', 'Piseth', 'Kunthea'];

  static List<PlutoRow> rowsByColumns({
    required int length, //
    required List<PlutoColumn> columns,
  }) {
    final random = Random();
    final rows = <PlutoRow>[];

    for (var i = 0; i < length; i++) {
      final name = '${_names[random.nextInt(_names.length)]} ${i + 1}';
      final money = random.nextInt(100000) + 5000;
      final registeredAt = DateTime(2026, random.nextInt(12) + 1, random.nextInt(28) + 1);

      rows.add(
        PlutoRow(
          cells: {
            'name': PlutoCell(value: name),
            'money': PlutoCell(value: money),
            'registered_at': PlutoCell(value: registeredAt),
          },
        ),
      );
    }

    return rows;
  }
}

class GridAsPopupScreen extends StatefulWidget {
  static const routeName = 'feature/grid-as-popup';

  const GridAsPopupScreen({super.key});

  @override
  _GridAsPopupScreenState createState() => _GridAsPopupScreenState();
}

class _GridAsPopupScreenState extends State<GridAsPopupScreen> {
  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  late TextEditingController _nameController;

  late TextEditingController _moneyController;

  @override
  void dispose() {
    _nameController.dispose();

    _moneyController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();

    _moneyController = TextEditingController();

    columns.addAll([PlutoColumn(title: 'name', field: 'name', type: PlutoColumnType.text()), PlutoColumn(title: 'money', field: 'money', type: PlutoColumnType.number()), PlutoColumn(title: 'registered at', field: 'registered_at', type: PlutoColumnType.date())]);

    rows.addAll(DummyData.rowsByColumns(length: 30, columns: columns));
  }

  void openGridPopup(BuildContext context, String selectFieldName) {
    final controller = selectFieldName == 'name' ? _nameController : _moneyController;

    PlutoGridPopup(
      context: context,
      columns: columns,
      width: 600,
      rows: rows,
      mode: PlutoGridMode.select,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        rows.asMap().entries.forEach((element) {
          final cell = element.value.cells[selectFieldName]!;

          if (cell.value.toString() == controller.text) {
            event.stateManager.setCurrentCell(cell, element.key);
            event.stateManager.moveScrollByRow(PlutoMoveDirection.up, element.key + 1);
          }
        });

        event.stateManager.setShowColumnFilter(true);
      },
      onSelected: (PlutoGridOnSelectedEvent event) {
        controller.text = event.row!.cells[selectFieldName]!.value.toString();
      },
      onSorted: (PlutoGridOnSortedEvent event) {
        print(event);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Select name',
              hintText: 'Select name',
              suffixIcon: InkWell(onTap: () => openGridPopup(context, 'name'), child: const Icon(Icons.search)),
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _moneyController,
            decoration: InputDecoration(
              labelText: 'Select money',
              hintText: 'Select money',
              suffixIcon: InkWell(onTap: () => openGridPopup(context, 'money'), child: const Icon(Icons.search)),
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: const GridAsPopupScreen(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
