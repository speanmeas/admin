// TODO: add more details here
// * ទំព័រ Detail សម្រាប់បង្ហាញព័ត៌មានលម្អិតនៃការស្នាក់នៅ

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * បង្កើត layout មេរបស់ទំព័រលម្អិត
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Detail"), //
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
            // spacing: 8,
            children: children, //
          ),
        ),
      ),
    ),
  );
}

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងការបង្ហាញព័ត៌មានលម្អិត
class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic map_raw;
  Room? map_room;
  bool is_loading = true;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និង front desk ពី server
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {Room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_raw = tmp.data[0] as Map<String, dynamic>;
    map_room = Room.fromJson(tmp.data[0]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញព័ត៌មានបន្ទប់ និងតម្លៃ
      (() {
        String room_number = map_room?.number ?? "";
        String room_type = map_room?.kind ?? "";
        tmp = map_room?.usd_per_day ?? 0;
        String price_per_day = tmp.toStringAsFixed(2);
        tmp = map_room?.usd_per_3h ?? 0;
        String price_per_3hours = tmp.toStringAsFixed(2);
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.hotel_outlined),
              Text('${t("Room")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.circle, size: 6),
              Text(room_number, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(room_type, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text("$price_per_day \$ / ${t("Day")}", style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text("$price_per_3hours \$ / ${t("Hour")}", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញព័ត៌មានភ្ញៀវ
      (() {
        String name = map_room?.front_desk_id?.guest_id?.full_name ?? "N/A";
        String gender = map_room?.front_desk_id?.guest_id?.gender ?? "N/A";
        String phone_number = map_room?.front_desk_id?.guest_id?.phone_number ?? "N/A";
        String nationality = map_raw?[Room.FRONT_DESK_ID]?[Front_Desk.GUEST_ID]?[Guest.NATIONALITY_ID]?[Nationality_Show.NAME]?.toString() ?? "N/A";
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.person_outline),
              Text('${t("Guest")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.circle, size: 6),
              Text(t("Name")),
              Text(name, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("Gender")),
              Text(gender, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("Phone Number")),
              Text(phone_number, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("Nationality")),
              Text(nationality, style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញព័ត៌មានការស្នាក់នៅ
      (() {
        String day = map_room?.front_desk_id?.check_in_day?.toString() ?? "";
        String hour = map_room?.front_desk_id?.check_in_hour?.toString() ?? "";
        String number_of_guest = map_room?.front_desk_id?.check_in_number?.toString() ?? "";
        String due = "";
        if (map_room?.front_desk_id?.check_in_due != null) {
          tmp = DateTime.tryParse(map_room?.front_desk_id?.check_in_due?.toString() ?? "");
          due = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp) : "";
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.access_time_outlined),
              Text('${t("Stay")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.circle, size: 6),
              Text("$day ${t("days")}", style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text("$hour ${t("hours")}", style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text("$number_of_guest ${t("guests")}", style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("Due to")),
              Text("$due", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញតម្លៃបន្ទប់សរុប
      (() {
        String value = "0.00";
        final pay_room = map_room?.front_desk_id?.pay_room ?? [];
        double total = 0;
        for (var l in pay_room) {
          total = total + (l.add_price ?? 0);
          total = total - (l.sub_price ?? 0);
        }
        value = total.toStringAsFixed(2);
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.attach_money_outlined),
              Text('${t("Room Price")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text("$value \$", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញប្រវត្តិការទូទាត់បន្ទប់នីមួយៗ
      for (var m in map_room?.front_desk_id?.pay_room ?? [])
        (() {
          String dt = "";
          tmp = DateTime.tryParse(m.created_at?.toString() ?? "");
          if (tmp != null) dt = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
          tmp = m.add_cash ?? 0;
          String cash = tmp.toStringAsFixed(2);
          tmp = m.add_bank ?? 0;
          String bank = tmp.toStringAsFixed(2);
          tmp = m.sub_return ?? 0;
          String change = tmp.toStringAsFixed(2);
          if (cash == "0.00" && bank == "0.00" && change == "0.00") return SizedBox.shrink();
          return Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("$dt:", style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.circle, size: 6),
                Text(t("Cash")),
                Text("$cash \$", style: TextStyle(color: Colors.blue)),
                Icon(Icons.circle, size: 6),
                Text(t("Bank")),
                Text("$bank \$", style: TextStyle(color: Colors.blue)),
                Icon(Icons.circle, size: 6),
                Text(t("Return")),
                Text("$change \$", style: TextStyle(color: Colors.blue)),
              ],
            ),
          );
        })(),

      // * បង្ហាញតម្លៃផ្សេងៗសរុប
      (() {
        String value = "0.00";
        final pay_other = map_room?.front_desk_id?.pay_other ?? [];
        double total = 0;
        for (var l in pay_other) {
          total = total + (l.add_price ?? 0);
          total = total - (l.sub_price ?? 0);
        }
        value = total.toStringAsFixed(2);
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.attach_money_outlined),
              Text('${t("Other Price")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text("$value \$", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញប្រវត្តិការទូទាត់ផ្សេងៗនីមួយៗ
      for (var m in map_room?.front_desk_id?.pay_other ?? [])
        (() {
          String dt = "";
          tmp = DateTime.tryParse(m.created_at?.toString() ?? "");
          if (tmp != null) dt = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
          tmp = m.add_cash ?? 0;
          String cash = tmp.toStringAsFixed(2);
          tmp = m.add_bank ?? 0;
          String bank = tmp.toStringAsFixed(2);
          tmp = m.sub_return ?? 0;
          String change = tmp.toStringAsFixed(2);
          return Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("$dt:", style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.circle, size: 6),
                Text(t("Cash")),
                Text("$cash \$", style: TextStyle(color: Colors.blue)),
                Icon(Icons.circle, size: 6),
                Text(t("Bank")),
                Text("$bank \$", style: TextStyle(color: Colors.blue)),
                Icon(Icons.circle, size: 6),
                Text(t("Return")),
                Text("$change \$", style: TextStyle(color: Colors.blue)),
              ],
            ),
          );
        })(),

      // * បង្ហាញព័ត៌មាន check in
      (() {
        String note = map_room?.front_desk_id?.check_in_note ?? "N/A";
        String by = map_room?.front_desk_id?.check_in_by?.full_name ?? "N/A";
        String at = "";
        if (map_room?.front_desk_id?.check_in_at != null) {
          tmp = DateTime.tryParse(map_room?.front_desk_id?.check_in_at?.toString() ?? "");
          at = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp) : "";
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.login_outlined),
              Text('${t("Check In")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.circle, size: 6),
              Text(t("Note")),
              Text(note, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("By")),
              Text(by, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("At")),
              Text(at, style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញព័ត៌មាន check out
      (() {
        String note = map_room?.front_desk_id?.check_out_note ?? "N/A";
        String by = map_room?.front_desk_id?.check_out_by?.full_name ?? "N/A";
        String at = "";
        if (map_room?.front_desk_id?.check_out_at != null) {
          tmp = DateTime.tryParse(map_room?.front_desk_id?.check_out_at?.toString() ?? "");
          at = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp) : "";
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.logout_outlined),
              Text('${t("Check Out")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.circle, size: 6),
              Text(t("Note")),
              Text(note, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("By")),
              Text(by, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("At")),
              Text(at, style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញព័ត៌មានការសម្អាត
      (() {
        String note = map_room?.front_desk_id?.clean_note ?? "N/A";
        String by = map_room?.front_desk_id?.clean_by?.full_name ?? "N/A";
        String at = "";
        if (map_room?.front_desk_id?.clean_at != null) {
          tmp = DateTime.tryParse(map_room?.front_desk_id?.clean_at?.toString() ?? "");
          at = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp) : "";
        }
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.cleaning_services_outlined),
              Text('${t("Clean")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.circle, size: 6),
              Text(t("Note")),
              Text(note, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("By")),
              Text(by, style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text(t("At")),
              Text(at, style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // TODO: add more details here

      //
      // * ប៊ូតុង OK ដើម្បីបិទទំព័រ
      OutlinedButton.icon(
        autofocus: true,
        label: Text(t("OK")),
        icon: Icon(Icons.check), //
        onPressed: () => Navigator.pop(context), //
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

// * ថ្នាក់ Main_ ជាទំព័របង្ហាញព័ត៌មានលម្អិត
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.room_id,
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
        home: Main_(
          room_id: "6a71dc186c013023294f6742", //
        ), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
