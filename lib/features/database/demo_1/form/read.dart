// * ទំព័រអានព័ត៌មានឧទាហរណ៍

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/show/show_boolean.dart";
import "package:speanmeas/core/widget/show/show_datetime.dart";
import "package:speanmeas/core/widget/show/show_number.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/demo_1.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រអានព័ត៌មានឧទាហរណ៍
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការអានព័ត៌មានឧទាហរណ៍
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_loading = true;

  String? text_1;
  String? text_2;
  double? number_1;
  double? number_2;
  DateTime? datetime_1;
  DateTime? datetime_2;
  bool? logic_1;
  bool? logic_2;
  String? note;

  // * ផ្ទុកព័ត៌មានឧទាហរណ៍តាម id
  void init() async {
    try {
      // * អានទិន្នន័យឧទាហរណ៍តាម id
      tmp = await dio.post(
        endpoint.DEMO_1_CRUD_READ_ID, //
        data: {sm_demo_1.ID: widget.id},
      );

      final data = tmp.data;
      if (data == null || data.isEmpty) {
        snackbar(ct: context, ms: "No data found.", cl: Colors.red);
        is_loading = false;
        setState(() {});
        return;
      }

      final row = data[0];
      text_1 = row[sm_demo_1.TEXT_1]?.toString();
      text_2 = row[sm_demo_1.TEXT_2]?.toString();
      number_1 = double.tryParse(row[sm_demo_1.NUMBER_1]?.toString() ?? "");
      number_2 = double.tryParse(row[sm_demo_1.NUMBER_2]?.toString() ?? "");
      final dt_1 = DateTime.tryParse(row[sm_demo_1.DATETIME_1]?.toString() ?? "");
      if (dt_1 != null) datetime_1 = dt_1;
      final dt_2 = DateTime.tryParse(row[sm_demo_1.DATETIME_2]?.toString() ?? "");
      if (dt_2 != null) datetime_2 = dt_2;
      final l_1 = row[sm_demo_1.LOGIC_1];
      logic_1 = l_1 is bool ? l_1 : null;
      final l_2 = row[sm_demo_1.LOGIC_2];
      logic_2 = l_2 is bool ? l_2 : null;
      note = row[sm_demo_1.NOTE]?.toString();

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
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញអត្ថបទ 1
      Show_Text(
        prefixIcon: Icons.text_fields,
        lead: "Text 1:", //
        value: text_1,
      ),

      // * បង្ហាញអត្ថបទ 2
      Show_Text(
        prefixIcon: Icons.text_fields,
        lead: "Text 2:", //
        value: text_2,
      ),

      // * បង្ហាញលេខ 1
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Number 1:", //
        value: number_1,
      ),

      // * បង្ហាញលេខ 2
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Number 2:", //
        value: number_2,
      ),

      // * បង្ហាញកាលបរិច្ឆេទ 1
      Show_Datetime(
        prefixIcon: Icons.calendar_month,
        leading: "Datetime 1:", //
        value: datetime_1,
      ),

      // * បង្ហាញកាលបរិច្ឆេទ 2
      Show_Datetime(
        prefixIcon: Icons.calendar_month,
        leading: "Datetime 2:", //
        value: datetime_2,
      ),

      // * បង្ហាញតម្លៃប៊ូលីន 1
      Show_Boolean(
        prefixIcon: Icons.toggle_on,
        leading: "Boolean:", //
        value: logic_1,
      ),

      // * បង្ហាញតម្លៃប៊ូលីន 2
      Show_Boolean(
        prefixIcon: Icons.toggle_on,
        leading: "Boolean 2:", //
        value: logic_2,
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

// * ថ្នាក់ Main_ ជាទំព័រអានព័ត៌មានឧទាហរណ៍
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
