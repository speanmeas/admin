import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure_storage.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart" as sb; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart" as theme; // ignore: unused_import

import "../schema.g.dart" as sm;

class _Dialog_State extends State<Dialog_> {
  dynamic tmp;
  final title = "Update Full Name"; //
  final label = "Full Name:";

  late final controller = TextEditingController(text: widget.input ?? "");

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(4),
      actionsPadding: EdgeInsets.all(4),
      alignment: AlignmentGeometry.topCenter, //
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
        ],
      ),

      content: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label, //
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: ExcludeFocus(
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: controller.clear,
                  ), //
                ),
              ),
            ),
            autofocus: true,
            onChanged: (v) => setState(() {}),
            onSubmitted: (v) => on_okay(),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          child: Text("Cancel"), //
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context); //
          }, //
        ),
        OutlinedButton(
          onPressed: on_okay, //
          child: Text("Okay"), //
        ),
      ],
    );
  }

  void on_okay() async {
    try {
      tmp = await dio.post(
        ep.USER_UPDATE, //
        data: {
          "_id": await ss.read(key: "_id"), //
          sm.FULL_NAME: controller.text, //
        },
      );

      if (tmp == null) throw "Failed";

      Navigator.pop(context, true);
      sb.view(context: context, message: "Success", color: Colors.green);
      //
    } catch (e) {
      sb.view(context: context, message: e.toString(), color: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Dialog_ extends StatefulWidget {
  Dialog_({
    super.key, //
    this.input,
  });

  final dynamic input;

  @override
  State<Dialog_> createState() => _Dialog_State();
}

Future<dynamic> view({
  required BuildContext context, //
  dynamic input, //
}) {
  return showDialog<dynamic>(
    context: context,
    builder: (context) {
      return Dialog_(input: input); //
    },
  );
}

class _Main_State extends State<Main_> {
  dynamic tmp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () async {
            final v = await view(
              context: context, //
              input: "John Doe",
            );
            print("value: $v");
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
