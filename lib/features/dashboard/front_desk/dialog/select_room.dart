import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ផ្លាស់ប្តូរបន្ទប់ (change room) — ស្វែងរក + ជ្រើសបន្ទប់ Available ដោយ typeahead
// * — Confirm ធ្វើ request តែប៉ុណ្ណោះ (FRONT_DESK_CHANGE)
Future<bool?> dialog_select_room({
  required BuildContext context, //
  required String lead,
  required String room_id, //
}) async {
  // * ទាញបន្ទប់ Available ពី server ដោយខ្លួនឯង
  dynamic tmp = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
  if (tmp == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return null;
  }

  final rooms = (tmp.data as List<dynamic>? ?? []).where((r) => r[Room.STATUS] == "Available").toList();

  String? new_room_id;
  bool is_loading = false;
  TextEditingController? room_ctrl;

  // * ស្វែងរកបន្ទប់ដោយលេខបន្ទប់
  List<String> search(String q) {
    final query = q.trim().toLowerCase();
    final options = <String>[];
    for (var r in rooms) {
      final number = (r[Room.NUMBER] ?? "").toString();
      if (query.isEmpty || number.toLowerCase().contains(query)) {
        options.add(number);
      }
    }
    return options;
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
            contentPadding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 0, color: Colors.grey),
                  const SizedBox(height: 8),

                  // * ស្វែងរក + ជ្រើសបន្ទប់ថ្មីដែល Available
                  TypeAheadField<String>(
                    animationDuration: Duration.zero, //
                    itemBuilder: (context, item) => ListTile(
                      title: Text(item),
                      leading: const Icon(Icons.meeting_room_outlined, color: Colors.blue),
                    ),
                    suggestionsCallback: search,
                    builder: (context, controller, focusNode) {
                      room_ctrl = controller;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!focusNode.hasFocus) focusNode.requestFocus();
                      });
                      return TextField(
                        autofocus: true,
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: "New Room:",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                        ),
                      );
                    },
                    onSelected: (v) {
                      room_ctrl?.text = v;
                      for (var r in rooms) {
                        if ((r[Room.NUMBER] ?? "").toString() == v) {
                          new_room_id = r[Room.ID];
                          break;
                        }
                      }
                      setState(() {});
                    },
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
                        if (new_room_id == null) return snackbar(ct: context, ms: "Please select a new room", cl: Colors.red);

                        setState(() => is_loading = true);
                        dynamic tmp_fd = await dio.post(
                          endpoint.FRONT_DESK_CHANGE,
                          data: {
                            Front_Desk.ROOM_ID: room_id, //
                            "new_room_id": new_room_id, //
                          },
                        );
                        if (tmp_fd == null) {
                          if (context.mounted) setState(() => is_loading = false);
                          return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
                        }

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
  bool? tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_select_room(
              context: context, //
              room_id: "111111111122222222223333", //
              lead: "Change Room 201", //
            );
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