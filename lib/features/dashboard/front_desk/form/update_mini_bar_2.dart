import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/input/input_bank_auto.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart"; // ignore: unused_import

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

// * ថ្នាក់ state របស់ Mini_Bar_2 គ្រប់គ្រងការទូទាត់ mini bar
class _Mini_Bar_2State extends State<Mini_Bar_2> {
  String tag = "Walk-in";
  List<String> options = ["Walk-in"];

  // * បញ្ជីទំនិញ mini bar (catalog)
  late List<Mini_Bar> list_mini_bar = widget.list_mini_bar;

  // * បញ្ជី order mini bar ដែលបានជ្រើសរើស (កែប្រែផ្ទាល់)
  late List<Order_Mini_Bar> list_order_mini_bar = widget.list_order_mini_bar;

  dynamic tmp;
  Room? map_room;
  bool _order_created = false;
  bool is_loading = true;

  double? new_price;
  double? old_price;
  double? last_paid;
  double? add_cash;
  double? add_bank;
  double? sub_return;
  String? note;

  // * បញ្ជី order mini bar ដែលមានស្រាប់ (សម្រាប់កែសម្រួល)
  List<Order_Mini_Bar> initial_orders = [];

  // * ទាញយកបញ្ជីទំនិញ mini bar ពី Server
  void init() async {
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.MINI_BAR_CRUD_READ);
    setState(() => is_loading = false);
    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_CRUD_READ}"), cl: Colors.red);

    // * ប្រើបញ្ជីដែលបានបញ្ជូនពី update_mini_bar_1 បើមាន
    if (list_mini_bar.isEmpty) {
      list_mini_bar = (tmp?.data as List<dynamic>? ?? []).map((e) => Mini_Bar.fromJson(e as Map<String, dynamic>)).toList();
    }

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

    // * គណនាតម្លៃថ្មីពី order mini bar ដែលបានជ្រើសរើស
    for (var l in widget.list_order_mini_bar) {
      final qty = l.quantity ?? 0;
      final price = l.mini_bar_id?.price ?? 0;
      new_price = (new_price ?? 0) + qty * price;
    }

    // * options មានតែបន្ទប់ដែលកំពុងកែសម្រួល (មិនអាចប្តូរបាន)
    options = [tag];

    setState(() {});
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
        init: new_price, //
        lead: '${t("Mini Bar Price")}:', //
        onChanged: (v) {
          new_price = v;
          setState(() {});
        },
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

      // * ប៊ូតុងបន្ថែមការទូទាត់ (បង់ឥឡូវ)
      OutlinedButton.icon(
        icon: Icon(Icons.update), //
        label: Text(t("Update")), //
        onPressed: can_add ? on_add : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

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

  // * walk-in ត្រូវបង់ពេញឥឡូវនេះ (balanced == 0) បន្ទប់អាចបង់បានគ្រប់ពេល
  bool get can_add {
    if (tag != "Walk-in") return true;

    if (balanced != 0) return false;

    return true;
  }

  // * ធ្វើសមកាលកម្ម order mini bar ជាមួយ backend:
  // * - ទំនិញដែលមានស្រាប់ → កែប្រែចំនួន (update)
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

    for (var l in widget.list_order_mini_bar) {
      final item_id = l.mini_bar_id?.id;
      final qty = l.quantity ?? 0;
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
            Order_Mini_Bar.FRONT_DESK_ID: map_room?.front_desk_id?.id, //
          },
        );
        if (r == null) return false;
      }
    }

    // * លុប order ដែលលែងមានក្នុងការជ្រើសរើសថ្មី (កំណត់ qty = 0 ហើយលុបចេញ)
    for (var o in initial_orders) {
      final id = o.mini_bar_id?.id;
      if (id == null || kept.contains(id) || o.id == null) continue;

      final r = await dio.post(
        endpoint.ORDER_MINI_BAR_CRUD_UPDATE, //
        data: {
          Order_Mini_Bar.ID: o.id, //
          Order_Mini_Bar.QUANTITY: 0, //
        },
      );
      if (r == null) return false;

      final d = await dio.post(
        endpoint.ORDER_MINI_BAR_CRUD_DELETE, //
        data: {Order_Mini_Bar.ID: o.id},
      );
      if (d == null) return false;
    }

    return true;
  }

  // * កែសម្រួលស្តុក mini bar តាមភាពខុសគ្នារវាងចំនួនថ្មី និងចំនួនដែលមានស្រាប់
  Future<void> _sync_stock() async {
    // * ផែនទីចំនួនថ្មីតាម mini_bar_id
    final new_qty = <String, int>{};
    for (var l in widget.list_order_mini_bar) {
      final id = l.mini_bar_id?.id;
      if (id != null) new_qty[id] = l.quantity ?? 0;
    }

    // * ផែនទីស្តុកបច្ចុប្បន្នតាម mini_bar_id
    final current_stock = <String, double>{};
    for (var m in list_mini_bar) {
      final id = m.id;
      if (id != null) current_stock[id] = m.stock ?? 0;
    }

    // * ទំនិញដែលមាន order ចាស់ → កាត់/បន្ថែមស្តុកតាមភាពខុសគ្នា
    for (var o in initial_orders) {
      final id = o.mini_bar_id?.id;
      if (id == null) continue;
      final old_q = o.quantity ?? 0;
      final new_q = new_qty[id] ?? 0;
      final stock = current_stock[id];
      if (stock == null) continue;
      if (new_q == old_q) continue;

      // * ចំនួនថយ → បន្ថែមស្តុកវិញ ចំនួនកើន → កាត់ស្តុកបន្ថែម
      final new_stock = stock - (new_q - old_q);
      await dio.post(
        endpoint.MINI_BAR_CRUD_UPDATE, //
        data: {
          Mini_Bar.ID: id, //
          Mini_Bar.STOCK: new_stock, //
        },
      );
    }

    // * ទំនិញថ្មី (គ្មាន order ចាស់) → កាត់ស្តុកតាមចំនួនថ្មី
    for (var l in widget.list_order_mini_bar) {
      final id = l.mini_bar_id?.id;
      if (id == null) continue;
      final qty = l.quantity ?? 0;
      if (qty <= 0) continue;
      final stock = current_stock[id];
      if (stock == null) continue;
      if (initial_orders.any((o) => o.mini_bar_id?.id == id)) continue;

      final new_stock = stock - qty;
      await dio.post(
        endpoint.MINI_BAR_CRUD_UPDATE, //
        data: {
          Mini_Bar.ID: id, //
          Mini_Bar.STOCK: new_stock, //
        },
      );
    }
  }

  // * អនុវត្តការបន្ថែមការទូទាត់ mini bar
  void on_add() async {
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

    // * កែសម្រួលស្តុក mini bar
    await _sync_stock();

    // * កត់ត្រាការទូទាត់ mini bar (តែពេល tag ជាបន្ទប់)
    if (map_room?.front_desk_id?.id != null) {
      double add_price = (new_price ?? 0) - (old_price ?? 0);
      if (add_price < 0) add_price = 0;
      double sub_price = (old_price ?? 0) - (new_price ?? 0);
      if (sub_price < 0) sub_price = 0;

      await dio.post(
        endpoint.FRONT_DESK_UPDATE_PAY_MINI_BAR,
        data: {
          Front_Desk.ID: map_room?.front_desk_id?.id, //
          Pay_Mini_Bar.ADD_PRICE: add_price, //
          Pay_Mini_Bar.SUB_PRICE: sub_price, //
          Pay_Mini_Bar.ADD_CASH: add_cash, //
          Pay_Mini_Bar.ADD_BANK: add_bank, //
          Pay_Mini_Bar.SUB_RETURN: sub_return, //
          Pay_Mini_Bar.NOTE: note, //
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

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រមេ mini bar
class Mini_Bar_2 extends StatefulWidget {
  const Mini_Bar_2({
    super.key, //
    this.room_id,
    this.list_mini_bar = const [],
    this.list_order_mini_bar = const [],
  });

  final String? room_id; // * id បន្ទប់ដែលកំពុងកែសម្រួល (update មិនមាន walk-in)
  final List<Mini_Bar> list_mini_bar; // * បញ្ជីទំនិញ mini bar
  final List<Order_Mini_Bar> list_order_mini_bar; // * បញ្ជី order mini bar ដែលបានជ្រើសរើស

  @override
  State<Mini_Bar_2> createState() => _Mini_Bar_2State();
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
        home: Mini_Bar_2(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
