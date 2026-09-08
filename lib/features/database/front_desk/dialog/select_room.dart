import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ផ្លាស់បន្ទប់ — ប្រើតែ CRUD endpoints ប៉ុណ្ណោះ (ROOM_READ + FRONT_DESK_UPDATE)
// * — ជ្រើសបន្ទប់ទាំងអស់ គ្មានលក្ខខណ្ឌ (រួមទាំង walk-in); Confirm ធ្វើ request
Future<bool?> dialog_select_room({
  required BuildContext context, //
  required String? front_desk_id, //
}) async {
  // * ទាញបន្ទប់ទាំងអស់ពី server (CRUD read)
  dynamic tmp_r = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
  if (tmp_r == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return null;
  }

  final rooms = tmp_r.data as List<dynamic>? ?? [];

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
                  "Select Room", //
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
                  const SizedBox(height: 8),
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
                          labelText: "Room:",
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
                icon: const Icon(Icons.close), //
                label: const Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              OutlinedButton.icon(
                icon: is_loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check), //
                label: const Text("Confirm"),
                onPressed: is_loading
                    ? null
                    : () async {
                        if (new_room_id == null) return snackbar(ct: context, ms: "Please select a room", cl: Colors.red);

                        // * ធ្វើបច្ចុប្បន្នភាព room_id របស់ stay (CRUD update)
                        setState(() => is_loading = true);
                        dynamic tmp_fd = await dio.post(
                          endpoint.FRONT_DESK_UPDATE,
                          data: {
                            Front_Desk.ID: front_desk_id, //
                            Front_Desk.ROOM_ID: new_room_id, //
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
            final v = await dialog_select_room(context: context, front_desk_id: "test");
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
