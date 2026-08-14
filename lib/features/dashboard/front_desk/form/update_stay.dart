// * ទំព័រ Update Stay សម្រាប់ធ្វើបច្ចុប្បន្នភាពការស្នាក់នៅ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

import "package:speanmeas/core/widget/input/input_text.dart";

// * បង្កើត layout មេរបស់ទំព័រធ្វើបច្ចុប្បន្នភាពការស្នាក់នៅ
Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Update Stay"), //
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

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទម្រង់ធ្វើបច្ចុប្បន្នភាពការស្នាក់នៅ
class _Main_State extends State<Main_> {
  dynamic tmp;
  bool is_loading = true;
  bool is_submitting = false;

  dynamic map_r;
  dynamic map_fd;

  String? front_desk_id;
  String? room_number;

  int? number_of_guest;
  int? stay_days;
  int? stay_hours;
  String? note;

  double? price_per_day;
  double? price_per_3hours;

  double? last_paid;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងការស្នាក់នៅបច្ចុប្បន្ន
  void init() async {
    try {
      // * អានព័ត៌មានបន្ទប់តាម id
      tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
      map_r = tmp.data[0] as Map<String, dynamic>;

      if (map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID] == null) throw Exception("Front desk ID is null");

      // * អានព័ត៌មាន front desk
      tmp = await dio.post(endpoint.FRONT_DESK_CRUD_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
      map_fd = tmp.data[0] as Map<String, dynamic>;

      front_desk_id = map_fd[sm_front_desk.ID];
      room_number = map_r[sm_room.NUMBER];

      room_number = map_r[sm_room.NUMBER] ?? "";
      price_per_day = map_r[sm_room.USD_PER_DAY] ?? 0;
      price_per_3hours = map_r[sm_room.USD_PER_3H] ?? 0;

      // * ផ្ទុកចំនួនភ្ញៀវ រយៈពេលស្នាក់ និងកំណត់ចំណាំ
      number_of_guest = map_fd[sm_front_desk.CHECK_IN_NUMBER] ?? 1;
      stay_days = map_fd[sm_front_desk.CHECK_IN_DAY] ?? 0;
      stay_hours = map_fd[sm_front_desk.CHECK_IN_HOUR] ?? 0;
      note = map_fd[sm_front_desk.CHECK_IN_NOTE] ?? "";

      // * គណនាប្រាក់ដែលបានទទួលរួច
      tmp = map_fd[sm_front_desk.PAY_ROOM] as List<dynamic>? ?? [];
      for (var l in tmp) {
        last_paid = (last_paid ?? 0) + (double.tryParse(l["pay_cash"].toString()) ?? 0);
        last_paid = (last_paid ?? 0) + (double.tryParse(l["pay_bank"].toString()) ?? 0);
        last_paid = (last_paid ?? 0) - (double.tryParse(l["pay_return"].toString()) ?? 0);
      }

      // pprint(last_paid);

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
          Text('${t("Room")} ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            room_number ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Divider(height: 1, color: Colors.black),

      // * ជ្រើសរើសចំនួនភ្ញៀវ
      Select_Dynamic(
        init: number_of_guest ?? 0, //
        lead: '${t("Number of Guests")}:',
        options: List.generate(10, (index) => index + 1),
        prefixIcon: Icons.people_outline, //
        onChanged: (v) {
          number_of_guest = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសរយៈពេលស្នាក់ (ថ្ងៃ)
      Select_Dynamic(
        init: stay_days ?? 0, //
        lead: '${t("Stay Duration (Days)")}:',
        options: List.generate(365, (index) => index),
        prefixIcon: Icons.calendar_month_outlined,
        onChanged: (v) {
          stay_days = v;
          setState(() {});
        },
      ),

      // * ជ្រើសរើសរយៈពេលស្នាក់ (ម៉ោង)
      Select_Dynamic(
        init: stay_hours ?? 0, //
        lead: '${t("Stay Duration (Hours)")}:',
        options: [0, 3, 6, 9, 12, 15, 18, 21],
        prefixIcon: Icons.access_time_outlined,
        onChanged: (v) {
          stay_hours = v;
          setState(() {});
        },
      ),

      // * បញ្ចូលកំណត់ចំណាំ
      Input_Text(
        init: note ?? "", //
        lead: '${t("Note")}:', //
        prefixIcon: Icons.note_alt_outlined, //
        maxLines: 4, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      // * ប៊ូតុងធ្វើបច្ចុប្បន្នភាព
      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text(is_submitting ? t("Updating...") : t("Update")), //
        onPressed: (can_update && !is_submitting) ? on_update : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  // * ពិនិត្យថាអាចធ្វើបច្ចុប្បន្នភាពបានឬអត់
  bool get can_update {
    if ((number_of_guest ?? 0) <= 0) return false;
    if ((stay_days ?? 0) <= 0 && (stay_hours ?? 0) <= 0) return false;

    return true;
  }

  // * គណនាតម្លៃបន្ទប់ពីរយៈពេលស្នាក់
  double get room_price {
    return ((price_per_day ?? 0) * (stay_days ?? 0)) + ((price_per_3hours ?? 0) * (stay_hours ?? 0) / 3);
  }

  // * អនុវត្តការធ្វើបច្ចុប្បន្នភាពការស្នាក់នៅ
  void on_update() async {
    if (is_submitting) return; // double-submit guard
    is_submitting = true;
    setState(() {});

    try {
      // * ធ្វើបច្ចុប្បន្នភាពព័ត៌មាន check-in
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_CHECK_IN, //
        data: {
          sm_front_desk.ID: front_desk_id, //
          sm_front_desk.CHECK_IN_NUMBER: number_of_guest, //
          sm_front_desk.CHECK_IN_DAY: stay_days, //
          sm_front_desk.CHECK_IN_HOUR: stay_hours, //
          sm_front_desk.CHECK_IN_NOTE: note, //
        },
      );

      pprint("room_price: $room_price");

      // * កត់ត្រាតម្លៃបន្ទប់ថ្មី
      await dio.post(
        endpoint.FRONT_DESK_ADD_PAY_ROOM, // update
        data: {
          sm_front_desk.ID: front_desk_id, //
          "add_price": room_price, //
        },
      );

      // * Compare in cents to avoid floating-point precision issues
      // * ប្រៀបធៀបជា cents ដើម្បីចៀសវាងបញ្ហាភាពជាក់លាក់នៃចំនួនទសភាគ
      final paid_cents = ((last_paid ?? 0) * 100).round();
      final price_cents = (room_price * 100).round();

      // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់តាមការប្រៀបធៀប
      if (paid_cents == price_cents)
        await dio.post(
          endpoint.ROOM_CRUD_UPDATE, //
          data: {
            sm_room.ID: widget.room_id, //
            sm_room.STATUS: "Pending Leave", //
          },
        );
      else
        await dio.post(
          endpoint.ROOM_CRUD_UPDATE, //
          data: {
            sm_room.ID: widget.room_id, //
            sm_room.STATUS: "Pending Pay", //
          },
        );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: t("Success"), cl: Colors.green);
    } catch (e, st) {
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
// * ថ្នាក់ Main_ ជាទំព័រធ្វើបច្ចុប្បន្នភាពការស្នាក់នៅ
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
        home: Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
