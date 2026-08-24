// * OK
// * ទំព័រ Update Guest សម្រាប់ធ្វើបច្ចុប្បន្នភាពភ្ញៀវរបស់បន្ទប់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/search/search_guest.dart";
import "../helper.dart";

// * បង្កើត layout មេរបស់ទំព័រធ្វើបច្ចុប្បន្នភាពភ្ញៀវ
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Update Guest"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ធ្វើបច្ចុប្បន្នភាពភ្ញៀវ
class _Main_State extends State<Main_> {
  dynamic tmp;
  Room? map_r;
  Front_Desk? map_fd;
  bool is_loading = true;

  String? guest_id;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងភ្ញៀវបច្ចុប្បន្ន
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_READ_ID, data: {Room.ID: widget.room_id});
    if (tmp == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_READ_ID}"), cl: Colors.red);
    }
    map_r = Room.fromJson(tmp.data[0]);

    // * រក stay សកម្មរបស់បន្ទប់
    final fds = await load_fds();
    map_fd = active_fd(fds, widget.room_id);

    guest_id = map_fd?.guest_id?.id?.toString();

    setState(() => is_loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញលេខបន្ទប់
      Text(
        '${t("Room")} ${map_r?.number ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      Divider(height: 1, color: Colors.black),

      // * ស្វែងរក និងជ្រើសរើសភ្ញៀវថ្មី
      Search_Guest(
        init: guest_id, //
        onChanged: (v) {
          guest_id = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងបញ្ជូនការធ្វើបច្ចុប្បន្នភាព
      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text(t("Update")), //
        onPressed: on_update, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * អនុវត្តការធ្វើបច្ចុប្បន្នភាពភ្ញៀវ
  void on_update() async {
    // * ធ្វើបច្ចុប្បន្នភាពភ្ញៀវរបស់ front desk
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_GUEST, //
      data: {
        Front_Desk.ID: map_fd?.id, //
        Front_Desk.GUEST_ID: guest_id,
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
// * ថ្នាក់ Main_ ជាទំព័រធ្វើបច្ចុប្បន្នភាពភ្ញៀវ
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
