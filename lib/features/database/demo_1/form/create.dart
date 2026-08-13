import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/pick/pick_boolean.dart";
import "package:speanmeas/core/widget/pick/pick_datetime.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/demo_1.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Create", //
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

  String? text_1;
  String? text_2;
  double? number_1;
  double? number_2;
  DateTime? datetime_1;
  DateTime? datetime_2;
  bool? logic_1;
  bool? logic_2;
  String? note;

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      Input_Text(
        init: text_1, //
        lead: "Text 1:", //
        onChanged: (v) => text_1 = v,
      ),

      Input_Text(
        init: text_2, //
        lead: "Text 2:", //
        onChanged: (v) => text_2 = v,
      ),

      Input_Number(
        init: number_1, //
        lead: "Number 1:", //
        onChanged: (v) => number_1 = v,
      ),

      Input_Number(
        init: number_2, //
        lead: "Number 2:", //
        onChanged: (v) => number_2 = v,
      ),

      Picker_Datetime(
        initial: datetime_1, //
        title: "Datetime 1:", //
        onChanged: (v) => datetime_1 = v,
      ),

      Picker_Datetime(
        initial: datetime_2, //
        title: "Datetime 2:", //
        onChanged: (v) => datetime_2 = v,
      ),

      Picker_Boolean(
        initial: logic_1, //
        title: "Logic 1:", //
        onChanged: (v) => logic_1 = v,
      ),

      Picker_Boolean(
        initial: logic_2, //
        title: "Logic 2:", //
        onChanged: (v) => logic_2 = v,
      ),

      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) => note = v ?? "",
      ),

      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Create"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_create,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_create() async {
    try {
      tmp = await dio.post(
        endpoint.DEMO_1_CRUD_CREATE, //
        data: {
          sm_demo_1.TEXT_1: text_1, //
          sm_demo_1.TEXT_2: text_2, //
          sm_demo_1.NUMBER_1: number_1, //
          sm_demo_1.NUMBER_2: number_2, //
          sm_demo_1.DATETIME_1: datetime_1?.toIso8601String(), //
          sm_demo_1.DATETIME_2: datetime_2?.toIso8601String(), //
          sm_demo_1.LOGIC_1: logic_1, //
          sm_demo_1.LOGIC_2: logic_2, //
          sm_demo_1.NOTE: note, //
        },
      );

      Navigator.pop(context, tmp.data[0]);

      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
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
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
