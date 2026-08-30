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

  String? text;
  double? number;
  DateTime? date_time;
  bool? logic;

  // * ផ្ទុកព័ត៌មានឧទាហរណ៍តាម id
  void init() async {
    // * អានទិន្នន័យឧទាហរណ៍តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.DEMO_1_READ_ID, data: {Demo_1.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    final demo = Demo_1.fromJson(tmp.data[0]);
    text = demo.text;
    number = demo.number;
    date_time = demo.date_time;
    logic = demo.logic;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញអត្ថបទ
      Show_Text(
        prefixIcon: Icons.text_fields,
        lead: "Text:", //
        value: text,
      ),

      // * បង្ហាញលេខ
      Show_Number(
        prefixIcon: Icons.numbers,
        leading: "Number:", //
        value: number,
      ),

      // * បង្ហាញកាលបរិច្ឆេទ
      Show_Datetime(
        prefixIcon: Icons.calendar_month,
        leading: "Date Time:", //
        value: date_time,
      ),

      // * បង្ហាញតម្លៃប៊ូលីន
      Show_Boolean(
        prefixIcon: Icons.toggle_on,
        leading: "Logic:", //
        value: logic,
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
