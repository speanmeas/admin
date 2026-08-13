// * OK

import "package:flutter/material.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import

import "package:speanmeas/core/widget/input/input_bank_auto.dart";
import "package:speanmeas/core/widget/input/input_number.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

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
  bool is_submitting = false;

  String? front_desk_id;
  String? room_number;

  double? pay_price;
  double? last_paid;
  double? pay_cash;
  double? pay_bank;
  double? pay_return;
  String? pay_note;

  void init() async {
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
    map_r = tmp.data[0] as Map<String, dynamic>;
    // pprint(map_r);

    if (map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID] == null) throw Exception("Front desk ID is null");

    tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
    map_fd = tmp.data[0] as Map<String, dynamic>;
    // pprint(map_fd);

    front_desk_id = map_fd[sm_front_desk.ID];
    room_number = map_r[sm_room.NUMBER];

    tmp = map_fd[sm_front_desk.PAY_ROOM] as List<dynamic>? ?? [];
    if (tmp.isNotEmpty) pay_price = double.tryParse(tmp.last["pay_price"].toString()) ?? 0;
    for (var l in tmp) {
      last_paid = (last_paid ?? 0) + (double.tryParse(l["pay_cash"].toString()) ?? 0);
      last_paid = (last_paid ?? 0) + (double.tryParse(l["pay_bank"].toString()) ?? 0);
      last_paid = (last_paid ?? 0) - (double.tryParse(l["pay_return"].toString()) ?? 0);
    }

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

      Input_Number(
        init: pay_price, //
        lead: "Room Price:", //
        onChanged: (v) {
          pay_price = v;
          setState(() {});
        },
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Last Payment: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            "${last_paid?.toStringAsFixed(2) ?? '0.00'} \$",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Input_Number(
        init: pay_cash, //
        lead: "Cash Payment:", //
        prefixIcon: Icons.payments_outlined, //
        onChanged: (v) {
          pay_cash = v;
          setState(() {});
        },
      ),

      Input_Number(
        init: pay_bank, //
        lead: "Bank Payment:", //
        prefixIcon: Icons.account_balance_outlined, //
        onChanged: (v) {
          pay_bank = v;
          setState(() {});
        },
      ),

      Input_Number(
        init: pay_return, //
        lead: "Return:", //
        prefixIcon: Icons.currency_exchange_outlined, //
        onChanged: (v) {
          pay_return = v;
          setState(() {});
        },
      ),

      Input_Bank_Auto(
        init: pay_note, //
        onChanged: (v) {
          pay_note = v;
          setState(() {});
        },
      ),

      Divider(height: 1, color: Colors.black),

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
        icon: Icon(Icons.payments_outlined), //
        label: Text(is_submitting ? "Processing..." : "Complete Payment"), //
        onPressed: (can_pay && !is_submitting) ? on_pay : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  bool get can_pay {
    if ((pay_price ?? 0) <= 0) return false;
    if (balanced != 0) return false;
    return true;
  }

  double get balanced {
    double temp = 0;

    temp = temp + (pay_cash ?? 0);
    temp = temp + (pay_bank ?? 0);
    temp = temp + (last_paid ?? 0);
    temp = temp - (pay_price ?? 0);
    temp = temp - (pay_return ?? 0);

    return temp;
  }

  void on_pay() async {
    if (is_submitting) return; // double-submit guard
    is_submitting = true;
    setState(() {});

    try {
      await dio.post(
        endpoint.FRONT_DESK_ADD_PAY_ROOM,
        data: {
          sm_front_desk.ID: front_desk_id, //
          "pay_price": pay_price ?? 0, //
          "pay_cash": pay_cash ?? 0, //
          "pay_bank": pay_bank ?? 0, //
          "pay_return": pay_return ?? 0, //
          "pay_note": pay_note ?? "", //
        },
      );

      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Pending Leave", //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    } finally {
      is_submitting = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
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
