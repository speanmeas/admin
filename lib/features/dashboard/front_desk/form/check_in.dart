// * OK
// * ទំព័រ Check In សម្រាប់ចុះឈ្មោះភ្ញៀវចូលស្នាក់នៅបន្ទប់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/enum/room_status.dart" as room_status;
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/search/search_guest.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

// * បង្កើត layout មេរបស់ទំព័រ check in
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Check In"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ check in
class _Main_State extends State<Main_> {
  dynamic tmp;
  Room? data;
  bool is_loading = true;
  bool is_submitting = false;

  String? room_number;
  double? price_per_day;
  double? price_per_3hours;

  String? guest_id;
  int? number_of_guest;
  int? stay_days;
  int? stay_hours;
  String? note;

  // * ផ្ទុកព័ត៌មានបន្ទប់ពី server
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {Room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.ROOM_CRUD_READ_ID}", cl: Colors.red);

    data = Room.fromJson(tmp.data[0]);

    room_number = data?.number ?? "";
    price_per_day = data?.usd_per_day ?? 0;
    price_per_3hours = data?.usd_per_3h ?? 0;

    number_of_guest = 1;
    stay_days = 0;
    stay_hours = 0;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញលេខបន្ទប់
      Text(
        '${t("Room")} ${room_number ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),

      Divider(height: 1, color: Colors.black),

      // * ជ្រើសរើសចំនួនភ្ញៀវ
      Select_Dynamic(
        lead: '${t("Number of Guests")}:',
        init: number_of_guest, //
        options: List.generate(10, (index) => index + 1),
        prefixIcon: Icons.people_outline, //
        onChanged: (v) {
          number_of_guest = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសរយៈពេលស្នាក់នៅ (ថ្ងៃ)
      Select_Dynamic(
        lead: '${t("Stay Duration (Days)")}:',
        init: stay_days, //
        options: List.generate(365, (index) => index),
        prefixIcon: Icons.calendar_month_outlined,
        onChanged: (v) {
          stay_days = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសរយៈពេលស្នាក់នៅ (ម៉ោង)
      Select_Dynamic(
        lead: '${t("Stay Duration (Hours)")}:',
        init: stay_hours,
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        prefixIcon: Icons.access_time_outlined,
        onChanged: (v) {
          stay_hours = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note, //
        lead: '${t("Note")}:', //
        maxLines: 4, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      // * ស្វែងរក និងជ្រើសរើសភ្ញៀវ
      Search_Guest(
        onChanged: (v) {
          guest_id = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងបញ្ជូន check in
      OutlinedButton.icon(
        icon: Icon(Icons.login_outlined), //
        label: Text(is_submitting ? t("Checking In...") : t("Check In")), //
        onPressed: (can_check_in && !is_submitting) ? on_check_in : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * គណនាតម្លៃបន្ទប់សរុប
  double get add_room_price {
    double temp = 0;

    temp = temp + ((price_per_day ?? 0) * (stay_days ?? 0));
    temp = temp + ((price_per_3hours ?? 0) * (stay_hours ?? 0) / 3);

    return temp;
  }

  // * ពិនិត្យថាអាច check in បានឬអត់
  bool get can_check_in {
    if (is_loading) return false;
    if (guest_id == null || guest_id!.isEmpty) return false;
    if ((number_of_guest ?? 0) <= 0) return false;
    if ((stay_days ?? 0) <= 0 && (stay_hours ?? 0) <= 0) return false;
    return true;
  }

  // * អនុវត្តការ check in ភ្ញៀវ
  void on_check_in() async {
    setState(() => is_loading = true);

    // * បង្កើតកំណត់ត្រា front desk
    tmp = await dio.post(
      endpoint.FRONT_DESK_CHECK_IN, // create
      data: {
        Front_Desk.ROOM_ID: widget.room_id, //
        Front_Desk.GUEST_ID: guest_id, //
        Front_Desk.CHECK_IN_NUMBER: number_of_guest, //
        Front_Desk.CHECK_IN_DAY: stay_days, //
        Front_Desk.CHECK_IN_HOUR: stay_hours, //
        Front_Desk.CHECK_IN_NOTE: note, //
      },
    );

    // * បន្ថែមតម្លៃបន្ទប់ទៅការទូទាត់
    if (add_room_price > 0)
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_PAY_ROOM, // update
        data: {
          Front_Desk.ID: tmp.data[0][Front_Desk.ID], //
          Pay_Room.ADD_PRICE: add_room_price,
        },
      );

    // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់ទៅ Pending Pay
    await dio.post(
      endpoint.ROOM_CRUD_UPDATE, //
      data: {
        Room.ID: widget.room_id, //
        Room.STATUS: room_status.PENDING_PAY, //
        Room.FRONT_DESK_ID: tmp.data[0][Front_Desk.ID], //
      },
    );
    setState(() => is_loading = false);

    snackbar(ct: context, ms: t("Success"), cl: Colors.green);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Main_ ជាទំព័រ check in
class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.room_id,
  });

  final String? room_id;

  @override
  State<Main_> createState() => _Main_State();
}

// * ចំណុចចាប់ផ្តើមកម្មវិធី
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: MaterialApp(
        home: Main_(
          room_id: "6a6ec9d7599d64fa5d293fb9", //
        ), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
