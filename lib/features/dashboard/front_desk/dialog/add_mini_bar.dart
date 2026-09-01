import "package:flutter/material.dart";
import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog បញ្ជាក់ការបន្ថែម Mini Bar (Walk-In) តែប៉ុណ្ណោះ
Future<bool?> dialog_add_mini_bar({
  required BuildContext context, //
}) async {
  // * បើក (ឬបង្កើត) row Walk-In នៃថ្ងៃ shift នេះ
  final tmp_walk = await dio.post(endpoint.FRONT_DESK_WALK_IN);
  if (tmp_walk == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return false;
  }

  // * បង្ហាញ dialog បញ្ជាក់
  final saved = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        alignment: Alignment.topCenter,
        titlePadding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
        contentPadding: const EdgeInsets.all(4),
        actionsPadding: const EdgeInsets.all(4),
        actionsAlignment: MainAxisAlignment.center,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Mini Bar", //
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const SizedBox(
          width: 400,
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, color: Colors.grey),
              Text("Add mini bar for walk-in?"), //
            ],
          ),
        ),
        actions: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            icon: const Icon(Icons.check), //
            label: const Text("Confirm"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );
  if (saved != true) return false;

  snackbar(ct: context, ms: "Mini Bar Added", cl: Colors.green);
  return true;
}
