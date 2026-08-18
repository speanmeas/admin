// * OK
// * ទំព័រ Cancel សម្រាប់បោះបង់ការស្នាក់នៅរបស់ភ្ញៀវ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/enum/room_status.dart" as room_status;
import "package:speanmeas/core/utility/all.dart";

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
  Room? map_room;
  bool is_loading = true;

  double? add_cash;
  double? add_bank;
  double? sub_return;

  DateTime? check_in_at;
  double? last_paid;
  double? cancel_price;
  String? target_status;
  String? note;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និង front desk ពី server
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {Room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_room = Room.fromJson(tmp.data[0]);

    // * គណនាចំនួនទឹកប្រាក់ដែលបានបង់រួច
    final pay_room_list = map_room?.front_desk_id?.pay_room ?? [];
    for (var l in pay_room_list) {
      last_paid = (last_paid ?? 0) + (l.add_cash ?? 0);
      last_paid = (last_paid ?? 0) + (l.add_bank ?? 0);
      last_paid = (last_paid ?? 0) - (l.sub_return ?? 0);
    }

    note = map_room?.front_desk_id?.cancel_note ?? "";

    final tmp_check = DateTime.tryParse(map_room?.front_desk_id?.check_in_at?.toString() ?? "");
    check_in_at = tmp_check;

    target_status = room_status.AVAILABLE;

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
        '${t("Room")} ${map_room?.number ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        init: add_cash, //
        lead: '${t("Cash Payment")}:', //
        prefixIcon: Icons.payments_outlined, //
        onChanged: (v) {
          add_cash = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលការទូទាត់តាមធនាគារ
      Input_Number(
        init: add_bank, //
        lead: '${t("Bank Payment")}:', //
        prefixIcon: Icons.account_balance_outlined, //
        onChanged: (v) {
          add_bank = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលប្រាក់អាប់
      Input_Number(
        init: sub_return, //
        lead: '${t("Return")}:', //
        prefixIcon: Icons.currency_exchange_outlined, //
        onChanged: (v) {
          sub_return = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសស្ថានភាពបន្ទប់បន្ទាប់ពីបោះបង់
      Select_Dynamic(
        lead: '${t("Room Status")}:', //
        init: target_status, //
        options: [room_status.AVAILABLE, room_status.PENDING_CLEAN], //
        prefixIcon: Icons.calendar_month_outlined, //
        onChanged: (v) {
          target_status = v;
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
        label: Text(t("Cancel")), //
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red), //
        onPressed: (can_cancel) ? on_cancel : null, //
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
    temp = temp + (add_cash ?? 0);
    temp = temp + (add_bank ?? 0);
    temp = temp - (sub_return ?? 0);
    temp = temp - (cancel_price ?? 0);

    return temp;
  }

  // * អនុវត្តការបោះបង់ការស្នាក់នៅ
  void on_cancel() async {
    // * កត់ត្រាការបោះបង់ទៅ front desk
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_CANCEL,
      data: {
        Front_Desk.ID: map_room?.front_desk_id?.id, //
        Front_Desk.CANCEL_NOTE: note, //
      },
    );
    setState(() => is_loading = false);

    // * កត់ត្រាតម្លៃបោះបង់ និងការទូទាត់ទៅ pay_room (រក្សាដានប្រាក់)
    setState(() => is_loading = true);
    if ((cancel_price ?? 0) > 0 || (add_cash ?? 0) > 0 || (add_bank ?? 0) > 0 || (sub_return ?? 0) > 0)
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_PAY_ROOM,
        data: {
          Front_Desk.ID: map_room?.front_desk_id?.id, //
          Pay_Room.ADD_PRICE: cancel_price ?? 0, //
          Pay_Room.ADD_CASH: add_cash ?? 0, //
          Pay_Room.ADD_BANK: add_bank ?? 0, //
          Pay_Room.SUB_RETURN: sub_return ?? 0, //
        },
      );
    setState(() => is_loading = false);

    // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់
    setState(() => is_loading = true);
    if (target_status == room_status.AVAILABLE) {
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          Room.ID: widget.room_id, //
          Room.STATUS: target_status, //
          Room.FRONT_DESK_ID: null, //
        },
      );
    } else if (target_status == room_status.PENDING_CLEAN) {
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          Room.ID: widget.room_id, //
          Room.STATUS: target_status, //
        },
      );
    }
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
