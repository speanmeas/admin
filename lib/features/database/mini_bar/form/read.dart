import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/schema/mini_bar.g.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show/show_number.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Read", //
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
  bool is_loading = true;

  String? name;
  double? price;
  double? stock;
  String? note;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.MINI_BAR_CRUD_READ_ID, //
        data: {sm_mini_bar.ID: widget.id},
      );

      name = tmp.data[0][sm_mini_bar.NAME];
      price = tmp.data[0][sm_mini_bar.PRICE];
      stock = tmp.data[0][sm_mini_bar.STOCK];
      note = tmp.data[0][sm_mini_bar.NOTE];

      setState(() => is_loading = false);
      //
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
      Show_Text(
        prefixIcon: Icons.text_fields,
        leading: "Name:", //
        value: name,
      ),

      //
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Price:", //
        value: price,
      ),

      //
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Stock:", //
        value: stock,
      ),

      //
      Show_Text(
        prefixIcon: Icons.note_alt_outlined,
        leading: "Note:", //
        value: note,
        maxLines: 4,
      ),

      //
      SizedBox(height: height - 100),
    ]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id,
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
