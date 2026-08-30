// * ទំព័របង្កើតភ្ញៀវថ្មី

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/search/search_nationality.dart";

// * បង្កើត layout មេរបស់ទំព័របង្កើតភ្ញៀវ
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បង្កើតភ្ញៀវ
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;

  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality_id;
  String? id_number;
  String? passport_number;
  String? note;

  void init() async {
    setState(() => is_loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
        init: "Cambodian", //
        onChanged: (v) {
          nationality_id = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v ?? "";
          setState(() {});
        },
      ),

      // * ប៊ូតុងបង្កើត
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Create"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: is_loading ? null : on_create,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការបង្កើតភ្ញៀវ
  void on_create() async {
    // * ផ្ញើសំណើបង្កើតភ្ញៀវ
    setState(() => is_loading = true);
    tmp = await dio.post(
      endpoint.GUEST_CREATE, //
      data: {
        Guest.FULL_NAME: full_name,
        Guest.PHONE_NUMBER: phone_number,
        // Guest.GENDER: gender,
        // Guest.NATIONALITY_ID: nationality_id,
        Guest.NOTE: note, //
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

// * ថ្នាក់ Main_ ជាទំព័របង្កើតភ្ញៀវ
class Main_ extends StatefulWidget {
  const Main_({super.key});
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
        home: Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
