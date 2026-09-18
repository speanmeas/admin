import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_check_out_at_select({
  required BuildContext context, //
  DateTime? initial, //
  DateTime? check_in_at, //
}) async {
  DateTime init = initial ?? DateTime.now();

  final DateTime? picked_date = await showDatePicker(
    context: context, //
    initialDate: init, //
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked_date == null) return null;

  TimeOfDay initial_time = TimeOfDay(hour: 12, minute: 0);
  if (initial is DateTime) initial_time = TimeOfDay.fromDateTime(initial);
  final TimeOfDay? picked_time = await showTimePicker(
    context: context, //
    initialTime: initial_time,
  );
  if (picked_time == null) return null;

  final v = DateTime(
    picked_date.year, //
    picked_date.month,
    picked_date.day,
    picked_time.hour,
    picked_time.minute,
  );

  if (check_in_at != null && v.isBefore(check_in_at)) {
    snackbar(ct: context, ms: "Check-out must be after check-in", cl: Colors.red);
    return null;
  }

  return v.toIso8601String();
}

class _Main_State extends State<Main_> {
  String? tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_check_out_at_select(context: context);
            if (v == null) return;
            tmp = v;
            setState(() {});
          },
          child: const Text("Show"),
        ),
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      home: const Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
