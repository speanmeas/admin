// * ទំព័រកែប្រែព័ត៌មានបន្ទប់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/parse.dart";
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "../widget/kind_select.dart" as k_select;
import "../widget/status_select.dart" as s_select;
import "package:speanmeas/core/schema/room.g.dart";
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

  // * ផ្ទុកព័ត៌មានបន្ទប់បច្ចុប្បន្ន
  void init() async {
    // * អានទិន្នន័យបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_CRUD_READ_ID}", cl: Colors.red);
    if (tmp.data.isEmpty) return snackbar(ct: context, ms: "No data found.", cl: Colors.red);

    number = parse_string(tmp.data[0][sm_room.NUMBER]);
    usd_per_day = parse_double(tmp.data[0][sm_room.USD_PER_DAY]);
    usd_per_3h = parse_double(tmp.data[0][sm_room.USD_PER_3H]);
    kind = parse_string(tmp.data[0][sm_room.KIND]);
    status = parse_string(tmp.data[0][sm_room.STATUS]);
    note = parse_string(tmp.data[0][sm_room.NOTE]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
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
          note = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងកែប្រែ
      OutlinedButton.icon(
        icon: Icon(Icons.check),
        label: Text("Update"),
        style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
        onPressed: is_loading ? null : on_update,
      ),
      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការកែប្រែបន្ទប់
  void on_update() async {
    // * ផ្ញើសំណើកែប្រែបន្ទប់
    setState(() => is_loading = true);
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
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_CRUD_UPDATE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, tmp.data[0]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
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
