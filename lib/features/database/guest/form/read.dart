// * ទំព័រអានព័ត៌មានភ្ញៀវ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រអានភ្ញៀវ
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់អានភ្ញៀវ
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_loading = true;

  String? id;
  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality_id;
  String? id_number;
  String? passport_number;
  String? note;

  // * ផ្ទុកព័ត៌មានភ្ញៀវតាម id
  void init() async {
    try {
      // * អានព័ត៌មានភ្ញៀវតាម id
      tmp = await dio.post(
        endpoint.GUEST_CRUD_READ_ID, //
        data: {sm_guest.ID: widget.id},
      );

      final data = tmp.data;
      // * បើគ្មានទិន្នន័យ បង្ហាញសារព្រមាន
      if (data == null || data.isEmpty) {
        snackbar(ct: context, ms: "No data found.", cl: Colors.red);
        is_loading = false;
        setState(() {});
        return;
      }
      final row = data[0];

      // * ផ្ទុកតម្លៃទៅក្នុងអថេរ
      id = row[sm_guest.ID]?.toString();
      full_name = row[sm_guest.FULL_NAME]?.toString();
      phone_number = row[sm_guest.PHONE_NUMBER]?.toString();
      gender = row[sm_guest.GENDER]?.toString();
      nationality_id = row[sm_guest.NATIONALITY_ID]?["name"]?.toString();
      id_number = row[sm_guest.ID_NUMBER]?.toString();
      passport_number = row[sm_guest.PASSPORT_NUMBER]?.toString();
      note = row[sm_guest.NOTE]?.toString();

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
      // * បង្ហាញឈ្មោះពេញ
      Show_Text(
        prefixIcon: Icons.person_outline,
        lead: "Full Name:", //
        value: full_name,
      ),

      // * បង្ហាញលេខទូរស័ព្ទ
      Show_Text(
        prefixIcon: Icons.phone_outlined,
        lead: "Phone Number:", //
        value: phone_number,
      ),

      // * បង្ហាញភេទ
      Show_Text(
        prefixIcon: Icons.wc_outlined,
        lead: "Gender:", //
        value: gender,
      ),

      // * បង្ហាញសញ្ជាតិ
      Show_Text(
        prefixIcon: Icons.flag_outlined,
        lead: "Nationality:", //
        value: nationality_id,
      ),

      // * បង្ហាញលេខអត្តសញ្ញាណប័ណ្ណ
      Show_Text(
        prefixIcon: Icons.badge_outlined,
        lead: "ID Number:", //
        value: id_number,
      ),

      // * បង្ហាញលេខលិខិតឆ្លងដែន
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

      SizedBox(height: height - 100),
    ]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រអានភ្ញៀវ
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
