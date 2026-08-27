import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ check in
class _Main_State extends State<Main_> {
  bool is_load = false;

  String? note;

  @override
  void initState() {
    super.initState();
    init();
  }

  // * ផ្ទុកព័ត៌មានបន្ទប់ពី server
  void init() async {
    setState(() {});
  }

  bool get is_paid {
    // todo: check out the payment is completed or not
    return true;
  }

  // * អនុវត្តការ check in ភ្ញៀវ
  void on_check_out() async {
    if (!is_paid) return snackbar(ct: context, ms: "Please paid.", cl: Colors.red);
    if (is_load) return snackbar(ct: context, ms: "Please wait.", cl: Colors.red);

    // create check out
    dynamic tpm_check_out = await dio.post(
      endpoint.CHECK_OUT_CREATE,
      data: {
        Check_Out.NOTE: note, //
      },
    );

    //   update front desk with check out id
    await dio.post(
      endpoint.FRONT_DESK_UPDATE,
      data: {
        Front_Desk.ID: widget.front_desk_id, //
        Front_Desk.CHECK_OUT_ID: tpm_check_out.data[0][Check_Out.ID], //
      },
    );

    // update room status to dirty
    await dio.post(
      endpoint.ROOM_UPDATE,
      data: {
        Room.ID: widget.room_id, //
        Room.STATUS: "Dirty", //
      },
    );

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, true);
  }

  Widget _layout(List<Widget> children) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check Out", //
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return _layout([
      // * បង្ហាញលេខបន្ទប់
      Text(
        'Room ${widget.room_number ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងបញ្ជូន check in
      OutlinedButton.icon(
        icon: Icon(Icons.logout_outlined), //
        label: Text("Check Out"), //
        onPressed: on_check_out,
      ),

      SizedBox(height: height - 100),
    ]);
  }
}

// * ថ្នាក់ Main_ ជាទំព័រ check in
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.front_desk_id,
    this.room_id,
    this.room_number,
    // this.price_per_day,
    // this.price_per_3h,
  });

  final String? front_desk_id;
  final String? room_id;
  final String? room_number;
  // final double? price_per_day;
  // final double? price_per_3h;

  @override
  State<Main_> createState() => _Main_State();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
void main() async {
  runApp(
    MaterialApp(
      home: Main_(
        // room_id: "6a6ec9d7599d64fa5d293fb9", //
        room_number: "101", //
        // price_per_day: 20, //
        // price_per_3h: 5, //
      ), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
