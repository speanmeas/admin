import "package:flutter/material.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Show_BooleanState extends State<Show_Boolean> {
  @override
  Widget build(BuildContext context) {
    String value = "";
    if (widget.value == true) value = "Yes";
    if (widget.value == false) value = "No";

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
            '$value ${widget.suffixText ?? ""}',
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class Show_Boolean extends StatefulWidget {
  const Show_Boolean({
    super.key, //
    required this.leading,
    required this.value,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
  });

  final String? leading;
  final bool? value;
  final IconData? prefixIcon;
  final String? prefixText;
  final String? suffixText;

  @override
  State<Show_Boolean> createState() => _Show_BooleanState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Show_Boolean(leading: "Text Value:", value: true)],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
