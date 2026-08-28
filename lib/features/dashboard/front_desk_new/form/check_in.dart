import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ check in
class _Main_State extends State<Main_> {
  bool is_load = false;

  int? stay_number = 1;
  String? stay_note;

  @override
  void initState() {
    super.initState();
    init();
  }

  // * ផ្ទុកព័ត៌មានបន្ទប់ពី server
  void init() async {
    //
  }

  // * អនុវត្តការ check in ភ្ញៀវ
  void on_check_in() async {
    // pprint(room_price);

    if (is_load) return snackbar(ct: context, ms: "Please wait.", cl: Colors.red);

    // create stay
    dynamic tmp_cin = await dio.post(
      endpoint.CHECK_IN_CREATE,
      data: {
        Check_In.NUMBER: stay_number, //
        Check_In.NOTE: stay_note, //
      },
    );

    //  create room pay
    dynamic tmp_rp = await dio.post(
      endpoint.ROOM_PAY_CREATE,
      data: {
        Room_Pay.PRICE: widget.price_per_day, //
      },
    );

    // create front desk
    dynamic tmp_fd = await dio.post(
      endpoint.FRONT_DESK_CREATE,
      data: {
        Front_Desk.ROOM_ID: widget.room_id, //
        Front_Desk.CHECK_IN_ID: tmp_cin.data[0][Check_In.ID], //
        Front_Desk.ROOM_PAY_ID: tmp_rp.data[0][Room_Pay.ID], //
      },
    );
    // update

    // update room status to occupied
    await dio.post(
      endpoint.ROOM_UPDATE,
      data: {
        Room.ID: widget.room_id, //
        Room.STATUS: "Occupied", //
        Room.FRONT_DESK_ID: tmp_fd.data[0][Front_Desk.ID], //
      },
    );

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, true);
  }

  Widget _layout(List<Widget> children) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check In", //
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

      // * ជ្រើសរើសចំនួនភ្ញៀវ
      Select_Dynamic(
        lead: "Number of Guests:",
        init: stay_number, //
        options: List.generate(10, (index) => index + 1),
        prefixIcon: Icons.people_outline, //
        onChanged: (v) {
          stay_number = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: stay_note, //
        lead: "Note:", //
        maxLines: 4, //
        onChanged: (v) {
          stay_note = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងបញ្ជូន check in
      OutlinedButton.icon(
        icon: Icon(Icons.login_outlined), //
        label: Text("Check In"), //
        onPressed: on_check_in,
      ),

      SizedBox(height: height - 100),
    ]);
  }
}

// * ថ្នាក់ Main_ ជាទំព័រ check in
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.room_id,
    this.room_number,
    this.price_per_day,
    // this.price_per_3h,
  });

  final String? room_id;
  final String? room_number;
  final double? price_per_day;
  // final double? price_per_3h;

  @override
  State<Main_> createState() => _Main_State();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();

  runApp(
    MaterialApp(
      home: Main_(
        // room_id: "6a6ec9d7599d64fa5d293fb9", //
        room_number: "101", //
        price_per_day: 20, //
        // price_per_3h: 5, //
      ), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
