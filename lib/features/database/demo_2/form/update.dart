import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/pick/pick_boolean.dart";
import "package:speanmeas/core/widget/pick/pick_datetime.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/demo_2.g.dart";

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

  String? text_1;
  double? number_1;
  DateTime? datetime_1;
  bool? logic_1;
  String? note;

  void init() async {
    //
    try {
      //
      tmp = await dio.post(
        endpoint.DEMO_2_CRUD_READ_ID, //
        data: {sm_demo_2.ID: widget.id},
      );

      text_1 = tmp.data[0][sm_demo_2.TEXT_1];
      number_1 = tmp.data[0][sm_demo_2.NUMBER_1];
      datetime_1 = tmp.data[0][sm_demo_2.DATETIME_1] != null ? DateTime.parse(tmp.data[0][sm_demo_2.DATETIME_1]) : null;
      logic_1 = tmp.data[0][sm_demo_2.LOGIC_1];
      note = tmp.data[0][sm_demo_2.NOTE];

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
        init: text_1, //
        lead: "Text 1:", //
        onChanged: (v) {
          text_1 = v;
          setState(() {});
        },
      ),

      //
      Input_Number(
        initial: number_1, //
        title: "Number 1:", //
        onChanged: (v) {
          number_1 = v;
          setState(() {});
        },
      ),

      Picker_Datetime(
        initial: datetime_1, //
        title: "Datetime 1:", //
        onChanged: (v) {
          datetime_1 = v;
          setState(() {});
        },
      ),

      Picker_Boolean(
        initial: logic_1, //
        title: "Logic 1:", //
        onChanged: (v) {
          logic_1 = v;
          setState(() {});
        },
      ),

      Input_Text(
        init: note, //
        lead: "Note:", //
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
        endpoint.DEMO_2_CRUD_UPDATE, //
        data: {
          sm_demo_2.ID: widget.id,
          sm_demo_2.TEXT_1: text_1,
          sm_demo_2.NUMBER_1: number_1,
          sm_demo_2.DATETIME_1: datetime_1?.toIso8601String(),
          sm_demo_2.LOGIC_1: logic_1,
          sm_demo_2.NOTE: note, //
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
