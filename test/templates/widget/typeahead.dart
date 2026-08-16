import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:speanmeas/core/utility/all.dart";

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  final c_search = TextEditingController();
  var options = ["Apple", "Banana", "Cherry"];

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: c_search,
      suggestionsCallback: (q) {
        var results = <String>[];
        for (var e in options) //
          if (e.toLowerCase().contains(q.toLowerCase())) //
            results.add(e); //
        return results;
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Fruit:", //
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 4),
              child: IconButton(
                icon: Icon(Icons.clear, size: 24, color: Colors.red), //
                onPressed: controller.clear,
              ),
            ),
          ),
        );
      },
      itemBuilder: (context, i) {
        return ListTile(title: Text(i));
      },
      onSelected: (s) {
        c_search.text = s;
        setState(() {});
      },
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
      title: "TypeAhead", //
      theme: theme_data, //
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Main_(), //
        ),
      ),
    ),
  );
}
