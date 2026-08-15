// * ទំព័រ Change Room សម្រាប់ប្តូរបន្ទប់របស់ភ្ញៀវ

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
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

// * បង្កើត layout មេរបស់ទំព័រប្តូរបន្ទប់
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Change Room"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ប្តូរបន្ទប់
class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic map_r;
  bool is_loading = true;

  String? to_room_number;
  String? change_note;

  String? to_room_id; // * សម្រាប់រក្សា ID បន្ទប់ថ្មី

  dynamic list_r = []; // * សម្រាប់រក្សាពត៏មានបន្ទប់ទាំងអស់

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងបញ្ជីបន្ទប់ទំនេរ
  void init() async {
    // * អានព័ត៌មានបន្ទប់បច្ចុប្បន្ន
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_r = tmp.data[0] as Map<String, dynamic>;

    // * អានបញ្ជីបន្ទប់ទាំងអស់
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ);
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ}"), cl: Colors.red);

    list_r = tmp.data as List<dynamic>;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញលេខបន្ទប់បច្ចុប្បន្ន
      Text(
        '${t("Room")} ${map_r?[sm_room.NUMBER] ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      Divider(height: 1, color: Colors.black),

      // * ជ្រើសរើសលេខបន្ទប់ថ្មីដែលទំនេរ
      Select_Dynamic(
        lead: '${t("New Room Number")}:', //
        prefixIcon: Icons.hotel_outlined, //
        options: (() {
          var options = [];
          for (var r in list_r) {
            if (r[sm_room.STATUS] == "Available") {
              options.add(r[sm_room.NUMBER]?.toString() ?? "");
            }
          }
          return options;
        })(),
        onChanged: (v) {
          to_room_number = v;

          // * ស្វែងរក id នៃបន្ទប់ថ្មីដែលបានជ្រើសរើស
          for (var r in list_r) {
            if (r[sm_room.NUMBER]?.toString() == v) {
              to_room_id = r[sm_room.ID]?.toString();
              break;
            }
          }

          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: change_note, //
        lead: '${t("Note")}:', //
        maxLines: 4,
        onChanged: (v) {
          change_note = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងបញ្ជូនការប្តូរបន្ទប់
      OutlinedButton.icon(
        icon: Icon(Icons.swap_horiz_outlined), //
        label: Text(t("Change")), //
        onPressed: (can_change) ? on_change_room : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * ពិនិត្យថាអាចប្តូរបន្ទប់បានឬអត់
  bool get can_change {
    if (to_room_id == null || to_room_id!.isEmpty) return false;
    return true;
  }

  // * អនុវត្តការប្តូរបន្ទប់
  void on_change_room() async {
    // * ដោះលែងបន្ទប់ចាស់
    setState(() => is_loading = true);
    await dio.post(
      endpoint.ROOM_CRUD_UPDATE, //
      data: {
        sm_room.ID: widget.room_id, //
        sm_room.STATUS: "Pending Clean", //
        sm_room.FRONT_DESK_ID: null, //
      },
    );
    setState(() => is_loading = false);

    // * កំណត់បន្ទប់ថ្មីជាបន្ទប់កំពុងស្នាក់នៅ
    setState(() => is_loading = true);
    await dio.post(
      endpoint.ROOM_CRUD_UPDATE, //
      data: {
        sm_room.ID: to_room_id, //
        sm_room.STATUS: "Pending Pay", //
        sm_room.FRONT_DESK_ID: map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID], //
      },
    );
    setState(() => is_loading = false);

    // * ធ្វើបច្ចុប្បន្នភាព front desk ទៅបន្ទប់ថ្មី
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_CHANGE_ROOM,
      data: {
        sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID], //
        sm_front_desk.ROOM_ID: to_room_id, //
        sm_front_desk.CHANGE_NOTE: change_note, //
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
}

// * ថ្នាក់ Main_ ជាទំព័រប្តូរបន្ទប់
class Main_ extends StatefulWidget {
  const Main_({
    super.key,
    this.room_id, //
  });

  final String? room_id;

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
