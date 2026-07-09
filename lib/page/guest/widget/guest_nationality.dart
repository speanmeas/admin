import "package:flutter/material.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/theme/Theme_Data.dart";

class _Main_State extends State<Main_> {
  //

  TextEditingController controller_nationality = TextEditingController();
  List<String> option_nationalities = [];
  Map<String, dynamic> output = {};

  @override
  void initState() {
    super.initState();
    output["guest_nationality"] = "Cambodian";
    controller_nationality.text = output["guest_nationality"]?.toString() ?? "";
    init();
  }

  void init() async {
    await dio
        .post("/nationality/data_read", data: form_data({}))
        .then((r) {
          option_nationalities = List<String>.from(r.data.map((e) => e["nationality"]));
          option_nationalities.sort((a, b) => a.compareTo(b));
        })
        .catchError((_) {});
  }

  // var room_status = ["Available", "Pending Pay", "Pending Leave", "Pending Clean", "Pending Fix"];

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      controller: controller_nationality,
      suggestionsCallback: (query) {
        List<String> result = [];
        for (var e in option_nationalities) {
          if (e.toLowerCase().contains(query.toLowerCase())) {
            result.add(e);
          }
        }
        return result;
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Nationality:",
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
              child: IconButton(
                icon: Icon(Icons.clear, size: 24, color: Colors.red), //
                onPressed: controller.clear,
              ),
            ),
          ),
        );
      },
      itemBuilder: (context, item) {
        return ListTile(title: Text(item));
      },
      onSelected: (selected) {
        // output["guest_nationality"] = selected; //
        controller_nationality.text = selected;

        setState(() {});
      },
    );

    // DropdownButtonFormField<String>(
    //   initialValue: widget.initialValue,
    //   icon: Icon(Icons.arrow_drop_down, color: Colors.blue), //
    //   decoration: InputDecoration(
    //     labelText: "Room Status:", //
    //     labelStyle: TextStyle(fontWeight: FontWeight.bold),
    //     floatingLabelBehavior: FloatingLabelBehavior.always,
    //   ),
    //   items: room_status.map((i) {
    //     return DropdownMenuItem<String>(value: i, child: Text(i));
    //   }).toList(),
    //   onChanged: (v) {
    //     widget.onChanged?.call(v!);
    //   },
    // );
  }
}

class Main_ extends StatefulWidget {
  Main_({
    super.key, //
    this.initialValue,
    this.onSelected,
  });

  final String? initialValue;
  final Function(String)? onSelected;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: Theme_Data(), //
      home: Scaffold(
        body: Center(
          child: Main_(
            initialValue: "Cambodian", //
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
