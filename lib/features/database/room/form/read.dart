// * ទំព័រអានព័ត៌មានបន្ទប់ (Read Room)

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/show/show_number.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/room.g.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រអានបន្ទប់
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការអានព័ត៌មានបន្ទប់
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

  // * ផ្ទុកព័ត៌មានបន្ទប់តាម ID
  void init() async {
    try {
      // * អានព័ត៌មានបន្ទប់តាម ID
      tmp = await dio.post(
        endpoint.ROOM_CRUD_READ_ID, //
        data: {sm_room.ID: widget.id},
      );

      final data = tmp.data;
      if (data == null || data.isEmpty) {
        snackbar(ct: context, ms: "No data found.", cl: Colors.red);
        is_loading = false;
        setState(() {});
        return;
      }
      final row = data[0];

      // * ផ្ទុកតម្លៃពីជួរដេក
      number = row[sm_room.NUMBER]?.toString();
      usd_per_day = double.tryParse(row[sm_room.USD_PER_DAY]?.toString() ?? "");
      usd_per_3h = double.tryParse(row[sm_room.USD_PER_3H]?.toString() ?? "");
      kind = row[sm_room.KIND]?.toString();
      status = row[sm_room.STATUS]?.toString();
      note = row[sm_room.NOTE]?.toString();

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
      // * បង្ហាញលេខបន្ទប់
      Show_Text(
        prefixIcon: Icons.meeting_room_outlined,
        lead: "Number:", //
        value: number,
      ),

      // * បង្ហាញតម្លៃក្នុងមួយថ្ងៃ
      Show_Number(
        prefixIcon: Icons.attach_money,
        leading: "USD/Day:", //
        value: usd_per_day,
      ),

      // * បង្ហាញតម្លៃក្នុងមួយ 3 ម៉ោង
      Show_Number(
        prefixIcon: Icons.attach_money,
        leading: "USD/3H:", //
        value: usd_per_3h,
      ),

      // * បង្ហាញប្រភេទបន្ទប់
      Show_Text(
        prefixIcon: Icons.king_bed_outlined,
        lead: "Kind:", //
        value: kind,
      ),

      // * បង្ហាញស្ថានភាពបន្ទប់
      Show_Text(
        prefixIcon: Icons.verified_outlined,
        lead: "Status:", //
        value: status,
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

// * ថ្នាក់ Main_ ជាទំព័រអានបន្ទប់
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
