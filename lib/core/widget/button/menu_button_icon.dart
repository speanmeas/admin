import "package:flutter/material.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Menu_Button_IconState extends State<Menu_Button_Icon> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tip,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          height: 38,
          width: 38,
          alignment: Alignment.center,
          child: Icon(widget.icon, size: 30, color: widget.color ?? Colors.blue), //
        ),
      ),
    );
  }
}

class Menu_Button_Icon extends StatefulWidget {
  const Menu_Button_Icon({
    super.key, //
    required this.tip,
    required this.icon,
    this.onPressed,
    this.color,
  });

  final String? tip;
  final IconData icon;
  final Function()? onPressed;
  final Color? color;

  @override
  State<Menu_Button_Icon> createState() => _Menu_Button_IconState();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Menu_Button_Icon(
              tip: "Create New",
              icon: Icons.add,
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
