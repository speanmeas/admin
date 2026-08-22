// * ទំព័របង្កើត front desk ថ្មី

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/widget/search/search_room.dart";
import "package:speanmeas/core/widget/search/search_guest.dart";

// * បង្កើត layout មេរបស់ទំព័របង្កើត front desk
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បង្កើត front desk
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;

  String? room_id;
  String? guest_id;
  double? check_in_number;
  double? check_in_day;
  double? check_in_hour;
  String? check_in_note;
  String? cancel_note;
  String? change_note;
  String? check_out_note;
  String? clean_note;
  String? broke_note;
  String? fix_note;

  void init() async {
    setState(() => is_loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * ស្វែងរក និងជ្រើសរើសបន្ទប់
      Search_Room(
        onChanged: (v) {
          room_id = v;
          setState(() {});
        },
      ),

      // * ស្វែងរក និងជ្រើសរើសភ្ញៀវ
      Search_Guest(
        onChanged: (v) {
          guest_id = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលចំនួនភ្ញៀវ
      Input_Number(
        init: check_in_number, //
        lead: "Number of Guests:", //
        prefixIcon: Icons.people_outline,
        onChanged: (v) {
          check_in_number = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលថ្ងៃស្នាក់នៅ
      Input_Number(
        init: check_in_day, //
        lead: "Stay Days:", //
        prefixIcon: Icons.calendar_month_outlined,
        onChanged: (v) {
          check_in_day = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលម៉ោងស្នាក់នៅ
      Input_Number(
        init: check_in_hour, //
        lead: "Stay Hours:", //
        prefixIcon: Icons.access_time_outlined,
        onChanged: (v) {
          check_in_hour = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំ check in
      Input_Text(
        init: check_in_note, //
        lead: "Check In Note:", //
        maxLines: 2, //
        onChanged: (v) {
          check_in_note = v ?? "";
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំបោះបង់
      Input_Text(
        init: cancel_note, //
        lead: "Cancel Note:", //
        maxLines: 2, //
        onChanged: (v) {
          cancel_note = v ?? "";
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំ check out
      Input_Text(
        init: check_out_note, //
        lead: "Check Out Note:", //
        maxLines: 2, //
        onChanged: (v) {
          check_out_note = v ?? "";
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំសម្អាត
      Input_Text(
        init: clean_note, //
        lead: "Clean Note:", //
        maxLines: 2, //
        onChanged: (v) {
          clean_note = v ?? "";
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំខូចខាត
      Input_Text(
        init: broke_note, //
        lead: "Broke Note:", //
        maxLines: 2, //
        onChanged: (v) {
          broke_note = v ?? "";
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំជួសជុល
      Input_Text(
        init: fix_note, //
        lead: "Fix Note:", //
        maxLines: 2, //
        onChanged: (v) {
          fix_note = v ?? "";
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

  // * អនុវត្តការបង្កើត front desk
  void on_create() async {
    // * ផ្ញើសំណើបង្កើត front desk
    setState(() => is_loading = true);
    tmp = await dio.post(
      endpoint.FRONT_DESK_CRUD_CREATE, //
      data: {
        Front_Desk.ROOM_ID: room_id, //
        Front_Desk.GUEST_ID: guest_id, //
        Front_Desk.CHECK_IN_NUMBER: check_in_number, //
        Front_Desk.CHECK_IN_DAY: check_in_day, //
        Front_Desk.CHECK_IN_HOUR: check_in_hour, //
        Front_Desk.CHECK_IN_NOTE: check_in_note, //
        Front_Desk.CANCEL_NOTE: cancel_note, //
        Front_Desk.CHECK_OUT_NOTE: check_out_note, //
        Front_Desk.CLEAN_NOTE: clean_note, //
        Front_Desk.BROKE_NOTE: broke_note, //
        Front_Desk.FIX_NOTE: fix_note, //
      },
    );
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.FRONT_DESK_CRUD_CREATE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, tmp.data[0]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័របង្កើត front desk
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
