import "package:flutter/material.dart";
import "package:speanmeas/theme/Theme_Data.dart";

class _Main_State extends State<Main_> {
  //

  var room_status = ["Available", "Pending Pay", "Pending Leave", "Pending Clean", "Pending Fix"];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: widget.initialValue,
      icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
      decoration: InputDecoration(
        labelText: "Room Status:", //
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      items: room_status.map((i) {
        return DropdownMenuItem<String>(value: i, child: Text(i));
      }).toList(),
      onChanged: (v) {
        widget.onChanged?.call(v!);
      },
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({
    super.key, //
    this.initialValue,
    this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String>? onChanged;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: Scaffold(body: Center(child: Main_())),
      debugShowCheckedModeBanner: false,
    ),
  );
}
