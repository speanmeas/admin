import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:intl/intl.dart";

import "package:speanmeas/core/config.dart";

//
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Select_Date_TimeState extends State<Select_Date_Time> {
  //
  dynamic tmp;
  final controller = TextEditingController();

  void init() {
    if (widget.init != null) {
      controller.text = DateFormat(DEFAULT_DATE_FORMAT).format(widget.init!);
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
          labelText: widget.lead,
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
    if (widget.init != null) init = widget.init!;
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

class Select_Date_Time extends StatefulWidget {
  const Select_Date_Time({
    super.key, //
    this.init,
    this.lead, //
    this.onChanged,
    // required this.controller,
  });

  final DateTime? init;
  final String? lead;
  final Function(DateTime?)? onChanged;
  // final TextEditingController controller;

  @override
  State<Select_Date_Time> createState() => _Select_Date_TimeState();
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
      child: MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Select_Date_Time(
                lead: "Datetime Start:",
                init: DateTime.tryParse("2023-01-01 12:00"),
                onChanged: (DateTime? value) {
                  print("Selected datetime: $value");
                },
              ),
            ],
          ),
        ),
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
