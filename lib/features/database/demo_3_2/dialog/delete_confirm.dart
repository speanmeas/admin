import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:speanmeas/core/utility/all.dart";

// សួរបញ្ជាក់ និងលុប Demo 3-2 — សំណើ dio នៅក្នុង dialog នេះ
Future<bool> dialog_demo_3_2_delete_confirm({
  required BuildContext context, //
  required String demo_3_2_id, //
  String? item, //
}) async {
  bool is_loading = false;

  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              //
              Future<void> submit() async {
                setState(() => is_loading = true);
                final tmp = await dio.post(
                  endpoint.DEMO_3_2_DELETE, //
                  data: {Demo_3_2.ID: demo_3_2_id},
                );
                if (!context.mounted) return;
                if (tmp == null) {
                  setState(() => is_loading = false);
                  snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
                  return;
                }
                Navigator.pop(context, true);
              }

              return AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                alignment: Alignment.topCenter,
                titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                contentPadding: const EdgeInsets.all(4),
                actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                actionsAlignment: MainAxisAlignment.end,
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Confirm Delete", //
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: Focus(
                  autofocus: true,
                  onKeyEvent: (node, event) {
                    if (is_loading) return KeyEventResult.ignored;
                    if (event is KeyDownEvent && (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
                      submit();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(height: 0, color: Colors.grey),
                        Text((item ?? "").trim().isEmpty ? "Delete this row?" : "Delete \"${item!.trim()}\"?", style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                actions: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.grey, padding: const EdgeInsets.symmetric(horizontal: 16)),
                    onPressed: is_loading ? null : () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 16)),
                    onPressed: is_loading ? null : submit,
                    child: is_loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text("Delete"),
                  ),
                ],
              );
            },
          );
        },
      ) ??
      false;
}

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            await dialog_demo_3_2_delete_confirm(context: context, demo_3_2_id: "test-id", item: "Sample");
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
