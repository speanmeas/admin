import "package:flutter/material.dart";

import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/mini_bar.g.dart";
import "package:speanmeas/core/schema/room.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/widget/snackbar.dart";

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

class Charge_ extends StatefulWidget {
  //
  final dynamic room;
  final List<Map<String, dynamic>> catalog;
  final Map<dynamic, int> sold; // * ចំនួនដែលបានលក់/គិតប្រាក់រួចហើយ (item id → qty)
  //
  const Charge_({
    super.key, //
    required this.room, //
    required this.catalog, //
    this.sold = const {}, //
  });
  //
  @override
  State<Charge_> createState() => _Charge_State();
  //
}

class _Charge_State extends State<Charge_> {
  //
  // * catalog item id → qty
  final map_qty = <dynamic, int>{};

  // * ប្រអប់ស្វែងរកទំនិញ mini bar
  final c_search = TextEditingController();
  String q = "";

  //
  // * បញ្ជីទំនិញបន្ទាប់ពីត្រងតាមពាក្យស្វែងរក (ឈ្មោះ)
  List<Map<String, dynamic>> get _catalog_filtered => q.isEmpty ? widget.catalog : widget.catalog.where((item) => "${item[sm_mini_bar.NAME]}".toLowerCase().contains(q)).toList();

  @override
  void dispose() {
    c_search.dispose();
    super.dispose();
  }

  //
  // * សរុបតម្លៃទំនិញដែលបានជ្រើស
  double get _total {
    var total = 0.0;
    for (var item in widget.catalog) {
      final qty = map_qty[item[sm_mini_bar.ID]] ?? 0;
      if (qty > 0) {
        total += (item[sm_mini_bar.PRICE] as num).toDouble() * qty;
      }
    }
    return total;
  }

  //
  bool get _has_items => _total > 0;

  //
  // * កំណត់ចំនួនទំនិញ
  void _set_qty(dynamic id, int qty) {
    final remaining = _remaining(id);
    if (remaining != null && qty > remaining) qty = remaining; // * កំណត់មិនឲ្យលើសស្តុក
    setState(() {
      if (qty <= 0) {
        map_qty.remove(id);
      } else {
        map_qty[id] = qty;
      }
    });
  }

  //
  // * ចំនួនស្តុកដែលនៅសល់អាចលក់បាន (stock - បានលក់ហើយ)
  // * (stock គ្មានតម្លៃ = គ្មានដែនកំណត់)
  int? _remaining(dynamic id) {
    dynamic stock;
    for (var item in widget.catalog) {
      if (item[sm_mini_bar.ID] == id) {
        stock = item[sm_mini_bar.STOCK];
        break;
      }
    }
    if (stock == null) return null;
    final remain = (stock as num).toInt() - (widget.sold[id] ?? 0);
    return remain < 0 ? 0 : remain;
  }

