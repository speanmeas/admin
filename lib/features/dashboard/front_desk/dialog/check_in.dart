import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:speanmeas/core/utility/all.dart";

Future<bool?> dialog_check_in({
  required BuildContext context, //
  required String lead,
  required String room_number, //
}) async {
  bool is_loading = false;

  Future<void> on_confirm(StateSetter setState) async {
    setState(() => is_loading = true);
    dynamic tmp_fd = await dio.post(
      endpoint.FRONT_DESK_CHECK_IN,
      data: {Front_Desk.ROOM_NUMBER: room_number},
    );
    if (tmp_fd == null) {
      if (context.mounted) setState(() => is_loading = false);
      return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    }

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    if (context.mounted) Navigator.pop(context, true);
  }

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(lead, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Focus(
              autofocus: true,
              onKeyEvent: (node, event) {
                if (is_loading) return KeyEventResult.ignored;
                if (event is KeyDownEvent && (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
                  on_confirm(setState);
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: const SizedBox(
                width: 400,
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 1, color: Colors.grey),
                    Text("Please confirm the check-in."),
                  ],
                ),
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
                    : () => on_confirm(setState),
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
            final v = await dialog_check_in(context: context, room_number: "201", lead: "Check-In Room 201");
            if (v == null) return;
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