import "package:flutter/material.dart";

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
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              OutlinedButton.icon(
                icon: const Icon(Icons.close, color: Colors.red), //
                label: const Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.check), //
                label: const Text("Confirm"), //
                onPressed: () async {
                  if ((full_name ?? "").isEmpty && (phone_number ?? "").isEmpty) return;
                  final guest = await dio.post(
                    endpoint.GUEST_CREATE,
                    data: {
                      Guest.FULL_NAME: full_name, //
                      Guest.PHONE_NUMBER: phone_number,
                    },
                  );
                  if (guest == null) return;
                  final guest_id = (guest.data as List?)?.firstOrNull?[Guest.ID] as String?;
                  if (guest_id == null) return;
                  final tmp = await dio.post(
                    endpoint.FRONT_DESK_UPDATE_GUEST_INFO,
                    data: {
                      Front_Desk.ID: fd_id, //
                      Front_Desk.GUEST_ID: guest_id, //
                    },
                  );
                  if (tmp == null) return;
                  if (context.mounted) Navigator.pop(context, "${full_name ?? ""} (${phone_number ?? ""})");
                },
              ),
            ],
          );
        },
      );
    },
  );
}
