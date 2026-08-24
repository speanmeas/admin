// * ទំព័រ Room Payment សម្រាប់ទូទាត់ថ្លៃបន្ទប់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/enum/room_status.dart" as room_status;
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_bank_auto.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "../helper.dart";

// * បង្កើត layout មេរបស់ទំព័រទូទាត់បន្ទប់
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Room Payment"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ទូទាត់បន្ទប់
class _Main_State extends State<Main_> {
  dynamic tmp;
  Room? map_room;
  Front_Desk? map_fd;
  bool is_loading = true;

  double? new_price;
  double? old_price;
  double? last_paid;
  double prev_cash = 0;
  double prev_bank = 0;
  double? add_cash;
  double? add_bank;
  double? sub_return;
  String? note;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងប្រវត្តិការទូទាត់
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_READ_ID, data: {Room.ID: widget.room_id});
    if (tmp == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_READ_ID}"), cl: Colors.red);
    }
    map_room = Room.fromJson(tmp.data[0]);

    // * រក stay សកម្មរបស់បន្ទប់
    final fds = await load_fds();
    map_fd = active_fd(fds, widget.room_id);

    // * តម្លៃចាស់ និងប្រាក់ដែលបានទទួលរួច (ពី room_pay តែមួយ)
    old_price = map_fd?.room_pay_id?.price ?? 0;
    last_paid = paid_of(map_fd?.room_pay_id);
    prev_cash = map_fd?.room_pay_id?.cash ?? 0;
    prev_bank = map_fd?.room_pay_id?.bank ?? 0;

    new_price = old_price;

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
        '${t("Room")} ${map_room?.number ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      Divider(height: 1, color: Colors.black),

      // * បញ្ចូលតម្លៃបន្ទប់
      Input_Number(
        init: new_price, //
        lead: '${t("Room Price")}:', //
        onChanged: (v) {
          new_price = v;
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

      // * បញ្ចូលកំណត់ចំណាំការទូទាត់
      Input_Bank_Auto(
        init: note, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      Divider(height: 1, color: Colors.black),

      // * បង្ហាញសមតុល្យ
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${t("Balanced")}: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold, //
            ),
          ),
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

      // * ប៊ូតុងបញ្ជូនការទូទាត់
      OutlinedButton.icon(
        icon: Icon(Icons.payments_outlined), //
        label: Text(t("Complete Payment")), //
        onPressed: (can_pay) ? on_pay : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * ពិនិត្យថាអាចទូទាត់បានឬអត់
  bool get can_pay {
    if (is_loading) return false;
    if (map_fd?.id == null) return false;
    if ((new_price ?? 0) <= 0) return false;
    if (balanced != 0) return false;
    return true;
  }

  // * គណនាប្រាក់សំណល់ = ប្រាក់ទទួលសរុប - តម្លៃថ្មីសរុប
  double get balanced {
    double temp = 0;

    temp = temp + (add_cash ?? 0);
    temp = temp + (add_bank ?? 0);
    temp = temp + (last_paid ?? 0);
    temp = temp - (new_price ?? 0);
    temp = temp - (sub_return ?? 0);

    return temp;
  }

  // * អនុវត្តការទូទាត់បន្ទប់
  void on_pay() async {
    // * កត់ត្រាការទូទាត់បន្ទប់ (upsert room_pay + link)
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_ROOM_PAY,
      data: {
        Front_Desk.ID: map_fd?.id, //
        Pay_Room.PRICE: new_price ?? 0, //
        // * ប្រាក់សរុប = ចាស់ + ថ្មី - ប្រាក់អាប់
        Pay_Room.CASH: prev_cash + (add_cash ?? 0) - (sub_return ?? 0), //
        Pay_Room.BANK: prev_bank + (add_bank ?? 0), //
        Pay_Room.NOTE: note ?? "", //
      },
    );
    setState(() => is_loading = false);

    // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់ទៅ Pending Leave
    setState(() => is_loading = true);
    await dio.post(
      endpoint.ROOM_UPDATE, //
      data: {
        Room.ID: widget.room_id, //
        Room.STATUS: room_status.PENDING_LEAVE, //
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

// * ថ្នាក់ Main_ ជាទំព័រទូទាត់បន្ទប់
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
        home: Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
