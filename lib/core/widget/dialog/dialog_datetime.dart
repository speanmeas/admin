// * នាំចូល Flutter material សម្រាប់ dialog
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ជ្រើសរើសកាលបរិច្ឆេទ និងពេលវេលា
Future<DateTime?> dialog_datetime(
  BuildContext context, {
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
  return DateTime(
    picked_date.year, //
    picked_date.month,
    picked_date.day,
    picked_time.hour,
    picked_time.minute,
  );
}

class _Main_State extends State<Main_> {
  DateTime? dt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selected: ${dt == null ? "-" : format_datetime(dt)}", //
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            //
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () async {
                final v = await dialog_datetime(context, initial: dt);
                if (v == null) return;
                dt = v;
                setState(() {});
              },
              child: const Text("Select Datetime"),
            ),
          ],
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
        home: const Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
