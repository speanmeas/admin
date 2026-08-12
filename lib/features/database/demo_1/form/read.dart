import "package:flutter/material.dart";

import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show/show_boolean.dart";
import "package:speanmeas/core/widget/show/show_datetime.dart";
import "package:speanmeas/core/widget/show/show_number.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/demo_1.g.dart";

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

  String? text_1;
  String? text_2;
  double? number_1;
  double? number_2;
  DateTime? datetime_1;
  DateTime? datetime_2;
  bool? logic_1;
  bool? logic_2;
  String? note;
  String? nationality_id;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.DEMO_1_CRUD_READ_ID, //
        data: {sm_demo_1.ID: widget.id},
      );

      text_1 = tmp.data[0][sm_demo_1.TEXT_1];
      text_2 = tmp.data[0][sm_demo_1.TEXT_2];
      number_1 = tmp.data[0][sm_demo_1.NUMBER_1];
      number_2 = tmp.data[0][sm_demo_1.NUMBER_2];
      datetime_1 = DateTime.parse(tmp.data[0][sm_demo_1.DATETIME_1]);
      datetime_2 = DateTime.parse(tmp.data[0][sm_demo_1.DATETIME_2]);
      logic_1 = tmp.data[0][sm_demo_1.LOGIC_1];
      logic_2 = tmp.data[0][sm_demo_1.LOGIC_2];
      note = tmp.data[0][sm_demo_1.NOTE];

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
        leading: "Text 1:", //
        value: text_1,
      ),

      //
      Show_Text(
        prefixIcon: Icons.text_fields,
        leading: "Text 2:", //
        value: text_2,
      ),

      //
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Number 1:", //
        value: number_1,
      ),

      //
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Number 2:", //
        value: number_2,
      ),

      //
      Show_Datetime(
        prefixIcon: Icons.calendar_month,
        leading: "Datetime 1:", //
        value: datetime_1,
      ),

      //
      Show_Datetime(
        prefixIcon: Icons.calendar_month,
        leading: "Datetime 2:", //
        value: datetime_2,
      ),

      //
      Show_Boolean(
        prefixIcon: Icons.toggle_on,
        leading: "Boolean:", //
        value: logic_1,
      ),

      //
      Show_Boolean(
        prefixIcon: Icons.toggle_on,
        leading: "Boolean 2:", //
        value: logic_2,
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
