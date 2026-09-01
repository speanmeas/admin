import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
// import "package:provider/provider.dart";

import "package:speanmeas/core/utility/all.dart";

// * បង្ហាញ dialog សម្រាប់ស្វែងរកសញ្ជាតិ ហើយត្រឡប់ id នៃសញ្ជាតិដែលបានជ្រើសរើស
Future<String?> dialog_search_nationality({
  required BuildContext context, //
}) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      List<dynamic> nationalities = [];

      // * ស្វែងរកសញ្ជាតិពី server
      Future<List<String>> search(String q) async {
        dynamic tmp_n = await dio.post(
          endpoint.NATIONALITY_READ_SEARCH,
          data: {
            "query": q, //
            "limit": 1000, //
          },
        );

        nationalities = tmp_n.data as List<dynamic>? ?? [];

        final options = <String>[];

        for (var n in nationalities) {
          final text = "${n[Nationality.NAME] ?? ""}";
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
              "Search Nationality", //
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
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.search, color: Colors.blue),
                              ),
                            );
                          },
                          onSelected: (v) async {
                            // * ស្វែងរកទិន្នន័យដែលត្រូវគ្នា
                            String? id;
                            for (final e in nationalities) {
                              if ("${e[Nationality.NAME] ?? ""}" == v) {
                                id = e[Nationality.ID] as String?;
                                break;
                              }
                            }
                            if (id == null) return snackbar(ct: context, ms: "Please select a nationality", cl: Colors.red);

                            snackbar(ct: context, ms: "Success", cl: Colors.green);
                            Navigator.pop(context, id);

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

// * ########## BLOCK TEST ##########

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () async {
            final v = await dialog_search_nationality(context: context);
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

// * ########## BLOCK TEST END ##########
