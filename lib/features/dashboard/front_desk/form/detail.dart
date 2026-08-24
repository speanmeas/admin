// * ទំព័រ Detail សម្រាប់បង្ហាញព័ត៌មានលម្អិតនៃការស្នាក់នៅ

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";
import "../helper.dart";

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
  Front_Desk? map_fd;
  Guest? map_guest;
  bool is_loading = true;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និង front desk ពី server
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_READ_ID, data: {Room.ID: widget.room_id});
    if (tmp == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_READ_ID}"), cl: Colors.red);
    }

    map_raw = tmp.data[0] as Map<String, dynamic>;
    map_room = Room.fromJson(tmp.data[0]);

    // * រក stay សកម្មរបស់បន្ទប់
    final fds = await load_fds();
    map_fd = active_fd(fds, widget.room_id);

    // * អានភ្ញៀវពេញលេញ (សម្រាប់ nationality)
    final guest_id = map_fd?.guest_id?.id;
    if (guest_id != null) {
      tmp = await dio.post(endpoint.GUEST_READ_ID, data: {Guest.ID: guest_id});
      if (tmp != null && (tmp.data as List?)?.isNotEmpty == true) map_guest = Guest.fromJson((tmp.data as List).first);
    }

    setState(() => is_loading = false);
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
        String price_per_day = (map_room?.price_per_day ?? 0).toStringAsFixed(2);
        String price_per_3hours = (map_room?.price_per_3h ?? 0).toStringAsFixed(2);
        return Column(
          children: [
            Row(
              children: [
                Icon(Icons.hotel_outlined),
                SizedBox(width: 4),
                Text("${t("Room Information")}:", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Number")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(room_number, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Type")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(room_type, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Price / Day")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text("$price_per_day \$", style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Price / 3H")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text("$price_per_3hours \$", style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        );
      })(),

      // * បង្ហាញព័ត៌មានភ្ញៀវ
      (() {
        String name = map_fd?.guest_id?.full_name ?? "N/A";
        String gender = map_fd?.guest_id?.gender ?? "N/A";
        String phone_number = map_fd?.guest_id?.phone_number ?? "N/A";
        String nationality = map_guest?.nationality_id?.name ?? "N/A";
        return Column(
          children: [
            Row(
              children: [
                Icon(Icons.person_outline),
                SizedBox(width: 4),
                Text("${t("Guest Information")}:", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Name")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(name, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Gender")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(gender, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Phone Number")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(phone_number, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Nationality")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(nationality, style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        );
      })(),

      // * បង្ហាញព័ត៌មានការស្នាក់នៅ
      (() {
        String day = map_fd?.check_in_day?.toString() ?? "";
        String hour = map_fd?.check_in_hour?.toString() ?? "";
        String number_of_guest = map_fd?.check_in_number?.toString() ?? "";
        String due = "";
        if (map_fd?.check_in_due != null) {
          tmp = DateTime.tryParse(map_fd?.check_in_due?.toString() ?? "");
          due = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp) : "";
        }
        return Column(
          children: [
            Row(
              children: [
                Icon(Icons.access_time_outlined),
                SizedBox(width: 4),
                Text("${t("Stay")}:", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("Duration:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text("$day days $hour hours", style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("Number of Guests:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text("$number_of_guest persons", style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Due Date")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text("$due", style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        );
      })(),

      // * បង្ហាញតម្លៃបន្ទប់សរុប
      (() {
        final value = price_of(map_fd?.room_pay_id).toStringAsFixed(2);
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

      // * បង្ហាញការទូទាត់បន្ទប់
      (() {
        final pay = map_fd?.room_pay_id;
        String dt = "";
        tmp = DateTime.tryParse(pay?.created_at?.toString() ?? "");
        if (tmp != null) dt = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
        String cash = paid_of(pay).toStringAsFixed(2);
        if (cash == "0.00") return SizedBox.shrink();
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
              Text(t("Paid")),
              Text("$cash \$", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញតម្លៃ mini bar សរុប
      (() {
        final value = price_of(map_fd?.mini_bar_pay_id).toStringAsFixed(2);
        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.attach_money_outlined),
              Text('${t("Mini Bar Price")}:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text("$value \$", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញការទូទាត់ mini bar
      (() {
        final pay = map_fd?.mini_bar_pay_id;
        String dt = "";
        tmp = DateTime.tryParse(pay?.created_at?.toString() ?? "");
        if (tmp != null) dt = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
        String cash = paid_of(pay).toStringAsFixed(2);
        if (cash == "0.00") return SizedBox.shrink();
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
              Text(t("Paid")),
              Text("$cash \$", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញតម្លៃផ្សេងៗសរុប
      (() {
        final value = price_of(map_fd?.penalty_pay_id).toStringAsFixed(2);
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

      // * បង្ហាញការទូទាត់ផ្សេងៗ
      (() {
        final pay = map_fd?.penalty_pay_id;
        String dt = "";
        tmp = DateTime.tryParse(pay?.created_at?.toString() ?? "");
        if (tmp != null) dt = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
        String cash = paid_of(pay).toStringAsFixed(2);
        if (cash == "0.00") return SizedBox.shrink();
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
              Text(t("Paid")),
              Text("$cash \$", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      // * បង្ហាញព័ត៌មាន check in
      (() {
        String note = map_fd?.check_in_note ?? "N/A";
        String by = map_fd?.check_in_by?.full_name ?? "N/A";
        String at = "";
        if (map_fd?.check_in_at != null) {
          tmp = DateTime.tryParse(map_fd?.check_in_at?.toString() ?? "");
          at = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp) : "";
        }
        return Column(
          children: [
            Row(
              children: [
                Icon(Icons.login_outlined),
                SizedBox(width: 4),
                Text("${t("Check In")}:", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Note")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(note, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Checked In By")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(by, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Checked In At")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(at, style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        );
      })(),

      // * បង្ហាញព័ត៌មាន check out
      (() {
        String note = map_fd?.check_out_note ?? "N/A";
        String by = map_fd?.check_out_by?.full_name ?? "N/A";
        String at = "";
        if (map_fd?.check_out_at != null) {
          tmp = DateTime.tryParse(map_fd?.check_out_at?.toString() ?? "");
          at = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp) : "";
        }
        return Column(
          children: [
            Row(
              children: [
                Icon(Icons.logout_outlined),
                SizedBox(width: 4),
                Text("${t("Check Out")}:", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Note")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(note, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Checked Out By")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(by, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Checked Out At")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(at, style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        );
      })(),

      // * បង្ហាញព័ត៌មានការសម្អាត
      (() {
        String note = map_fd?.clean_note ?? "N/A";
        String by = map_fd?.clean_by?.full_name ?? "N/A";
        String at = "";
        if (map_fd?.clean_at != null) {
          tmp = DateTime.tryParse(map_fd?.clean_at?.toString() ?? "");
          at = tmp != null ? DateFormat(DEFAULT_DATE_FORMAT).format(tmp) : "";
        }
        return Column(
          children: [
            Row(
              children: [
                Icon(Icons.cleaning_services_outlined),
                SizedBox(width: 4),
                Text("${t("Clean")}:", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Note")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(note, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Cleaned By")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(by, style: TextStyle(color: Colors.blue)),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.arrow_right),
                Text("${t("Cleaned At")}:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(at, style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        );
      })(),

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
