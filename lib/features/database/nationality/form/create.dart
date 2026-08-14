// * ទំព័របង្កើតសញ្ជាតិថ្មី

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/schema/nationality.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័របង្កើតសញ្ជាតិ
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បង្កើតសញ្ជាតិ
class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  String? name;
  String? note;

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * បញ្ចូលឈ្មោះសញ្ជាតិ
      Input_Text(
        init: name, //
        lead: "Name:", //
        onChanged: (v) => name = v,
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: null, //
        lead: "Note:", //
        prefixIcon: Icons.note_alt_outlined, //
        maxLines: 4, //
        onChanged: (v) => note = v ?? "",
      ),

      // * ប៊ូតុងបង្កើត
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Create"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_create,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការបង្កើតសញ្ជាតិ
  void on_create() async {
    try {
      // * ផ្ញើសំណើបង្កើតសញ្ជាតិ
      tmp = await dio.post(
        endpoint.NATIONALITY_CRUD_CREATE, //
        data: {
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

// * ថ្នាក់ Main_ ជាទំព័របង្កើតសញ្ជាតិ
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
  //
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
