import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as sb;

import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;
import "../schema.g.dart" as sm;

class _Main_State extends State<Main_> {
  dynamic tmp;

  final c_price = TextEditingController();
  final c_pay = TextEditingController();
  final c_change = TextEditingController();

  final c_note = TextEditingController();

  void init() async {
    try {
      sm.clear();
      sm_r.clear();

      tmp = await dio.post(
        ep.FRONT_DESK_READ_ID,
        data: {
          sm.ID: widget.front_desk_id, //
        },
      );

      for (var e in sm.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: "Failed", color: Colors.red);
    }

    c_price.text = sm.data[sm.ROOM_PRICE]?["value"]?.toString() ?? "";
    c_pay.text = sm.data[sm.ROOM_PAY]?["value"]?.toString() ?? "";
    c_change.text = sm.data[sm.ROOM_RETURN]?["value"]?.toString() ?? "";
    c_note.text = sm.data[sm.CHECK_IN_NOTE]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      //
      TextField(
        controller: c_price,
        decoration: InputDecoration(
          labelText: "Room Price:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),
      SizedBox(height: 8),

      //
      TextField(
        controller: c_pay,
        autofocus: true,
        decoration: InputDecoration(
          labelText: "Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),
      SizedBox(height: 8),

      //
      TextField(
        controller: c_change,
        decoration: InputDecoration(
          labelText: "Return:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),
      SizedBox(height: 8),

      // note
      TextField(
        controller: c_note,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "Note:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_pay() : null, //
      ),

      // balanced
      Divider(height: 8, thickness: 1, color: Colors.black),
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
      SizedBox(height: 8),

      // additional information
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            icon: Icon(Icons.payment), //
            label: Text("Payment"), //
            onPressed: can_pay ? on_pay : null, //
          ),
        ],
      ),
    ]);
  }

  bool get can_pay {
    if (double.tryParse(c_price.text) == null) return false;
    if (double.tryParse(c_pay.text) == null) return false;
    if (double.tryParse(c_price.text)! <= 0) return false;
    if (balanced != 0) return false;
    return true;
  }

  double get balanced {
    double price = double.tryParse(c_price.text) ?? 0;
    double pay = double.tryParse(c_pay.text) ?? 0;
    double change = double.tryParse(c_change.text) ?? 0;
    return pay - price - change;
  }

  void on_pay() async {
    try {
      //

      double price = double.tryParse(c_price.text) ?? 0;
      double pay = double.tryParse(c_pay.text) ?? 0;
      double change = double.tryParse(c_change.text) ?? 0;

      await dio.post(
        ep.FRONT_DESK_FORM_PAY_ROOM,
        data: {
          sm.ID: widget.front_desk_id, //
          sm.ROOM_PRICE: price, //
          sm.ROOM_PAY: pay, //
          sm.ROOM_RETURN: change, //
          sm.CHECK_IN_NOTE: c_note.text, //
        },
      );

      await dio.post(
        ep.ROOM_UPDATE, //
        data: {
          sm_r.ID: sm.data[sm.ROOM_ID]!["value"], //
          sm_r.STATUS: "Pending Leave", //
        },
      );

      Navigator.pop(context, true);

      sb.view(
        context: context,
        message: "Payment Successful",
        color: Colors.green,
      );

      //
    } catch (e, st) {
      print(st);
      sb.view(context: context, message: "Failed", color: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

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
            children: children, //
          ),
        ),
      ),
    ),
  );
}

//
class Main_ extends StatefulWidget {
  Main_({
    super.key,
    this.front_desk_id, //
  });

  final String? front_desk_id;

  @override
  State<Main_> createState() => _Main_State();
}

//
void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme.data(), //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
