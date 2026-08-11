import "package:intl/intl.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/dialog/datetime.dart";
import "package:speanmeas/core/widget/boolean_picker.dart";
import "package:speanmeas/core/widget/datetime_picker.dart";
import "package:speanmeas/core/widget/number_input.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/show_data.dart";
import "package:speanmeas/core/schema/demo_1.g.dart";
import "package:speanmeas/core/widget/text_input.dart";

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
  dynamic tmp; // ignore: unused

  final c_text_1 = TextEditingController();
  final c_text_2 = TextEditingController();
  final c_number_1 = TextEditingController();
  final c_number_2 = TextEditingController();
  final c_datetime_1 = TextEditingController();
  final c_datetime_2 = TextEditingController();
  final c_logic_1 = TextEditingController();
  final c_logic_2 = TextEditingController();
  final c_note = TextEditingController();

  String? text_1;
  String? text_2;
  double? number_1;
  double? number_2;
  DateTime? datetime_1;
  DateTime? datetime_2;
  bool? logic_1;
  bool? logic_2;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      //
      Text_Input(
        initial: text_1, //
        title: "Text 1:", //
        onChanged: (v) {
          text_1 = v;
          print(text_1);
          setState(() {});
        },
      ),

      //
      Text_Input(
        initial: text_2, //
        title: "Text 2:", //
        onChanged: (v) {
          text_2 = v;
          print(text_2);
          setState(() {});
        },
      ),

      //
      Number_Input(
        initial: number_1, //
        title: "Number 1:", //
        onChanged: (v) {
          number_1 = v;
          print(number_1);
          setState(() {});
        },
      ),

      //
      Number_Input(
        initial: number_2, //
        title: "Number 2:", //
        onChanged: (v) {
          number_2 = v;
          print(number_2);
          setState(() {});
        },
      ),

      Datetime_Picker(
        initial: datetime_1, //
        title: "Datetime 1:", //
        onChanged: (v) {
          datetime_1 = v;
          print(datetime_1);
          setState(() {});
        },
      ),

      Datetime_Picker(
        initial: datetime_2, //
        title: "Datetime 2:", //
        onChanged: (v) {
          datetime_2 = v;
          print(datetime_2);
          setState(() {});
        },
      ),

      Boolean_Picker(
        initial: logic_1, //
        title: "Logic 1:", //
        onChanged: (v) {
          logic_1 = v;
          print(logic_1);
          setState(() {});
        },
      ),

      Boolean_Picker(
        initial: logic_2, //
        title: "Logic 2:", //
        onChanged: (v) {
          logic_2 = v;
          print(logic_2);
          setState(() {});
        },
      ),

      //
      TextField(
        controller: c_note,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "Note:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (v) => setState(() {}),
      ),

      //
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
      //
      tmp = await dio.post(
        endpoint.DEMO_1_CRUD_CREATE, //
        data: {
          sm_demo_1.TEXT_1: c_text_1.text.trim(),
          sm_demo_1.TEXT_2: c_text_2.text.trim(),
          sm_demo_1.NUMBER_1: double.tryParse(c_number_1.text.trim()),
          sm_demo_1.NUMBER_2: double.tryParse(c_number_2.text.trim()),
          sm_demo_1.DATETIME_1: c_datetime_1.text.trim(),
          sm_demo_1.DATETIME_2: c_datetime_2.text.trim(),
          sm_demo_1.LOGIC_1: c_logic_1.text.trim() == "Yes"
              ? true
              : c_logic_1.text.trim() == "No"
              ? false
              : null,
          sm_demo_1.LOGIC_2: c_logic_2.text.trim() == "Yes"
              ? true
              : c_logic_2.text.trim() == "No"
              ? false
              : null,
          sm_demo_1.NOTE: c_note.text.trim(),
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