  //
  // * បញ្ជាក់ការបន្ថែមទំនិញ
  // * (បើមានបន្ទប់៖ បញ្ជូនទំនិញនីមួយៗទៅ Server តាម /front_desk/form/add_pay_mini_bar
  // *  walk-in (គ្មានបន្ទប់)៖ រក្សាទុកទាំងអស់ទៅ Server តាម /front_desk/form/add_walkin_mini_bar
  // *  ដើម្បីឲ្យ report រាប់តាមថ្ងៃ)
  void on_confirm() async {
    final charges = <Map<String, dynamic>>[];
    for (var item in widget.catalog) {
      final qty = map_qty[item[sm_mini_bar.ID]] ?? 0;
      if (qty > 0) {
        final price = (item[sm_mini_bar.PRICE] as num).toDouble();
        charges.add({
          sm_mini_bar.ID: item[sm_mini_bar.ID], //
          sm_mini_bar.NAME: item[sm_mini_bar.NAME], //
          sm_mini_bar.PRICE: price, //
          "qty": qty, //
          "total": price * qty, //
        });
      }
    }

    try {
      // * គិតប្រាក់ទៅបន្ទប់៖ បញ្ជូនទំនិញនីមួយៗទៅកាន់ Server
      if (widget.room != null) {
        final front_desk_id = widget.room[sm_room.FRONT_DESK_ID];
        for (var l in charges) {
          await dio.post(
            endpoint.FRONT_DESK_ADD_PAY_MINI_BAR,
            data: {
              sm_front_desk.ID: front_desk_id, //
              "item_id": l[sm_mini_bar.ID], //
              "item_quantity": l["qty"], //
              "pay_price": l[sm_mini_bar.PRICE], //
              "pay_note": "", //
            },
          );
        }
      } else {
        for (var l in charges) {
          await dio.post(
            endpoint.FRONT_DESK_ADD_PAY_MINI_BAR,
            data: {
              "item_id": l[sm_mini_bar.ID], //
              "item_quantity": l["qty"], //
              "pay_price": l[sm_mini_bar.PRICE], //
              "pay_note": "", //
            },
          );
        }
      }

      Navigator.pop(context, charges);
      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final room_number = widget.room != null ? widget.room[sm_room.NUMBER] : null;
    return _layout([
      // * ព័ត៌មានបន្ទប់ ឬ អតិថិជនដើរចូលទិញ (Walk-in)
      if (widget.room != null)
        Row(
          spacing: 4,
          children: [
            Icon(Icons.meeting_room_outlined, size: 24), //
            Text("បន្ទប់:", style: TextStyle(fontWeight: FontWeight.bold)), //
            Text(
              "$room_number",
              style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
            ), //
            //
            SizedBox(width: 8), //
            Icon(Icons.circle, size: 10, color: Colors.orange), //
            Text("${widget.room[sm_room.STATUS]}", style: TextStyle(color: Colors.orange)), //
          ],
        )
      else
        Row(
          spacing: 4,
          children: [
            Icon(Icons.person_add_outlined, size: 24, color: Colors.purple), //
            Text("Walk-in:", style: TextStyle(fontWeight: FontWeight.bold)), //
            //
            SizedBox(width: 4), //
            Icon(Icons.circle, size: 6), //
            Text("អតិថិជនដើរចូលទិញ (មិនស្នាក់នៅបន្ទប់)", style: TextStyle(color: Colors.purple)), //
          ],
        ),

      // * ប្រអប់ស្វែងរកទំនិញ mini bar
      TextField(
        controller: c_search,
        onChanged: (v) => setState(() => q = v.trim().toLowerCase()),
        decoration: InputDecoration(
          hintText: "ស្វែងរកទំនិញ...", //
          prefixIcon: Icon(Icons.search), //
          isDense: true, //
          border: OutlineInputBorder(), //
        ),
      ),

      Divider(height: 1, color: Colors.grey), //
      // * បញ្ជីទំនិញ mini bar
      if (widget.catalog.isEmpty)
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          child: Text(
            "គ្មានទំនិញ mini bar ទេ (សូមបន្ថែមទំនិញក្នុង Data Mini Bar ជាមុន)", //
            style: TextStyle(color: Colors.red),
          ),
        )
      else if (_catalog_filtered.isEmpty)
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          child: Text(
            "រកមិនឃើញទំនិញ \"$q\"", //
            style: TextStyle(color: Colors.red),
          ),
        )
      else
        for (var item in _catalog_filtered)
          (() {
            final item_id = item[sm_mini_bar.ID];
            final qty = map_qty[item_id] ?? 0;
            final price = (item[sm_mini_bar.PRICE] as num).toDouble();
            final remaining = _remaining(item_id);
            return Container(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
              child: Row(
                children: [
                  // info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${item[sm_mini_bar.NAME]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("${price.toStringAsFixed(2)} \$", style: TextStyle(fontSize: 14, color: Colors.blue)),
                        if (remaining != null)
                          Text(
                            "Remaining: $remaining", //
                            style: TextStyle(fontSize: 12, color: remaining == 0 ? Colors.red : Colors.green),
                          ),
                      ],
                    ),
                  ),

                  // qty stepper
                  IconButton(
                    onPressed: qty > 0 ? () => _set_qty(item_id, qty - 1) : null, //
                    icon: Icon(Icons.remove_circle_outline),
                    color: Colors.red, //
                  ),

                  SizedBox(
                    width: 40,
                    child: Text(
                      "$qty", //
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  IconButton(
                    onPressed: remaining == null || qty < remaining ? () => _set_qty(item_id, qty + 1) : null, //
                    icon: Icon(Icons.add_circle_outline),
                    color: Colors.green, //
                  ),
                ],
              ),
            );
          })(),

      Divider(height: 1, color: Colors.grey), //
      // * សរុបតម្លៃ
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
        child: Row(
          children: [
            Text("សរុប:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
            Spacer(), //
            Text(
              "$_total \$",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ), //
          ],
        ),
      ),

      // * បញ្ជាក់
      OutlinedButton.icon(
        onPressed: _has_items ? on_confirm : null, //
        icon: Icon(Icons.check),
        label: Text("Confirm"),
        style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.green)),
      ),
    ]);
  }
}

//
void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Charge_(
        room: null, //
        catalog: [
          {sm_mini_bar.ID: "a", sm_mini_bar.NAME: "Coca Cola", sm_mini_bar.PRICE: 1.5}, //
          {sm_mini_bar.ID: "b", sm_mini_bar.NAME: "Beer Angkor", sm_mini_bar.PRICE: 2.0}, //
          {sm_mini_bar.ID: "c", sm_mini_bar.NAME: "Water", sm_mini_bar.PRICE: 0.5}, //
        ],
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
