// * ទំព័របង្កើតបន្ទប់ថ្មី (Create Room)

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/room.g.dart";

import "../widget/kind_select.dart" as k_select;
import "../widget/status_select.dart" as s_select;
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

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

  String? number;
  double? usd_per_day;
  double? usd_per_3h;
  String? kind;
  String? status;
  String? note;

  // * ផ្ទុកទិន្នន័យដំបូង
  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * បញ្ចូលលេខបន្ទប់
      Input_Text(
        init: number, //
        lead: "Number:", //
        onChanged: (v) => number = v,
      ),

      // * បញ្ចូលតម្លៃក្នុងមួយថ្ងៃ
      Input_Number(
        init: usd_per_day, //
        lead: "USD/Day:", //
        onChanged: (v) => usd_per_day = v,
      ),

      // * បញ្ចូលតម្លៃក្នុងមួយ 3 ម៉ោង
      Input_Number(
        init: usd_per_3h, //
        lead: "USD/3H:", //
        onChanged: (v) => usd_per_3h = v,
      ),

      // * ជ្រើសរើសប្រភេទបន្ទប់
      k_select.Main_(
        initial: kind, //
        onChanged: (v) => kind = v,
      ),

      // * ជ្រើសរើសស្ថានភាពបន្ទប់
      s_select.Main_(
        initial: status, //
        onChanged: (v) => status = v,
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) => note = v ?? "",
      ),

      // * ប៊ូតុងបង្កើតបន្ទប់
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Create"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_create,
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * បង្កើតបន្ទប់ថ្មីតាមរយៈ API
  void on_create() async {
    try {
      // * ផ្ញើសំណើបង្កើតបន្ទប់
      tmp = await dio.post(
        endpoint.ROOM_CRUD_CREATE, //
        data: {
          sm_room.NUMBER: number,
          sm_room.USD_PER_DAY: usd_per_day,
          sm_room.USD_PER_3H: usd_per_3h,
          sm_room.KIND: kind,
          sm_room.STATUS: status,
          sm_room.NOTE: note, //
        },
      );

      // * ត្រលប់ទៅទំព័រមុនជាមួយទិន្នន័យដែលបានបង្កើត
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
