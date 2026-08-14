// * ទំព័រកែប្រែភ្ញៀវ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
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
  dynamic tmp;
  bool is_loading = true;

  String? full_name;
  String? phone_number;
  String? gender;
  String? nationality_id;
  String? id_number;
  String? passport_number;
  String? note;

  // * ផ្ទុកព័ត៌មានភ្ញៀវតាម id សម្រាប់កែប្រែ
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
      // * កែប្រែឈ្មោះពេញ
      Input_Text(
        init: full_name, //
        lead: "Full Name:",
        onChanged: (v) {
          full_name = v;
          setState(() {});
        },
      ),

      // * កែប្រែលេខទូរស័ព្ទ
      Input_Text(
        init: phone_number, //
        lead: "Phone Number:",
        onChanged: (v) {
          phone_number = v;
          setState(() {});
        },
      ),

      // * កែប្រែភេទ
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

      // * កែប្រែសញ្ជាតិ
      Search_Nationality(
        init: nationality_id, //
        onChanged: (v) {
          nationality_id = v;
          setState(() {});
        },
      ),

      // * កែប្រែលេខអត្តសញ្ញាណប័ណ្ណ
      Input_Text(
        init: id_number, //
        lead: "ID Number:",
        onChanged: (v) {
          id_number = v;
          setState(() {});
        },
      ),

      // * កែប្រែលេខលិខិតឆ្លងដែន
      Input_Text(
        init: passport_number, //
        lead: "Passport Number:",
        onChanged: (v) {
          passport_number = v;
          setState(() {});
        },
      ),

      // * កែប្រែកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: "Note:",
        maxLines: 4,
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),
      // * ប៊ូតុងកែប្រែ
      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text("Update"),
        onPressed: on_update,
      ),

      SizedBox(height: height - 100), //
    ]);
  }

  // * អនុវត្តការកែប្រែភ្ញៀវ
  void on_update() async {
    try {
      // * ផ្ញើសំណើកែប្រែភ្ញៀវ
      tmp = await dio.post(
        endpoint.GUEST_CRUD_UPDATE, //
        data: {
          sm_guest.ID: widget.id, //
          sm_guest.FULL_NAME: full_name, //
          sm_guest.PHONE_NUMBER: phone_number, //
          sm_guest.ID_NUMBER: id_number, //
          sm_guest.PASSPORT_NUMBER: passport_number, //
          sm_guest.NOTE: note, //
          sm_guest.GENDER: gender, //
          sm_guest.NATIONALITY_ID: nationality_id, //
        },
      );

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
}

// * ថ្នាក់ Main_ ជាទំព័រកែប្រែភ្ញៀវ
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
