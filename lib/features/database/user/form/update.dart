// * ទំព័រកែប្រែព័ត៌មានអ្នកប្រើប្រាស់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

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
    tmp = await dio.post(endpoint.USER_READ_ID, data: {User.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    final user = User.fromJson(tmp.data[0]);
    username = user.username;
    full_name = user.full_name;
    phone_number = user.phone_number;
    is_admin = user.is_admin;
    is_manager = user.is_manager;
    is_receptionist = user.is_receptionist;
    is_housekeeper = user.is_housekeeper;
    note = user.note;

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
      endpoint.USER_UPDATE, //
      data: {
        User.ID: widget.id,
        User.USERNAME: username,
        User.PASSWORD: password,
        User.FULL_NAME: full_name,
        User.PHONE_NUMBER: phone_number,
        User.IS_ADMIN: is_admin,
        User.IS_MANAGER: is_manager,
        User.IS_RECEPTIONIST: is_receptionist,
        User.IS_HOUSEKEEPER: is_housekeeper,
        User.NOTE: note, //
      },
    );
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

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
