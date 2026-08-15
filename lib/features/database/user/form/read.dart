// * ទំព័រអានព័ត៌មានអ្នកប្រើប្រាស់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/parse.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/show/show_boolean.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រអានព័ត៌មានអ្នកប្រើប្រាស់
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការអានព័ត៌មានអ្នកប្រើប្រាស់
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;

  String? username;
  String? password;
  String? full_name;
  String? phone_number;
  bool? is_admin;
  bool? is_manager;
  bool? is_receptionist;
  bool? is_housekeeper;
  String? note;

  // * ផ្ទុកព័ត៌មានអ្នកប្រើប្រាស់តាម id
  void init() async {
    // * អានទិន្នន័យអ្នកប្រើប្រាស់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.USER_CRUD_READ_ID, data: {sm_user.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.USER_CRUD_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    username = parse_string(tmp.data[0][sm_user.USERNAME]);
    full_name = parse_string(tmp.data[0][sm_user.FULL_NAME]);
    phone_number = parse_string(tmp.data[0][sm_user.PHONE_NUMBER]);
    is_admin = parse_bool(tmp.data[0][sm_user.IS_ADMIN]);
    is_manager = parse_bool(tmp.data[0][sm_user.IS_MANAGER]);
    is_receptionist = parse_bool(tmp.data[0][sm_user.IS_RECEPTIONIST]);
    is_housekeeper = parse_bool(tmp.data[0][sm_user.IS_HOUSEKEEPER]);
    note = parse_string(tmp.data[0][sm_user.NOTE]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញUsername
      Show_Text(
        prefixIcon: Icons.person_outline,
        lead: "Username:", //
        value: username,
      ),

      // * បង្ហាញពាក្យសម្ងាត់ (លាក់)
      Show_Text(
        prefixIcon: Icons.lock_outline,
        lead: "Password:", //
        value: "**********",
      ),

      // * បង្ហាញFull Name
      Show_Text(
        prefixIcon: Icons.badge_outlined,
        lead: "Full Name:", //
        value: full_name,
      ),

      // * បង្ហាញPhone Number
      Show_Text(
        prefixIcon: Icons.phone_outlined,
        lead: "Phone Number:", //
        value: phone_number,
      ),

      // * បង្ហាញIs Admin
      Show_Boolean(
        prefixIcon: Icons.admin_panel_settings_outlined,
        leading: "Is Admin:", //
        value: is_admin,
      ),

      // * បង្ហាញIs Manager
      Show_Boolean(
        prefixIcon: Icons.manage_accounts_outlined,
        leading: "Is Manager:", //
        value: is_manager,
      ),

      // * បង្ហាញIs Receptionist
      Show_Boolean(
        prefixIcon: Icons.support_agent_outlined,
        leading: "Is Receptionist:", //
        value: is_receptionist,
      ),

      // * បង្ហាញIs Housekeeper
      Show_Boolean(
        prefixIcon: Icons.cleaning_services_outlined,
        leading: "Is Housekeeper:", //
        value: is_housekeeper,
      ),

      // * បង្ហាញកំណត់ចំណាំ
      Show_Text(
        prefixIcon: Icons.note_alt_outlined,
        lead: "Note:", //
        value: note,
        maxLines: 4,
      ),

      // * ប៊ូតុងបិទ
      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text("Close"),
        onPressed: () => Navigator.pop(context),
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

// * ថ្នាក់ Main_ ជាទំព័រអានព័ត៌មានអ្នកប្រើប្រាស់
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id,
  });

  final String id;

  @override
  State<Main_> createState() => _Main_State();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: MaterialApp(
        home: Main_(id: "1"), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
