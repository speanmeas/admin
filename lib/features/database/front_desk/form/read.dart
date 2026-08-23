// * ទំព័រអានព័ត៌មាន front desk

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/widget/show/show_number.dart";
import "package:speanmeas/core/widget/show/show_datetime.dart";

// * បង្កើត layout មេរបស់ទំព័រអានព័ត៌មាន front desk
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការអានព័ត៌មាន front desk
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;

  Front_Desk? f;

  // * ផ្ទុកព័ត៌មាន front desk តាម id
  void init() async {
    // * អានទិន្នន័យ front desk តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {Front_Desk.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.FRONT_DESK_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    f = Front_Desk.fromJson(tmp.data[0]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញបន្ទប់
      Show_Text(
        prefixIcon: Icons.meeting_room_outlined,
        lead: "Room:", //
        value: "${f?.room_id?.number ?? ""} (${f?.room_id?.kind ?? ""})",
      ),

      // * បង្ហាញភ្ញៀវ
      Show_Text(
        prefixIcon: Icons.person_outline,
        lead: "Guest:", //
        value: f?.guest_id?.full_name ?? "",
      ),

      // * បង្ហាញលេខទូរស័ព្ទភ្ញៀវ
      Show_Text(
        prefixIcon: Icons.phone_outlined,
        lead: "Phone:", //
        value: f?.guest_id?.phone_number ?? "",
      ),

      // * បង្ហាញចំនួនភ្ញៀវ
      Show_Number(
        prefixIcon: Icons.people_outline,
        leading: "Number of Guests:", //
        value: f?.check_in_number,
      ),

      // * បង្ហាញថ្ងៃស្នាក់នៅ
      Show_Number(
        prefixIcon: Icons.calendar_month_outlined,
        leading: "Stay Days:", //
        value: f?.check_in_day,
      ),

      // * បង្ហាញម៉ោងស្នាក់នៅ
      Show_Number(
        prefixIcon: Icons.access_time_outlined,
        leading: "Stay Hours:", //
        value: f?.check_in_hour,
      ),

      // * បង្ហាញថ្ងៃកំណត់ check out
      Show_Datetime(
        prefixIcon: Icons.event_outlined,
        leading: "Due:", //
        value: f?.check_in_due,
      ),

      // * បង្ហាញពេល check in
      Show_Datetime(
        prefixIcon: Icons.login_outlined,
        leading: "Check In At:", //
        value: f?.check_in_at,
      ),

      // * បង្ហាញកំណត់ចំណាំ check in
      Show_Text(
        prefixIcon: Icons.note_alt_outlined,
        lead: "Check In Note:", //
        value: f?.check_in_note,
        maxLines: 2,
      ),

      // * បង្ហាញកំណត់ចំណាំបោះបង់
      Show_Text(
        prefixIcon: Icons.cancel_outlined,
        lead: "Cancel Note:", //
        value: f?.cancel_note,
        maxLines: 2,
      ),

      // * បង្ហាញពេលបោះបង់
      Show_Datetime(
        prefixIcon: Icons.cancel_outlined,
        leading: "Cancel At:", //
        value: f?.cancel_at,
      ),

      // * បង្ហាញកំណត់ចំណាំ check out
      Show_Text(
        prefixIcon: Icons.logout_outlined,
        lead: "Check Out Note:", //
        value: f?.check_out_note,
        maxLines: 2,
      ),

      // * បង្ហាញពេល check out
      Show_Datetime(
        prefixIcon: Icons.logout_outlined,
        leading: "Check Out At:", //
        value: f?.check_out_at,
      ),

      // * បង្ហាញកំណត់ចំណាំសម្អាត
      Show_Text(
        prefixIcon: Icons.cleaning_services_outlined,
        lead: "Clean Note:", //
        value: f?.clean_note,
        maxLines: 2,
      ),

      // * បង្ហាញកំណត់ចំណាំខូចខាត
      Show_Text(
        prefixIcon: Icons.error_outline,
        lead: "Broke Note:", //
        value: f?.broke_note,
        maxLines: 2,
      ),

      // * បង្ហាញកំណត់ចំណាំជួសជុល
      Show_Text(
        prefixIcon: Icons.build_outlined,
        lead: "Fix Note:", //
        value: f?.fix_note,
        maxLines: 2,
      ),

      // * បង្ហាញពេលបង្កើត
      Show_Datetime(
        prefixIcon: Icons.create_outlined,
        leading: "Created At:", //
        value: f?.created_at,
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

// * ថ្នាក់ Main_ ជាទំព័រអានព័ត៌មាន front desk
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
