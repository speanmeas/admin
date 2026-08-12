import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/search/search_nationality.dart";
import "package:speanmeas/core/schema/guest.g.dart";

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

  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality_id;
  String? id_number;
  String? passport_number;
  String? note;

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      //
      Input_Text(
        initial: full_name, //
        title: "Full Name:", //
        onChanged: (v) {
          full_name = v;
          print(full_name);
          setState(() {});
        },
      ),

      //
      Input_Text(
        initial: phone_number, //
        title: "Phone Number:", //
        onChanged: (v) {
          phone_number = v;
          print(phone_number);
          setState(() {});
        },
      ),

      //
      Select_Dynamic(
        prefixIcon: Icon(Icons.wc),
        options: ["Male", "Female", "Other"], //
        onChanged: (v) {
          gender = v;
          print(gender);
          setState(() {});
        },
      ),

      //
      Search_Nationality(
        initial: "Cambodian", //
        onChanged: (v) {
          nationality_id = v;
          print(nationality_id);
          setState(() {});
        },
      ),

      //
      Input_Text(
        initial: id_number, //
        title: "National ID Number:", //
        onChanged: (v) {
          id_number = v;
          print(id_number);
          setState(() {});
        },
      ),

      //
      Input_Text(
        initial: passport_number, //
        title: "Passport Number:", //
        onChanged: (v) {
          passport_number = v;
          print(passport_number);
          setState(() {});
        },
      ),

      Input_Text(
        initial: note, //
        title: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v ?? "";
          print(note);
          setState(() {});
        },
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
        endpoint.GUEST_CRUD_CREATE, //
        data: {
          sm_guest.FULL_NAME: full_name,
          sm_guest.PHONE_NUMBER: phone_number,
          sm_guest.GENDER: gender,
          sm_guest.NATIONALITY_ID: nationality_id,
          sm_guest.ID_NUMBER: id_number,
          sm_guest.PASSPORT_NUMBER: passport_number,
          sm_guest.NOTE: note, //
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
