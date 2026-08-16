// * ទំព័រ Add Room Payment សម្រាប់បន្ថែមការទូទាត់បន្ទប់

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
import "package:speanmeas/core/schema/payment_room.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

// * បង្កើត layout មេរបស់ទំព័របន្ថែមការទូទាត់បន្ទប់
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Add Room Payment"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់បន្ថែមការទូទាត់បន្ទប់
class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic map_room;
  bool is_loading = true;

  double? room_price;
  double? old_price;
  double? last_paid;
  double? pay_cash;
  double? pay_bank;
  double? pay_return;
  String? pay_note;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងប្រវត្តិការទូទាត់
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_room = tmp.data[0] as Map<String, dynamic>;

    // * គណនាតម្លៃចាស់ និងប្រាក់ដែលបានទទួលរួច
    tmp = map_room[sm_room.FRONT_DESK_ID]?[sm_front_desk.PAY_ROOM] as List<dynamic>? ?? [];
    for (var l in tmp) {
      // * តម្លៃសរុប = ផលបូកនៃ add_price ដក sub_price ទាំងអស់
      old_price = (old_price ?? 0) + (parse_double(l[sm_payment_room.ADD_PRICE]) ?? 0);
      old_price = (old_price ?? 0) - (parse_double(l[sm_payment_room.SUB_PRICE]) ?? 0);
      // * ប្រាក់ដែលបានទទួលសរុប
      last_paid = (last_paid ?? 0) + (parse_double(l[sm_payment_room.ADD_CASH]) ?? 0);
      last_paid = (last_paid ?? 0) + (parse_double(l[sm_payment_room.ADD_BANK]) ?? 0);
      last_paid = (last_paid ?? 0) - (parse_double(l[sm_payment_room.SUB_RETURN]) ?? 0);
    }
    room_price = old_price;

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

      // * បញ្ចូលតម្លៃបន្ទប់
      Input_Number(
        init: room_price, //
        lead: '${t("Room Price")}:', //
        onChanged: (v) {
          room_price = v;
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

      // * ប៊ូតុងបន្ថែមការទូទាត់
      OutlinedButton.icon(
        icon: Icon(Icons.add), //
        label: Text(t("Add Payment")), //
        onPressed: (can_update) ? on_update : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * តម្រូវឱ្យមានតម្លៃ។ មិនកំណត់លើ balanced == 0 ទេ ព្រោះ
  // * លំហូរនេះបន្ថែមការទូទាត់ទៅសមតុល្យ (pay_room ជាលំហូរទូទាត់ពេញ)។
  bool get can_update {
    if ((room_price ?? 0) <= 0) return false;
    return true;
  }

  // * ភាពខុសគ្នារវាងតម្លៃថ្មី និងតម្លៃចាស់
  double get _diff => (room_price ?? 0) - (old_price ?? 0);

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
    temp = temp - (room_price ?? 0);
    temp = temp - (pay_return ?? 0);

    return temp;
  }

  // * អនុវត្តការបន្ថែមការទូទាត់បន្ទប់
  void on_update() async {
    // * កត់ត្រាការទូទាត់បន្ទប់
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_PAY_ROOM,
      data: {
        sm_front_desk.ID: map_room[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID], //
        sm_payment_room.ADD_PRICE: _add_price, //
        sm_payment_room.SUB_PRICE: _sub_price, //
        sm_payment_room.ADD_CASH: pay_cash ?? 0, //
        sm_payment_room.ADD_BANK: pay_bank ?? 0, //
        sm_payment_room.SUB_RETURN: pay_return ?? 0, //
        sm_payment_room.NOTE: pay_note ?? "", //
      },
    );
    setState(() => is_loading = false);

    // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់តាមសមតុល្យ
    setState(() => is_loading = true);
    if (balanced == 0)
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Pending Leave", //
        },
      );
    else
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Pending Pay", //
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

// * ថ្នាក់ Main_ ជាទំព័របន្ថែមការទូទាត់បន្ទប់
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
