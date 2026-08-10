import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Show_DataState extends State<Show_Data> {
  //
  dynamic tmp;

  //

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.title ?? ""}: ", //
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            "${widget.value ?? ""}${widget.suffix ?? ""}", //
            style: TextStyle(color: Colors.blue),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: widget.max_lines ?? 1,
          ),
        ),
      ],
    );
  }
}

class Show_Data extends StatefulWidget {
  const Show_Data({
    super.key, //
    this.title,
    this.value,
    this.suffix,
    this.max_lines,
  });

  final String? title;
  final String? value;
  final String? suffix;
  final int? max_lines;

  @override
  State<Show_Data> createState() => _Show_DataState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: const Scaffold(
        body: Center(
          child: Show_Data(
            title: "Hello", //
            value: "World",
            suffix: "!",
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
