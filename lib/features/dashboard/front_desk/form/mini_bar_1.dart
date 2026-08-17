import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

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
  List<Map<String, dynamic>> catalog = [];

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
    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.MINI_BAR_CRUD_READ}"), cl: Colors.red);

    catalog = List<Map<String, dynamic>>.from(tmp?.data ?? []);
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
                  "${_qty[item[Mini_Bar.ID]] ?? 0}", //
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                IconButton(
                  icon: Icon(Icons.add_circle_outline), //
                  onPressed: (_qty[item[Mini_Bar.ID]] ?? 0) < _stock(item) ? () => _add(item) : null,
                ),

                SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item[Mini_Bar.NAME]} (x${_stock(item)})", //
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
                  "${(_price(item) * (_qty[item[Mini_Bar.ID]] ?? 0)).toStringAsFixed(2)} \$", //
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
        onPressed: _total > 0 ? next : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * បញ្ជីទំនិញដែលមានចំនួន > 0
  List<Map<String, dynamic>> get _selected_items {
    return catalog.where((item) => (_qty[item[Mini_Bar.ID]] ?? 0) > 0).toList();
  }

  // * បើក dialog ជ្រើសរើសទំនិញ ហើយបញ្ចូលចំនួនដែលបានជ្រើស
  void _pick_item() async {
    final result = await showDialog<Map<dynamic, int>>(
      context: context,
      builder: (context) => _Item_Picker(
        catalog: catalog, //
        stock: (item) => _stock(item),
      ),
    );
    if (result == null) return;
    setState(() {
      result.forEach((id, qty) {
        if (qty > 0) {
          _qty[id] = qty;
        } else {
          _qty.remove(id);
        }
      });
    });
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
    for (var item in catalog) {
      final qty = _qty[item[Mini_Bar.ID]] ?? 0;
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

  // * បញ្ជាក់ការជ្រើសរើស ហើយបញ្ជូនបញ្ជីទំនិញត្រឡប់ទៅ main.dart
  void next() {
    final lines = <Map<String, dynamic>>[];
    for (var item in _selected_items) {
      final qty = _qty[item[Mini_Bar.ID]] ?? 0;
      final price = _price(item);
      lines.add({Mini_Bar.ID: item[Mini_Bar.ID], Mini_Bar.NAME: item[Mini_Bar.NAME], "price": price, "qty": qty, "total": price * qty});
    }
    // Navigator.pop(context, lines);
    nav_push(
      context,
      Mini_Bar_2(
        catalog: catalog, //
        lines: lines, //
        other_price: _total, //
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * dialog ជ្រើសរើសទំនិញ mini bar ជាមួយ stepper +/- ក្នុងមួយទំនិញ
class _Item_Picker extends StatefulWidget {
  const _Item_Picker({required this.catalog, required this.stock});

  final List<Map<String, dynamic>> catalog; // * បញ្ជីទំនិញ mini bar
  final int Function(dynamic item) stock; // * គណនាស្តុកដែលនៅសល់

  @override
  State<_Item_Picker> createState() => _Item_PickerState();
}

class _Item_PickerState extends State<_Item_Picker> {
  // * ចំនួនដែលជ្រើសរើសក្នុង dialog (key = item id)
  final Map<dynamic, int> _qty = {};

  // * controller សម្រាប់ស្វែងរកទំនិញ
  final _search_controller = TextEditingController();

  // * តម្រងបញ្ជីទំនិញតាមឈ្មោះដែលស្វែងរក
  List<Map<String, dynamic>> get _list_show {
    final q = _search_controller.text.trim().toLowerCase();
    if (q.isEmpty) return widget.catalog;
    return widget.catalog.where((item) => '${item[Mini_Bar.NAME]}'.toLowerCase().contains(q)).toList();
  }

  @override
  void dispose() {
    _search_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      titlePadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          const Text(
            "Select Item", //
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // * ប៊ូតុងបិទ dialog
          IconButton(
            icon: const Icon(Icons.close, size: 24, color: Colors.red),
            padding: EdgeInsets.all(4),
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        height: 480,
        child: Column(
          children: [
            // * ប្រអប់ស្វែងរកទំនិញតាមឈ្មោះ
            Container(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _search_controller,
                        decoration: InputDecoration(
                          hintText: "Search",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                          isDense: true,
                          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.blue),
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // * បញ្ជីទំនិញដែលបានត្រង
            Expanded(
              child: widget.catalog.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _list_show.isEmpty
                  ? const Center(
                      child: Text("No item found", style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      itemCount: _list_show.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                      itemBuilder: (context, index) {
                        final item = _list_show[index];
                        final id = item[Mini_Bar.ID];
                        final selected = (_qty[id] ?? 0) > 0;
                        final price = (item[Mini_Bar.PRICE] as num?)?.toDouble() ?? 0;
                        return InkWell(
                          hoverColor: Colors.blue.withValues(alpha: 0.05),
                          onTap: () {
                            // * ជ្រើស/មិនជ្រើសទំនិញមួយម្តងៗ
                            setState(() {
                              if (selected) {
                                _qty.remove(id);
                              } else {
                                _qty[id] = 1;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border(left: selected ? const BorderSide(color: Colors.blue, width: 3) : BorderSide.none),
                            ),
                            child: Row(
                              children: [
                                // * សញ្ញាធីកបង្ហាញថាបានជ្រើសរើស
                                Icon(selected ? Icons.check_circle : Icons.radio_button_unchecked, color: selected ? Colors.blue : Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item[Mini_Bar.NAME]}", //
                                        style: TextStyle(
                                          fontSize: 16, //
                                          fontWeight: FontWeight.bold,
                                          color: selected ? Colors.blue : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "$price \$ / item", //
                                        style: const TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      actions: [
        // * ប៊ូតុងបញ្ជាក់ការជ្រើសរើស
        OutlinedButton.icon(
          icon: const Icon(Icons.check), //
          label: const Text("Done"), //
          onPressed: () => Navigator.pop(context, _qty), //
        ),
      ],
    );
  }
}

// * ថ្នាក់ Main_ ជាទំព័រមេ mini bar
class Main_ extends StatefulWidget {
  const Main_({super.key});

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
