import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "../schema.g.dart" as sm_fd;

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
  final c_pay = TextEditingController();
  final c_return = TextEditingController();
  final c_note = TextEditingController();

  void init() async {
    try {
      sm_fd.clear();
      sm_r.clear();

      tmp = await dio.post(ep.ROOM_READ_ID, data: {sm_fd.ID: widget.room_id});
      for (var e in sm_r.data.entries) e.value["value"] = tmp.data[0][e.key];

      if (sm_r.data[sm_r.FRONT_DESK_ID]!["value"] != null) {
        tmp = await dio.post(ep.FRONT_DESK_READ_ID, data: {sm_fd.ID: sm_r.data[sm_r.FRONT_DESK_ID]!["value"]});
        for (var e in sm_fd.data.entries) e.value["value"] = tmp.data[0][e.key];
      }

      c_pay.text = sm_fd.data[sm_fd.ROOM_PAY]?["value"]?.toString() ?? "";
      c_return.text = sm_fd.data[sm_fd.ROOM_RETURN]?["value"]?.toString() ?? "";
      c_note.text = sm_fd.data[sm_fd.CANCEL_NOTE]?["value"]?.toString() ?? "";

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
      //
      TextField(
        controller: c_pay,
        decoration: InputDecoration(
          labelText: "Payment:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixText: "\$ ",
        ),
        onChanged: (v) => setState(() {}), //
      ),

      //
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

      // note
      TextField(
        controller: c_note,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: "Reason:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (v) => setState(() {}), //
      ),

      Divider(color: Colors.black),

      // balanced
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

      // additional information
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(foregroundColor: Colors.red), //
        icon: Icon(Icons.cancel_outlined), //
        label: Text("Cancel"), //
        onPressed: can_cancel ? on_cancel : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  //
  bool get can_cancel {
    if (balanced != 0) return false;
    return true;
  }

  //
  double get balanced {
    double pay_r = double.tryParse(c_pay.text) ?? 0;
    double return_r = double.tryParse(c_return.text) ?? 0;
    return pay_r - return_r;
  }

  //
  void on_cancel() async {
    try {
      //
      await dio.post(
        ep.FRONT_DESK_FORM_CANCEL,
        data: {
          sm_fd.ID: sm_fd.data[sm_fd.ID]!["value"], //
          sm_fd.ROOM_PAY: double.tryParse(c_pay.text) ?? 0, //
          sm_fd.ROOM_RETURN: double.tryParse(c_return.text) ?? 0, //
          sm_fd.CANCEL_NOTE: c_note.text, //
        },
      );

      //
      await dio.post(
        ep.ROOM_UPDATE, //
        data: {
          sm_r.ID: sm_r.data[sm_r.ID]!["value"], //
          sm_r.STATUS: "Available", //
          sm_r.FRONT_DESK_ID: null, //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
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
      theme: theme.data(), //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
