import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import

//
// Input dialog — Single text field, returns the entered string or null.
//
// Usage:
//   import "package:speanmeas/templates/dialog/input.dart" as input;
//
//   final name = await input.input(
//     context,
//     title: "Enter Name",
//     hint: "Full name...",
//   );
//   if (name == null) return;
//

Future<String?> input(BuildContext context, {String title = "Input", String hint = "", String cancelText = "Cancel", String confirmText = "OK", TextInputType keyboardType = TextInputType.text, List<TextInputFormatter>? inputFormatters}) async {
  //

  final controller = TextEditingController();

  //
  final result = await showDialog<String>(
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
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(hintText: hint, border: const OutlineInputBorder(), isDense: true),
          autofocus: true,
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: Text(cancelText)),
          OutlinedButton(onPressed: () => Navigator.pop(context, controller.text), child: Text(confirmText)),
        ],
      );
    },
  );

  //
  controller.dispose();
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
            final v = await input(context, title: "Enter Name", hint: "Your name...");
            if (v != null && v.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hello, $v")));
            }
          },
          child: const Text("Input Dialog"),
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
