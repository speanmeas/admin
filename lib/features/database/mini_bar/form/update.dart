import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/mini_bar.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Update", //
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
  dynamic tmp; // ignore: unused
  bool is_loading = true;

  String? name;
  double? price;
  double? stock;
  String? note;

  void init() async {
    //
    try {
      //
      tmp = await dio.post(
        endpoint.MINI_BAR_CRUD_READ_ID, //
        data: {sm_mini_bar.ID: widget.id},
      );

      name = tmp.data[0][sm_mini_bar.NAME];
      price = tmp.data[0][sm_mini_bar.PRICE];
      stock = tmp.data[0][sm_mini_bar.STOCK];
      note = tmp.data[0][sm_mini_bar.NOTE];

      setState(() => is_loading = false);
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      //
      Input_Text(
        initial: name, //
        title: "Name:", //
        onChanged: (v) {
          name = v;
          setState(() {});
        },
      ),

      //
      Input_Number(
        initial: price, //
        title: "Price:", //
        onChanged: (v) {
          price = v;
          setState(() {});
        },
      ),

      //
      Input_Number(
        initial: stock, //
        title: "Stock:", //
        onChanged: (v) {
          stock = v;
          setState(() {});
        },
      ),

      Input_Text(
        initial: null, //
        title: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v ?? "";
          setState(() {});
        },
      ),

      //
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  void on_update() async {
    try {
      //
      tmp = await dio.post(
        endpoint.MINI_BAR_CRUD_UPDATE, //
        data: {
          sm_mini_bar.ID: widget.id,
          sm_mini_bar.NAME: name,
          sm_mini_bar.PRICE: price,
          sm_mini_bar.STOCK: stock,
          sm_mini_bar.NOTE: note, //
        },
      );

      //
      Navigator.pop(context, tmp.data[0]);

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
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
