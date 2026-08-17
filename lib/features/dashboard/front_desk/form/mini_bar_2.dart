import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/enum/room_status.dart" as room_status;
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
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;

  String tag = "Walk-in";
  List<String> tag_options = ["Walk-in"];

  late List<Mini_Bar> list_mini_bar = widget.list_mini_bar;
  late List<Order_Mini_Bar> list_order_mini_bar = widget.list_order_mini_bar;
  late List<Room> list_room = [];

  Room? select_room;

  double? new_price;
  double? add_cash;
  double? add_bank;
  double? sub_return;
  String? note;

  // * ទាញយកបញ្ជីទំនិញ mini bar ពី Server
  void init() async {
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ);
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ}"), cl: Colors.red);

    list_room = List<Room>.from((tmp?.data ?? []).map((e) => Room.fromJson(e)));

    // * បង្កើត options ពីបន្ទប់ដែលមានស្ថានភាព Pending Pay ឬ Pending Leave
    for (var r in list_room) {
      final st = r.status ?? "";
      if (st == room_status.PENDING_PAY || st == room_status.PENDING_LEAVE) {
        tag_options.add(r.number ?? "");
      }
    }

    // calcualte new price
    for (var l in list_order_mini_bar) {
      int qty = l.quantity ?? 0;
      double price = l.mini_bar_id?.price ?? 0;
      new_price = (new_price ?? 0) + qty * price;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      Select_Dynamic(
        lead: "Tag:",
        prefixIcon: Icons.sell_outlined, //
        init: tag, //
        options: tag_options, //
        noClear: true,
        onChanged: (v) {
          tag = v;
          if (tag == "Walk-in") select_room = null;
          if (tag != "Walk-in") {
            select_room = null;
            for (var e in list_room) {
              if (e.number == v) {
                select_room = e;
                break;
              }
            }
          }
          setState(() {});
        },
      ),

      Divider(height: 1, color: Colors.black),

      // * បញ្ចូលតម្លៃផ្សេងៗ
      Input_Number(
        init: new_price, //
        lead: '${t("Mini Bar Price")}:', //
        onChanged: (v) {
          new_price = v ?? 0;
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
        icon: Icon(Icons.payment), //
        label: Text(t("Payment")), //
        onPressed: can_pay ? on_add : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * គណនាបានប្រាក់សំណើរ = ប្រាក់ទទួលសរុប - តម្លៃថ្មីសរុប
  double get balanced {
    double temp = 0;

    temp = temp - (new_price ?? 0);
    temp = temp + (add_cash ?? 0);
    temp = temp + (add_bank ?? 0);
    temp = temp - (sub_return ?? 0);

    return temp;
  }

  // * walk-in ត្រូវបង់ពេញឥឡូវនេះ (balanced == 0) បន្ទប់អាចបង់បានគ្រប់ពេល
  bool get can_pay {
    if (tag == "Walk-in") //
      if (balanced != 0) //
        return false;
    return true;
  }

  void on_add() {
    if (select_room == null) on_add_walk_in();
    if (select_room != null) on_add_room();
  }

  // * អនុវត្តការបន្ថែមការទូទាត់ mini bar
  void on_add_walk_in() async {
    // create blank front_desk
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.FRONT_DESK_CRUD_CREATE);
    setState(() => is_loading = false);

    // * ពិនិត្យលទ្ធផលមុនបន្ត (dio ត្រឡប់ null ពេលបរាជ័យ)
    if (tmp == null || tmp.data == null || tmp.data is! List || (tmp.data as List).isEmpty) {
      return snackbar(ct: context, ms: t("Error: ${endpoint.FRONT_DESK_CRUD_CREATE}"), cl: Colors.red);
    }

    var front_desk = Front_Desk.fromJson((tmp.data as List).first as Map<String, dynamic>);

    //
    setState(() => is_loading = true);
    for (var l in list_order_mini_bar) {
      await dio.post(
        endpoint.ORDER_MINI_BAR_CRUD_CREATE, //
        data: {
          Order_Mini_Bar.MINI_BAR_ID: l.mini_bar_id?.id, //
          Order_Mini_Bar.QUANTITY: l.quantity, //
          Order_Mini_Bar.FRONT_DESK_ID: front_desk.id, //
        },
      );
    }
    setState(() => is_loading = false);

    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_PAY_MINI_BAR,
      data: {
        Front_Desk.ID: front_desk.id, //
        Pay_Mini_Bar.ADD_PRICE: new_price, //
        Pay_Mini_Bar.SUB_PRICE: null,
        Pay_Mini_Bar.ADD_CASH: add_cash, //
        Pay_Mini_Bar.ADD_BANK: add_bank, //
        Pay_Mini_Bar.SUB_RETURN: sub_return, //
        Pay_Mini_Bar.NOTE: note, //
      },
    );
    setState(() => is_loading = false);

    // * កាត់បន្ថយស្តុក mini bar តាមចំនួនដែលបានលក់
    for (var l in list_order_mini_bar) {
      final match = widget.list_mini_bar.where((m) => m.id == l.mini_bar_id?.id).toList();
      if (match.isEmpty) continue;
      final new_stock = (match[0].stock ?? 0) - (l.quantity ?? 0);
      await dio.post(
        endpoint.MINI_BAR_CRUD_UPDATE, //
        data: {
          Mini_Bar.ID: match[0].id, //
          Mini_Bar.STOCK: new_stock, //
        },
      );
    }

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  // * អនុវត្តការបន្ថែមការទូទាត់ mini bar
  void on_add_room() async {
    setState(() => is_loading = true);
    for (var l in widget.list_order_mini_bar) {
      await dio.post(
        endpoint.ORDER_MINI_BAR_CRUD_CREATE, //
        data: {
          Order_Mini_Bar.MINI_BAR_ID: l.mini_bar_id?.id, //
          Order_Mini_Bar.QUANTITY: l.quantity, //
          Order_Mini_Bar.FRONT_DESK_ID: select_room?.front_desk_id?.id, //
        },
      );
    }
    setState(() => is_loading = false);

    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_PAY_MINI_BAR,
      data: {
        Front_Desk.ID: select_room?.front_desk_id?.id, //
        Pay_Mini_Bar.ADD_PRICE: new_price, //
        Pay_Mini_Bar.SUB_PRICE: null,
        Pay_Mini_Bar.ADD_CASH: add_cash, //
        Pay_Mini_Bar.ADD_BANK: add_bank, //
        Pay_Mini_Bar.SUB_RETURN: sub_return, //
        Pay_Mini_Bar.NOTE: note, //
      },
    );
    setState(() => is_loading = false);

    // * បើនៅមានសមតុល្យមិនទាន់បង់ → សម្គាល់បន្ទប់ជា Pending Pay
    setState(() => is_loading = true);
    if (balanced != 0 && select_room != null) //
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          Room.ID: select_room?.id, //
          Room.STATUS: room_status.PENDING_PAY, //
        },
      );
    setState(() => is_loading = false);

    // * កាត់បន្ថយស្តុក mini bar តាមចំនួនដែលបានលក់
    for (var l in widget.list_order_mini_bar) {
      final match = widget.list_mini_bar.where((m) => m.id == l.mini_bar_id?.id).toList();
      if (match.isEmpty) continue;
      final new_stock = (match[0].stock ?? 0) - (l.quantity ?? 0);
      await dio.post(
        endpoint.MINI_BAR_CRUD_UPDATE, //
        data: {
          Mini_Bar.ID: match[0].id, //
          Mini_Bar.STOCK: new_stock, //
        },
      );
    }

    snackbar(ct: context, ms: "Success", cl: Colors.green);
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
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    required this.list_mini_bar,
    required this.list_order_mini_bar,
  });

  final List<Mini_Bar> list_mini_bar;
  final List<Order_Mini_Bar> list_order_mini_bar;

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
        home: Main_(
          list_mini_bar: [], //
          list_order_mini_bar: [], //
        ), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
