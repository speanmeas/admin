import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog ជ្រើសរើសអ្នកចូល (check_in_by) ពីបញ្ជីអ្នកប្រើ
// * — ប្រើតែ CRUD endpoints ប៉ុណ្ណោះ (USER_READ + FRONT_DESK_UPDATE)
Future<bool?> dialog_select_check_in_by({
  required BuildContext context, //
  required String? front_desk_id, //
}) async {
  dynamic tmp_u = await dio.post(endpoint.USER_READ, data: {"key": User.FULL_NAME, "order": 1});
  if (tmp_u == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return null;
  }

  final users = tmp_u.data as List<dynamic>? ?? [];

  String? new_user_id;
  bool is_loading = false;

  // * ស្វែងរកអ្នកប្រើដោយ full_name
  List<String> search(String q) {
    final query = q.trim().toLowerCase();
    final options = <String>[];
    for (var u in users) {
      final name = (u[User.FULL_NAME] ?? "").toString();
      if (query.isEmpty || name.toLowerCase().contains(query)) {
        options.add(name);
      }
    }
    return options;
  }

  final v = await showDialog<bool>(
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
            title: Row(
              mainAxisAlignment: .center,
              children: [
                Text(
                  "Select Check-in User", //
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(height: 1, color: Colors.grey),
                  SizedBox(height: 8),
                  TypeAheadField<String>(
                    itemBuilder: (context, item) => ListTile(title: Text(item)),
                    suggestionsCallback: search,
                    builder: (context, controller, focusNode) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!focusNode.hasFocus) focusNode.requestFocus();
                      });
                      return TextField(
                        autofocus: true,
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: "Search User:",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                        ),
                      );
                    },
                    onSelected: (v) {
                      for (var u in users) {
                        if ((u[User.FULL_NAME] ?? "").toString() == v) {
                          new_user_id = u[User.ID];
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
                icon: const Icon(Icons.close), //
                label: const Text("Cancel"),
                onPressed: is_loading ? null : () => Navigator.pop(context, false),
              ),
              OutlinedButton.icon(
                icon: is_loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check), //
                label: const Text("Confirm"),
                onPressed: is_loading
                    ? null
                    : () async {
                        if (new_user_id == null) return snackbar(ct: context, ms: "Please select a user", cl: Colors.red);

                        setState(() => is_loading = true);
                        dynamic tmp_fd = await dio.post(
                          endpoint.FRONT_DESK_UPDATE,
                          data: {
                            Front_Desk.ID: front_desk_id, //
                            Front_Desk.CHECK_IN_BY: new_user_id, //
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
  return v;
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
            final v = await dialog_select_check_in_by(context: context, front_desk_id: "test");
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

