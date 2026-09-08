import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ជ្រើសរើសពេលចូល (check_in_at) — កាលបរិច្ឆេទ និងពេលវេលា
// * — ប្រើតែ CRUD endpoints ប៉ុណ្ណោះ (FRONT_DESK_UPDATE)
Future<bool?> dialog_update_check_in_at({
  required BuildContext context, //
  required String fd_id, //
  DateTime? initial, //
}) async {
  // * កំណត់កាលបរិច្ឆេទដំបូង
  DateTime init = DateTime.now();
  if (initial is DateTime) init = initial;

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
  if (initial is DateTime) initial_time = TimeOfDay.fromDateTime(initial);
  final TimeOfDay? picked_time = await showTimePicker(
    context: context, //
    initialTime: initial_time,
  );
  if (picked_time == null) return null;

  // * ផ្សំកាលបរិច្ឆេទ និងពេលវេលា
  final v = DateTime(
    picked_date.year, //
    picked_date.month,
    picked_date.day,
    picked_time.hour,
    picked_time.minute,
  );

  final tmp = await dio.post(
    endpoint.FRONT_DESK_UPDATE,
    data: {
      Front_Desk.ID: fd_id, //
      Front_Desk.CHECK_IN_AT: v.toIso8601String(), //
    },
  );
  if (tmp == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return null;
  }

  snackbar(ct: context, ms: "Updated", cl: Colors.green);
  return true;
}

class _Main_State extends State<Main_> {
  bool? tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_update_check_in_at(context: context, fd_id: "test");
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