import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_guest_add({
  required BuildContext context, //
  required String fd_id, //
}) async {
  String? full_name;
  String? phone_number;
  final phone_focus = FocusNode();

  Future<void> on_confirm() async {
    if ((full_name ?? "").isEmpty && (phone_number ?? "").isEmpty) return;
    final guest = await dio.post(
      endpoint.GUEST_CREATE,
      data: {Guest.FULL_NAME: full_name, Guest.PHONE_NUMBER: phone_number},
    );
    if (guest == null) return;
    final guest_id = (guest.data as List?)?.firstOrNull?[Guest.ID] as String?;
    if (guest_id == null) return;
    final tmp = await dio.post(
      endpoint.FRONT_DESK_UPDATE_GUEST_INFO,
      data: {Front_Desk.ID: fd_id, Front_Desk.GUEST_ID: guest_id},
    );
    if (tmp == null) return;
    if (context.mounted) Navigator.pop(context, "${full_name ?? ""} (${phone_number ?? ""})");
  }

  return await showDialog<String?>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.topCenter,
            titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            contentPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Add Guest", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 0, color: Colors.grey),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: "Full Name:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => full_name = v,
                    onSubmitted: (_) => phone_focus.requestFocus(),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: "Phone Number:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    focusNode: phone_focus,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) => phone_number = v,
                    onSubmitted: (_) => on_confirm(),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: on_confirm,
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    },
  );
}

class _Main_State extends State<Main_> {
  String? tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_guest_add(context: context, fd_id: "test");
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