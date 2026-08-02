import "package:flutter/material.dart";
import "package:speanmeas/core/theme/theme_data.dart";

/// Usage:
///   import "..." as dialog;
///   dialog.view(context);

Future<dynamic> view(
  BuildContext context, //
) async {
  //

  final result = await showDialog<dynamic>(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        contentPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        title: Text(
          "Title", //
          // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Container(
          width: 300,
          height: 400,
          child: Column(
            children: [
              Text("Content"), //
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              //
              Navigator.of(context).pop(null);
            },
            child: Text("Cancel"),
          ),
          OutlinedButton(
            onPressed: () {
              //
              Navigator.of(context).pop(null);
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );

  //
  return result;
}

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () => view(context), //
          child: Text("Show Dialog"),
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
      theme: Theme_Data(), //
      home: Scaffold(body: Main_()),
      debugShowCheckedModeBanner: false,
    ),
  );
}
