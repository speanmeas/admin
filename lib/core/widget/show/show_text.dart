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
    value = _format(widget.value);
  }

  @override
  void didUpdateWidget(covariant Show_Text oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) value = _format(widget.value);
  }

  String _format(dynamic v) {
    if (v == null) return "";
    if (v is String) return v;
    if (v is int) return v.toString();
    if (v is double) return v.toString();
    if (v is bool) return v ? "Yes" : "No";
    if (v is DateTime) return DateFormat(DEFAULT_DATE_FORMAT).format(v);
    return "";
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
