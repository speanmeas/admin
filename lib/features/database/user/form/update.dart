// * ទំព័រកែប្រែព័ត៌មានអ្នកប្រើប្រាស់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/parse.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/pick/pick_boolean.dart";
import "package:speanmeas/core/widget/input/input_password.dart";
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់កែប្រែអ្នកប្រើប្រាស់
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

  // * ផ្ទុកព័ត៌មានអ្នកប្រើប្រាស់បច្ចុប្បន្ន
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
      // * បញ្ចូលUsername
      Input_Text(
        init: username, //
        lead: "Username:", //
        onChanged: (v) {
          username = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលពាក្យសម្ងាត់
      Input_Password(
        initial: password, //
        hint: "New Password", //
        onChanged: (v) {
          password = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលFull Name
      Input_Text(
        init: full_name, //
        lead: "Full Name:", //
        onChanged: (v) {
          full_name = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលPhone Number
      Input_Text(
        init: phone_number, //
        lead: "Phone Number:", //
        onChanged: (v) {
          phone_number = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសIs Admin
      Picker_Boolean(
        initial: is_admin, //
        title: "Is Admin:", //
        onChanged: (v) {
          is_admin = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសIs Manager
      Picker_Boolean(
        initial: is_manager, //
        title: "Is Manager:", //
        onChanged: (v) {
          is_manager = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសIs Receptionist
      Picker_Boolean(
        initial: is_receptionist, //
        title: "Is Receptionist:", //
        onChanged: (v) {
          is_receptionist = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសIs Housekeeper
      Picker_Boolean(
        initial: is_housekeeper, //
        title: "Is Housekeeper:", //
        onChanged: (v) {
          is_housekeeper = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងកែប្រែ
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: is_loading ? null : on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការកែប្រែអ្នកប្រើប្រាស់
  void on_update() async {
    // * ផ្ញើសំណើកែប្រែអ្នកប្រើប្រាស់
    setState(() => is_loading = true);
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
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.USER_CRUD_UPDATE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, tmp.data[0]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
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
