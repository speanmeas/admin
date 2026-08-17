// * ទំព័រ Update Stay សម្រាប់ធ្វើបច្ចុប្បន្នភាពការស្នាក់នៅ

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/widget/select/select_dynamic.dart";
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
  Room? map_room;
  bool is_loading = true;

  int? number_of_guest;
  int? stay_days;
  int? stay_hours;
  String? note;

  double? price_per_day;
  double? price_per_3hours;

  double? last_paid;

  double? old_price;

  // * ផ្ទុកព័ត៌មានបន្ទប់ និងការស្នាក់នៅបច្ចុប្បន្ន
  void init() async {
    // * អានព័ត៌មានបន្ទប់តាម id
    setState(() => is_loading = true);
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {Room.ID: widget.room_id});
    setState(() => is_loading = false);

    if (tmp == null) return snackbar(ct: context, ms: t("Error: ${endpoint.ROOM_CRUD_READ_ID}"), cl: Colors.red);

    map_room = Room.fromJson(tmp.data[0]);

    price_per_day = map_room?.usd_per_day ?? 0;
    price_per_3hours = map_room?.usd_per_3h ?? 0;

    // * ផ្ទុកចំនួនភ្ញៀវ រយៈពេលស្នាក់ និងកំណត់ចំណាំ
    number_of_guest = map_room?.front_desk_id?.check_in_number?.toInt() ?? 1;
    stay_days = map_room?.front_desk_id?.check_in_day?.toInt() ?? 0;
    stay_hours = map_room?.front_desk_id?.check_in_hour?.toInt() ?? 0;
    note = map_room?.front_desk_id?.check_in_note ?? "";

    // * តម្លៃចាស់ពីការស្នាក់នៅបច្ចុប្បន្ន (បានកត់ត្រាពេល check in)
    old_price = ((price_per_day ?? 0) * (stay_days ?? 0)) + ((price_per_3hours ?? 0) * (stay_hours ?? 0) / 3);

    // * គណនាប្រាក់ដែលបានទទួលរួច
    final pay_room_list = map_room?.front_desk_id?.pay_room ?? [];
    for (var l in pay_room_list) {
      last_paid = (last_paid ?? 0) + (l.add_cash ?? 0);
      last_paid = (last_paid ?? 0) + (l.add_bank ?? 0);
      last_paid = (last_paid ?? 0) - (l.sub_return ?? 0);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      // * បង្ហាញលេខបន្ទប់
      Text(
        '${t("Room")} ${map_room?.number ?? "N/A"}', //
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        label: Text(t("Update")), //
        onPressed: (can_update) ? on_update : null, //
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
    // * ធ្វើបច្ចុប្បន្នភាពព័ត៌មាន check-in
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_STAY, //
      data: {
        Front_Desk.ID: map_room?.front_desk_id?.id, //
        Front_Desk.CHECK_IN_NUMBER: number_of_guest, //
        Front_Desk.CHECK_IN_DAY: stay_days, //
        Front_Desk.CHECK_IN_HOUR: stay_hours, //
        Front_Desk.CHECK_IN_NOTE: note, //
      },
    );
    setState(() => is_loading = false);

    // * កត់ត្រាតម្លៃបន្ទប់ថ្មី (បន្ថែមតែភាពខុសគ្នា មិនមែនតម្លៃពេញទេ — check in បានកត់ត្រារួច)
    final diff = room_price - (old_price ?? 0);
    final add_price = diff > 0 ? diff : 0;
    final sub_price = diff < 0 ? -diff : 0;
    setState(() => is_loading = true);
    await dio.post(
      endpoint.FRONT_DESK_UPDATE_PAY_ROOM, // update
      data: {
        Front_Desk.ID: map_room?.front_desk_id?.id, //
        Pay_Room.ADD_PRICE: add_price, //
        Pay_Room.SUB_PRICE: sub_price, //
      },
    );
    setState(() => is_loading = false);

    // * ប្រៀបធៀបជា cents ដើម្បីចៀសវាងបញ្ហាភាពជាក់លាក់នៃចំនួនទសភាគ
    final paid_cents = ((last_paid ?? 0) * 100).round();
    final price_cents = (room_price * 100).round();

    // * ធ្វើបច្ចុប្បន្នភាពស្ថានភាពបន្ទប់តាមការប្រៀបធៀប
    setState(() => is_loading = true);
    if (paid_cents == price_cents)
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          Room.ID: widget.room_id, //
          Room.STATUS: "Pending Leave", //
        },
      );
    else
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          Room.ID: widget.room_id, //
          Room.STATUS: "Pending Pay", //
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
