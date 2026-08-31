import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់បង្កើត Demo 2-2 ថ្មី
Future<Map<String, dynamic>?> dialog_create_demo_2_2({
  required BuildContext context, //
}) async {
  String text = "";
  String number = "";

  final result = await showDialog<Map<String, dynamic>>(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create Demo 2-2", //
              style: TextStyle(
                fontSize: 20, //
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, color: Colors.grey),

              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: "Text:",
                  prefixIcon: Icon(Icons.text_fields),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                onChanged: (v) {
                  text = v;
                },
              ),

              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: "Number:",
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                onChanged: (v) {
                  number = v;
                },
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("Create"),
            onPressed: () async {
              dynamic tmp = await dio.post(
                endpoint.DEMO_2_2_CREATE,
                data: {
                  Demo_2_2.TEXT: text, //
                  Demo_2_2.NUMBER: int.tryParse(number), //
                },
              );
              if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

              snackbar(ct: context, ms: "Created", cl: Colors.green);
              Navigator.pop(context, tmp.data[0]);
            },
          ),
        ],
      );
    },
  );
  return result;
}
