import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/utility/all.dart";

Future<String?> dialog_bank_name_select({
  required BuildContext context, //
  String? initial, //
}) async {
  dynamic tmp = await dio.post(endpoint.BANK_READ);
  if (tmp == null) {
    if (context.mounted) snackbar(ct: context, ms: dio.error_msg ?? "Failed to fetch banks", cl: Colors.red);
    return null;
  }

  List<String> options = [];
  if (tmp.data is List) {
    for (var b in tmp.data as List) {
      if (b is Map) {
        final name = (b[Bank.NAME] ?? b["name"] ?? "").toString().trim();
        if (name.isNotEmpty && !options.contains(name)) {
          options.add(name);
        }
      }
    }
  }

  final controller = TextEditingController(text: initial ?? "");

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
              "ឈ្មោះធនាគារ", //
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
                animationDuration: Duration.zero,
                controller: controller,
                hideOnUnfocus: false,
                itemBuilder: (context, item) => ListTile(
                  leading: Icon(item.isEmpty ? Icons.block_outlined : Icons.account_balance_outlined, color: item.isEmpty ? Colors.red : Colors.blue),
                  title: Text(item.isEmpty ? "គ្មាន (Clear)" : item),
                ),
                suggestionsCallback: (q) {
                  final query = q.trim().toLowerCase();
                  final list = <String>[...options];
                  if (query.isEmpty) return ["", ...list];
                  final filtered = list.where((element) => element.toLowerCase().contains(query)).toList();
                  return ["", ...filtered];
                },
                builder: (context, ctrl, focusNode) {
                  return TextField(
                    autofocus: true,
                    controller: ctrl,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: "ស្វែងរក:", //
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                    ),
                  );
                },
                onSelected: (v) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) Navigator.pop(context, v);
                  });
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
            final v = await dialog_bank_name_select(context: context);
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
