import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
// import "package:provider/provider.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ស្វែងរកភ្ញៀវ ហើយត្រូវបានបញ្ចូលទៅ front desk
Future<bool?> dialog_search_guest({
  required BuildContext context, //
  required String? front_desk_id, //
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      String? guest_id;
      List<dynamic> guests = [];

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

      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        alignment: Alignment.topCenter,
        titlePadding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
        contentPadding: const EdgeInsets.all(4),
        actionsPadding: const EdgeInsets.all(4),
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
        //
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 400,
              child: Column(
                // spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1, color: Colors.grey),

                  SizedBox(height: 4),

                  Row(
                    children: [
                      Expanded(
                        child: TypeAheadField<String>(
                          // offset: const Offset(0, 0),
                          // decorationBuilder: (context, child) {
                          //   return DecoratedBox(
                          //     decoration: const BoxDecoration(
                          //       color: Colors.white, //
                          //       borderRadius: BorderRadius.zero,
                          //       boxShadow: [BoxShadow(blurRadius: 4)],
                          //     ),
                          //     child: child,
                          //   );
                          // },
                          itemBuilder: (context, item) => ListTile(title: Text(item)),
                          suggestionsCallback: search,
                          builder: (context, controller, focusNode) {
                            // * ផ្តោតលើប្រអប់ស្វែងរកភ្លាមៗនៅពេលបើក dialog
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!focusNode.hasFocus) focusNode.requestFocus();
                            });
                            return TextField(
                              autofocus: true,
                              controller: controller,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                // labelText: "Search Guest:",
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.search, color: Colors.blue),
                              ),
                            );
                          },
                          onSelected: (v) async {
                            // * ស្វែងរកទិន្នន័យដែលត្រូវគ្នា

                            for (var e in guests) {
                              if ("${e[Guest.FULL_NAME] ?? ""} (${e[Guest.PHONE_NUMBER] ?? "N/A"})" == v) {
                                guest_id = e[Guest.ID] as String?;
                                break;
                              }
                            }
                            if (guest_id == null) return snackbar(ct: context, ms: "Please select a guest", cl: Colors.red);

                            dynamic tmp_fd = await dio.post(
                              endpoint.FRONT_DESK_UPDATE,
                              data: {
                                Front_Desk.ID: front_desk_id, //
                                Front_Desk.GUEST_ID: guest_id, //
                              },
                            );
                            if (tmp_fd == null) return snackbar(ct: context, ms: "Failed", cl: Colors.red);

                            snackbar(ct: context, ms: "Success", cl: Colors.green);
                            Navigator.pop(context, true);

                            // setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
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
            final v = await dialog_search_guest(
              context: context, //
              front_desk_id: "111111111122222222223333", //
            );
            if (v == null) return;
            pprint(v);
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
