// * ទំព័រ Room Payment សម្រាប់ទូទាត់ថ្លៃបន្ទប់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_bank_auto.dart";
import "package:speanmeas/core/widget/input/input_number.dart";

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
  bool is_loading = true;

  double? new_price;
  double? old_price;
  double? last_paid;
  double? add_cash;
  double? add_bank;
  double? sub_return;
  String? note;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងប្រវត្តិការទូទាត់
  void init() async {
    pprint(widget.room_id);
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {Room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_room = Room.fromJson(tmp.data[0]);

    // * គណនាតម្លៃចាស់ និងប្រាក់ដែលបានទទួលរួច
    final pay_room_list = map_room?.front_desk_id?.pay_room ?? [];
    for (var l in pay_room_list) {
      // * តម្លៃសរុប = ផលបូកនៃ add_price ដក sub_price ទាំងអស់
      old_price = (old_price ?? 0) + (l.add_price ?? 0);
      old_price = (old_price ?? 0) - (l.sub_price ?? 0);
      // * ប្រាក់ដែលបានទទួលសរុប
      last_paid = (last_paid ?? 0) + (l.add_cash ?? 0);
      last_paid = (last_paid ?? 0) + (l.add_bank ?? 0);
      last_paid = (last_paid ?? 0) - (l.sub_return ?? 0);
    }

    new_price = old_price;

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
    if (map_room?.front_desk_id?.id == null) return false;
    if ((new_price ?? 0) <= 0) return false;
    if (balanced != 0) return false;
    return true;
  }

  // * ភាពខុសគ្នារវាងតម្លៃថ្មី និងតម្លៃចាស់
  double get _diff => (new_price ?? 0) - (old_price ?? 0);

  // * បើតម្លៃថ្មីខ្ពស់ជាង បញ្ចូលទៅ add_price
  double get add_price => _diff > 0 ? _diff : 0;

  // * បើតម្លៃថ្មីទាបជាង បញ្ចូលទៅ sub_price
  double get sub_price => _diff < 0 ? -_diff : 0;

  // * គណនាបានប្រាក់សំណើរ = ប្រាក់ទទួលសរុប - តម្លៃថ្មីសរុប
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
    // * កត់ត្រាការទូទាត់បន្ទប់
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_PAY_ROOM,
      data: {
        Front_Desk.ID: map_room?.front_desk_id?.id, //
        Pay_Room.ADD_PRICE: add_price, //
        Pay_Room.SUB_PRICE: sub_price, //
        Pay_Room.ADD_CASH: add_cash ?? 0, //
        Pay_Room.ADD_BANK: add_bank ?? 0, //
        Pay_Room.SUB_RETURN: sub_return ?? 0, //
        Pay_Room.NOTE: note ?? "", //
      },
    );
    setState(() => is_loading = false);

    // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់ទៅ Pending Leave
    setState(() => is_loading = true);
    await dio.post(
      endpoint.ROOM_CRUD_UPDATE, //
      data: {
        Room.ID: widget.room_id, //
        Room.STATUS: "Pending Leave", //
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
