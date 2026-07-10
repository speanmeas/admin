import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/theme_data.dart";

class _Main_State extends State<Main_> {
  //
  var c_search = TextEditingController();
  List<int> options = List.generate(100, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) c_search.text = widget.initialValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<int>(
      controller: c_search,
      itemBuilder: (context, item) {
        return ListTile(title: Text(item.toString()));
      },
      suggestionsCallback: (q) {
        return options.toList();
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          keyboardType: TextInputType.numberWithOptions(decimal: false),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
          decoration: const InputDecoration(
            labelText: "Number of Guests:",
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        );
      },
      onSelected: (value) {
        c_search.text = value.toString();
        widget.onChanged?.call(value);
      },
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.initialValue,
    this.onChanged,
  });

  final int? initialValue;
  final ValueChanged<int?>? onChanged;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: const Scaffold(body: Center(child: Main_())),
      debugShowCheckedModeBanner: false,
    ),
  );
}
