// * ទំព័រអានព័ត៌មានឧទាហរណ៍

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/show/show_boolean.dart";
import "package:speanmeas/core/widget/show/show_datetime.dart";
import "package:speanmeas/core/widget/show/show_number.dart";
import "package:speanmeas/core/widget/show/show_text.dart";

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
    // * អានទិន្នន័យឧទាហរណ៍តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.DEMO_1_CRUD_READ_ID, data: {Demo_1.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.DEMO_1_CRUD_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    final demo = Demo_1.fromJson(tmp.data[0]);
    text_1 = demo.text_1;
    text_2 = demo.text_2;
    number_1 = demo.number_1;
    number_2 = demo.number_2;
    datetime_1 = demo.datetime_1;
    datetime_2 = demo.datetime_2;
    logic_1 = demo.logic_1;
    logic_2 = demo.logic_2;
    note = demo.note;

    setState(() {});
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
