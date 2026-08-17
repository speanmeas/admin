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
  // * ចំនួនដែលជ្រើសរើសក្នុងមួយទំនិញ (key = item id)
  // final Map<dynamic, int> _qty = {};

  String tag = "Walk-in";
  List<String> options = ["Walk-in"];

  // * បញ្ជីទំនិញ mini bar (catalog) ទាញពី Server
  List<Mini_Bar> list_mini_bar = [];

  dynamic tmp;
  Room? map_room;
  bool _order_created = false;
  bool is_loading = true;

  double? new_price;
  double? old_price;
  double? last_paid;
  double? pay_cash;
  double? pay_bank;
  double? pay_return;
  String? pay_note;

  List<Room> rooms = [];

  // * ទាញយកបញ្ជីទំនិញ mini bar ពី Server
  void init() async {
    list_mini_bar = widget.list_mini_bar;

    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ);
    setState(() => is_loading = false);
    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ}"), cl: Colors.red);

    rooms = List<Room>.from((tmp?.data ?? []).map((e) => Room.fromJson(e)));

    // * បង្កើត options ពីបន្ទប់ដែលមានស្ថានភាព Pending Pay ឬ Pending Leave
    options = ["Walk-in"];
    for (var r in rooms) {
      final st = r.status ?? "";
      if (st == room_status.PENDING_PAY || st == room_status.PENDING_LEAVE) {
        options.add(r.number ?? "");
      }
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
        options: options, //
        noClear: true,
        onChanged: (v) {
          tag = v;
          // * កំណត់ map_room តាមបន្ទប់ដែលបានជ្រើសរើស
          map_room = null;
          for (var r in rooms) {
            if (r.number == v) {
              map_room = r;
              break;
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
          new_price = v;
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
        icon: Icon(Icons.payment), //
        label: Text(t("Payment")), //
        onPressed: can_add ? on_add : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * គណនាបានប្រាក់សំណើរ = ប្រាក់ទទួលសរុប - តម្លៃថ្មីសរុប
  double get balanced {
    double temp = 0;

    temp = temp + (pay_cash ?? 0);
    temp = temp + (pay_bank ?? 0);
    temp = temp + (last_paid ?? 0);
    temp = temp - (new_price ?? 0);
    temp = temp - (pay_return ?? 0);

    return temp;
  }

  // * walk-in ត្រូវបង់ពេញឥឡូវនេះ (balanced == 0) បន្ទប់អាចបង់បានគ្រប់ពេល
  bool get can_add {
    if (tag != "Walk-in") return true;

    if (balanced != 0) return false;

    return true;
  }

  // * ត្រឡប់ true បើបង្កើតបានជោគជ័យទាំងអស់
  Future<bool> _create_orders() async {
    // * walk-in គ្មាន front_desk ដូច្នេះមិនអាចបង្កើត order បានទេ
    if (map_room?.front_desk_id?.id == null) return false;

    for (var l in widget.lines) {
      final qty = (l["qty"] as num?)?.toInt() ?? 0;
      if (qty <= 0) continue;

      final r = await dio.post(
        endpoint.ORDER_MINI_BAR_CRUD_CREATE, //
        data: {
          Order_Mini_Bar.MINI_BAR_ID: l[Mini_Bar.ID], //
          Order_Mini_Bar.QUANTITY: qty, //
          Order_Mini_Bar.FRONT_DESK_ID: map_room?.front_desk_id?.id, //
        },
      );
      if (r == null) return false;
    }
    return true;
  }

  // * អនុវត្តការបន្ថែមការទូទាត់ mini bar
  void on_add() async {
    setState(() => is_loading = true);

    // * បង្កើត order mini bar បើមិនទាន់មាន (តែពេល tag ជាបន្ទប់)
    if (!_order_created && map_room?.front_desk_id?.id != null) {
      final ok = await _create_orders();
      if (!ok) {
        setState(() => is_loading = false);
        return snackbar(ct: context, ms: t("Error: ${endpoint.ORDER_MINI_BAR_CRUD_CREATE}"), cl: Colors.red);
      }
      _order_created = true;
    }

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
    required this.lines,
  });

  final List<Mini_Bar> list_mini_bar;
  final List<Map> lines; //

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
          lines: [], //
        ), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
