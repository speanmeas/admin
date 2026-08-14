// TODO: add more details here

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/nationality.g.dart";
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

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

class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic map_r;
  dynamic map_fd;
  bool is_loading = true;

  void init() async {
    try {
      tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
      map_r = tmp.data[0] as Map<String, dynamic>;
      // pprint(map_r);

      if (map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID] == null) throw Exception("Front desk ID is null");

      tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
      map_fd = tmp.data[0] as Map<String, dynamic>;
      pprint(map_fd);

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      (() {
        String room_number = map_fd?[sm_front_desk.ROOM_ID]?[sm_room.NUMBER]?.toString() ?? "";
        String room_type = map_fd?[sm_front_desk.ROOM_ID]?[sm_room.KIND]?.toString() ?? "";
        tmp = double.tryParse(map_fd?[sm_front_desk.ROOM_ID]?[sm_room.USD_PER_DAY]?.toString() ?? "0") ?? 0;
        String price_per_day = tmp.toStringAsFixed(2);
        tmp = double.tryParse(map_fd?[sm_front_desk.ROOM_ID]?[sm_room.USD_PER_3H]?.toString() ?? "0") ?? 0;
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
              Text("$price_per_day \$ / Day", style: TextStyle(color: Colors.blue)),
              Icon(Icons.circle, size: 6),
              Text("$price_per_3hours \$ / 3H", style: TextStyle(color: Colors.blue)),
            ],
          ),
        );
      })(),

      (() {
        String name = map_fd?[sm_front_desk.GUEST_ID]?[sm_guest.FULL_NAME]?.toString() ?? "N/A";
        String gender = map_fd?[sm_front_desk.GUEST_ID]?[sm_guest.GENDER]?.toString() ?? "N/A";
        String phone_number = map_fd?[sm_front_desk.GUEST_ID]?[sm_guest.PHONE_NUMBER]?.toString() ?? "N/A";
        String nationality = map_fd?[sm_front_desk.GUEST_ID]?[sm_guest.NATIONALITY_ID]?[sm_nationality.NAME]?.toString() ?? "N/A";
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

      (() {
        String day = map_fd?[sm_front_desk.CHECK_IN_DAY]?.toString() ?? "";
        String hour = map_fd?[sm_front_desk.CHECK_IN_HOUR]?.toString() ?? "";
        String number_of_guest = map_fd?[sm_front_desk.CHECK_IN_NUMBER]?.toString() ?? "";
        String due = "";
        if (map_fd?[sm_front_desk.CHECK_IN_DUE] != null) {
          tmp = DateTime.tryParse(map_fd?[sm_front_desk.CHECK_IN_DUE]?.toString() ?? "");
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

      (() {
        String value = "0.00";
        final pay_room = map_fd?[sm_front_desk.PAY_ROOM] as List<dynamic>? ?? [];
        if (pay_room.isNotEmpty) {
          tmp = double.tryParse(pay_room.last["pay_price"]?.toString() ?? "0") ?? 0;
          value = tmp.toStringAsFixed(2);
        }
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

      for (var m in map_fd?[sm_front_desk.PAY_ROOM] as List<dynamic>? ?? [])
        (() {
          String dt = "";
          tmp = DateTime.tryParse(m["pay_at"]?.toString() ?? "");
          if (tmp != null) dt = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
          tmp = double.tryParse(m["pay_cash"]?.toString() ?? "0") ?? 0;
          String cash = tmp.toStringAsFixed(2);
          tmp = double.tryParse(m["pay_bank"]?.toString() ?? "0") ?? 0;
          String bank = tmp.toStringAsFixed(2);
          tmp = double.tryParse(m["pay_return"]?.toString() ?? "0") ?? 0;
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

      (() {
        String value = "0.00";
        final pay_other = map_fd?[sm_front_desk.PAY_OTHER] as List<dynamic>? ?? [];
        if (pay_other.isNotEmpty) {
          tmp = double.tryParse(pay_other.last["pay_price"]?.toString() ?? "0") ?? 0;
          value = tmp.toStringAsFixed(2);
        }
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

      for (var m in map_fd?[sm_front_desk.PAY_OTHER] as List<dynamic>? ?? [])
        (() {
          String dt = "";
          tmp = DateTime.tryParse(m["pay_at"]?.toString() ?? "");
          if (tmp != null) dt = DateFormat(DEFAULT_DATE_FORMAT).format(tmp);
          tmp = double.tryParse(m["pay_cash"]?.toString() ?? "0") ?? 0;
          String cash = tmp.toStringAsFixed(2);
          tmp = double.tryParse(m["pay_bank"]?.toString() ?? "0") ?? 0;
          String bank = tmp.toStringAsFixed(2);
          tmp = double.tryParse(m["pay_return"]?.toString() ?? "0") ?? 0;
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

      (() {
        String note = map_fd?[sm_front_desk.CHECK_IN_NOTE]?.toString() ?? "N/A";
        String by = map_fd?[sm_front_desk.CHECK_IN_BY]?[sm_user.FULL_NAME]?.toString() ?? "N/A";
        String at = "";
        if (map_fd?[sm_front_desk.CHECK_IN_AT] != null) {
          tmp = DateTime.tryParse(map_fd?[sm_front_desk.CHECK_IN_AT]?.toString() ?? "");
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

      (() {
        String note = map_fd?[sm_front_desk.CHECK_OUT_NOTE]?.toString() ?? "N/A";
        String by = map_fd?[sm_front_desk.CHECK_OUT_BY]?[sm_user.FULL_NAME]?.toString() ?? "N/A";
        String at = "";
        if (map_fd?[sm_front_desk.CHECK_OUT_AT] != null) {
          tmp = DateTime.tryParse(map_fd?[sm_front_desk.CHECK_OUT_AT]?.toString() ?? "");
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

      (() {
        String note = map_fd?[sm_front_desk.CLEAN_NOTE]?.toString() ?? "N/A";
        String by = map_fd?[sm_front_desk.CLEAN_BY]?[sm_user.FULL_NAME]?.toString() ?? "N/A";
        String at = "";
        if (map_fd?[sm_front_desk.CLEAN_AT] != null) {
          tmp = DateTime.tryParse(map_fd?[sm_front_desk.CLEAN_AT]?.toString() ?? "");
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

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.room_id,
  });

  final String? room_id;

  @override
  State<Main_> createState() => _Main_State();
}

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
      child: Main_(
        room_id: "6a71dc186c013023294f6742", //
      ),
    ),
  );
}
