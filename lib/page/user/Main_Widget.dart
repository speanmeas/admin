import 'package:flutter/material.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/utility/Datetime_format.dart';

Widget Header_Sort_Mode({
  required dynamic row, //
  required String? key,
  required String? order,
  required VoidCallback onPressed,
}) {
  return Container(
    height: HEADER_HEIGHT, //
    width: COLUMN_WIDTH, //
    // color: Colors.blue[50],
    child: InkWell(
      onTap: () => onPressed(),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          key == row["key"]
              ? //
                Icon(order == "-1" ? Icons.arrow_downward : Icons.arrow_upward, size: 20, color: Colors.blue)
              : const Icon(Icons.unfold_more, size: 20, color: Colors.blue),

          SizedBox(width: 4),
          Expanded(
            child: Text(
              row["title"], //
              style: const TextStyle(
                fontWeight: FontWeight.bold, //
                color: Colors.blue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget Header_Search_Datetime({
  required dynamic row, //
  required VoidCallback onPressed,
}) {
  return Container(
    height: HEADER_HEIGHT, //
    width: COLUMN_WIDTH, //
    child: InkWell(
      onTap: onPressed,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.date_range, size: 20, color: Colors.blue),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              row["title"], //
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget Header_Search_Number({
  required dynamic row, //
  required VoidCallback onPressed,
}) {
  return Container(
    height: HEADER_HEIGHT, //
    width: COLUMN_WIDTH, //
    child: InkWell(
      onTap: onPressed,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tune, size: 20, color: Colors.blue),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              row["title"], //
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget Header_Search_Text({
  required dynamic row, //
  required VoidCallback onPressed,
}) {
  return Container(
    height: HEADER_HEIGHT, //
    width: COLUMN_WIDTH, //
    child: InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.filter_alt_outlined, size: 20, color: Colors.blue),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              row["title"], //
              style: const TextStyle(
                fontWeight: FontWeight.bold, //
                color: Colors.blue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget Container_Index(int index) {
  return Container(
    width: NUMBER_COLUMN_WIDTH, //
    alignment: Alignment.center,
    child: Text(
      "${index + 1}", //
    ),
  );
}

Widget Container_Total(int total) {
  return Container(
    height: ROW_HEIGHT, //
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Colors.black12, width: 1)),
    ),
    child: Center(child: Text("Total: $total rows")),
  );
}

Widget Container_Loading() {
  return Container(
    height: ROW_HEIGHT, //
    alignment: Alignment.centerLeft,
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Colors.black12, width: 1)),
    ),
    child: const Center(child: CircularProgressIndicator()),
  );
}

Widget Cell_Price(dynamic input) {
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

Widget Cell_Datetime(dynamic data) {
  final raw = data;
  if (raw is Map && raw.containsKey(r'$date')) {
    final datetime = DateTime.tryParse(raw[r'$date']);
    data = datetime_to_string(datetime) ?? "";
  }

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

Widget Cell_Text(dynamic data) {
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

Widget Cell_Number(dynamic data) {
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

Widget Cell_Boolean(dynamic data) {
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

Widget Cell_General(dynamic data) {
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

Widget Footer_Add({required VoidCallback onPressed}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
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

Widget Footer_Visibility({required VoidCallback onPressed}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
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

Widget Header_No() {
  return Container(
    height: HEADER_HEIGHT,
    width: NUMBER_COLUMN_WIDTH,
    alignment: Alignment.center,
    child: const Text('No.', style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget Header_Action() {
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

Widget Footer_Export({
  required VoidCallback onPressed, //
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.download_outlined, //
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget Footer_Filter({
  required bool is_filter, //
  required VoidCallback onPressed,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
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

Widget Button_Update({required VoidCallback onPressed}) {
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
