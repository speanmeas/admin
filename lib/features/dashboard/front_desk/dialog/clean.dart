import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog បញ្ជាក់ការសម្អាតបន្ទប់ (Clean) — រួមទាំង dio request និង snackbar
// * — Confirm ធ្វើ request តែប៉ុណ្ណោះ (FRONT_DESK_CLEAN)
Future<bool?> dialog_clean({
  required BuildContext context, //
  required String lead,
  required String room_id, //
}) async {
  bool is_loading = false;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.topCenter,
            titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            contentPadding: const EdgeInsets.all(4),
            actionsPadding: const EdgeInsets.all(4),
            actionsAlignment: MainAxisAlignment.center,
            title: Row(
              mainAxisAlignment: .center,
              children: [
                Text(
                  lead, //
                  style: TextStyle(
                    fontSize: 20, //
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(height: 1, color: Colors.grey),
                  Text("Please confirm the clean.", style: TextStyle(fontSize: 16)), //
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
                        // stamp cleaned on the stay (endpoint auto-sets clean_at/by)
                        setState(() => is_loading = true);
                        dynamic tmp = await dio.post(
                          endpoint.FRONT_DESK_CLEAN,
                          data: {
                            Front_Desk.ROOM_ID: room_id, //
                          },
                        );
                        if (tmp == null) {
                          if (context.mounted) setState(() => is_loading = false);
                          return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
                        }

                        // room status auto-flips to Available + clears front_desk_id on the backend
                        snackbar(ct: context, ms: "Success", cl: Colors.green);
                        if (context.mounted) Navigator.pop(context, true);
                      },
              ),
            ],
          );
        },
      );
    },
  );
  return result;
}

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_clean(
              context: context, //
              room_id: "111111111122222222223333", //
              lead: "Clean Room 201", //
            );
            if (v == null) return;
            // page = v;
            pprint(v);
            setState(() {});
          },
          child: const Text("Show"),
        ),
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      home: Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}