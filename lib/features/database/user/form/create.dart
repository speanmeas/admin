import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/input/input_password.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/pick/pick_boolean.dart";
import "package:speanmeas/core/schema/user.g.dart";

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

  String? username;
  String? password;
  String? full_name;
  String? phone_number;
  bool? is_admin;
  bool? is_manager;
  bool? is_receptionist;
  bool? is_housekeeper;
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
        initial: username, //
        title: "Username:", //
        onChanged: (v) {
          username = v;
          print(username);
          setState(() {});
        },
      ),

      //
      Input_Password(
        initial: password, //
        onChanged: (v) {
          password = v;
          print(password);
          setState(() {});
        },
      ),

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
      Picker_Boolean(
        initial: is_admin, //
        title: "Is Admin:", //
        onChanged: (v) {
          is_admin = v;
          print(is_admin);
          setState(() {});
        },
      ),

      //
      Picker_Boolean(
        initial: is_manager, //
        title: "Is Manager:", //
        onChanged: (v) {
          is_manager = v;
          print(is_manager);
          setState(() {});
        },
      ),

      //
      Picker_Boolean(
        initial: is_receptionist, //
        title: "Is Receptionist:", //
        onChanged: (v) {
          is_receptionist = v;
          print(is_receptionist);
          setState(() {});
        },
      ),

      //
      Picker_Boolean(
        initial: is_housekeeper, //
        title: "Is Housekeeper:", //
        onChanged: (v) {
          is_housekeeper = v;
          print(is_housekeeper);
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
        endpoint.USER_CRUD_CREATE, //
        data: {
          sm_user.USERNAME: username,
          sm_user.PASSWORD: password,
          sm_user.FULL_NAME: full_name,
          sm_user.PHONE_NUMBER: phone_number,
          sm_user.IS_ADMIN: is_admin,
          sm_user.IS_MANAGER: is_manager,
          sm_user.IS_RECEPTIONIST: is_receptionist,
          sm_user.IS_HOUSEKEEPER: is_housekeeper,
          sm_user.NOTE: note, //
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
