import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/input/input_bank_auto.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

// * បង្កើត layout មេរបស់ទំព័រគិតថ្លៃ mini bar
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Mini Bar", //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      centerTitle: false,
      toolbarHeight: 40,
      titleSpacing: 0,

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4), //
        child: LinearProgressIndicator(
          minHeight: 4,
          value: 2 / 2, // fixed bar (no animation)
          color: Colors.blue, //
        ),
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

// * ថ្នាក់ state របស់ Charge_ គ្រប់គ្រងការជ្រើសរើសទំនិញ mini bar
class _Mini_Bar_2State extends State<Mini_Bar_2> {
  // * ចំនួនដែលជ្រើសរើសក្នុងមួយទំនិញ (key = item id)
  // final Map<dynamic, int> _qty = {};

  String tag = "Walk-in";
  List<String> options = ["Walk-in"];

  // * បញ្ជីទំនិញ mini bar (catalog) ទាញពី Server
  List<Map<String, dynamic>> catalog = [];

  dynamic tmp;
  Room? map_room;
  bool _order_created = false;
  bool is_loading = true;

  double? other_price;
  double? old_price;
  double? last_paid;
  double? pay_cash;
  double? pay_bank;
  double? pay_return;
  String? pay_note;

  // * បញ្ជី order mini bar ដែលមានស្រាប់ (សម្រាប់កែសម្រួល)
  List<Order_Mini_Bar> initial_orders = [];

  // * ទាញយកបញ្ជីទំនិញ mini bar ពី Server
  void init() async {
    setState(() => is_loading = true);
    tmp = await dio.post(
      endpoint.MINI_BAR_CRUD_READ, //
      data: {
        "key": DEFAULT_KEY, //
        "order": DEFAULT_ORDER, //
        "offset": 0, //
        "limit": DEFAULT_LIMIT_ROW,
      },
    );
    setState(() => is_loading = false);

    catalog = List<Map<String, dynamic>>.from(tmp?.data ?? []);

    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {Room.ID: widget.room_id});
    setState(() => is_loading = false);
    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_room = Room.fromJson(tmp.data[0]);
    initial_orders = map_room?.front_desk_id?.order_mini_bar ?? [];

    // * កំណត់ tag ទៅបន្ទប់ដែលកំពុងកែសម្រួល (update មិនមាន walk-in ទេ)
    tag = map_room?.number ?? "";

    // * គណនាតម្លៃចាស់ និងប្រាក់ដែលបានទទួលរួចពី pay_mini_bar ដែលមានស្រាប់
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

    // * options មានតែបន្ទប់ដែលកំពុងកែសម្រួល (មិនអាចប្តូរបាន)
    options = [tag];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
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

      // * ប៊ូតុងបន្ថែមការទូទាត់ (បង់ឥឡូវ)
      OutlinedButton.icon(
        icon: Icon(Icons.update), //
        label: Text(t("Update")), //
        onPressed: can_add ? on_add : null, //
      ),

      // * បើ tag ជាបន្ទប់ អាចបង់ក្រោយបាន (walk-in ត្រូវបង់ឥឡូវ)
      // if (tag != "Walk-in")
      //   OutlinedButton.icon(
      //     icon: Icon(Icons.schedule), //
      //     label: Text(t("Pay Later")), //
      //     onPressed: on_pay_later, //
      //   ),
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

  // * walk-in ត្រូវបង់ពេញឥឡូវនេះ (balanced == 0) បន្ទប់អាចបង់បានគ្រប់ពេល
  bool get can_add {
    if (tag != "Walk-in") return true;

    if (balanced != 0) return false;

    return true;
  }

  // * ធ្វើសមកាលកម្ម order mini bar ជាមួយ backend:
  // * - ទំនិញដែលមានស្រាប់ → កែប្រែចំនួន (update)
  // * - ទំនិញដែលលុបចេញ (qty = 0) → លុប order (delete)
  // * - ទំនិញថ្មី → បង្កើត order (create)
  // * ត្រឡប់ true បើជោគជ័យទាំងអស់
  Future<bool> _sync_orders() async {
    // * walk-in គ្មាន front_desk ដូច្នេះមិនអាចធ្វើសមកាលកម្ម order បានទេ
    if (map_room?.front_desk_id?.id == null) return false;

    // * ផែនទី order ដែលមានស្រាប់តាម mini_bar_id
    final existing = <String, Order_Mini_Bar>{};
    for (var o in initial_orders) {
      final id = o.mini_bar_id?.id;
      if (id != null) existing[id] = o;
    }

    // * បញ្ជី mini_bar_id ដែលនៅសល់ក្នុងការជ្រើសរើសថ្មី
    final kept = <String>{};

    for (var l in widget.lines) {
      final item_id = l[Mini_Bar.ID]?.toString();
      final qty = (l["qty"] as num?)?.toInt() ?? 0;
      if (item_id == null || qty <= 0) continue;
      kept.add(item_id);

      final old = existing[item_id];
      if (old != null) {
        // * កែប្រែចំនួនរបស់ order ដែលមានស្រាប់
        final r = await dio.post(
          endpoint.ORDER_MINI_BAR_CRUD_UPDATE, //
          data: {
            Order_Mini_Bar.ID: old.id, //
            Order_Mini_Bar.QUANTITY: qty, //
            // Order_Mini_Bar.NOTE: l["note"] ?? "", //
          },
        );
        if (r == null) return false;
      } else {
        // * បង្កើត order ថ្មីសម្រាប់ទំនិញដែលទើបជ្រើសរើស
        final r = await dio.post(
          endpoint.ORDER_MINI_BAR_CRUD_CREATE, //
          data: {
            Order_Mini_Bar.MINI_BAR_ID: item_id, //
            Order_Mini_Bar.QUANTITY: qty, //
            // Order_Mini_Bar.NOTE: l["note"] ?? "", //
            Order_Mini_Bar.FRONT_DESK_ID: map_room?.front_desk_id?.id, //
          },
        );
        if (r == null) return false;
      }
    }

    // * លុប order ដែលលែងមានក្នុងការជ្រើសរើសថ្មី
    for (var o in initial_orders) {
      final id = o.mini_bar_id?.id;
      if (id != null && !kept.contains(id) && o.id != null) {
        final r = await dio.post(
          endpoint.ORDER_MINI_BAR_CRUD_DELETE, //
          data: {Order_Mini_Bar.ID: o.id},
        );
        if (r == null) return false;
      }
    }

    return true;
  }

