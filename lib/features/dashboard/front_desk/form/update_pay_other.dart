// * ទំព័រ Add Other Payment សម្រាប់បន្ថែមការទូទាត់ផ្សេងៗ

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
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/payment_other.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

// * បង្កើត layout មេរបស់ទំព័របន្ថែមការទូទាត់ផ្សេងៗ
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Add Other Payment"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បន្ថែមការទូទាត់ផ្សេងៗ
class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic map_room;
  bool is_loading = true;

  double? other_price;
  double? old_price;
  double? last_paid;
  double? add_cash;
  double? add_bank;
  double? sub_return;
  String? note;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងប្រវត្តិការទូទាត់ផ្សេងៗ
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_room = tmp.data[0] as Map<String, dynamic>;

    // * គណនាតម្លៃចាស់ និងប្រាក់ដែលបានទទួលរួច
    tmp = map_room[sm_room.FRONT_DESK_ID]?[sm_front_desk.PAY_OTHER] as List<dynamic>? ?? [];
    for (var l in tmp) {
      // * តម្លៃសរុប = ផលបូកនៃ add_price ដក sub_price ទាំងអស់
      old_price = (old_price ?? 0) + (parse_double(l[sm_payment_other.ADD_PRICE]) ?? 0);
      old_price = (old_price ?? 0) - (parse_double(l[sm_payment_other.SUB_PRICE]) ?? 0);
      // * ប្រាក់ដែលបានទទួលសរុប
      last_paid = (last_paid ?? 0) + (parse_double(l[sm_payment_other.ADD_CASH]) ?? 0);
      last_paid = (last_paid ?? 0) + (parse_double(l[sm_payment_other.ADD_BANK]) ?? 0);
      last_paid = (last_paid ?? 0) - (parse_double(l[sm_payment_other.SUB_RETURN]) ?? 0);
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
        '${t("Room")} ${map_room?[sm_room.NUMBER] ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      Divider(height: 1, color: Colors.black),

      // * បញ្ចូលតម្លៃផ្សេងៗ
      Input_Number(
        init: other_price, //
        lead: '${t("Other Price")}:', //
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
  double get add_price => _diff > 0 ? _diff : 0;

  // * បើតម្លៃថ្មីទាបជាង បញ្ចូលទៅ sub_price
  double get sub_price => _diff < 0 ? -_diff : 0;

  // * គណនាបានប្រាក់សំណើរ = ប្រាក់ទទួលសរុប - តម្លៃថ្មីសរុប
  double get balanced {
    double temp = 0;

    temp = temp + (add_cash ?? 0);
    temp = temp + (add_bank ?? 0);
    temp = temp + (last_paid ?? 0);
    temp = temp - (other_price ?? 0);
    temp = temp - (sub_return ?? 0);

    return temp;
  }

  // * អនុវត្តការបន្ថែមការទូទាត់ផ្សេងៗ
  void on_pay() async {
    // * កត់ត្រាការទូទាត់ផ្សេងៗ
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_PAY_OTHER,
      data: {
        sm_front_desk.ID: map_room[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID], //
        sm_payment_other.ADD_PRICE: add_price, //
        sm_payment_other.SUB_PRICE: sub_price, //
        sm_payment_other.ADD_CASH: add_cash ?? 0, //
        sm_payment_other.ADD_BANK: add_bank ?? 0, //
        sm_payment_other.SUB_RETURN: sub_return ?? 0, //
        sm_payment_other.NOTE: note ?? "", //
      },
    );
    setState(() => is_loading = false);

    if (balanced != 0) {
      setState(() => is_loading = true);
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: map_room[sm_room.ID], //
          sm_room.STATUS: "Pending Pay", //
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

// * ថ្នាក់ Main_ ជាទំព័របន្ថែមការទូទាត់ផ្សេងៗ
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
