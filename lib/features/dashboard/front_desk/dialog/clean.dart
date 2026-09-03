import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ជ្រើសរើសលេខទំព័រ
Future<bool?> dialog_clean({
  required BuildContext context, //
  required String lead,
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

              Text("Please confirm the clean.", style: TextStyle(fontSize: 16)), //
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
              // stamp cleaned on the stay (endpoint auto-sets clean_at/by)
              dynamic tmp = await dio.post(
                endpoint.FRONT_DESK_CLEAN,
                data: {
                  Front_Desk.ROOM_ID: room_id, //
                },
              );
              if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

              // room status auto-flips to Available + clears front_desk_id on the backend
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
