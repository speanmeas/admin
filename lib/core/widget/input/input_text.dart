import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Input_TextState extends State<Input_Text> {
  //
  final controller = TextEditingController();
  final focusNode = FocusNode();

  void init() {
    if (widget.init != null) {
      controller.text = widget.init!;
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
        labelText: widget.lead,
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
    this.init,
    this.lead,
    this.onChanged,
    this.maxLines,
    this.prefixIcon,
  });

  final String? init;
  final String? lead;
  final Function(String?)? onChanged;
  final int? maxLines;
  final IconData? prefixIcon;

  @override
  State<Input_Text> createState() => _Input_TextState();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Input_Text(
              lead: "Text Value:",
              init: "Hello",
              onChanged: (v) {
                print("Changed: $v");
              },
            ),
          ],
        ),
      ),
    ),
  );
}
