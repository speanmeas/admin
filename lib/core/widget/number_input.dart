import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Number_InputState extends State<Number_Input> {
  //
  final controller = TextEditingController();
  final focusNode = FocusNode();

  bool is_error = false;

  void init() async {
    if (widget.initial != null) {
      controller.text = widget.initial!.toString();
      widget.onChanged?.call(widget.initial);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorText: is_error ? "Invalid number" : null,
        prefixIcon: Icon(Icons.onetwothree), //
        suffixIcon: ExcludeFocus(
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(Icons.clear, color: Colors.red),
              onPressed: () async {
                controller.clear();
                widget.onChanged?.call(null);
                is_error = false;
                focusNode.requestFocus();
                setState(() {});
              },
            ),
          ),
        ),
      ),

      onChanged: (v) {
        final double? value = double.tryParse(v);
        is_error = value == null;
        widget.onChanged?.call(value);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}

class Number_Input extends StatefulWidget {
  const Number_Input({
    super.key, //
    this.initial,
    this.title,
    this.onChanged,
  });

  final double? initial;
  final String? title;
  final Function(double?)? onChanged;

  @override
  State<Number_Input> createState() => _Number_InputState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Number_Input(
              title: "Number Value:",
              initial: 5.0,
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
