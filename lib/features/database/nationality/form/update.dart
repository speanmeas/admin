// * ទំព័រកែប្រែសញ្ជាតិ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/schema/nationality.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រកែប្រែសញ្ជាតិ
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់កែប្រែសញ្ជាតិ
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_loading = true;

  String? name;
  String? note;

  // * ផ្ទុកព័ត៌មានសញ្ជាតិតាម id សម្រាប់កែប្រែ
  void init() async {
    try {
      // * អានព័ត៌មានសញ្ជាតិតាម id
      tmp = await dio.post(
        endpoint.NATIONALITY_CRUD_READ_ID, //
        data: {sm_nationality.ID: widget.id},
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
      name = row[sm_nationality.NAME]?.toString();
      note = row[sm_nationality.NOTE]?.toString();

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
      // * កែប្រែឈ្មោះសញ្ជាតិ
      Input_Text(
        init: name, //
        lead: "Name:", //
        onChanged: (v) => name = v,
      ),

      // * កែប្រែកំណត់ចំណាំ
      Input_Text(
        init: null, //
        lead: "Note:", //
        maxLines: 4, //
        prefixIcon: Icons.note_alt_outlined, //
        onChanged: (v) => note = v ?? "",
      ),

      // * ប៊ូតុងកែប្រែ
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការកែប្រែសញ្ជាតិ
  void on_update() async {
    try {
      // * ផ្ញើសំណើកែប្រែសញ្ជាតិ
      tmp = await dio.post(
        endpoint.NATIONALITY_CRUD_UPDATE, //
        data: {
          sm_nationality.ID: widget.id,
          sm_nationality.NAME: name,
          sm_nationality.NOTE: note, //
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

  //
}

// * ថ្នាក់ Main_ ជាទំព័រកែប្រែសញ្ជាតិ
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
