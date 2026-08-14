// * ទំព័រកែប្រែព័ត៌មានឧទាហរណ៍

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/pick/pick_boolean.dart";
import "package:speanmeas/core/widget/pick/pick_datetime.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/demo_1.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រកែប្រែឧទាហរណ៍
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់កែប្រែឧទាហរណ៍
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

  // * ផ្ទុកព័ត៌មានឧទាហរណ៍បច្ចុប្បន្ន
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
      // * បញ្ចូលអត្ថបទ 1
      Input_Text(
        init: text_1, //
        lead: "Text 1:", //
        onChanged: (v) => text_1 = v,
      ),

      // * បញ្ចូលអត្ថបទ 2
      Input_Text(
        init: text_2, //
        lead: "Text 2:", //
        onChanged: (v) => text_2 = v,
      ),

      // * បញ្ចូលលេខ 1
      Input_Number(
        init: number_1, //
        lead: "Number 1:", //
        onChanged: (v) => number_1 = v,
      ),

      // * បញ្ចូលលេខ 2
      Input_Number(
        init: number_2, //
        lead: "Number 2:", //
        onChanged: (v) => number_2 = v,
      ),

      // * ជ្រើសរើសកាលបរិច្ឆេទ 1
      Picker_Datetime(
        initial: datetime_1, //
        title: "Datetime 1:", //
        onChanged: (v) => datetime_1 = v,
      ),

      // * ជ្រើសរើសកាលបរិច្ឆេទ 2
      Picker_Datetime(
        initial: datetime_2, //
        title: "Datetime 2:", //
        onChanged: (v) => datetime_2 = v,
      ),

      // * ជ្រើសរើសតម្លៃប៊ូលីន 1
      Picker_Boolean(
        initial: logic_1, //
        title: "Logic 1:", //
        onChanged: (v) => logic_1 = v,
      ),

      // * ជ្រើសរើសតម្លៃប៊ូលីន 2
      Picker_Boolean(
        initial: logic_2, //
        title: "Logic 2:", //
        onChanged: (v) => logic_2 = v,
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
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

  // * អនុវត្តការកែប្រែឧទាហរណ៍
  void on_update() async {
    try {
      // * ផ្ញើសំណើកែប្រែឧទាហរណ៍
      tmp = await dio.post(
        endpoint.DEMO_1_CRUD_UPDATE, //
        data: {
          sm_demo_1.ID: widget.id,
          sm_demo_1.TEXT_1: text_1,
          sm_demo_1.TEXT_2: text_2,
          sm_demo_1.NUMBER_1: number_1,
          sm_demo_1.NUMBER_2: number_2,
          sm_demo_1.DATETIME_1: datetime_1?.toIso8601String(),
          sm_demo_1.DATETIME_2: datetime_2?.toIso8601String(),
          sm_demo_1.LOGIC_1: logic_1,
          sm_demo_1.LOGIC_2: logic_2,
          sm_demo_1.NOTE: note, //
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

// * ថ្នាក់ Main_ ជាទំព័រកែប្រែឧទាហរណ៍
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
