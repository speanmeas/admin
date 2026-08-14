// * ទំព័រកែប្រែព័ត៌មានអ្នកប្រើប្រាស់ (Update User)

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/pick/pick_boolean.dart";
import "package:speanmeas/core/widget/input/input_password.dart";

// * បង្កើត layout មេរបស់ទំព័រកែប្រែអ្នកប្រើប្រាស់
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការកែប្រែអ្នកប្រើប្រាស់
class _Main_State extends State<Main_> {
  //
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

  // * ផ្ទុកព័ត៌មានអ្នកប្រើប្រាស់តាម ID
  void init() async {
    try {
      // * អានព័ត៌មានអ្នកប្រើប្រាស់តាម ID
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

      // * ផ្ទុកតម្លៃពីជួរដេក
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
      // * បញ្ចូលឈ្មោះអ្នកប្រើប្រាស់
      Input_Text(
        init: username, //
        lead: "Username:", //
        onChanged: (v) => username = v,
      ),

      // * បញ្ចូលពាក្យសម្ងាត់ថ្មី
      Input_Password(
        initial: password, //
        hint: "New Password", //
        onChanged: (v) => password = v,
      ),

      // * បញ្ចូលឈ្មោះពេញ
      Input_Text(
        init: full_name, //
        lead: "Full Name:", //
        onChanged: (v) => full_name = v,
      ),

      // * បញ្ចូលលេខទូរស័ព្ទ
      Input_Text(
        init: phone_number, //
        lead: "Phone Number:", //
        onChanged: (v) => phone_number = v,
      ),

      // * ជ្រើសរើសតួនាទីជាអ្នកគ្រប់គ្រងប្រព័ន្ធ
      Picker_Boolean(
        initial: is_admin, //
        title: "Is Admin:", //
        onChanged: (v) => is_admin = v,
      ),

      // * ជ្រើសរើសតួនាទីជាអ្នកគ្រប់គ្រង
      Picker_Boolean(
        initial: is_manager, //
        title: "Is Manager:", //
        onChanged: (v) => is_manager = v,
      ),

      // * ជ្រើសរើសតួនាទីជាអ្នកទទួលភ្ញៀវ
      Picker_Boolean(
        initial: is_receptionist, //
        title: "Is Receptionist:", //
        onChanged: (v) => is_receptionist = v,
      ),

      // * ជ្រើសរើសតួនាទីជាអ្នកសម្អាត
      Picker_Boolean(
        initial: is_housekeeper, //
        title: "Is Housekeeper:", //
        onChanged: (v) => is_housekeeper = v,
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) => note = v ?? "",
      ),

      // * ប៊ូតុងកែប្រែអ្នកប្រើប្រាស់
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  // * កែប្រែព័ត៌មានអ្នកប្រើប្រាស់តាមរយៈ API
  void on_update() async {
    try {
      // * ផ្ញើសំណើកែប្រែអ្នកប្រើប្រាស់
      tmp = await dio.post(
        endpoint.USER_CRUD_UPDATE, //
        data: {
          sm_user.ID: widget.id,
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

      // * ត្រលប់ទៅទំព័រមុនជាមួយទិន្នន័យដែលបានកែប្រែ
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

// * ថ្នាក់ Main_ ជាទំព័រកែប្រែអ្នកប្រើប្រាស់
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.id, //
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
  //
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
