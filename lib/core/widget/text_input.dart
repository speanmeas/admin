import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Text_InputState extends State<Text_Input> {
  //
  final controller = TextEditingController();
  final focusNode = FocusNode();

  void init() async {
    if (widget.initial != null) {
      controller.text = widget.initial!;
      widget.onChanged?.call(widget.initial);
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
        prefixIcon: Icon(Icons.text_fields), //
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

class Text_Input extends StatefulWidget {
  const Text_Input({
    super.key, //
    this.initial,
    this.title,
    this.onChanged,
    this.maxLines,
  });

  final String? initial;
  final String? title;
  final Function(String?)? onChanged;
  final int? maxLines;

  @override
  State<Text_Input> createState() => _Text_InputState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text_Input(
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
