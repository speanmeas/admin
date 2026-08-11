import "package:intl/intl.dart";
import "package:flutter/material.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/theme/theme_data.dart";

class _Datetime_PickerState extends State<Datetime_Picker> {
  //
  final controller = TextEditingController();

  void init() async {
    if (widget.initial != null) {
      controller.text = DateFormat(DEFAULT_DATE_FORMAT).format(widget.initial!);
      widget.onChanged?.call(widget.initial);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: widget.title,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.calendar_month_outlined), //
        suffixIcon: ExcludeFocus(
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(Icons.clear, color: Colors.red),
              onPressed: () {
                controller.clear();
                widget.onChanged?.call(null);
                setState(() {});
              },
            ), //
          ), //
        ),
      ),
      onTap: () async {
        final v = await picker(context);
        if (v == null) return;
        controller.text = DateFormat(DEFAULT_DATE_FORMAT).format(v);
        widget.onChanged?.call(v);
        setState(() {});
      },
    );
  }

  Future<DateTime?>? picker(BuildContext context) async {
    DateTime init = DateTime.now();
    if (widget.initial != null) init = widget.initial!;

    // select date
    final DateTime? picked_date = await showDatePicker(
      context: context, //
      initialDate: init, //
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked_date == null) return null;

    // select time
    TimeOfDay initial_time = TimeOfDay(hour: 0, minute: 0);
    if (widget.initial != null) initial_time = TimeOfDay.fromDateTime(widget.initial!);
    final TimeOfDay? picked_time = await showTimePicker(
      context: context, //
      initialTime: initial_time,
    );

    if (picked_time == null) return null;

    // combine date + time
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

class Datetime_Picker extends StatefulWidget {
  const Datetime_Picker({
    super.key, //
    this.initial,
    this.title, //
    this.onChanged,
  });

  final String? title;
  final DateTime? initial;
  final Function(DateTime?)? onChanged;

  @override
  State<Datetime_Picker> createState() => _Datetime_PickerState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Datetime_Picker(
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
