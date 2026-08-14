import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

//
// Confirm dialog — Yes/No with customizable title, message, button colors.
//
// Usage:
//   import "package:speanmeas/templates/dialog/confirm.dart" as confirm;
//
//   final ok = await confirm.confirm(
//     context,
//     title: "Delete?",
//     message: "Are you sure?",
//     confirmText: "Delete",
//     confirmColor: Colors.red,
//   );
//   if (ok != true) return;
//

Future<bool?> confirm(BuildContext context, {String title = "Confirm", String message = "Are you sure?", String cancelText = "Cancel", String confirmText = "OK", Color? confirmColor}) async {
  //

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        actionsPadding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        title: Text(
          title, //
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelText)),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText, //
              style: confirmColor != null ? TextStyle(color: confirmColor) : null,
            ),
          ),
        ],
      );
    },
  );

  //
  return result;
}

// ---------------------------------------------------------------------------
// Standalone dev
// ---------------------------------------------------------------------------

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () async {
            final ok = await confirm(context, title: "Delete?", message: "Delete this item?");
            if (ok == true) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Confirmed")));
            }
          },
          child: const Text("Confirm Dialog"),
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
  runApp(MaterialApp(home: const Scaffold(body: Main_()), debugShowCheckedModeBanner: false));
}
