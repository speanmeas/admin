import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Input_PasswordState extends State<Input_Password> {
  //
  final controller = TextEditingController();

  void init() {
    if (widget.initial != null) {
      controller.text = widget.initial!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: widget.hint, //
        labelText: "Password:", //
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.lock_outline, color: Colors.blue),
        suffixIcon: ExcludeFocus(
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(Icons.clear, color: Colors.red),
              onPressed: () {
                controller.clear();
                widget.onChanged.call(null);
                setState(() {});
              },
            ), //
          ),
        ),
      ),
      onChanged: (v) {
        widget.onChanged.call(v);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Input_Password extends StatefulWidget {
  const Input_Password({
    super.key, //
    this.initial,
    this.hint,
    required this.onChanged,
  });

  final String? initial;
  final String? hint;
  final Function(String?) onChanged;

  @override
  State<Input_Password> createState() => _Input_PasswordState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Center(
          child: Input_Password(
            hint: "Enter a new password",
            onChanged: (v) {
              print("Changed: $v");
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}