  // * អនុវត្តការបន្ថែមការទូទាត់ mini bar
  void on_add() async {
    // pprint(widget.initial_orders);

    // return;
    setState(() => is_loading = true);

    // * ធ្វើសមកាលកម្ម order mini bar (តែពេល tag ជាបន្ទប់)
    if (!_order_created && map_room?.front_desk_id?.id != null) {
      final ok = await _sync_orders();
      if (!ok) {
        setState(() => is_loading = false);
        return snackbar(ct: context, ms: t("Error: ${endpoint.ORDER_MINI_BAR_CRUD_UPDATE}"), cl: Colors.red);
      }
      _order_created = true;
    }

    // * កត់ត្រាការទូទាត់ mini bar (តែពេល tag ជាបន្ទប់)
    if (map_room?.front_desk_id?.id != null) {
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_PAY_MINI_BAR,
        data: {
          Front_Desk.ID: map_room?.front_desk_id?.id, //
          Pay_Mini_Bar.ADD_PRICE: _add_price, //
          Pay_Mini_Bar.SUB_PRICE: _sub_price, //
          Pay_Mini_Bar.ADD_CASH: pay_cash ?? 0, //
          Pay_Mini_Bar.ADD_BANK: pay_bank ?? 0, //
          Pay_Mini_Bar.SUB_RETURN: pay_return ?? 0, //
          Pay_Mini_Bar.NOTE: pay_note ?? "", //
        },
      );
    }
    setState(() => is_loading = false);

    // * បើនៅមានសមតុល្យមិនទាន់បង់ → សម្គាល់បន្ទប់ជា Pending Pay
    if (balanced != 0 && map_room != null) {
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
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  // * បង់ក្រោយ (តែពេល tag ជាបន្ទប់) — កត់ត្រាតម្លៃ ប៉ុន្តែមិនទាមទារការទូទាត់ពេញ
  void on_pay_later() async {
    setState(() => is_loading = true);

    // * ធ្វើសមកាលកម្ម order mini bar បើមិនទាន់មាន
    if (!_order_created && map_room?.front_desk_id?.id != null) {
      final ok = await _sync_orders();
      if (!ok) {
        setState(() => is_loading = false);
        return snackbar(ct: context, ms: t("Error: ${endpoint.ORDER_MINI_BAR_CRUD_UPDATE}"), cl: Colors.red);
      }
      _order_created = true;
    }

    // * កត់ត្រាការទូទាត់ mini bar
    if (map_room?.front_desk_id?.id != null) {
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_PAY_MINI_BAR,
        data: {
          Front_Desk.ID: map_room?.front_desk_id?.id, //
          Pay_Mini_Bar.ADD_PRICE: _add_price, //
          Pay_Mini_Bar.SUB_PRICE: _sub_price, //
          Pay_Mini_Bar.ADD_CASH: pay_cash ?? 0, //
          Pay_Mini_Bar.ADD_BANK: pay_bank ?? 0, //
          Pay_Mini_Bar.SUB_RETURN: pay_return ?? 0, //
          Pay_Mini_Bar.NOTE: pay_note ?? "", //
        },
      );
    }
    setState(() => is_loading = false);

    // * បន្ទប់នៅតែមានសមតុល្យមិនទាន់បង់ → សម្គាល់ជា Pending Pay
    if (balanced != 0 && map_room != null) {
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
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    // * ទទួលតម្លៃដែលបានបញ្ជូនពី mini_bar_1
    catalog = widget.catalog.isNotEmpty ? widget.catalog : catalog;
    other_price = widget.other_price ?? other_price;
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រមេ mini bar
class Mini_Bar_2 extends StatefulWidget {
  const Mini_Bar_2({super.key, this.room_id, this.catalog = const [], this.sold = const {}, this.lines = const [], this.other_price});

  final String? room_id; // * id បន្ទប់ដែលកំពុងកែសម្រួល (update មិនមាន walk-in)
  final List<Map<String, dynamic>> catalog; // * បញ្ជីទំនិញ mini bar
  final Map<dynamic, int> sold; // * ចំនួនដែលបានលក់រួចហើយ
  final List<Map<String, dynamic>> lines; // * បញ្ជីទំនិញដែលបានជ្រើសរើសពី mini_bar_1
  final double? other_price; // * តម្លៃសរុបពី mini_bar_1

  @override
  State<Mini_Bar_2> createState() => _Mini_Bar_2State();
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
        home: Mini_Bar_2(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
