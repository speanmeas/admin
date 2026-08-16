// * ទំព័រអានព័ត៌មានភ្ញៀវ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/show/show_text.dart";

// * បង្កើត layout មេរបស់ទំព័រអានព័ត៌មានភ្ញៀវ
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការអានព័ត៌មានភ្ញៀវ
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

  // * ផ្ទុកព័ត៌មានភ្ញៀវតាម id
  void init() async {
    // * អានទិន្នន័យភ្ញៀវតាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.GUEST_CRUD_READ_ID, data: {Guest.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.GUEST_CRUD_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    final guest = Guest.fromJson(tmp.data[0]);
    full_name = guest.full_name;
    phone_number = guest.phone_number;
    gender = guest.gender;
    nationality_id = guest.nationality_id?.name;
    id_number = guest.id_number;
    passport_number = guest.passport_number;
    note = guest.note;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញFull Name
      Show_Text(
        prefixIcon: Icons.person_outline,
        lead: "Full Name:", //
        value: full_name,
      ),

      // * បង្ហាញPhone Number
      Show_Text(
        prefixIcon: Icons.phone_outlined,
        lead: "Phone Number:", //
        value: phone_number,
      ),

      // * បង្ហាញGender
      Show_Text(
        prefixIcon: Icons.wc_outlined,
        lead: "Gender:", //
        value: gender,
      ),

      // * បង្ហាញNationality
      Show_Text(
        prefixIcon: Icons.flag_outlined,
        lead: "Nationality:", //
        value: nationality_id,
      ),

      // * បង្ហាញID Number
      Show_Text(
        prefixIcon: Icons.badge_outlined,
        lead: "ID Number:", //
        value: id_number,
      ),

      // * បង្ហាញPassport Number
      Show_Text(
        prefixIcon: Icons.book_outlined,
        lead: "Passport Number:", //
        value: passport_number,
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

// * ថ្នាក់ Main_ ជាទំព័រអានព័ត៌មានភ្ញៀវ
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
