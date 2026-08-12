import "package:flutter/material.dart";

import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/show/show_boolean.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/user.g.dart";

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
        endpoint.USER_CRUD_READ_ID, //
        data: {sm_user.ID: widget.id},
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
        prefixIcon: Icons.person_outline,
        leading: "Username:", //
        value: data[sm_user.USERNAME] ?? "",
      ),

      //
      Show_Text(
        prefixIcon: Icons.lock_outline,
        leading: "Password:", //
        value: "**********",
      ),

      //
      Show_Text(
        prefixIcon: Icons.badge_outlined,
        leading: "Full Name:", //
        value: data[sm_user.FULL_NAME] ?? "",
      ),

      //
      Show_Text(
        prefixIcon: Icons.phone_outlined,
        leading: "Phone Number:", //
        value: data[sm_user.PHONE_NUMBER] ?? "",
      ),

      //
      Show_Boolean(
        prefixIcon: Icons.admin_panel_settings_outlined,
        leading: "Is Admin:", //
        value: data[sm_user.IS_ADMIN],
      ),

      //
      Show_Boolean(
        prefixIcon: Icons.manage_accounts_outlined,
        leading: "Is Manager:", //
        value: data[sm_user.IS_MANAGER],
      ),

      //
      Show_Boolean(
        prefixIcon: Icons.support_agent_outlined,
        leading: "Is Receptionist:", //
        value: data[sm_user.IS_RECEPTIONIST],
      ),

      //
      Show_Boolean(
        prefixIcon: Icons.cleaning_services_outlined,
        leading: "Is Housekeeper:", //
        value: data[sm_user.IS_HOUSEKEEPER],
      ),

      //
      Show_Text(
        prefixIcon: Icons.note_alt_outlined,
        leading: "Note:", //
        value: data[sm_user.NOTE],
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
