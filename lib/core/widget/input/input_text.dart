import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Input_TextState extends State<Input_Text> {
  //
  final controller = TextEditingController();
  final focusNode = FocusNode();

  void init() {
    if (widget.initial != null) {
      controller.text = widget.initial!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(widget.prefixIcon ?? Icons.text_fields), //
        suffixIcon: ExcludeFocus(
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(Icons.clear, color: Colors.red),
              onPressed: () async {
                controller.clear();
                widget.onChanged?.call(null);
                focusNode.requestFocus();
                setState(() {});
              },
            ),
          ),
        ),
      ),
      onChanged: (v) {
        widget.onChanged?.call(v);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Input_Text extends StatefulWidget {
  const Input_Text({
    super.key, //
    this.initial,
    this.title,
    this.onChanged,
    this.maxLines,
    this.prefixIcon,
  });

  final String? initial;
  final String? title;
  final Function(String?)? onChanged;
  final int? maxLines;
  final IconData? prefixIcon;

  @override
  State<Input_Text> createState() => _Input_TextState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Input_Text(
              title: "Text Value:",
              initial: "Hello",
              onChanged: (v) {
                print("Changed: $v");
              },
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
