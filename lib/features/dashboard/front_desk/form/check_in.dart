// * OK
// * ទំព័រ Check In សម្រាប់ចុះឈ្មោះភ្ញៀវចូលស្នាក់នៅបន្ទប់

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/search/search_guest.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";

import "package:speanmeas/core/schema/front_desk.g.dart";
// import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

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
  dynamic map_r;
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
    try {
      // * អានព័ត៌មានបន្ទប់តាម id
      tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
      map_r = tmp.data[0] as Map<String, dynamic>;
      // pprint(map_r);

      room_number = map_r[sm_room.NUMBER] ?? "";
      price_per_day = map_r[sm_room.USD_PER_DAY] ?? 0;
      price_per_3hours = map_r[sm_room.USD_PER_3H] ?? 0;

      number_of_guest = 1;
      stay_days = 0;
      stay_hours = 0;

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
      is_loading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // * បង្ហាញ loading ពេលកំពុងផ្ទុក
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញលេខបន្ទប់
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${t("Room")}: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            room_number ?? t("Unknown"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
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
  double get room_price {
    return ((price_per_day ?? 0) * (stay_days ?? 0)) + ((price_per_3hours ?? 0) * (stay_hours ?? 0) / 3);
  }

  // * ពិនិត្យថាអាច check in បានឬអត់
  bool get can_check_in {
    if ((number_of_guest ?? 0) <= 0) return false;
    if ((stay_days ?? 0) <= 0 && (stay_hours ?? 0) <= 0) return false;
    return true;
  }

  // * អនុវត្តការ check in ភ្ញៀវ
  void on_check_in() async {
    if (is_submitting) return; // double-submit guard
    is_submitting = true;
    setState(() {});

    dynamic front_desk_id; // track created record for rollback
    try {
      // * បង្កើតកំណត់ត្រា front desk
      tmp = await dio.post(
        endpoint.FRONT_DESK_CHECK_IN, // create
        data: {
          sm_front_desk.ROOM_ID: widget.room_id, //
          sm_front_desk.GUEST_ID: guest_id, //
          sm_front_desk.CHECK_IN_NUMBER: number_of_guest, //
          sm_front_desk.CHECK_IN_DAY: stay_days, //
          sm_front_desk.CHECK_IN_HOUR: stay_hours, //
          sm_front_desk.CHECK_IN_NOTE: note, //
        },
      );

      front_desk_id = tmp.data[0][sm_front_desk.ID];

      // * បន្ថែមតម្លៃបន្ទប់ទៅការទូទាត់
      await dio.post(
        endpoint.FRONT_DESK_ADD_PAY_ROOM, // update
        data: {
          sm_front_desk.ID: front_desk_id, //
          "add_price": room_price, //
        },
      );

      // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់ទៅ Pending Pay
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Pending Pay", //
          sm_room.FRONT_DESK_ID: front_desk_id, //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: t("Success"), cl: Colors.green);
    } catch (e, st) {
      // compensating rollback: undo the created front_desk record
      // * បើមានកំហុស លុបកំណត់ត្រាដែលបានបង្កើតវិញ
      if (front_desk_id != null) {
        try {
          await dio.post(
            endpoint.FRONT_DESK_CRUD_DELETE,
            data: {
              sm_front_desk.ID: front_desk_id, //
            },
          );
        } catch (e2, st2) {
          pprint(st2);
        }
      }
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

  //
}

//
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

//
// * ចំណុចចាប់ផ្តើមកម្មវិធី
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  //
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
