import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_guest_add({
  required BuildContext context, //
  required String fd_id, //
}) async {
  String? full_name;
  String? phone_number;

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
                Text(
                  "Add Guest", //
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
                  TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: "Full Name:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onChanged: (v) => full_name = v,
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
                    onChanged: (v) => phone_number = v,
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
                  if ((full_name ?? "").isEmpty && (phone_number ?? "").isEmpty) return;
                  final res = await dio.post(
                    endpoint.FRONT_DESK_SET_GUEST,
                    data: {
                      "_id": fd_id,
                      "full_name": full_name,
                      "phone_number": phone_number,
                    },
                  );
                  if (res == null) return;
                  final updated = (res.data as List?)?.firstOrNull;
                  final guestObj = updated?[Front_Desk.GUEST_ID];
                  final formatted = (guestObj is Map)
                      ? "${guestObj[Guest.FULL_NAME] ?? "N/A"} (${guestObj[Guest.PHONE_NUMBER] ?? "N/A"})"
                      : "${full_name ?? ""} (${phone_number ?? ""})";
                  if (context.mounted) Navigator.pop(context, formatted);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    },
  );
}
