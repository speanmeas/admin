import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n.dart";

import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/mini_bar.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Mini Bar Charge", //
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

class _Charge_State extends State<Charge_> {
  // * ចំនួនដែលជ្រើសរើសក្នុងមួយទំនិញ (key = item id)
  final Map<dynamic, int> _qty = {};

  // * ស្តុកដែលនៅសល់ (ស្តុកសរុប - បានលក់រួច)
  int _stock(dynamic item) {
    final total = (item[sm_mini_bar.STOCK] as num?)?.toInt() ?? 0;
    final sold = widget.sold[item[sm_mini_bar.ID]] ?? 0;
    return total - sold;
  }

  // * សរុបតម្លៃទំនិញដែលបានជ្រើសរើស
  double get _total {
    var total = 0.0;
    for (var item in widget.catalog) {
      final qty = _qty[item[sm_mini_bar.ID]] ?? 0;
      if (qty > 0) {
        total += qty * ((item[sm_mini_bar.PRICE] as num?)?.toDouble() ?? 0);
      }
    }
    return total;
  }

  void _add(dynamic item) {
    final id = item[sm_mini_bar.ID];
    final cur = _qty[id] ?? 0;
    if (cur < _stock(item)) {
      setState(() => _qty[id] = cur + 1);
    }
  }

  void _sub(dynamic item) {
    final id = item[sm_mini_bar.ID];
    final cur = _qty[id] ?? 0;
    if (cur > 0) {
      setState(() => _qty[id] = cur - 1);
    }
  }

  // * បញ្ជាក់ការជ្រើសរើស ហើយបញ្ជូនបញ្ជីទំនិញត្រឡប់ទៅ main.dart
  void _confirm() {
    final lines = <Map<String, dynamic>>[];
    for (var item in widget.catalog) {
      final qty = _qty[item[sm_mini_bar.ID]] ?? 0;
      if (qty > 0) {
        final price = (item[sm_mini_bar.PRICE] as num?)?.toDouble() ?? 0;
        lines.add({
          sm_mini_bar.ID: item[sm_mini_bar.ID],
          sm_mini_bar.NAME: item[sm_mini_bar.NAME],
          "price": price,
          "qty": qty,
          "total": price * qty,
        });
      }
    }
    Navigator.pop(context, lines);
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      // * បង្ហាញបន្ទប់ ឬ Walk-in
      if (widget.room != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Room ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.room[sm_room.NUMBER]}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        )
      else
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_outlined, color: Colors.purple),
            SizedBox(width: 4),
            Text(
              "Walk-in",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),

      Divider(height: 1, color: Colors.black),

      // * បញ្ជីទំនិញ mini bar ជាមួយប៊ូតុង +/- ជ្រើសរើសចំនួន
      for (var item in widget.catalog)
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item[sm_mini_bar.NAME]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${(item[sm_mini_bar.PRICE] as num?)?.toDouble() ?? 0} \$  (stock: ${_stock(item)})",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: (_qty[item[sm_mini_bar.ID]] ?? 0) > 0
                    ? () => _sub(item)
                    : null,
              ),
              Text(
                "${_qty[item[sm_mini_bar.ID]] ?? 0}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: (_qty[item[sm_mini_bar.ID]] ?? 0) < _stock(item)
                    ? () => _add(item)
                    : null,
              ),
            ],
          ),
        ),

      Divider(height: 1, color: Colors.black),

      // * សរុបតម្លៃ
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Total: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "${_total.toStringAsFixed(2)} \$",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),

      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text("Confirm"), //
        onPressed: _total > 0 ? _confirm : null, //
      ),
    ]);
  }
}

class Charge_ extends StatefulWidget {
  const Charge_({
    super.key,
    this.room,
    this.catalog = const [],
    this.sold = const {},
  });

  final dynamic room; // * បន្ទប់ (null = walk-in)
  final List<Map<String, dynamic>> catalog; // * បញ្ជីទំនិញ mini bar
  final Map<dynamic, int> sold; // * ចំនួនដែលបានលក់រួចហើយ

  @override
  State<Charge_> createState() => _Charge_State();
}

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
      child: Charge_(),
    ),
  );
}
