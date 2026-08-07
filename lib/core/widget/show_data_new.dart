import "package:flutter/material.dart";

import "package:speanmeas/core/theme/light.dart" as theme;

class _ShowDataState extends State<ShowData> {
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

class ShowData extends StatefulWidget {
  const ShowData({
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
  State<ShowData> createState() => _ShowDataState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme.data(), //
      home: const Scaffold(
        body: Center(
          child: ShowData(
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
