import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/show/show_boolean.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

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

  String? username;
  String? full_name;
  String? phone_number;
  bool? is_admin;
  bool? is_manager;
  bool? is_receptionist;
  bool? is_housekeeper;
  String? note;

  void init() async {
    try {
      tmp = await dio.post(
        endpoint.USER_CRUD_READ_ID, //
        data: {sm_user.ID: widget.id},
      );

      final data = tmp.data;
      if (data == null || data.isEmpty) {
        snackbar(ct: context, ms: "No data found.", cl: Colors.red);
        is_loading = false;
        setState(() {});
        return;
      }
      final row = data[0];

      username = row[sm_user.USERNAME]?.toString();
      full_name = row[sm_user.FULL_NAME]?.toString();
      phone_number = row[sm_user.PHONE_NUMBER]?.toString();
      final a = row[sm_user.IS_ADMIN];
      is_admin = a is bool ? a : null;
      final m = row[sm_user.IS_MANAGER];
      is_manager = m is bool ? m : null;
      final r = row[sm_user.IS_RECEPTIONIST];
      is_receptionist = r is bool ? r : null;
      final h = row[sm_user.IS_HOUSEKEEPER];
      is_housekeeper = h is bool ? h : null;
      note = row[sm_user.NOTE]?.toString();

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      Show_Text(
        prefixIcon: Icons.person_outline,
        lead: "Username:", //
        value: username,
      ),

      Show_Text(
        prefixIcon: Icons.lock_outline,
        lead: "Password:", //
        value: "**********",
      ),

      Show_Text(
        prefixIcon: Icons.badge_outlined,
        lead: "Full Name:", //
        value: full_name,
      ),

      Show_Text(
        prefixIcon: Icons.phone_outlined,
        lead: "Phone Number:", //
        value: phone_number,
      ),

      Show_Boolean(
        prefixIcon: Icons.admin_panel_settings_outlined,
        leading: "Is Admin:", //
        value: is_admin,
      ),

      Show_Boolean(
        prefixIcon: Icons.manage_accounts_outlined,
        leading: "Is Manager:", //
        value: is_manager,
      ),

      Show_Boolean(
        prefixIcon: Icons.support_agent_outlined,
        leading: "Is Receptionist:", //
        value: is_receptionist,
      ),

      Show_Boolean(
        prefixIcon: Icons.cleaning_services_outlined,
        leading: "Is Housekeeper:", //
        value: is_housekeeper,
      ),

      Show_Text(
        prefixIcon: Icons.note_alt_outlined,
        lead: "Note:", //
        value: note,
        maxLines: 4,
      ),

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: Main_(id: "1"),
    ),
  );
}
