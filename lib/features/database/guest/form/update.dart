import "package:flutter/material.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/select/select_string.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/search/search_nationality.dart";
import "package:speanmeas/core/schema/guest.g.dart";

// import "../widget/gender_select.dart" as g_select;

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

  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality_id;
  String? id_number;
  String? passport_number;
  String? note;

  //
  void init() async {
    //
    try {
      //
      tmp = await dio.post(
        endpoint.GUEST_CRUD_READ_ID, //
        data: {sm_guest.ID: widget.id},
      );
      print(tmp);

      full_name = tmp.data[0][sm_guest.FULL_NAME];
      phone_number = tmp.data[0][sm_guest.PHONE_NUMBER];
      gender = tmp.data[0][sm_guest.GENDER];
      // nationality_id = tmp.data[0][sm_guest.NATIONALITY_ID];
      id_number = tmp.data[0][sm_guest.ID_NUMBER];
      passport_number = tmp.data[0][sm_guest.PASSPORT_NUMBER];
      note = tmp.data[0][sm_guest.NOTE];

      is_loading = false;
      setState(() {});
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
        initial: full_name, //
        title: "Full Name:", //
        onChanged: (v) {
          full_name = v;
          setState(() {});
        },
      ),

      //
      Input_Text(
        initial: phone_number, //
        title: "Phone Number:", //
        onChanged: (v) {
          phone_number = v;
          setState(() {});
        },
      ),

      //
      Select_String(
        initial: gender, //
        options: ["Male", "Female", "Other"], //
        prefixIcon: Icon(Icons.wc),
        onChanged: (v) {
          gender = v;
          setState(() {});
        },
      ),

      //
      Search_Nationality(
        initial: "Cambodian", //
        onChanged: (v) {
          nationality_id = v;
          setState(() {});
        },
      ),

      //
      Input_Text(
        initial: id_number, //
        title: "ID Number:", //
        onChanged: (v) {
          id_number = v;
          setState(() {});
        },
      ),

      //
      Input_Text(
        initial: passport_number, //
        title: "Passport Number:", //
        onChanged: (v) {
          passport_number = v;
          setState(() {});
        },
      ),

      Input_Text(
        initial: note, //
        title: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v ?? "";
          setState(() {});
        },
      ),

      //
      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text("Update"),
        onPressed: on_update,
      ),

      //
      SizedBox(height: height - 100),
    ]);
  }

  //
  void on_update() async {
    try {
      //
      tmp = await dio.post(
        endpoint.GUEST_CRUD_UPDATE, //
        data: {
          sm_guest.ID: widget.id,
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
