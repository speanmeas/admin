import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_search_nationality(
  BuildContext context, //
) async {
  List<dynamic> nationalities = [];
  TextEditingController? nationality_ctrl;

  Future<List<String>> search(String q) async {
    dynamic tmp_n = await dio.post(endpoint.NATIONALITY_READ_SEARCH, data: {"query": q, "limit": 1000});
    nationalities = tmp_n.data as List<dynamic>? ?? [];
    final options = <String>[];
    for (var n in nationalities) {
      final text = "${n[Nationality.NAME] ?? ""}";
      options.add(text);
    }
    return options;
  }

  String? selected_name;

  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.topCenter,
            titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            contentPadding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            actionsAlignment: MainAxisAlignment.center,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Search Nationality", //
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
                  TypeAheadField<String>(
                    animationDuration: Duration.zero, //
                    itemBuilder: (context, item) => ListTile(title: Text(item)),
                    suggestionsCallback: search,
                    builder: (context, controller, focusNode) {
                      nationality_ctrl = controller;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!focusNode.hasFocus) focusNode.requestFocus();
                      });
                      return TextField(
                        autofocus: true,
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: "Search Nationality:",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                        ),
                      );
                    },
                    onSelected: (v) {
                      nationality_ctrl?.text = v;
                      for (var e in nationalities) {
                        if ("${e[Nationality.NAME] ?? ""}" == v) {
                          selected_name = e[Nationality.NAME] as String?;
                          break;
                        }
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton.icon(
                icon: const Icon(Icons.close, color: Colors.red), //
                label: const Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.check), //
                label: const Text("Confirm"),
                onPressed: () {
                  if (selected_name == null) return snackbar(ct: context, ms: "Please select a nationality", cl: Colors.red);
                  Navigator.pop(context, selected_name);
                },
              ),
            ],
          );
        },
      );
    },
  );
  return result;
}

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_search_nationality(context);
            if (v == null) return;
            setState(() {});
          },
          child: const Text("Show"),
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
      home: Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
