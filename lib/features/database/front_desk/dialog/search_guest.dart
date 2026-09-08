import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ស្វែងរកភ្ញៀវ ហើយភ្ជាប់ទៅ front desk (ដូច dashboard)
// * — ប្រើតែ CRUD endpoints ប៉ុណ្ណោះ (GUEST_READ_SEARCH / FRONT_DESK_UPDATE)
Future<bool?> dialog_search_guest({
  required BuildContext context, //
  required String? front_desk_id, //
}) async {
  String? guest_id;
  List<dynamic> guests = [];
  bool is_loading = false;
  TextEditingController? guest_ctrl;

  // * ស្វែងរកភ្ញៀវពី server
  Future<List<String>> search(String q) async {
    dynamic tmp_g = await dio.post(
      endpoint.GUEST_READ_SEARCH,
      data: {
        "query": q, //
        "limit": 1000, //
      },
    );

    guests = tmp_g.data as List<dynamic>? ?? [];

    final options = <String>[];

    for (var g in guests) {
      final text = "${g[Guest.FULL_NAME] ?? ""} (${g[Guest.PHONE_NUMBER] ?? "N/A"})";
      options.add(text);
    }

    return options;
  }

  final result = await showDialog<bool>(
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
                    animationDuration: Duration.zero, //
                    itemBuilder: (context, item) => ListTile(title: Text(item)),
                    suggestionsCallback: search,
                    builder: (context, controller, focusNode) {
                      guest_ctrl = controller;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!focusNode.hasFocus) focusNode.requestFocus();
                      });
                      return TextField(
                        autofocus: true,
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: "Search Guest:",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                        ),
                      );
                    },
                    onSelected: (v) {
                      guest_ctrl?.text = v;
                      for (var e in guests) {
                        if ("${e[Guest.FULL_NAME] ?? ""} (${e[Guest.PHONE_NUMBER] ?? "N/A"})" == v) {
                          guest_id = e[Guest.ID] as String?;
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
                onPressed: is_loading ? null : () => Navigator.pop(context, false),
              ),
              OutlinedButton.icon(
                icon: is_loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check), //
                label: const Text("Confirm"),
                onPressed: is_loading
                    ? null
                    : () async {
                        if (guest_id == null) return snackbar(ct: context, ms: "Please select a guest", cl: Colors.red);

                        setState(() => is_loading = true);
                        dynamic tmp_fd = await dio.post(
                          endpoint.FRONT_DESK_UPDATE,
                          data: {
                            Front_Desk.ID: front_desk_id, //
                            Front_Desk.GUEST_ID: guest_id, //
                          },
                        );
                        if (tmp_fd == null) {
                          if (context.mounted) setState(() => is_loading = false);
                          return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
                        }

                        snackbar(ct: context, ms: "Success", cl: Colors.green);
                        if (context.mounted) Navigator.pop(context, true);
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
  bool? tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_search_guest(context: context, front_desk_id: "test");
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
