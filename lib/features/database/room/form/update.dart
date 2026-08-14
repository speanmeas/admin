// * ទំព័រកែប្រែបន្ទប់ (Update Room)

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/room.g.dart";

import "../widget/kind_select.dart" as k_select;
import "../widget/status_select.dart" as s_select;
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * បង្កើត layout មេរបស់ទំព័រកែប្រែបន្ទប់
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់កែប្រែបន្ទប់
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

      // * ប៊ូតុងកែប្រែបន្ទប់
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  // * កែប្រែបន្ទប់តាមរយៈ API
  void on_update() async {
    try {
      // * ផ្ញើសំណើកែប្រែបន្ទប់
      tmp = await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.id,
          sm_room.NUMBER: number,
          sm_room.USD_PER_DAY: usd_per_day,
          sm_room.USD_PER_3H: usd_per_3h,
          sm_room.KIND: kind,
          sm_room.STATUS: status,
          sm_room.NOTE: note, //
        },
      );

      // * ត្រលប់ទៅទំព័រមុនជាមួយទិន្នន័យដែលបានកែប្រែ
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

// * ថ្នាក់ Main_ ជាទំព័រកែប្រែបន្ទប់
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
