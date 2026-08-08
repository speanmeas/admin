import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/room.g.dart";
import "../schema.g.dart" as sm_fd;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Room Payment", //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      centerTitle: false,
      toolbarHeight: 40,
      titleSpacing: 0,

      // Add a divider at the bottom of the app bar
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
  //
  dynamic tmp;
  final c_price = TextEditingController();
  final c_pay_bank = TextEditingController();
  final c_pay_cash = TextEditingController();
  final c_change = TextEditingController();
  final c_note = TextEditingController();

  void init() async {
    try {
      sm_fd.clear();
      sm_room.clear();

      tmp = await dio.post(endpoint.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
      for (var e in sm_room.data.entries) e.value["value"] = tmp.data[0][e.key];

      if (sm_room.data[sm_room.FRONT_DESK_ID]!["value"] != null) {
        tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_fd.ID: sm_room.data[sm_room.FRONT_DESK_ID]!["value"]});
        for (var e in sm_fd.data.entries) e.value["value"] = tmp.data[0][e.key];
      }

      c_price.text = sm_fd.data[sm_fd.ROOM_PRICE]?["value"]?.toString() ?? "";
      c_pay_cash.text = sm_fd.data[sm_fd.ROOM_PAY_CASH]?["value"]?.toString() ?? "";
      c_pay_bank.text = sm_fd.data[sm_fd.ROOM_PAY_BANK]?["value"]?.toString() ?? "";
      c_change.text = sm_fd.data[sm_fd.ROOM_RETURN]?["value"]?.toString() ?? "";
      c_note.text = sm_fd.data[sm_fd.ROOM_PAY_NOTE]?["value"]?.toString() ?? "";

      setState(() {});
      //
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // room price
      TextField(
        controller: c_price,
        decoration: InputDecoration(
          labelText: "Room Price:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.attach_money_outlined), //
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),

      // payment
      TextField(
        controller: c_pay_cash,
        decoration: InputDecoration(
          labelText: "Cash Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.payments_outlined), //
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),

      // payment
      TextField(
        controller: c_pay_bank,
        decoration: InputDecoration(
          labelText: "Bank Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.account_balance_outlined),
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),

      // return
      TextField(
        controller: c_change,
        decoration: InputDecoration(
          labelText: "Return:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.currency_exchange_outlined),
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),

      // note
      TextField(
        controller: c_note,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "Note:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.note_alt_outlined), //
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),

      Divider(color: Colors.black),

      // balanced
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Balanced: ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold, //
            ),
          ),

          Text(
            "$balanced\$",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold, //
              color: balanced == 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),

      //
      OutlinedButton.icon(
        icon: Icon(Icons.payment), //
        label: Text("Payment"), //
        onPressed: can_pay ? on_pay : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  bool get can_pay {
    double price = double.tryParse(c_price.text) ?? 0;

    if (price <= 0) return false;
    if (balanced != 0) return false;
    return true;
  }

  double get balanced {
    double price = double.tryParse(c_price.text) ?? 0;
    double pay_cash = double.tryParse(c_pay_cash.text) ?? 0;
    double pay_bank = double.tryParse(c_pay_bank.text) ?? 0;
    double change = double.tryParse(c_change.text) ?? 0;
    return (pay_cash + pay_bank) - price - change;
  }

  void on_pay() async {
    try {
      //

      double price = double.tryParse(c_price.text) ?? 0;
      double pay_cash = double.tryParse(c_pay_cash.text) ?? 0;
      double pay_bank = double.tryParse(c_pay_bank.text) ?? 0;
      double change = double.tryParse(c_change.text) ?? 0;

      await dio.post(
        endpoint.FRONT_DESK_FORM_PAY_ROOM,
        data: {
          sm_fd.ID: sm_fd.data[sm_fd.ID]!["value"], //
          sm_fd.ROOM_PRICE: price, //
          sm_fd.ROOM_PAY_CASH: pay_cash, //
          sm_fd.ROOM_PAY_BANK: pay_bank, //
          sm_fd.ROOM_RETURN: change, //
          sm_fd.ROOM_PAY_NOTE: c_note.text, //
        },
      );

      await dio.post(
        endpoint.ROOM_UPDATE, //
        data: {
          sm_room.ID: sm_room.data[sm_room.ID]!["value"], //
          sm_room.STATUS: "Pending Leave", //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
      //
    } catch (e, st) {
      print(st);
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
  });

  final String? room_id;

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
