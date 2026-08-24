// * ទំព័រ Change Room សម្រាប់ប្តូរបន្ទប់របស់ភ្ញៀវ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/enum/room_status.dart" as room_status;
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "../helper.dart";

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
  Room? map_r;
  Front_Desk? map_fd;
  bool is_loading = true;

  String? to_room_number;
  String? change_note;

  String? to_room_id; // * សម្រាប់រក្សា ID បន្ទប់ថ្មី

  List<Room> list_r = []; // * សម្រាប់រក្សាពត៏មានបន្ទប់ទាំងអស់

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងបញ្ជីបន្ទប់ទំនេរ
  void init() async {
    // * អានព័ត៌មានបន្ទប់បច្ចុប្បន្ន
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_READ_ID, data: {Room.ID: widget.room_id});
    if (tmp == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_READ_ID}"), cl: Colors.red);
    }
    map_r = Room.fromJson(tmp.data[0]);

    // * អានបញ្ជីបន្ទប់ទាំងអស់
    tmp = await dio.post(endpoint.ROOM_READ, data: {"key": Room.NUMBER, "order": 1});
    if (tmp == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_READ}"), cl: Colors.red);
    }

    list_r = List<Room>.from((tmp.data ?? const []).map((d) => Room.fromJson(d)));

    // * រក stay សកម្មរបស់បន្ទប់
    final fds = await load_fds();
    map_fd = active_fd(fds, widget.room_id);

    setState(() => is_loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញលេខបន្ទប់បច្ចុប្បន្ន
      Text(
        '${t("Room")} ${map_r?.number ?? "N/A"}', //
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
            if (r.status == room_status.AVAILABLE) {
              options.add(r.number?.toString() ?? "");
            }
          }
          return options;
        })(),
        onChanged: (v) {
          to_room_number = v;

          // * ស្វែងរក id នៃបន្ទប់ថ្មីដែលបានជ្រើសរើស
          for (var r in list_r) {
            if (r.number?.toString() == v) {
              to_room_id = r.id?.toString();
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
      endpoint.ROOM_UPDATE, //
      data: {
        Room.ID: widget.room_id, //
        Room.STATUS: room_status.PENDING_CLEAN, //
      },
    );
    setState(() => is_loading = false);

    // * កំណត់បន្ទប់ថ្មីជាបន្ទប់កំពុងស្នាក់នៅ
    setState(() => is_loading = true);
    await dio.post(
      endpoint.ROOM_UPDATE, //
      data: {
        Room.ID: to_room_id, //
        Room.STATUS: room_status.PENDING_PAY, //
      },
    );
    setState(() => is_loading = false);

    // * ធ្វើបច្ចុប្បន្នភាព front desk ទៅបន្ទប់ថ្មី
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_CHANGE_ROOM,
      data: {
        Front_Desk.ID: map_fd?.id, //
        Front_Desk.ROOM_ID: to_room_id, //
        Front_Desk.CHANGE_NOTE: change_note, //
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
