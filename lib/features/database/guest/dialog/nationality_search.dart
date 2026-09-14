import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_nationality_search({
  required BuildContext context, //
  required String? guest_id, //
}) async {
  dynamic tmp_n = await dio.post(endpoint.NATIONALITY_READ, data: {"key": Nationality.NAME, "order": 1});
  if (tmp_n == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return null;
  }

  final nationalities = tmp_n.data as List<dynamic>? ?? [];

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        alignment: Alignment.topCenter,
        titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
        contentPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        title: const Row(
          mainAxisAlignment: .center,
          children: [
            Text(
              "Select Nationality", //
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 8),
              TypeAheadField<String>(
                itemBuilder: (context, item) => ListTile(title: Text(item)),
                suggestionsCallback: (q) {
                  final query = q.trim().toLowerCase();
                  final options = <String>[];
                  for (var n in nationalities) {
                    final name = (n[Nationality.NAME] ?? "").toString();
                    if (query.isEmpty || name.toLowerCase().contains(query)) {
                      options.add(name);
                    }
                  }
                  return options;
                },
                builder: (context, controller, focusNode) {
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
                onSelected: (v) async {
                  String? nationality_name;
                  for (var n in nationalities) {
                    final name = (n[Nationality.NAME] ?? "").toString();
                    if (name == v) {
                      nationality_name = name;
                      break;
                    }
                  }
                  if (nationality_name == null || guest_id == null) return;

                  Navigator.pop(context, nationality_name);

                  await dio.post(
                    endpoint.GUEST_UPDATE,
                    data: {
                      Guest.ID: guest_id, //
                      Guest.NATIONALITY: nationality_name, //
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _Main_State extends State<Main_> {
  String? tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_nationality_search(context: context, guest_id: "test");
            if (v == null) return;
            tmp = v;
            setState(() {});
          },
          child: const Text("Show"),
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
      home: const Main_(), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
