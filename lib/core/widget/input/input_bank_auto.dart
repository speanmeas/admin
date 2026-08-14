import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Input_Bank_AutoState extends State<Input_Bank_Auto> {
  dynamic tmp;
  dynamic data;

  List<String> options = [];
  List<String> our_banks = ["ABA Bank", "ACLEDA Bank"];

  final controller = TextEditingController();

  void init() async {
    try {
      tmp = await dio.post(endpoint.BANK_CRUD_READ);
      data = tmp.data as List<dynamic>;

      for (var to in our_banks)
        for (var from in data.map((e) => e["name"])) //
          if (from.isNotEmpty) options.add("$from to $to");
    } catch (e, st) {
      pprint(st);
    }

    if (widget.init != null) controller.text = widget.init!;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<dynamic>(
      controller: controller,
      itemBuilder: (context, item) => ListTile(title: Text(item)),
      suggestionsCallback: (q) {
        List<dynamic> opts = [];
        for (var e in options) {
          tmp = e.split(" to ")[0];
          if (tmp.toLowerCase().contains(q.toLowerCase())) //
            opts.add(e);
        }
        return opts;
      },
      builder: (context, controller, focusNode) {
        return TextField(
          maxLines: widget.maxLines ?? 4,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Note:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(
              widget.prefixIcon ?? Icons.note_alt_outlined,
              color: Colors.blue,
            ),
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
      },
      onSelected: (v) {
        controller.text = v.toString();
        widget.onChanged?.call(v);
      },
    );
  }

  @override
  initState() {
    super.initState();
    init();
  }
}

class Input_Bank_Auto extends StatefulWidget {
  const Input_Bank_Auto({
    super.key, //
    this.init,
    this.prefixIcon,
    this.maxLines,
    required this.onChanged,
  });

  final String? init;
  final IconData? prefixIcon;
  final int? maxLines;
  final Function(String?)? onChanged;

  @override
  State<Input_Bank_Auto> createState() => _Input_Bank_AutoState();
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
        body: Center(
          child: Input_Bank_Auto(
            onChanged: (data) {
              print("Selected Data: $data");
            },
          ),
        ),
      ),
    ),
  );
}
