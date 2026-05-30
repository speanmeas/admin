import 'package:flutter/material.dart';
import 'package:speanmeas/Environment.dart';

// Widget Container_Datetime()

Widget Container_Price(dynamic input) {
  final priceValue = input;
  final price = priceValue is num ? priceValue.toDouble() : double.tryParse(priceValue?.toString() ?? "0.0") ?? 0.0;
  return Container(
    width: COLUMN_WIDTH, //
    alignment: Alignment.center,
    child: Text(
      "${price.toStringAsFixed(2)} \$", //
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      softWrap: true,
    ),
  );
}

Widget Container_General(String data) {
  // general case
  return Container(
    width: COLUMN_WIDTH, //
    alignment: Alignment.center,
    child: Text(
      data, //
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      softWrap: true,
    ),
  );
}

Widget Container_Add({required VoidCallback onPressed}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.add, fontWeight: FontWeight.bold),
    ),
  );
}

Widget Container_Column_Visible({required VoidCallback onPressed}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.view_column_outlined, fontWeight: FontWeight.bold),
    ),
  );
}

Widget Container_No() {
  return Container(
    height: HEADER_HEIGHT,
    width: NUMBER_COLUMN_WIDTH,
    alignment: Alignment.center,
    child: const Text('No.', style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget Container_Action() {
  return Container(
    height: HEADER_HEIGHT, //
    width: 80, //
    child: Row(
      children: [
        Spacer(),
        Text("Actions", style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 4), //
        Spacer(),
      ],
    ),
  );
}

Widget Container_Filter({
  required bool is_filter, //
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(
        is_filter ? Icons.filter_alt_off_outlined : Icons.filter_alt_outlined, //
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget Button_Edit({required VoidCallback onPressed}) {
  return SizedBox(
    width: ROW_HEIGHT, //
    child: IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.edit_outlined), //
      tooltip: "Edit",
    ),
  );
}

Widget Button_Delete({required VoidCallback onPressed}) {
  return SizedBox(
    width: ROW_HEIGHT, //
    child: IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.delete_outline), //
      tooltip: "Delete",
      color: Colors.red,
    ),
  );
}
