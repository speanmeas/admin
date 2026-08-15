// * OK
// * ទំព័រ Fix សម្រាប់កំណត់បន្ទប់ថាជួសជុលរួច

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

// * បង្កើត layout មេរបស់ទំព័រ fix
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Fix"), //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Column(
            spacing: 8,
            children: children, //
          ),
        ),
      ),
    ),
  );
}

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ជួសជុលបន្ទប់
class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic map_r;
  bool is_loading = true;

  String? note;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និង front desk ពី server
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_r = tmp.data[0] as Map<String, dynamic>;

    note = map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.FIX_NOTE]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញលេខបន្ទប់
      Text(
        '${t("Room")} ${map_r?[sm_room.NUMBER] ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      Divider(height: 1, color: Colors.black),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: '${t("Note")}:', //
        maxLines: 4,
        prefixIcon: Icons.note_alt_outlined, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងបញ្ជូនជួសជុល
      OutlinedButton.icon(
        autofocus: true,
        icon: Icon(Icons.build_outlined), //
        label: Text(t("Fix")), //
        onPressed: (is_loading) ? null : on_fix, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការជួសជុលបន្ទប់
  void on_fix() async {
    // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់ទៅ Available
    setState(() => is_loading = true);
    await dio.post(
      endpoint.ROOM_CRUD_UPDATE, //
      data: {
        sm_room.ID: widget.room_id, //
        sm_room.STATUS: "Available", //
        sm_room.FRONT_DESK_ID: null, //
      },
    );
    setState(() => is_loading = false);

    // * កត់ត្រាការជួសជុលទៅ front desk
    setState(() => is_loading = true);
    if (map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID] != null)
      await dio.post(
        endpoint.FRONT_DESK_FIX,
        data: {
          sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID], //
          sm_front_desk.FIX_NOTE: note, //
        },
      );
    setState(() => is_loading = false);

    snackbar(ct: context, ms: t("Success"), cl: Colors.green);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

//
// * ថ្នាក់ Main_ ជាទំព័រជួសជុលបន្ទប់
class Main_ extends StatefulWidget {
  const Main_({
    super.key,
    this.room_id, //
  });

  final String? room_id;

  @override
  State<Main_> createState() => _Main_State();
}

//
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
        home: Main_(
          room_id: "6a6ec9d7599d64fa5d293fb9", //
        ), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
