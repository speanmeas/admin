import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog បញ្ជាក់ការបន្ថែមជួរដេកថ្មី (Add Row) — រួមទាំង dio request និង snackbar
// * — ប្រើតែ CRUD endpoints ប៉ុណ្ណោះ (FRONT_DESK_CREATE)
Future<bool?> dialog_add_row({
  required BuildContext context, //
  required DateTime shift_date, //
}) async {
  bool is_loading = false;

  final v = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.topCenter,
            titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            contentPadding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            actionsAlignment: MainAxisAlignment.center,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Row", //
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 0, color: Colors.grey),
                  const Text(
                    "Are you sure you want to add a new row?", //
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton.icon(
                icon: const Icon(Icons.close, color: Colors.red), //
                label: const Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: is_loading ? null : () => Navigator.pop(context, false),
              ),
              OutlinedButton.icon(
                icon: is_loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check), //
                label: const Text("Confirm"),
                onPressed: is_loading
                    ? null
                    : () async {
                        setState(() => is_loading = true);
                        final tmp = await dio.post(
                          endpoint.FRONT_DESK_CREATE,
                          data: {
                            Front_Desk.SHIFT_DATE: shift_date.toIso8601String(), //
                          },
                        );
                        if (tmp == null) {
                          if (context.mounted) setState(() => is_loading = false);
                          return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
                        }

                        snackbar(ct: context, ms: "Created", cl: Colors.green);
                        if (context.mounted) Navigator.pop(context, true);
                      },
              ),
            ],
          );
        },
      );
    },
  );
  return v;
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
            final v = await dialog_add_row(context: context, shift_date: DateTime.now());
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
