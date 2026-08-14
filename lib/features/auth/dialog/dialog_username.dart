import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure_storage.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

class _Dialog_State extends State<Dialog_> {
  //
  dynamic tmp;

  final title = "Update Username"; //
  final label = "Username:";

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
            autofocus: true,
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
            onChanged: (v) => setState(() {}),
            onSubmitted: (v) => on_okay(),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context); //
          },
          child: Text("Cancel"), //
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
        endpoint.USER_CRUD_UPDATE, //
        data: {
          "_id": await secure_storage.read(key: "_id"), //
          sm_user.USERNAME: controller.text, //
        },
      );
      if (tmp == null) throw "Failed";

      //
      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Dialog_ extends StatefulWidget {
  const Dialog_({
    super.key, //
    this.input,
  });

  final String? input;

  @override
  State<Dialog_> createState() => _Dialog_State();
}

Future<dynamic> view({
  required BuildContext context, //
  String? input, //
}) {
  return showDialog<dynamic>(
    context: context,
    builder: (context) {
      return Dialog_(input: input); //
    },
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () async {
            final v = await view(
              context: context, //
              input: "0123456789", //
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
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
