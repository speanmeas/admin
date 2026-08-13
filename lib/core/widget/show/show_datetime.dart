import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:speanmeas/core/config.dart";

import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Show_DatetimeState extends State<Show_Datetime> {
  @override
  Widget build(BuildContext context) {
    String value = "";
    if (widget.value != null) {
      value = DateFormat(DEFAULT_DATE_FORMAT).format(widget.value!.toLocal());
    }

    return Row(
      spacing: 4,
      children: [
        if (widget.prefixIcon != null) Icon(widget.prefixIcon!, color: Colors.blue),
        if (widget.prefixText != null)
          Text(
            widget.prefixText ?? "", //
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        Text(
          widget.leading ?? "", //
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value, //
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class Show_Datetime extends StatefulWidget {
  const Show_Datetime({
    super.key, //
    required this.leading,
    required this.value,
    this.prefixIcon,
    this.prefixText,
  });

  final String? leading;
  final DateTime? value;
  final IconData? prefixIcon;
  final String? prefixText;

  @override
  State<Show_Datetime> createState() => _Show_DatetimeState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Show_Datetime(leading: "Text Value:", value: DateTime.now())],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}