import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

Future<bool?> dialog_add_mini_bar({
  required BuildContext context, //
}) async {
  bool is_loading = false;

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.topCenter,
            titlePadding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
            contentPadding: const EdgeInsets.all(4),
            actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: is_loading ? null : () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: is_loading
                    ? null
                    : () async {
                        setState(() => is_loading = true);
                        final tmp_walk = await dio.post(endpoint.FRONT_DESK_WALK_IN);
                        if (tmp_walk == null) {
                          if (context.mounted) setState(() => is_loading = false);
                          return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
                        }

                        snackbar(ct: context, ms: "Mini Bar Added", cl: Colors.green);
                        if (context.mounted) Navigator.pop(context, true);
                      },
                child: is_loading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Confirm"),
              ),
            ],
          );
        },
      );
    },
  );
  return saved;
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
            final v = await dialog_add_mini_bar(context: context);
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