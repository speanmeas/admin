import "package:flutter/material.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;

class _Dialog_State extends State<Dialog_> {
  final title = "Update Password"; //
  final label_pw = "New Password:";
  final label_cf_pw = "Confirm New Password:";

  final controller_pw = TextEditingController();
  final controller_cf_pw = TextEditingController();

  bool is_obscure_pw = true;
  bool is_obscure_cf_pw = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(4),
      actionsPadding: EdgeInsets.all(4),
      alignment: AlignmentGeometry.topCenter, //
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
        ],
      ),

      content: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller_pw,
            decoration: InputDecoration(
              labelText: label_pw, //
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: ExcludeFocus(
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(is_obscure_pw ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      is_obscure_pw = !is_obscure_pw;
                      setState(() {});
                    },
                  ), //
                ),
              ),
            ),
            obscureText: is_obscure_pw, //
            autofocus: true,
            onChanged: (v) => setState(() {}),
            onSubmitted: (v) => can_okay() ? on_okay() : null,
          ),

          TextField(
            controller: controller_cf_pw,
            decoration: InputDecoration(
              labelText: label_cf_pw, //
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: ExcludeFocus(
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(is_obscure_cf_pw ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      is_obscure_cf_pw = !is_obscure_cf_pw;
                      setState(() {});
                    },
                  ), //
                ),
              ),
            ),
            obscureText: is_obscure_cf_pw, //
            onChanged: (v) => setState(() {}),
            onSubmitted: (v) => can_okay() ? on_okay() : null,
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          child: Text("Cancel"), //
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context); //
          }, //
        ),
        OutlinedButton(
          onPressed: can_okay() ? on_okay : null,
          child: Text("Okay"), //
        ),
      ],
    );
  }

  bool can_okay() {
    if (controller_pw.text.isEmpty) return false;
    if (controller_cf_pw.text.isEmpty) return false;
    if (controller_pw.text != controller_cf_pw.text) return false;
    return true;
  }

  void on_okay() {
    Navigator.pop(context, controller_pw.text);
  }
}

class Dialog_ extends StatefulWidget {
  Dialog_({super.key});

  @override
  State<Dialog_> createState() => _Dialog_State();
}

Future<dynamic> view(BuildContext context) {
  return showDialog<dynamic>(
    context: context,
    builder: (context) {
      return Dialog_(); //
    },
  );
}

class _Main_State extends State<Main_> {
  dynamic tmp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () async {
            final v = await view(context);
            print("value: $v");
          },
          child: const Text("Show Dialog"),
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
      title: "Development", //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
