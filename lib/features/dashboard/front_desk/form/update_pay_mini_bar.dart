// * ទំព័រ Add Mini Bar Payment សម្រាប់បន្ថែមការទូទាត់ mini bar

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/parse.dart";
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import

import "package:speanmeas/core/widget/input/input_bank_auto.dart";
import "package:speanmeas/core/widget/input/input_number.dart";

import "package:speanmeas/core/schema.g.dart";

// * បង្កើត layout មេរបស់ទំព័របន្ថែមការទូទាត់ mini bar
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Add Mini Bar Payment"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បន្ថែមការទូទាត់ mini bar
class _Main_State extends State<Main_> {
  dynamic tmp;
  Room? map_room;
  bool is_loading = true;

  double? other_price;
  double? old_price;
  double? last_paid;
  double? pay_cash;
  double? pay_bank;
  double? pay_return;
  String? pay_note;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងប្រវត្តិការទូទាត់ mini bar
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {Room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_room = Room.fromJson(tmp.data[0]);

    // * គណនាតម្លៃចាស់ និងប្រាក់ដែលបានទទួលរួច
    final pay_mini_bar_list = map_room?.front_desk_id?.pay_mini_bar ?? [];
    for (var l in pay_mini_bar_list) {
      // * តម្លៃសរុប = ផលបូកនៃ add_price ដក sub_price ទាំងអស់
      old_price = (old_price ?? 0) + (l.add_price ?? 0);
      old_price = (old_price ?? 0) - (l.sub_price ?? 0);
      // * ប្រាក់ដែលបានទទួលសរុប
      last_paid = (last_paid ?? 0) + (l.add_cash ?? 0);
      last_paid = (last_paid ?? 0) + (l.add_bank ?? 0);
      last_paid = (last_paid ?? 0) - (l.sub_return ?? 0);
    }
    other_price = old_price;

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

      // * បញ្ចូលតម្លៃផ្សេងៗ
      Input_Number(
        init: other_price, //
        lead: '${t("Mini Bar Price")}:', //
        onChanged: (v) {
          other_price = v;
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

      // * បញ្ចូលកំណត់ចំណាំការទូទាត់
      Input_Bank_Auto(
        init: pay_note, //
        onChanged: (v) {
          pay_note = v;
          setState(() {});
        },
      ),

      Divider(height: 1, color: Colors.black),

      // * បង្ហាញសមតុល្យ
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

      // * ប៊ូតុងបន្ថែមការទូទាត់
      OutlinedButton.icon(
        icon: Icon(Icons.add), //
        label: Text(t("Add Payment")), //
        onPressed: on_pay, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * ភាពខុសគ្នារវាងតម្លៃថ្មី និងតម្លៃចាស់
  double get _diff => (other_price ?? 0) - (old_price ?? 0);

  // * បើតម្លៃថ្មីខ្ពស់ជាង បញ្ចូលទៅ add_price
  double get _add_price => _diff > 0 ? _diff : 0;

  // * បើតម្លៃថ្មីទាបជាង បញ្ចូលទៅ sub_price
  double get _sub_price => _diff < 0 ? -_diff : 0;

  // * គណនាបានប្រាក់សំណើរ = ប្រាក់ទទួលសរុប - តម្លៃថ្មីសរុប
  double get balanced {
    double temp = 0;

    temp = temp + (pay_cash ?? 0);
    temp = temp + (pay_bank ?? 0);
    temp = temp + (last_paid ?? 0);
    temp = temp - (other_price ?? 0);
    temp = temp - (pay_return ?? 0);

    return temp;
  }

  // * អនុវត្តការបន្ថែមការទូទាត់ mini bar
  void on_pay() async {
    // * កត់ត្រាការទូទាត់ mini bar
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_PAY_MINI_BAR,
      data: {
        Front_Desk.ID: map_room?.front_desk_id?.id, //
        Payment_Mini_Bar.ADD_PRICE: _add_price, //
        Payment_Mini_Bar.SUB_PRICE: _sub_price, //
        Payment_Mini_Bar.ADD_CASH: pay_cash ?? 0, //
        Payment_Mini_Bar.ADD_BANK: pay_bank ?? 0, //
        Payment_Mini_Bar.SUB_RETURN: pay_return ?? 0, //
        Payment_Mini_Bar.NOTE: pay_note ?? "", //
      },
    );
    setState(() => is_loading = false);

    if (balanced != 0) {
      setState(() => is_loading = true);
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          Room.ID: map_room?.id, //
          Room.STATUS: "Pending Pay", //
        },
      );
      setState(() => is_loading = false);
    }

    snackbar(ct: context, ms: t("Success"), cl: Colors.green);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័របន្ថែមការទូទាត់ mini bar
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
