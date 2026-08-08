import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Delete", //
        style: TextStyle(
          fontSize: 20, //
          fontWeight: FontWeight.bold,
        ),
      ),

      centerTitle: false,
      toolbarHeight: 40,
      titleSpacing: 0,

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1), //
        child: Divider(height: 1, color: Colors.black),
      ),
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Container(
          width: 600,
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 8,
            children: children, //
          ),
        ),
      ),
    ),
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * បញ្ជាក់
      Text("Confirm to delete?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

      // * ប៊ូតុង Delete
      OutlinedButton.icon(
        autofocus: true,
        icon: Icon(Icons.delete_outlined),
        label: Text("Delete"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
        onPressed: on_delete,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_delete() async {
    try {
      //
      tmp = await dio.post(
        endpoint.ROOM_DELETE, //
        data: {"_id": widget.id},
      );

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
      Navigator.pop(context, tmp.data);

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id, //
  });

  final String id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(id: "1"),
      debugShowCheckedModeBanner: false,
    ),
  );
}
