// * OK
// * ទំព័រ Cancel សម្រាប់បោះបង់ការស្នាក់នៅរបស់ភ្ញៀវ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

import "package:speanmeas/core/schema/room.g.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";

import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

// * បង្កើត layout មេរបស់ទំព័រ cancel
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Cancel"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បោះបង់ការស្នាក់នៅ
class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic map_r;
  dynamic map_fd;
  bool is_loading = true;
  bool is_submitting = false;

  double? pay_cash;
  double? pay_bank;
  double? pay_return;

  String? front_desk_id;
  String? room_number;
  String? note;

  double? last_paid;

  DateTime? check_in_at;

  double? cancel_price;

  String? room_status;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និង front desk ពី server
  void init() async {
    try {
      // * អានព័ត៌មានបន្ទប់តាម id
      tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
      map_r = tmp.data[0] as Map<String, dynamic>;

      if (map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID] == null) throw Exception("Front desk ID is null");

      // * អានព័ត៌មាន front desk របស់បន្ទប់
      tmp = await dio.post(endpoint.FRONT_DESK_CRUD_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
      map_fd = tmp.data[0] as Map<String, dynamic>;

      front_desk_id = map_fd[sm_front_desk.ID];
      room_number = map_r[sm_room.NUMBER];

      // * គណនាចំនួនទឹកប្រាក់ដែលបានបង់រួច
      tmp = map_fd[sm_front_desk.PAY_ROOM] as List<dynamic>? ?? [];
      for (var l in tmp) {
        last_paid = (last_paid ?? 0) + (double.tryParse(l["pay_cash"].toString()) ?? 0);
        last_paid = (last_paid ?? 0) + (double.tryParse(l["pay_bank"].toString()) ?? 0);
        last_paid = (last_paid ?? 0) - (double.tryParse(l["pay_return"].toString()) ?? 0);
      }

      note = map_fd[sm_front_desk.CANCEL_NOTE]?.toString() ?? "";

      check_in_at = map_fd[sm_front_desk.CHECK_IN_AT] != null ? DateTime.tryParse(map_fd[sm_front_desk.CHECK_IN_AT].toString()) : null;

      room_status = "Available";

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
      is_loading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញលេខបន្ទប់
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${t("Room")}: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            room_number ?? t("Unknown"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Divider(height: 1, color: Colors.black),

      // * បញ្ចូលតម្លៃបោះបង់
      Input_Number(
        init: cancel_price, //
        lead: '${t("Cancel Price")}:', //
        onChanged: (v) {
          cancel_price = v;
          setState(() {});
        },
      ),

      // * បង្ហាញការទូទាត់ចុងក្រោយ
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('${t("Last Payment")}: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            "${last_paid?.toStringAsFixed(2) ?? '0.00'} \$",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      // * បញ្ចូលការទូទាត់ជាសាច់ប្រាក់
      Input_Number(
        init: pay_cash, //
        lead: '${t("Cash Payment")}:', //
        prefixIcon: Icons.payments_outlined, //
        onChanged: (v) {
          pay_cash = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលការទូទាត់តាមធនាគារ
      Input_Number(
        init: pay_bank, //
        lead: '${t("Bank Payment")}:', //
        prefixIcon: Icons.account_balance_outlined, //
        onChanged: (v) {
          pay_bank = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលប្រាក់អាប់
      Input_Number(
        init: pay_return, //
        lead: '${t("Return")}:', //
        prefixIcon: Icons.currency_exchange_outlined, //
        onChanged: (v) {
          pay_return = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសស្ថានភាពបន្ទប់បន្ទាប់ពីបោះបង់
      Select_Dynamic(
        lead: '${t("Room Status")}:', //
        init: room_status, //
        options: ["Available", "Pending Clean"], //
        prefixIcon: Icons.calendar_month_outlined, //
        onChanged: (v) {
          room_status = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលហេតុផល
      Input_Text(
        init: note, //
        lead: '${t("Reason")}:', //
        maxLines: 4,
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      Divider(height: 1, color: Colors.black),

      // * បង្ហាញចំនួនសមតុល្យ
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('${t("Balanced")}: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            "${balanced.toStringAsFixed(2)} \$",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold, //
              color: balanced == 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),

      // * ព័ត៌មានអំពីការកំណត់ពេលបោះបង់
      Row(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue),
          Text(
            t("You can't cancel within 1 hour after check-in."), //
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),

      // * ប៊ូតុងបញ្ជូនបោះបង់
      OutlinedButton.icon(
        icon: Icon(Icons.cancel_outlined), //
        label: Text(is_submitting ? t("Cancelling...") : t("Cancel")), //
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red), //
        onPressed: (can_cancel && !is_submitting) ? on_cancel : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * ពិនិត្យថាអាចបោះបង់បានឬអត់
  bool get can_cancel {
    if (balanced != 0) return false;
    // * Client-side 1-hour rule: cannot cancel within 1 hour after check-in
    // * ក្បួន 1 ម៉ោង៖ មិនអាចបោះបង់ក្នុងរយៈពេល 1 ម៉ោងបន្ទាប់ពី check in
    if (check_in_at != null && DateTime.now().difference(check_in_at!).inMinutes < 60) return false;
    return true;
  }

  // * គណនាសមតុល្យសរុប
  double get balanced {
    double temp = 0;

    temp = temp + (last_paid ?? 0);
    temp = temp + (pay_cash ?? 0);
    temp = temp + (pay_bank ?? 0);
    temp = temp - (pay_return ?? 0);
    temp = temp - (cancel_price ?? 0);

    return temp;
  }

  // * អនុវត្តការបោះបង់ការស្នាក់នៅ
  void on_cancel() async {
    if (is_submitting) return; // double-submit guard
    is_submitting = true;
    setState(() {});

    try {
      // * កត់ត្រាការបោះបង់ទៅ front desk
      await dio.post(
        endpoint.FRONT_DESK_CANCEL,
        data: {
          sm_front_desk.ID: front_desk_id, //
          sm_front_desk.CANCEL_NOTE: note, //
        },
      );

      // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់
      if (room_status == "Available") {
        await dio.post(
          endpoint.ROOM_CRUD_UPDATE, //
          data: {
            sm_room.ID: widget.room_id, //
            sm_room.STATUS: room_status, //
            sm_room.FRONT_DESK_ID: null, //
          },
        );
      } else if (room_status == "Pending Clean") {
        await dio.post(
          endpoint.ROOM_CRUD_UPDATE, //
          data: {
            sm_room.ID: widget.room_id, //
            sm_room.STATUS: room_status, //
          },
        );
      }

      Navigator.pop(context, true);
      snackbar(ct: context, ms: t("Success"), cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: t("Your can't cancel within 1 hour after check-in."), cl: Colors.red);
    } finally {
      is_submitting = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

//
// * ថ្នាក់ Main_ ជាទំព័របោះបង់ការស្នាក់នៅ
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
