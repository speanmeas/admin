import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:speanmeas/core/config.dart";

import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Show_TextState extends State<Show_Text> {
  String value = "";

  @override
  void initState() {
    super.initState();

    if (widget.value != null) {
      if (widget.value is String) value = widget.value;
      if (widget.value is int) value = widget.value.toString();
      if (widget.value is double) value = widget.value.toString();
      if (widget.value is bool) value = widget.value ? "Yes" : "No";
      if (widget.value is DateTime) value = DateFormat(DEFAULT_DATE_FORMAT).format(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          widget.lead ?? "", //
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: widget.maxLines ?? 1,
          ),
        ),
      ],
    );
  }
}

class Show_Text extends StatefulWidget {
  const Show_Text({
    super.key, //
    required this.lead,
    required this.value,
    this.prefixIcon,
    this.prefixText,
    this.maxLines,
  });

  final String? lead;
  final dynamic value;
  final IconData? prefixIcon;
  final String? prefixText;
  final int? maxLines;

  @override
  State<Show_Text> createState() => _Show_TextState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Show_Text(lead: "Text Value:", value: "Hello")],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}