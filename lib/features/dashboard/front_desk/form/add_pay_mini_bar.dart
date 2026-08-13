import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

import "../widget/note_bank_search.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Add Mini Bar Payment", //
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

class _Main_State extends State<Main_> {
  dynamic tmp;
  dynamic map_r;
  dynamic map_fd;
  bool is_loading = true;

  final c_price = TextEditingController();
  final c_pay_cash = TextEditingController();
  final c_pay_bank = TextEditingController();
  final c_change = TextEditingController();
  final c_note = TextEditingController();

  String? front_desk_id;
  String? room_number;
  double last_paid = 0;

  void init() async {
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
    map_r = tmp.data[0] as Map<String, dynamic>;

    if (map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID] != null) {
      tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
      map_fd = tmp.data[0] as Map<String, dynamic>;
    }

    front_desk_id = map_fd[sm_front_desk.ID];
    room_number = map_r[sm_room.NUMBER];

    double total_cash = 0, total_bank = 0, total_return = 0;
    String? last_note;
    for (var l in (map_fd["pay_mini_bar"] ?? [])) {
      last_paid += double.tryParse(l["pay_cash"]?.toString() ?? "0") ?? 0;
      last_paid += double.tryParse(l["pay_bank"]?.toString() ?? "0") ?? 0;
      last_paid -= double.tryParse(l["pay_return"]?.toString() ?? "0") ?? 0;
      total_cash += double.tryParse(l["pay_cash"]?.toString() ?? "0") ?? 0;
      total_bank += double.tryParse(l["pay_bank"]?.toString() ?? "0") ?? 0;
      total_return += double.tryParse(l["pay_return"]?.toString() ?? "0") ?? 0;
      if (l["pay_note"] != null) last_note = l["pay_note"].toString();
    }

    final price_mini_bar_list = map_fd["price_mini_bar"];
    if (price_mini_bar_list is List && price_mini_bar_list.isNotEmpty) {
      c_price.text = (double.tryParse(price_mini_bar_list.last["price"]?.toString() ?? "0") ?? 0).toString();
    }
    c_pay_cash.text = total_cash.toString();
    c_pay_bank.text = total_bank.toString();
    c_change.text = total_return.toString();
    c_note.text = last_note ?? "";

    is_loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Room: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            room_number ?? "Unknown",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Divider(height: 1, color: Colors.black),

      TextField(
        autofocus: true,
        controller: c_price,
        decoration: InputDecoration(
          labelText: "Revenue Price:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.attach_money_outlined), //
        ),
        onChanged: (v) => setState(() {}), //
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Last Payment: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            "${last_paid.toStringAsFixed(2)} \$",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      TextField(
        controller: c_pay_cash,
        decoration: InputDecoration(
          labelText: "Cash Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.payments_outlined), //
        ),
        onChanged: (v) => setState(() {}), //
      ),

      TextField(
        controller: c_pay_bank,
        decoration: InputDecoration(
          labelText: "Bank Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.account_balance_outlined),
        ),
        onChanged: (v) => setState(() {}), //
      ),

      TextField(
        controller: c_change,
        decoration: InputDecoration(
          labelText: "Return:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.currency_exchange_outlined),
        ),
        onChanged: (v) => setState(() {}), //
      ),

      NoteBankSearch(
        controller: c_note, //
        onChanged: (v) => setState(() {}), //
      ),

      Divider(color: Colors.black),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Balanced: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

      OutlinedButton.icon(
        icon: Icon(Icons.add), //
        label: Text("Add Payment"), //
        onPressed: balanced == 0 ? on_pay : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  double get balanced {
    double price = double.tryParse(c_price.text) ?? 0;
    double pay_cash = double.tryParse(c_pay_cash.text) ?? 0;
    double pay_bank = double.tryParse(c_pay_bank.text) ?? 0;
    double change = double.tryParse(c_change.text) ?? 0;
    return (pay_cash + pay_bank + last_paid) - price - change;
  }

  void on_pay() async {
    try {
      double price = double.tryParse(c_price.text) ?? 0;
      double pay_cash = double.tryParse(c_pay_cash.text) ?? 0;
      double pay_bank = double.tryParse(c_pay_bank.text) ?? 0;
      double change = double.tryParse(c_change.text) ?? 0;

      await dio.post(
        endpoint.FRONT_DESK_ADD_PAY_MINI_BAR,
        data: {
          sm_front_desk.ID: front_desk_id, //
          "item_id": widget.item_id, //
          "item_quantity": 1, //
          "pay_price": price, //
          "pay_cash": pay_cash, //
          "pay_bank": pay_bank, //
          "pay_return": change, //
          "pay_note": c_note.text, //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

//
class Main_ extends StatefulWidget {
  const Main_({
    super.key,
    this.room_id, //
    this.item_id, //
  });

  final String? room_id;
  final String? item_id;

  @override
  State<Main_> createState() => _Main_State();
}

//
void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
