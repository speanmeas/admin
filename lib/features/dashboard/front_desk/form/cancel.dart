import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

//
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Cancel", //
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
  bool is_loading = true;

  final c_pay_cash = TextEditingController();
  final c_pay_bank = TextEditingController();
  final c_return = TextEditingController();

  String? front_desk_id;
  String? note;

  void init() async {
    tmp = await dio.post(
      endpoint.ROOM_CRUD_READ_ID, //
      data: {sm_room.ID: widget.room_id},
    );
    front_desk_id = tmp.data[0][sm_room.FRONT_DESK_ID];

    if (front_desk_id != null) {
      tmp = await dio.post(
        endpoint.FRONT_DESK_READ_ID, //
        data: {sm_front_desk.ID: front_desk_id},
      );

      c_pay_cash.text = tmp.data[0]["room_pay_cash"]?.toString() ?? "";
      c_pay_bank.text = tmp.data[0]["room_pay_bank"]?.toString() ?? "";
      c_return.text = tmp.data[0]["room_return"]?.toString() ?? "";
      note = tmp.data[0][sm_front_desk.CANCEL_NOTE]?.toString() ?? "";
    }

    is_loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      TextField(
        controller: c_pay_cash,
        decoration: InputDecoration(
          labelText: "Cash Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: "\$ ",
        ),
        onChanged: (v) => setState(() {}), //
      ),

      TextField(
        controller: c_pay_bank,
        decoration: InputDecoration(
          labelText: "Bank Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: "\$ ",
        ),
        onChanged: (v) => setState(() {}), //
      ),

      TextField(
        controller: c_return,
        decoration: InputDecoration(
          labelText: "Return:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: "\$ ",
        ),
        onChanged: (v) => setState(() {}), //
      ),

      Input_Text(
        init: note, //
        lead: "Reason:", //
        maxLines: 4,
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      Divider(color: Colors.black),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Balanced: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            "$balanced \$",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold, //
              color: balanced == 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),

      Row(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue),
          Text(
            "You can't cancel within 1 hour after check-in.", //
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),

      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red), //
        icon: Icon(Icons.cancel_outlined), //
        label: Text("Cancel"), //
        onPressed: can_cancel ? on_cancel : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  bool get can_cancel {
    if (balanced != 0) return false;
    return true;
  }

  double get balanced {
    double cash = double.tryParse(c_pay_cash.text) ?? 0;
    double bank = double.tryParse(c_pay_bank.text) ?? 0;
    double ret = double.tryParse(c_return.text) ?? 0;
    return (cash + bank) - ret;
  }

  void on_cancel() async {
    try {
      await dio.post(
        endpoint.FRONT_DESK_CANCEL,
        data: {
          sm_front_desk.ID: front_desk_id, //
          sm_front_desk.CANCEL_NOTE: note, //
        },
      );

      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Available", //
          sm_room.FRONT_DESK_ID: null, //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: "Your can't cancel within 1 hour after check-in.", cl: Colors.red);
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
      home: Main_(
        room_id: "6a6ec9d7599d64fa5d293fb9", //
      ), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
