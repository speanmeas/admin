import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_guest_update({
  required BuildContext context, //
  required String fd_id, //
  required String guest_id, //
  String? current_name, //
  String? current_phone, //
}) async {
  final name_ctrl = TextEditingController(text: current_name ?? "");
  final phone_ctrl = TextEditingController(text: current_phone ?? "");
  final phone_focus = FocusNode();

  Future<void> on_confirm() async {
    final tmp = await dio.post(
      endpoint.GUEST_UPDATE,
      data: {
        Guest.ID: guest_id, //
        Guest.FULL_NAME: name_ctrl.text, //
        Guest.PHONE_NUMBER: phone_ctrl.text,
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    if (context.mounted) Navigator.pop(context, "${name_ctrl.text} (${phone_ctrl.text})");
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
                    controller: phone_ctrl,
                    focusNode: phone_focus,
                    textInputAction: TextInputAction.done,
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