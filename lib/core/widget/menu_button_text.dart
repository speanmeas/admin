import "package:flutter/material.dart";

import "package:speanmeas/core/theme/theme_data.dart";

class _Menu_Button_TextState extends State<Menu_Button_Text> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tip,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          height: 38,
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 18, //
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ), //
        ),
      ),
    );
  }
}

class Menu_Button_Text extends StatefulWidget {
  const Menu_Button_Text({
    super.key, //
    required this.tip,
    required this.text,
    this.onPressed,
    this.color,
  });

  final String? tip;
  final String text;
  final Function()? onPressed;
  final Color? color;

  @override
  State<Menu_Button_Text> createState() => _Menu_Button_TextState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Menu_Button_Text(
              tip: "Create New",
              text: "Create New",
              onPressed: () {
                print("Pressed");
              },
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
