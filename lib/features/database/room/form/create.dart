// * ទំព័របង្កើតបន្ទប់ថ្មី

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "../widget/kind_select.dart" as k_select;
import "../widget/status_select.dart" as s_select;

// * បង្កើត layout មេរបស់ទំព័របង្កើតបន្ទប់
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បង្កើតបន្ទប់
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  bool is_loading = true;

  String? number;
  double? usd_per_day;
  double? usd_per_3h;
  String? kind;
  String? status;
  String? note;

  void init() async {
    setState(() => is_loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * បញ្ចូលNumber
      Input_Text(
        init: number, //
        lead: "Number:", //
        onChanged: (v) {
          number = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលUSD/Day
      Input_Number(
        init: usd_per_day, //
        lead: "USD/Day:", //
        onChanged: (v) {
          usd_per_day = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលUSD/3H
      Input_Number(
        init: usd_per_3h, //
        lead: "USD/3H:", //
        onChanged: (v) {
          usd_per_3h = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសប្រភេទបន្ទប់
      k_select.Main_(
        initial: kind, //
        onChanged: (v) {
          kind = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសស្ថានភាពបន្ទប់
      s_select.Main_(
        initial: status, //
        onChanged: (v) {
          status = v;
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

  // * អនុវត្តការបង្កើតបន្ទប់
  void on_create() async {
    // * ផ្ញើសំណើបង្កើតបន្ទប់
    setState(() => is_loading = true);
    tmp = await dio.post(
      endpoint.ROOM_CREATE, //
      data: {
        Room.NUMBER: number,
        Room.PRICE_PER_DAY: usd_per_day,
        Room.PRICE_PER_3H: usd_per_3h,
        Room.KIND: kind,
        Room.STATUS: status,
        Room.NOTE: note, //
      },
    );
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, tmp.data[0]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័របង្កើតបន្ទប់
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
