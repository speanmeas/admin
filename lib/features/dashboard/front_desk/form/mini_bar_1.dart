import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "../dialog/item_picker.dart";
import "mini_bar_2.dart";

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
  // * ចំនួនដែលជ្រើសរើសក្នុងមួយទំនិញ (key = item id)
  final Map<dynamic, int> _qty = {};

  // * បញ្ជីទំនិញ mini bar (catalog) ទាញពី Server
  //   List<Map<String, dynamic>> catalog = [];
  List<Mini_Bar> list_mini_bar = [];

  // * បញ្ជី order mini bar ដែលមានស្រាប់ (សម្រាប់កែសម្រួល)
  List<Order_Mini_Bar> initial_orders = [];

  // * ទាញយកបញ្ជីទំនិញ mini bar ពី Server
  void init() async {
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.MINI_BAR_CRUD_READ);
    setState(() => is_loading = false);
    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_CRUD_READ}"), cl: Colors.red);

    list_mini_bar = (tmp?.data as List<dynamic>? ?? []).map((e) => Mini_Bar.fromJson(e as Map<String, dynamic>)).toList();

    // * ទំព័របង្កើតថ្មី (Add Mini Bar) មិនមាន order ដែលមានស្រាប់ទេ
    initial_orders = [];

    // * បំពេញចំនួនដែលបានជ្រើសរើសពី order ដែលមានស្រាប់ (សម្រាប់កែសម្រួល)
    for (var o in initial_orders) {
      final id = o.mini_bar_id?.id;
      final qty = o.quantity ?? 0;
      if (id != null && qty > 0) {
        _qty[id] = qty;
      }
    }

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
                  "${_qty[item.id] ?? 0}", //
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                IconButton(
                  icon: Icon(Icons.add_circle_outline), //
                  onPressed: (_qty[item.id] ?? 0) < _stock(item) ? () => _add(item) : null,
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
                  "${(_price(item) * (_qty[item.id] ?? 0)).toStringAsFixed(2)} \$", //
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
        onPressed: next, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * បញ្ជីទំនិញដែលមានចំនួន > 0
  List<Mini_Bar> get _selected_items {
    return list_mini_bar.where((item) => (_qty[item.id] ?? 0) > 0).toList();
  }

  // * បើក dialog ជ្រើសរើសទំនិញ ហើយបញ្ចូលចំនួនដែលបានជ្រើស
  void _pick_item() async {
    final result = await showDialog<Map<dynamic, int>>(
      context: context, //
      builder: (context) => Item_Picker_(
        list_mini_bar: list_mini_bar, //
      ),
    );
    if (result == null) return;
    result.forEach((id, qty) {
      if (qty > 0) _qty[id] = qty;
      if (qty <= 0) _qty.remove(id);
    });
    setState(() {});
  }

  // * ស្តុកដែលនៅសល់ (ស្តុកសរុប - បានលក់រួច)
  int _stock(dynamic item) {
    final total = (item[Mini_Bar.STOCK] as num?)?.toInt() ?? 0;
    return total;
  }

  // * តម្លៃទំនិញមួយឯកតា
  double _price(dynamic item) => (item[Mini_Bar.PRICE] as num?)?.toDouble() ?? 0;

  // * សរុបតម្លៃទំនិញដែលបានជ្រើសរើស
  double get _total {
    var total = 0.0;
    for (var item in list_mini_bar) {
      final qty = _qty[item.id] ?? 0;
      if (qty > 0) {
        total += qty * _price(item);
      }
    }
    return total;
  }

  void _add(dynamic item) {
    final id = item[Mini_Bar.ID];
    final cur = _qty[id] ?? 0;
    if (cur < _stock(item)) {
      setState(() => _qty[id] = cur + 1);
    }
  }

  void _sub(dynamic item) {
    final id = item[Mini_Bar.ID];
    final cur = _qty[id] ?? 0;
    if (cur > 0) {
      setState(() => _qty[id] = cur - 1);
    }
  }

  // * បញ្ជាក់ការជ្រើសរើស ហើយបញ្ជូនបញ្ជីទំនិញត្រឡប់ទៅ mini_bar_2
  void next() {
    final lines = <Map<String, dynamic>>[];
    for (var item in _selected_items) {
      final qty = _qty[item.id] ?? 0;
      final price = _price(item);
      lines.add({
        Mini_Bar.ID: item.id, //
        Mini_Bar.NAME: item.name, //
        "price": price, //
        "qty": qty, //
        "total": price * qty,
      });
    }
    // Navigator.pop(context, lines);
    nav_push(
      context,
      Mini_Bar_2(
        list_mini_bar: list_mini_bar, //
        lines: lines, //
        // other_price: _total, //
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
