import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ជ្រើសរើសលេខទំព័រ
Future<bool?> dialog_check_out({
  required BuildContext context, //
  required String lead,
  required String front_desk_id, //
  required String room_id, //
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
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

              Text("Please confirm the check-out.", style: TextStyle(fontSize: 16)), //
            ],
          ),
        ),
        //
        actions: [
          OutlinedButton.icon(
            // autofocus: true,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            icon: const Icon(Icons.logout_outlined), //
            label: const Text("Check Out"),
            onPressed: () async {
              // create Check_Out child + set check_out_id on the stay
              dynamic tmp = await dio.post(
                endpoint.FRONT_DESK_CHECK_OUT,
                data: {
                  Front_Desk.ID: front_desk_id, //
                },
              );
              if (tmp == null) return snackbar(ct: context, ms: "Error: Check-Out", cl: Colors.red);

              // update room status to dirty
              await dio.post(
                endpoint.ROOM_UPDATE,
                data: {
                  Room.ID: room_id, //
                  Room.STATUS: "Dirty", //
                },
              );

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
            final v = await dialog_check_out(
              context: context, //
              room_id: "111111111122222222223333", //
              front_desk_id: "111111111122222222223333", //
              lead: "Check-Out from Room 201", //
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
