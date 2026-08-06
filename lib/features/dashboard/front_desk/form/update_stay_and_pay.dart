import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart" as ep; // ignore: unused_import
import "package:speanmeas/core/theme/theme_light.dart" as theme;
import "package:speanmeas/core/widget/snackbar.dart" as snackbar;
import "package:speanmeas/core/widget/show_data.dart" as show_data;

import "../schema.g.dart" as sm;
import "package:speanmeas/features/database/guest/schema.g.dart" as sm_g;
import "package:speanmeas/features/database/room/schema.g.dart" as sm_r;

import "../widget/guest_search.dart" as search_g;
import "../widget/number_select.dart" as select_n;

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Update Stay & Payment", //
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

class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  final c_g_search = TextEditingController();
  final c_n_o_guest = TextEditingController();
  final c_d_day = TextEditingController();
  final c_d_hour = TextEditingController();
  final c_note = TextEditingController();
  final c_payment = TextEditingController();
  final c_payment_method = TextEditingController();
  final c_payment_method_options = TextEditingController();
  final c_price = TextEditingController();
  final c_pay = TextEditingController();
  final c_change = TextEditingController();
  final c_payment_method_options_list = TextEditingController();

  void init() async {
    sm.clear();
    sm_g.clear();
    sm_r.clear();

    sm.data[sm.STAY_N_GUEST]?["value"] = 1;

    c_g_search.text = sm_g.data[sm_g.PHONE_NUMBER]?["value"]?.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _layout([
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Stay",
            style: TextStyle(
              fontSize: 20, //
              fontWeight: FontWeight.bold, //
            ),
          ), //
        ],
      ),

      // number of guests
      select_n.Main_(
        controller: c_n_o_guest,
        title: "Number of Guests:",
        options: List.generate(10, (index) => index + 1),
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      // stay duration days
      select_n.Main_(
        controller: c_d_day,
        title: "Stay Duration (Days):",
        options: List.generate(365, (index) => index),
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      // stay duration hours
      select_n.Main_(
        controller: c_d_hour,
        title: "Stay Duration (Hours):",
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        onChanged: (v) => setState(() {}), //
      ),

      SizedBox(height: 8),

      Divider(height: 8, thickness: 1, color: Colors.black),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Payment",
            style: TextStyle(
              fontSize: 20, //
              fontWeight: FontWeight.bold, //
            ),
          ), //
        ],
      ),

      TextField(
        controller: c_price,
        decoration: InputDecoration(
          labelText: "Room Price:", //
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (v) => setState(() {}), //
        onSubmitted: (v) => can_pay ? on_update() : null, //
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
        onSubmitted: (v) => can_pay ? on_update() : null, //
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
        onSubmitted: (v) => can_pay ? on_update() : null, //
      ),
      SizedBox(height: 8),

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
        onSubmitted: (v) => can_pay ? on_update() : null, //
      ),

      SizedBox(height: 8),

      // additional information
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            icon: Icon(Icons.check), //
            label: Text("Update"), //
            onPressed: on_update, //
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

  void on_update() async {
    try {
      //
      // tmp = await dio.post(
      //   ep.FRONT_DESK_UPDATE, //
      //   data: {
      //     sm.ID: widget.front_desk_id, //
      //     sm.GUEST_ID: sm.data[sm.GUEST_ID]?["value"],
      //   },
      // );

      Navigator.pop(context, true);

      snackbar.view(context: context, message: "Update Successful", color: Colors.green);

      //
    } catch (e, st) {
      print(st);
      snackbar.view(context: context, message: e.toString(), color: Colors.red);
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
