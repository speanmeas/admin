import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Datetime_Picker_(), //
    ),
  );
}

Future<DateTime?> datetime_picker(
  BuildContext context, { //
  DateTime? initial_datetime,
}) async {
  // Select Date
  final DateTime? picked_date = await showDatePicker(
    context: context, //
    initialDate: initial_datetime ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked_date == null) return null;

  // Select Time
  final TimeOfDay? picked_time = await showTimePicker(
    context: context, //
    initialTime: TimeOfDay(hour: 12, minute: 0),
    // initialTime: TimeOfDay.now(),
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

class Datetime_Picker_ extends StatefulWidget {
  const Datetime_Picker_({super.key});

  @override
  State<Datetime_Picker_> createState() => _Datetime_Picker_State();
}

class _Datetime_Picker_State extends State<Datetime_Picker_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date Time Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                final datetime = await datetime_picker(context);
                print(datetime);
              }, //
              label: const Text('Select Date & Time'),
              icon: const Icon(Icons.calendar_today),
            ),
          ],
        ),
      ),
    );
  }
}
