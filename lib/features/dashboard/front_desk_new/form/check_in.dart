import "package:flutter/material.dart";

import "package:speanmeas/core/utility/all.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ check in
class _Main_State extends State<Main_> {
  bool is_load = false;

  int? stay_number;
  int? stay_day;
  int? stay_hour;
  String? stay_note;

  @override
  void initState() {
    super.initState();
    init();
  }

  // * ផ្ទុកព័ត៌មានបន្ទប់ពី server
  void init() async {
    stay_number = 1;
    stay_day = 0;
    stay_hour = 0;

    setState(() {});
  }

  // * គណនាតម្លៃបន្ទប់សរុប
  double get room_price {
    // print(widget.price_per_day);
    // print(widget.price_per_3h);
    // print(stay_day);
    // print(stay_hour);

    double temp = 0;

    temp = temp + ((widget.price_per_day ?? 0) * (stay_day ?? 0));
    temp = temp + ((widget.price_per_3h ?? 0) * (stay_hour ?? 0) / 3);

    return temp;
  }

  // * ពិនិត្យថាអាច check in បានឬអត់
  bool get can_go {
    // print(stay_number);
    // print(stay_day);
    // print(stay_hour);

    if ((stay_number ?? 0) <= 0) return false;
    if ((stay_day ?? 0) <= 0 && (stay_hour ?? 0) <= 0) return false;

    return true;
  }

  // * អនុវត្តការ check in ភ្ញៀវ
  void on_check_in() async {
    // pprint(room_price);

    if (!can_go) return snackbar(ct: context, ms: "Please fill the form.", cl: Colors.red);
    if (is_load) return snackbar(ct: context, ms: "Please wait.", cl: Colors.red);

    // create stay
    dynamic tmp_stay = await dio.post(
      endpoint.STAY_CREATE,
      data: {
        Stay.NUMBER: stay_number, //
        Stay.DAY: stay_day, //
        Stay.HOUR: stay_hour, //
        Stay.NOTE: stay_note, //
      },
    );

    //  create room pay
    dynamic tmp_room_pay = await dio.post(
      endpoint.ROOM_PAY_CREATE,
      data: {
        Room_Pay.PRICE: room_price, //
      },
    );

    // create front desk
    dynamic tmp_front_desk = await dio.post(
      endpoint.FRONT_DESK_CREATE,
      data: {
        Front_Desk.ROOM_ID: widget.room_id, //
        Front_Desk.STAY_ID: tmp_stay.data[0][Stay.ID], //
        Front_Desk.ROOM_PAY_ID: tmp_room_pay.data[0][Room_Pay.ID], //
      },
    );
    // update

    // update room status to occupied
    await dio.post(
      endpoint.ROOM_UPDATE,
      data: {
        Room.ID: widget.room_id, //
        Room.STATUS: "Occupied", //
        Room.FRONT_DESK_ID: tmp_front_desk.data[0][Front_Desk.ID], //
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

      // * ជ្រើសរើសរយៈពេលស្នាក់នៅ (ថ្ងៃ)
      Select_Dynamic(
        lead: "Stay Duration (Days):",
        init: stay_day, //
        options: List.generate(365, (index) => index),
        prefixIcon: Icons.calendar_month_outlined,
        onChanged: (v) {
          stay_day = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសរយៈពេលស្នាក់នៅ (ម៉ោង)
      Select_Dynamic(
        lead: "Stay Duration (Hours):",
        init: stay_hour,
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        prefixIcon: Icons.access_time_outlined,
        onChanged: (v) {
          stay_hour = v;
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
    this.price_per_3h,
  });

  final String? room_id;
  final String? room_number;
  final double? price_per_day;
  final double? price_per_3h;

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
        price_per_3h: 5, //
      ), //
      theme: theme_data, //
      title: "Development", //
      debugShowCheckedModeBanner: false, //
    ),
  );
}
