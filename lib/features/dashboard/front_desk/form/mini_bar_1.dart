import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "../dialog/pick_item.dart";
import "mini_bar_2.dart" as mini_bar_2;

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
          value: 1 / 2, // fixed bar (no animation)
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

  List<Mini_Bar> list_mini_bar = [];
  List<Order_Mini_Bar> list_order_mini_bar = [];

  // * ទាញយកបញ្ជីទំនិញ mini bar ពី Server
  void init() async {
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.MINI_BAR_CRUD_READ);
    setState(() => is_loading = false);
    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_CRUD_READ}"), cl: Colors.red);

    list_mini_bar = (tmp?.data as List<dynamic>? ?? []).map((e) => Mini_Bar.fromJson(e as Map<String, dynamic>)).toList();

    // * ទំព័របង្កើតថ្មី (Add Mini Bar) មិនមាន order ដែលមានស្រាប់ទេ
    list_order_mini_bar = [];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បញ្ជីទំនិញដែលបានជ្រើសរើសរួច
      if (_selected_items.isEmpty)
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.grey.withValues(alpha: 0.05),
          ),
          child: Center(
            child: Text(
              "No item selected", //
              style: TextStyle(color: Colors.grey),
            ),
          ),
        )
      else
        for (var item in _selected_items)
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.blue),
                  onPressed: () => _sub(item),
                ),

                Text(
                  "${_qty_of(item.id)}", //
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                IconButton(
                  icon: Icon(Icons.add_circle_outline), //
                  onPressed: _qty_of(item.id) < _stock(item) ? () => _add(item) : null,
                ),

                SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.name} (x${_stock(item)})", //
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, //
                        ),
                      ),
                      Text(
                        "${_price(item)} \$ / Item", //
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),

                Text(
                  "${(_price(item) * _qty_of(item.id)).toStringAsFixed(2)} \$", //
                  style: TextStyle(
                    fontSize: 18, //
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                SizedBox(width: 8),
              ],
            ),
          ),

      Divider(height: 1, color: Colors.black),

      // * សរុបតម្លៃ
      Row(
        children: [
          // * ប៊ូតុងបើក dialog ជ្រើសរើសទំនិញ mini bar
          OutlinedButton.icon(
            icon: Icon(Icons.add_circle_outline, color: Colors.blue), //
            label: Text("Add Item"), //
            onPressed: () => _pick_item(),
          ),

          Spacer(),

          Text("Total: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            "${_total.toStringAsFixed(2)} \$",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      // if tag is not walk-in, show payment method
      OutlinedButton.icon(
        icon: Icon(Icons.arrow_forward), //
        label: Text("Next"), //
        onPressed: can_next ? next : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * បញ្ជីទំនិញដែលមានចំនួន > 0
  List<Mini_Bar> get _selected_items {
    return list_mini_bar.where((item) => _qty_of(item.id) > 0).toList();
  }

  // * ចំនួនទំនិញតាម id (0 បើមិនទាន់មានក្នុង list_order_mini_bar)
  int _qty_of(String? id) {
    for (var o in list_order_mini_bar) {
      if (o.mini_bar_id?.id == id) return o.quantity ?? 0;
    }
    return 0;
  }

  // * បើក dialog ជ្រើសរើសទំនិញ (កែប្រែ list_order_mini_bar ផ្ទាល់)
  void _pick_item() async {
    await showDialog(
      context: context, //
      builder: (context) => Pick_Item(
        list_mini_bar: list_mini_bar, //
        list_order_mini_bar: list_order_mini_bar, //
      ),
    );
    setState(() {});
  }

  // * ស្តុកដែលនៅសល់ (ស្តុកសរុប - បានលក់រួច)
  int _stock(Mini_Bar item) {
    final total = (item.stock ?? 0).toInt();
    return total;
  }

  // * តម្លៃទំនិញមួយឯកតា
  double _price(Mini_Bar item) => item.price ?? 0;

  // * កំណត់ចំនួនទំនិញឡើងវិញ (លុបចោលបើ qty = 0)
  void _set_qty(Mini_Bar item, int qty) {
    list_order_mini_bar.removeWhere((o) => o.mini_bar_id?.id == item.id);
    if (qty > 0) {
      list_order_mini_bar.add(
        Order_Mini_Bar(
          mini_bar_id: Mini_Bar_Show(id: item.id, name: item.name, price: item.price),
          quantity: qty,
        ),
      );
    }
  }

  // * សរុបតម្លៃទំនិញដែលបានជ្រើសរើស
  double get _total {
    var total = 0.0;
    for (var o in list_order_mini_bar) {
      final qty = o.quantity ?? 0;
      if (qty > 0) {
        total += qty * (o.mini_bar_id?.price ?? 0);
      }
    }
    return total;
  }

  void _add(Mini_Bar item) {
    final cur = _qty_of(item.id);
    if (cur < _stock(item)) {
      setState(() => _set_qty(item, cur + 1));
    }
  }

  void _sub(Mini_Bar item) {
    final cur = _qty_of(item.id);
    if (cur > 0) {
      setState(() => _set_qty(item, cur - 1));
    }
  }

  bool get can_next {
    if (list_order_mini_bar.isEmpty) return false;

    return true;
  }

  // * បញ្ជាក់ការជ្រើសរើស ហើយបញ្ជូនបញ្ជីទំនិញត្រឡប់ទៅ mini_bar_2
  void next() {
    nav_push(
      context,
      mini_bar_2.Main_(
        list_mini_bar: list_mini_bar, //
        list_order_mini_bar: list_order_mini_bar, //
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រមេ mini bar
class Main_ extends StatefulWidget {
  const Main_({super.key, this.room_id});

  final String? room_id; // * id បន្ទប់ដែលកំពុងកែសម្រួល

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
