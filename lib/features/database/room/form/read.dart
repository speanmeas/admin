// * ទំព័រអានព័ត៌មានបន្ទប់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/show/show_number.dart";

// * បង្កើត layout មេរបស់ទំព័រអានព័ត៌មានបន្ទប់
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
  dynamic tmp;
  bool is_loading = true;

  String? number;
  double? usd_per_day;
  double? usd_per_3h;
  String? kind;
  String? status;
  String? note;

  // * ផ្ទុកព័ត៌មានបន្ទប់តាម id
  void init() async {
    // * អានទិន្នន័យបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {Room.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_CRUD_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    final room = Room.fromJson(tmp.data[0]);
    number = room.number;
    usd_per_day = room.usd_per_day;
    usd_per_3h = room.usd_per_3h;
    kind = room.kind;
    status = room.status;
    note = room.note;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញNumber
      Show_Text(
        prefixIcon: Icons.meeting_room_outlined,
        lead: "Number:", //
        value: number,
      ),

      // * បង្ហាញUSD/Day
      Show_Number(
        prefixIcon: Icons.attach_money,
        leading: "USD/Day:", //
        value: usd_per_day,
      ),

      // * បង្ហាញUSD/3H
      Show_Number(
        prefixIcon: Icons.attach_money,
        leading: "USD/3H:", //
        value: usd_per_3h,
      ),

      // * បង្ហាញKind
      Show_Text(
        prefixIcon: Icons.king_bed_outlined,
        lead: "Kind:", //
        value: kind,
      ),

      // * បង្ហាញStatus
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

// * ថ្នាក់ Main_ ជាទំព័រអានព័ត៌មានបន្ទប់
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
