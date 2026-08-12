import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Show_TextState extends State<Show_Text> {
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
            widget.value ?? "", //
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
    required this.leading,
    required this.value,
    this.prefixIcon,
    this.prefixText,
    this.maxLines,
  });

  final String? leading;
  final String? value;
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
          children: [Show_Text(leading: "Text Value:", value: "Hello")],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
