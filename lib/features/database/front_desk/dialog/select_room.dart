import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_select_room({
  required BuildContext context, //
}) async {
  dynamic tmp_r = await dio.post(
    endpoint.ROOM_READ, //
    data: {"key": Room.NUMBER, "order": 1},
  );
  if (tmp_r == null) {
    snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    return null;
  }

  final rooms = tmp_r.data as List<dynamic>? ?? [];

  final v = await showDialog<String>(
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
              "Search:", //
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
                itemBuilder: (context, item) => ListTile(
                  title: Text(item),
                  leading: const Icon(Icons.meeting_room_outlined, color: Colors.blue),
                ),
                suggestionsCallback: (q) {
                  final query = q.trim().toLowerCase();
                  final options = <String>[];
                  for (var r in rooms) {
                    final number = (r[Room.NUMBER] ?? "").toString();
                    if (query.isEmpty || number.toLowerCase().contains(query)) {
                      options.add(number);
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
                      labelText: "Room:",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                    ),
                  );
                },
                onSelected: (v) {
                  String? room_number;
                  for (var r in rooms) {
                    if ((r[Room.NUMBER] ?? "").toString() == v) {
                      room_number = r[Room.NUMBER];
                      break;
                    }
                  }
                  if (room_number == null) return;
                  Navigator.pop(context, room_number);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
  return v;
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
            final v = await dialog_select_room(context: context);
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
