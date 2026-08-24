import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/enum/room_status.dart" as room_status;
import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/input/input_bank_auto.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart"; // ignore: unused_import
import "../dialog/pick_item.dart";
import "../helper.dart";

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
  Front_Desk? map_fd;
  bool _order_created = false;
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

  // * បញ្ជី order mini bar ដែលមានស្រាប់ (សម្រាប់កែសម្រួល)
  List<Order_Mini_Bar> initial_orders = [];

  // * ទាញយកបញ្ជីទំនិញ mini bar ពី Server
  void init() async {
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.MINI_BAR_READ);
    if (tmp == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_READ}"), cl: Colors.red);
    }

    // * ប្រើបញ្ជីដែលបានបញ្ជូនពី update_mini_bar_1 បើមាន
    if (list_mini_bar.isEmpty) {
      list_mini_bar = (tmp?.data as List<dynamic>? ?? []).map((e) => Mini_Bar.fromJson(e as Map<String, dynamic>)).toList();
    }

    // * អានព័ត៌មានបន្ទប់តាម id
    tmp = await dio.post(endpoint.ROOM_READ_ID, data: {Room.ID: widget.room_id});
    if (tmp == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_READ_ID}"), cl: Colors.red);
    }

    map_room = Room.fromJson(tmp.data[0]);

    // * រក stay សកម្មរបស់បន្ទប់
    final fds = await load_fds();
    map_fd = active_fd(fds, widget.room_id);

    // * អាន item mini bar ដែលភ្ជាប់នឹងឯកសារទូទាត់របស់ stay
    initial_orders = [];
    final pay_id = map_fd?.mini_bar_pay_id?.id;
    if (pay_id != null) {
      tmp = await dio.post(endpoint.MINI_BAR_ITEM_READ);
      if (tmp == null) {
        setState(() => is_loading = false);
        return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_ITEM_READ}"), cl: Colors.red);
      }
      final items = [for (final d in (tmp.data ?? const [])) Mini_Bar_Item.fromJson(d)];
      for (var o in items) {
        if (o.mini_bar_pay_id?.id != pay_id) continue; // * មិនមែនរបស់ stay នេះ
        if ((o.quantity ?? 0) <= 0) continue;
        initial_orders.add(
          Order_Mini_Bar(
            id: o.id, //
            mini_bar_id: Mini_Bar_Show_2(id: o.mini_bar_id?.id, name: o.mini_bar_id?.name, price: o.mini_bar_id?.price),
            quantity: o.quantity ?? 1,
          ),
        );
      }
    }

    // * កំណត់ tag ទៅបន្ទប់ដែលកំពុងកែសម្រួល (update មិនមាន walk-in ទេ)
    tag = map_room?.number ?? "";

    // * តម្លៃចាស់ និងប្រាក់ដែលបានទទួលរួច (ពី mini_bar_pay តែមួយ)
    old_price = map_fd?.mini_bar_pay_id?.price ?? 0;
    last_paid = paid_of(map_fd?.mini_bar_pay_id);
    prev_cash = map_fd?.mini_bar_pay_id?.cash ?? 0;
    prev_bank = map_fd?.mini_bar_pay_id?.bank ?? 0;

    // * គណនាតម្លៃថ្មីពី order mini bar ដែលបានជ្រើសរើស
    for (var l in widget.list_order_mini_bar) {
      final qty = l.quantity;
      final price = l.mini_bar_id?.price ?? 0;
      new_price = (new_price ?? 0) + qty * price;
    }

    // * options មានតែបន្ទប់ដែលកំពុងកែសម្រួល (មិនអាចប្តូរបាន)
    options = [tag];

    setState(() => is_loading = false);
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
  // * - ទំនិញថ្មី → បង្កើត item (create)
  // * - ទំនិញដែលដកចេញ → លុប item (delete)
  // * ត្រឡប់ true បើជោគជ័យទាំងអស់
  Future<bool> _sync_orders(String? pay_id) async {
    // * ត្រូវមាន stay និងឯកសារទូទាត់ជាមុន
    if (map_fd?.id == null || pay_id == null) return false;

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
      final qty = l.quantity;
      if (item_id == null || qty <= 0) continue;
      kept.add(item_id);

      final old = existing[item_id];
      if (old != null) {
        // * កែប្រែចំនួនរបស់ item ដែលមានស្រាប់
        if (old.id == null || old.quantity == qty) continue;
        final r = await dio.post(
          endpoint.MINI_BAR_ITEM_UPDATE, //
          data: {
            Mini_Bar_Item.ID: old.id, //
            Mini_Bar_Item.QUANTITY: qty, //
          },
        );
        if (r == null) return false;
      } else {
        // * បង្កើត item ថ្មីសម្រាប់ទំនិញដែលទើបជ្រើសរើស
        final r = await dio.post(
          endpoint.MINI_BAR_ITEM_CREATE, //
          data: {
            Mini_Bar_Item.MINI_BAR_ID: item_id, //
            Mini_Bar_Item.QUANTITY: qty, //
            Mini_Bar_Item.MINI_BAR_PAY_ID: pay_id, //
          },
        );
        if (r == null) return false;
      }
    }

    // * លុប item ដែលលែងមានក្នុងការជ្រើសរើសថ្មី
    for (var o in initial_orders) {
      final id = o.mini_bar_id?.id;
      if (id == null || kept.contains(id) || o.id == null) continue;

      final d = await dio.post(
        endpoint.MINI_BAR_ITEM_DELETE, //
        data: {Mini_Bar_Item.ID: o.id},
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
      if (id != null) new_qty[id] = l.quantity;
    }

    // * ផែនទីស្តុកបច្ចុប្បន្នតាម mini_bar_id
    final current_stock = <String, double>{};
    for (var m in list_mini_bar) {
      final id = m.id;
      if (id != null) current_stock[id] = m.stock?.toDouble() ?? 0;
    }

    // * ទំនិញដែលមាន order ចាស់ → កាត់/បន្ថែមស្តុកតាមភាពខុសគ្នា
    for (var o in initial_orders) {
      final id = o.mini_bar_id?.id;
      if (id == null) continue;
      final old_q = o.quantity;
      final new_q = new_qty[id] ?? 0;
      final stock = current_stock[id];
      if (stock == null) continue;
      if (new_q == old_q) continue;

      // * ចំនួនថយ → បន្ថែមស្តុកវិញ ចំនួនកើន → កាត់ស្តុកបន្ថែម
      final new_stock = stock - (new_q - old_q);
      await dio.post(
        endpoint.MINI_BAR_UPDATE, //
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
      final qty = l.quantity;
      if (qty <= 0) continue;
      final stock = current_stock[id];
      if (stock == null) continue;
      if (initial_orders.any((o) => o.mini_bar_id?.id == id)) continue;

      final new_stock = stock - qty;
      await dio.post(
        endpoint.MINI_BAR_UPDATE, //
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

    // * បញ្ជាក់មាន stay សកម្ម
    if (map_fd?.id == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("No active stay for this room."), cl: Colors.red);
    }

    // * បង្កើតឯកសារទូទាត់ mini bar បើអត់មាន (upsert)
    String? pay_id = map_fd?.mini_bar_pay_id?.id;
    if (pay_id == null) {
      tmp = await dio.post(endpoint.MINI_BAR_PAY_CREATE, data: {Mini_Bar_Pay.NOTE: note ?? ""});
      if (tmp == null || tmp.data is! List || (tmp.data as List).isEmpty) {
        setState(() => is_loading = false);
        return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_PAY_CREATE}"), cl: Colors.red);
      }
      pay_id = (tmp.data as List).first[Mini_Bar_Pay.ID];

      // * ភ្ជាប់ឯកសារទូទាត់ទៅ front desk
      await dio.post(
        endpoint.FRONT_DESK_UPDATE,
        data: {
          Front_Desk.ID: map_fd?.id, //
          Front_Desk.MINI_BAR_PAY_ID: pay_id, //
        },
      );
    }

    // * ធ្វើសមកាលកម្ម item mini bar
    if (!_order_created) {
      final ok = await _sync_orders(pay_id);
      if (!ok) {
        setState(() => is_loading = false);
        return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_ITEM_UPDATE}"), cl: Colors.red);
      }
      _order_created = true;
    }

    // * កែសម្រួលស្តុក mini bar
    await _sync_stock();

    // * កត់ត្រាការទូទាត់ mini bar (តម្លៃពេញលើ mini_bar_pay)
    final clamped_return = clamp_sub_return(sub_return ?? 0, last_paid ?? 0, add_cash ?? 0, add_bank ?? 0);
    tmp = await dio.post(
      endpoint.MINI_BAR_PAY_UPDATE,
      data: {
        Mini_Bar_Pay.ID: pay_id, //
        Mini_Bar_Pay.PRICE: new_price ?? 0, //
        // * ប្រាក់សរុប = ចាស់ + ថ្មី - ប្រាក់អាប់
        Mini_Bar_Pay.CASH: prev_cash + (add_cash ?? 0) - clamped_return, //
        Mini_Bar_Pay.BANK: prev_bank + (add_bank ?? 0), //
        Mini_Bar_Pay.NOTE: note ?? "", //
      },
    );
    if (tmp == null) {
      setState(() => is_loading = false);
      return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_PAY_UPDATE}"), cl: Colors.red);
    }
    setState(() => is_loading = false);

    // * បើនៅមានសមតុល្យមិនទាន់បង់ → សម្គាល់បន្ទប់ជា Pending Pay
    if (balanced != 0 && map_room != null) {
      setState(() => is_loading = true);
      await dio.post(
        endpoint.ROOM_UPDATE, //
        data: {
          Room.ID: map_room?.id, //
          Room.STATUS: room_status.PENDING_PAY, //
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
