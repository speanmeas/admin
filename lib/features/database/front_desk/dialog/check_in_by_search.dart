import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_check_in_by_search({
  required BuildContext context, //
  required String? front_desk_id, //
}) async {
  dynamic tmp_u = await dio.post(endpoint.USER_READ, data: {"key": User.FULL_NAME, "order": 1});
  if (tmp_u == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return null;
  }

  final users = tmp_u.data as List<dynamic>? ?? [];

  return await showDialog<String>(
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
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 8),
              TypeAheadField<String>(
                itemBuilder: (context, item) => ListTile(title: Text(item)),
                suggestionsCallback: (q) {
                  final query = q.trim().toLowerCase();
                  final options = <String>[];
                  for (var u in users) {
                    final name = (u[User.FULL_NAME] ?? "").toString();
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
                      labelText: "Search User:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                    ),
                  );
                },
                onSelected: (v) async {
                  String? user_id;
                  String? full_name;
                  for (var u in users) {
                    if ((u[User.FULL_NAME] ?? "").toString() == v) {
                      user_id = u[User.ID];
                      full_name = u[User.FULL_NAME];
                      break;
                    }
                  }
                  if (user_id == null || front_desk_id == null) return;

                  Navigator.pop(context, full_name);

                  await dio.post(
                    endpoint.FRONT_DESK_UPDATE,
                    data: {
                      Front_Desk.ID: front_desk_id, //
                      Front_Desk.CHECK_IN_BY: user_id, //
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
            final v = await dialog_check_in_by_search(context: context, front_desk_id: "test");
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
