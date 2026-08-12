import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/config.dart";

//
import "package:speanmeas/core/theme/theme_data.dart";

class _SelectDateTimeState extends State<SelectDateTime> {
  //
  dynamic tmp;
  final controller = TextEditingController();

  void init() {
    if (widget.initial != null) {
      controller.text = DateFormat(DEFAULT_DATE_FORMAT).format(widget.initial!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          labelText: widget.title,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
        ),
        readOnly: true,
        onTap: () async {
          final v = await select_page(context);
          if (v == null) return;
          controller.text = DateFormat(DEFAULT_DATE_FORMAT).format(v);
          widget.onChanged?.call(v);
          setState(() {});
        },
      ),
    );
  }

  Future<DateTime?>? select_page(BuildContext context) async {
    DateTime init = DateTime.now();
    if (widget.initial != null) init = widget.initial!;
    if (controller.text.isNotEmpty) init = DateTime.tryParse(controller.text)?.toLocal() ?? DateTime.now();

    // Select Date
    final DateTime? picked_date = await showDatePicker(
      context: context, //
      initialDate: init, //
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked_date == null) return null;

    // Select Time
    final TimeOfDay? picked_time = await showTimePicker(
      context: context, //
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );

    if (picked_time == null) return null;

    // Combine Date + Time
    final DateTime picked_datetime = DateTime(
      picked_date.year, //
      picked_date.month,
      picked_date.day,
      picked_time.hour,
      picked_time.minute,
    );

    return picked_datetime;
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class SelectDateTime extends StatefulWidget {
  const SelectDateTime({
    super.key, //
    this.initial,
    this.title, //
    this.onChanged,
    // required this.controller,
  });

  final DateTime? initial;
  final String? title;
  final Function(DateTime?)? onChanged;
  // final TextEditingController controller;

  @override
  State<SelectDateTime> createState() => _SelectDateTimeState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectDateTime(
              title: "Datetime Start:",
              initial: DateTime.tryParse("2023-01-01 12:00"),
              onChanged: (DateTime? value) {
                print("Selected datetime: $value");
              },
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
