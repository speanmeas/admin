import "package:flutter/material.dart";

Future<DateTime?> datetime_picker(
  BuildContext context, { //
  DateTime? initial_datetime,
}) async {
  // select date
  final DateTime? picked_date = await showDatePicker(
    context: context, //
    initialDate: initial_datetime ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked_date == null) return null;

  // select time
  final initial_time = initial_datetime != null ? TimeOfDay.fromDateTime(initial_datetime) : TimeOfDay(hour: 12, minute: 0);
  final TimeOfDay? picked_time = await showTimePicker(
    context: context, //
    initialTime: initial_time,
    // initialTime: TimeOfDay.now(),
  );

  if (picked_time == null) return null;

  // combine date and time
  final DateTime picked_datetime = DateTime(
    picked_date.year, //
    picked_date.month,
    picked_date.day,
    picked_time.hour,
    picked_time.minute,
  );

  return picked_datetime;
}

class _Datetime_Picker_State extends State<Datetime_Picker_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Date Time Picker"),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), //
          child: Divider(height: 1, color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                await datetime_picker(context);
                // print(datetime);
              }, //
              label: const Text("Select Date & Time"),
              icon: const Icon(Icons.calendar_today),
            ),
          ],
        ),
      ),
    );
  }
}

class Datetime_Picker_ extends StatefulWidget {
  const Datetime_Picker_({super.key});

  @override
  State<Datetime_Picker_> createState() => _Datetime_Picker_State();
}

void main() {
  runApp(
    MaterialApp(
      home: Datetime_Picker_(), //
    ),
  );
}
