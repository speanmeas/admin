import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

// * បង្ហាញ dialog សម្រាប់ផ្លាស់ប្តូរបន្ទប់ (change room)
Future<bool?> dialog_change_room({
  required BuildContext context, //
  required String lead,
  required String front_desk_id, //
  required List<dynamic> rooms, //
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      String? new_room_id;

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
        //
        content: SizedBox(
          width: 400,
          // height: 100,
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, color: Colors.grey),

              // * ជ្រើសរើសបន្ទប់ថ្មីដែល Available
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

              // Text("Please confirm the room change."), //
            ],
          ),
        ),
        //
        actions: [
          OutlinedButton.icon(
            // autofocus: true,
            icon: const Icon(Icons.check), //
            label: const Text("Confirm"),
            onPressed: () async {
              if (new_room_id == null) return snackbar(ct: context, ms: "Please select a new room", cl: Colors.red);

              dynamic tmp_fd = await dio.post(
                endpoint.FRONT_DESK_CHANGE,
                data: {
                  Front_Desk.ID: front_desk_id, //
                  Front_Desk.CHANGE_TO: new_room_id, //
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
            final v = await dialog_change_room(
              context: context, //
              front_desk_id: "111111111122222222223333", //
              rooms: [
                {Room.ID: "111111111122222222223333", Room.NUMBER: "201"},
                {Room.ID: "111111111122222222224444", Room.NUMBER: "202"},
              ],
              lead: "Change Room 201", //
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
