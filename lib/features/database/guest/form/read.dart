import "package:flutter/material.dart";

import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/guest.g.dart";

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

  String? id;
  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality_id;
  String? id_number;
  String? passport_number;
  String? note;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.GUEST_CRUD_READ_ID, //
        data: {sm_guest.ID: widget.id},
      );

      id = tmp.data[0][sm_guest.ID];
      full_name = tmp.data[0][sm_guest.FULL_NAME];
      phone_number = tmp.data[0][sm_guest.PHONE_NUMBER];
      gender = tmp.data[0][sm_guest.GENDER];
      nationality_id = tmp.data[0][sm_guest.NATIONALITY_ID]["name"];
      id_number = tmp.data[0][sm_guest.ID_NUMBER];
      passport_number = tmp.data[0][sm_guest.PASSPORT_NUMBER];
      note = tmp.data[0][sm_guest.NOTE];

      is_loading = false;
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
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      //
      Show_Text(
        prefixIcon: Icons.person_outline,
        leading: "Full Name:", //
        value: full_name,
      ),
      //
      Show_Text(
        prefixIcon: Icons.phone_outlined,
        leading: "Phone Number:", //
        value: phone_number,
      ),
      //
      Show_Text(
        prefixIcon: Icons.wc_outlined,
        leading: "Gender:", //
        value: gender,
      ),
      //
      Show_Text(
        prefixIcon: Icons.flag_outlined,
        leading: "Nationality:", //
        value: nationality_id,
      ),
      //
      Show_Text(
        prefixIcon: Icons.badge_outlined,
        leading: "ID Number:", //
        value: id_number,
      ),
      //
      Show_Text(
        prefixIcon: Icons.book_outlined,
        leading: "Passport Number:", //
        value: passport_number,
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
