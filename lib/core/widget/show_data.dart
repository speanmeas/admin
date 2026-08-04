import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart" as theme;

class _Main_State extends State<Main_> {
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: widget.max_lines ?? 1,
          ),
        ),
      ],
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({
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
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme.data(), //
      home: const Scaffold(
        body: Center(
          child: Main_(
            //
            title: "Hello",
            value: "World",
            suffix: "!",
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
