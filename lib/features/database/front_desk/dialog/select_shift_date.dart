import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog ជ្រើសរើសកាលបរិច្ឆេទតែប៉ុណ្ណោះ (yyyy-MM-dd) — ដូច report
// * — ប្រើតែ CRUD endpoints ប៉ុណ្ណោះ (FRONT_DESK_UPDATE)
Future<bool?> dialog_select_shift_date({
  required BuildContext context, //
  required String? front_desk_id, //
  DateTime? initial, //
}) async {
  final picked = await showDatePicker(
    context: context, //
    initialDate: initial ?? DateTime.now(), //
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked == null) return null;

  final v = DateTime(picked.year, picked.month, picked.day);

  final tmp = await dio.post(
    endpoint.FRONT_DESK_UPDATE,
    data: {
      Front_Desk.ID: front_desk_id, //
      Front_Desk.SHIFT_DATE: v.toIso8601String(), //
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
            final v = await dialog_select_shift_date(context: context, front_desk_id: "test");
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

