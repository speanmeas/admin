// * ទំព័រកែប្រែព័ត៌មានភ្ញៀវ

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
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/search/search_nationality.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រកែប្រែភ្ញៀវ
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់កែប្រែភ្ញៀវ
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_loading = true;

  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality_id;
  String? id_number;
  String? passport_number;
  String? note;

  // * ផ្ទុកព័ត៌មានភ្ញៀវបច្ចុប្បន្ន
  void init() async {
    // * អានទិន្នន័យភ្ញៀវតាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.GUEST_CRUD_READ_ID, data: {sm_guest.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.GUEST_CRUD_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    full_name = parse_string(tmp.data[0][sm_guest.FULL_NAME]);
    phone_number = parse_string(tmp.data[0][sm_guest.PHONE_NUMBER]);
    gender = parse_string(tmp.data[0][sm_guest.GENDER]);
    nationality_id = parse_string(tmp.data[0][sm_guest.NATIONALITY_ID]?['name']);
    id_number = parse_string(tmp.data[0][sm_guest.ID_NUMBER]);
    passport_number = parse_string(tmp.data[0][sm_guest.PASSPORT_NUMBER]);
    note = parse_string(tmp.data[0][sm_guest.NOTE]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
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

      // * ជ្រើសរើសGender
      Select_Dynamic(
        init: gender, //
        lead: "Gender:", //
        options: ["Male", "Female", "Other"], //
        prefixIcon: Icons.wc,
        onChanged: (v) {
          gender = v;
          setState(() {});
        },
      ),

      // * ស្វែងរកNationality
      Search_Nationality(
        init: nationality_id, //
        onChanged: (v) {
          nationality_id = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលID Number
      Input_Text(
        init: id_number, //
        lead: "ID Number:", //
        onChanged: (v) {
          id_number = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលPassport Number
      Input_Text(
        init: passport_number, //
        lead: "Passport Number:", //
        onChanged: (v) {
          passport_number = v;
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

  // * អនុវត្តការកែប្រែភ្ញៀវ
  void on_update() async {
    // * ផ្ញើសំណើកែប្រែភ្ញៀវ
    setState(() => is_loading = true);
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
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.GUEST_CRUD_UPDATE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, tmp.data[0]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រកែប្រែភ្ញៀវ
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
