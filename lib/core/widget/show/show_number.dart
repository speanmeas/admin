import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Show_NumberState extends State<Show_Number> {
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
          widget.leading ?? "", //
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            '${widget.value?.toStringAsFixed(2) ?? ""} ${widget.suffixText ?? ""}',
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class Show_Number extends StatefulWidget {
  const Show_Number({
    super.key, //
    required this.leading,
    required this.value,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
  });

  final String? leading;
  final double? value;
  final IconData? prefixIcon;
  final String? prefixText;
  final String? suffixText;

  @override
  State<Show_Number> createState() => _Show_NumberState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Show_Number(leading: "Text Value:", value: 10)],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
