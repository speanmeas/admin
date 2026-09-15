import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_guest_update({
  required BuildContext context, //
  required String fd_id, //
  required String guest_id, //
  String? current_name, //
  String? current_phone, //
}) async {
  String? full_name = current_name;
  String? phone_number = current_phone;
  final name_ctrl = TextEditingController(text: current_name ?? "");
  final phone_ctrl = TextEditingController(text: current_phone ?? "");
  final phone_focus = FocusNode();

  Future<void> on_confirm() async {
    if ((full_name ?? "").isEmpty && (phone_number ?? "").isEmpty) return;
    final tmp = await dio.post(
      endpoint.GUEST_UPDATE,
      data: {
        Guest.ID: guest_id, //
        Guest.FULL_NAME: full_name, //
        Guest.PHONE_NUMBER: phone_number,
      },
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
                Text("Update Guest", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    controller: name_ctrl,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => full_name = v,
                    onSubmitted: (_) => phone_focus.requestFocus(),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Phone Number:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    controller: phone_ctrl,
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
                onPressed: () async {
                  await on_confirm();
                },
                child: const Text("Confirm"),
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
            final v = await dialog_guest_update(context: context, fd_id: "test", guest_id: "test");
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