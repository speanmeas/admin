import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់បោះបង់ការស្នាក់ (cancel)
Future<bool?> dialog_cancel({
  required BuildContext context, //
  required String lead,
  required String front_desk_id, //
}) async {
  String cancel_reason = "";

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

              // Text("Please confirm the cancel.", style: TextStyle(fontSize: 16)), //
              TextField(
                maxLines: 4,
                autofocus: true,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: "Cancel Reason",
                  prefixIcon: Icon(Icons.text_fields),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                onChanged: (v) {
                  cancel_reason = v;
                },
              ),
            ],
          ),
        ),
        //
        actions: [
          OutlinedButton.icon(
            // autofocus: true,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            icon: const Icon(Icons.cancel_outlined), //
            label: const Text("Cancel"),
            onPressed: () async {
              // stamp cancel on the stay (endpoint auto-sets cancel_at/by + check_out_at/by)
              dynamic tmp = await dio.post(
                endpoint.FRONT_DESK_CANCEL,
                data: {
                  Front_Desk.ID: front_desk_id, //
                  Front_Desk.CANCEL_REASON: cancel_reason, //
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
            final v = await dialog_cancel(
              context: context, //
              front_desk_id: "111111111122222222223333", //
              lead: "Cancel Stay in Room 201", //
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
