// * នាំចូល intl និង Flutter material សម្រាប់ UI
import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

// * ថ្នាក់ state របស់ Picker_Datetime គ្រប់គ្រងការជ្រើសរើសកាលបរិច្ឆេទ
class _Picker_DatetimeState extends State<Picker_Datetime> {
  //
  // * controller សម្រាប់អត្ថបទ
  final controller = TextEditingController();

  // * ចាប់ផ្តើមតម្លៃដំបូង
  void init() {
    if (widget.initial != null) {
      controller.text = DateFormat(DEFAULT_DATE_FORMAT).format(widget.initial!);
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
        // * ប៊ូតុងសម្អាតតម្លៃ
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
      // * បើក picker នៅពេលចុច
      onTap: () async {
        final v = await picker(context);
        if (v == null) return;
        controller.text = DateFormat(DEFAULT_DATE_FORMAT).format(v);
        widget.onChanged?.call(v);
        setState(() {});
      },
    );
  }

  // * បើក picker សម្រាប់ជ្រើសរើសកាលបរិច្ឆេទ និងពេលវេលា
  Future<DateTime?>? picker(BuildContext context) async {
    // * កំណត់កាលបរិច្ឆេទដំបូង
    DateTime init = DateTime.now();
    if (widget.initial != null) init = widget.initial!;

    // * ជ្រើសរើសកាលបរិច្ឆេទ
    final DateTime? picked_date = await showDatePicker(
      context: context, //
      initialDate: init, //
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked_date == null) return null;

    // * ជ្រើសរើសពេលវេលា
    TimeOfDay initial_time = TimeOfDay(hour: 0, minute: 0);
    if (widget.initial != null) initial_time = TimeOfDay.fromDateTime(widget.initial!);
    final TimeOfDay? picked_time = await showTimePicker(
      context: context, //
      initialTime: initial_time,
    );

    if (picked_time == null) return null;

    // * ផ្សំកាលបរិច្ឆេទ និងពេលវេលា
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

// * ថ្នាក់ Picker_Datetime ជា widget សម្រាប់ជ្រើសរើសកាលបរិច្ឆេទ
class Picker_Datetime extends StatefulWidget {
  const Picker_Datetime({
    super.key, //
    this.initial,
    this.title, //
    this.onChanged,
  });

  final String? title;
  final DateTime? initial;
  final Function(DateTime?)? onChanged;

  @override
  State<Picker_Datetime> createState() => _Picker_DatetimeState();
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
              Picker_Datetime(
                title: "Datetime Start:",
                initial: DateTime.tryParse("2023-01-01 12:00"),
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
