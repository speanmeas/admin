import "package:flutter/material.dart";

import "package:speanmeas/theme/theme_data.dart";

class _Main_State extends State<Main_> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.color, width: 2), //
      ),
      child: Wrap(
        children: [
          //
          TextButton.icon(
            //
            icon: Icon(widget.icon, size: 24), //
            label: Text(widget.text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), //
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(4, 0, 8, 0), //
              foregroundColor: widget.color, //
            ),
            onPressed: widget.onPressed, //
          ),

          //
          MenuAnchor(
            style: MenuStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 0)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)))),
            ),
            builder: (context, controller, child) {
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: Icon(Icons.more_vert, color: widget.color, size: 24), //
                onPressed: () {
                  controller.isOpen ? controller.close() : controller.open();
                },
              );
            },
            menuChildren: widget.menuChildren,
          ),
        ],
      ),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({
    super.key, //
    this.color = Colors.blue,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.menuChildren,
  });

  final Color color;
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final List<Widget> menuChildren;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: Scaffold(
        body: Center(
          child: Container(
            width: 600,
            child: Main_(
              icon: Icons.local_hotel_outlined, //
              text: "Hello World",
              menuChildren: [
                MenuItemButton(leadingIcon: Icon(Icons.visibility_outlined), onPressed: () {}, child: Text("View")),
                MenuItemButton(leadingIcon: Icon(Icons.edit_outlined), onPressed: () {}, child: Text("Edit")),
                MenuItemButton(leadingIcon: Icon(Icons.copy_outlined), onPressed: () {}, child: Text("Duplicate")),
                Divider(height: 1),
                MenuItemButton(leadingIcon: Icon(Icons.delete_outline), onPressed: () {}, child: Text("Delete")),
              ],
              onPressed: () {
                print("Hello World");
              },
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
