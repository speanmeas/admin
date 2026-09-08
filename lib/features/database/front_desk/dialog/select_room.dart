import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

// * បង្ហាញ dialog សម្រាប់ផ្លាស់បន្ទប់ — ប្រើតែ CRUD endpoints ប៉ុណ្ណោះ (ROOM_READ + FRONT_DESK_UPDATE)
// * — ជ្រើសបន្ទប់ទាំងអស់ គ្មានលក្ខខណ្ឌ (រួមទាំង walk-in)
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
  final v = await showDialog<bool>(
    context: context,
    builder: (context) {
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
              "Change Room", //
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 8),
              Select_Dynamic(
                lead: "New Room:",
                init: null, //
                options: [for (var r in rooms) r[Room.NUMBER]], //
                prefixIcon: Icons.meeting_room_outlined, //
                noClear: true, //
                onChanged: (v) {
                  String? number = v?.toString();
                  for (var r in rooms) {
                    if (r[Room.NUMBER]?.toString() == number) {
                      new_room_id = r[Room.ID];
                      break;
                    }
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton.icon(
            icon: const Icon(Icons.check), //
            label: const Text("Confirm"),
            onPressed: () async {
              if (new_room_id == null) return snackbar(ct: context, ms: "Please select a new room", cl: Colors.red);

              // * ធ្វើបច្ចុប្បន្នភាព room_id របស់ stay (CRUD update)
              dynamic tmp_fd = await dio.post(
                endpoint.FRONT_DESK_UPDATE,
                data: {
                  Front_Desk.ID: front_desk_id, //
                  Front_Desk.ROOM_ID: new_room_id, //
                },
              );
              if (tmp_fd == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

              snackbar(ct: context, ms: "Success", cl: Colors.green);
              Navigator.pop(context, true);
            },
          ),
        ],
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

