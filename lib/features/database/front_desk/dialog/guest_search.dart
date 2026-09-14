import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_guest_search({
  required BuildContext context, //
  required String fd_id, //
}) async {
  List<dynamic> guests = [];

  Future<List<String>> search(String q) async {
    dynamic tmp_g = await dio.post(endpoint.GUEST_READ_SEARCH, data: {"query": q, "limit": 1000});
    guests = tmp_g.data as List<dynamic>? ?? [];
    final options = <String>[];
    for (var g in guests) {
      final text = "${g[Guest.FULL_NAME] ?? "N/A"} (${g[Guest.PHONE_NUMBER] ?? "N/A"})";
      options.add(text);
    }
    return options;
  }

  return await showDialog<String?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        alignment: Alignment.topCenter,
        titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
        contentPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Search Guest", //
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
                itemBuilder: (context, item) => ListTile(title: Text(item)),
                suggestionsCallback: search,
                builder: (context, controller, focusNode) {
                  return TextField(
                    autofocus: true,
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: "Search:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                    ),
                  );
                },
                onSelected: (v) async {
                  for (var e in guests) {
                    if ("${e[Guest.FULL_NAME] ?? ""} (${e[Guest.PHONE_NUMBER] ?? "N/A"})" == v) {
                      final tmp = await dio.post(
                        endpoint.FRONT_DESK_UPDATE_GUEST_INFO,
                        data: {
                          Front_Desk.ID: fd_id, //
                          Front_Desk.GUEST_ID: e[Guest.ID], //
                        },
                      );
                      if (tmp != null) Navigator.pop(context, v);
                      return;
                    }
                  }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () => dialog_guest_search(
            context: context, //
            fd_id: "",
          ),
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
