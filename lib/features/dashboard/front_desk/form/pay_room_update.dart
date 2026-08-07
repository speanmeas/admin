import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;
import "../schema.g.dart" as sm_fd;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Update Room Payment", //
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
  final c_pay = TextEditingController();
  final c_change = TextEditingController();
  final c_note = TextEditingController();

  void init() async {
    try {
      sm_fd.clear();
      sm_r.clear();

      //
      tmp = await dio.post(ep.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
      for (var e in sm_r.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      tmp = await dio.post(ep.FRONT_DESK_READ_ID, data: {sm_fd.ID: sm_r.data[sm_r.FRONT_DESK_ID]!["value"]});
      for (var e in sm_fd.data.entries) e.value["value"] = tmp.data[0][e.key];

      //
      c_price.text = sm_fd.data[sm_fd.ROOM_PRICE]?["value"]?.toString() ?? "";
      c_pay.text = sm_fd.data[sm_fd.ROOM_PAY]?["value"]?.toString() ?? "";
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
          prefixText: "\$ ",
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => on_pay(), //
      ),

      // payment
      TextField(
        autofocus: true,
        controller: c_pay,
        decoration: InputDecoration(
          labelText: "Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: "\$ ",
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => on_pay(), //
      ),

      // return
      TextField(
        controller: c_change,
        decoration: InputDecoration(
          labelText: "Return:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: "\$ ",
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => on_pay(), //
      ),

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
        onSubmitted: (v) => on_pay(), //
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
        icon: Icon(Icons.check), //
        label: Text("Update"), //
        onPressed: on_pay, //
      ),

      SizedBox(height: height - 100),
    ]);
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
          sm_fd.ID: sm_fd.data[sm_fd.ID]!["value"], //
          sm_fd.ROOM_PRICE: price, //
          sm_fd.ROOM_PAY: pay, //
          sm_fd.ROOM_RETURN: change, //
          sm_fd.ROOM_PAY_NOTE: c_note.text, //
        },
      );

      // * ប្រសិនបើលុយមិនទាន់បង់គ្រប់
      if (pay < price + change)
        await dio.post(
          ep.ROOM_UPDATE, //
          data: {
            sm_r.ID: sm_r.data[sm_r.ID]!["value"], //
            sm_r.STATUS: "Pending Pay", // * ត្រឡប់ទៅ Pending Pay វិញ
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
      theme: theme.data(), //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
