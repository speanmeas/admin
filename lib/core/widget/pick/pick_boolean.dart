import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Picker_BooleanState extends State<Picker_Boolean> {
  //
  final controller = TextEditingController();

  void init() {
    if (widget.initial != null) {
      if (widget.initial == true) controller.text = "Yes";
      if (widget.initial == false) controller.text = "No";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: controller,
      suggestionsCallback: (query) => ["Yes", "No"],
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.title ?? "Logic 1:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(controller.text == "Yes" ? Icons.toggle_on : Icons.toggle_off_outlined),
            suffixIcon: ExcludeFocus(
              child: Padding(
                padding: EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(Icons.clear, color: Colors.red),
                  onPressed: () async {
                    controller.clear();
                    widget.onChanged?.call(null);
                    setState(() {});
                  },
                ), //
              ),
            ),
          ),
        );
      },
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      onSelected: (v) {
        controller.text = v;
        if (v == "Yes") widget.onChanged?.call(true);
        if (v == "No") widget.onChanged?.call(false);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Picker_Boolean extends StatefulWidget {
  const Picker_Boolean({
    super.key, //
    this.initial,
    this.title, //
    this.onChanged,
  });

  final bool? initial;
  final String? title;
  final Function(bool?)? onChanged;

  @override
  State<Picker_Boolean> createState() => _Picker_BooleanState();
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
            Picker_Boolean(
              title: "Boolean Value:",
              initial: true,
              onChanged: (v) {
                print("Selected: $v");
              },
            ),
          ],
        ),
      ),
    ),
  );
}
