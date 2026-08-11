import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/schema/demo_1.g.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show_boolean.dart";
import "package:speanmeas/core/widget/show_datetime.dart";
import "package:speanmeas/core/widget/show_number.dart";
import "package:speanmeas/core/widget/show_text.dart";
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
  dynamic data;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.DEMO_1_CRUD_READ_ID, //
        data: {sm_demo_1.ID: widget.id},
      );

      data = tmp.data[0];

      setState(() {});
      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (data == null) return Center(child: CircularProgressIndicator());
    return _layout([
      //
      Show_Text(
        prefixIcon: Icons.text_fields,
        leading: "Text 1:", //
        value: data[sm_demo_1.TEXT_1] ?? "",
      ),

      //
      Show_Text(
        prefixIcon: Icons.text_fields,
        leading: "Text 2:", //
        value: data[sm_demo_1.TEXT_2] ?? "",
      ),

      //
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Number 1:", //
        value: data[sm_demo_1.NUMBER_1] ?? "",
      ),

      //
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Number 2:", //
        value: data[sm_demo_1.NUMBER_2] ?? "",
      ),

      //
      Show_Datetime(
        prefixIcon: Icons.calendar_month,
        leading: "Datetime 1:", //
        value: DateTime.tryParse(data[sm_demo_1.DATETIME_1]),
      ),

      //
      Show_Datetime(
        prefixIcon: Icons.calendar_month,
        leading: "Datetime 2:", //
        value: DateTime.tryParse(data[sm_demo_1.DATETIME_2]),
      ),

      //
      Show_Boolean(
        prefixIcon: Icons.toggle_on,
        leading: "Boolean:", //
        value: data[sm_demo_1.LOGIC_1],
      ),

      //
      Show_Boolean(
        prefixIcon: Icons.toggle_on,
        leading: "Boolean 2:", //
        value: data[sm_demo_1.LOGIC_2],
      ),

      //
      Show_Text(
        prefixIcon: Icons.note,
        leading: "Note:", //
        value: data[sm_demo_1.NOTE],
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
