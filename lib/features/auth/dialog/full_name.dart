import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;

Future<String?> input(
  BuildContext context, {
  String title = "Input",
  String hint = "",
  String cancelText = "Cancel",
  String confirmText = "OK",
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
}) async {
  //

  final controller = TextEditingController();

  //
  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        actionsPadding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        title: Text(
          "Update Name", //
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          // keyboardType: keyboardType,
          // inputFormatters: inputFormatters,
          decoration: InputDecoration(
            // hintText: hint, //
            border: const OutlineInputBorder(),
            // isDense: true,
          ),
          autofocus: true,
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Cancel"), //
            onPressed: () {
              Navigator.pop(context); //
            }, //
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context, controller.text); //
            }, //
            child: Text(confirmText),
          ),
        ],
      );
    },
  );

  //
  controller.dispose();
  return result;
}

class _Main_State extends State<Main_> {
  dynamic tmp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () async {
            final v = await input(
              context,
              title: "Enter Name", //
              hint: "Your name...",
            );
            print(v);
          },
          child: const Text("Show Dialog"),
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
      title: "Development", //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
