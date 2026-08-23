// * ទំព័របង្កើតឧទាហរណ៍ថ្មី

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/pick/pick_boolean.dart";
import "package:speanmeas/core/widget/pick/pick_datetime.dart";
import "package:speanmeas/core/widget/input/input_number.dart";

// * បង្កើត layout មេរបស់ទំព័របង្កើតឧទាហរណ៍
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បង្កើតឧទាហរណ៍
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_loading = true;

  String? text_1;
  double? number_1;
  DateTime? datetime_1;
  bool? logic_1;
  String? note;

  void init() async {
    setState(() => is_loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * បញ្ចូលអត្ថបទ 1
      Input_Text(
        init: text_1, //
        lead: "Text 1:", //
        onChanged: (v) {
          text_1 = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលលេខ 1
      Input_Number(
        init: number_1, //
        lead: "Number 1:", //
        onChanged: (v) {
          number_1 = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសកាលបរិច្ឆេទ 1
      Picker_Datetime(
        initial: datetime_1, //
        title: "Datetime 1:", //
        onChanged: (v) {
          datetime_1 = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសតម្លៃប៊ូលីន 1
      Picker_Boolean(
        initial: logic_1, //
        title: "Logic 1:", //
        onChanged: (v) {
          logic_1 = v;
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

  // * អនុវត្តការបង្កើតឧទាហរណ៍
  void on_create() async {
    // * ផ្ញើសំណើបង្កើតឧទាហរណ៍
    setState(() => is_loading = true);
    tmp = await dio.post(
      endpoint.DEMO_2_CREATE, //
      data: {
        Demo_2.TEXT_1: text_1, //
        Demo_2.NUMBER_1: number_1, //
        Demo_2.DATETIME_1: datetime_1?.toIso8601String(), //
        Demo_2.LOGIC_1: logic_1, //
        Demo_2.NOTE: note, //
      },
    );
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.DEMO_2_CREATE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, tmp.data[0]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័របង្កើតឧទាហរណ៍
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
