// * OK

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/search/search_guest.dart";

import "package:speanmeas/core/schema/room.g.dart";
import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        t("Update Guest"), //
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
  dynamic map_r;
  dynamic map_fd;
  bool is_loading = true;
  bool is_submitting = false;

  String? room_number;
  String? guest_id;
  String? front_desk_id;

  // String? front_desk_id;
  // String? room_number;
  // String? guest_full_name;
  // String? guest_phone_number;
  // String? guest_gender;
  // String? guest_nationality;

  void init() async {
    try {
      tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
      map_r = tmp.data[0] as Map<String, dynamic>;

      if (map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID] == null) throw Exception("Front desk ID is null");

      tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
      map_fd = tmp.data[0] as Map<String, dynamic>;

      front_desk_id = map_fd[sm_front_desk.ID];
      guest_id = map_fd[sm_front_desk.GUEST_ID]?[sm_guest.ID]?.toString();

      room_number = map_r[sm_room.NUMBER];

      // guest_full_name = map_fd["guest_full_name"]?.toString();
      // guest_phone_number = map_fd["guest_phone_number"]?.toString();
      // guest_gender = map_fd["guest_gender"]?.toString();
      // guest_nationality = map_fd["guest_nationality"]?.toString();

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
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

      Search_Guest(
        init: guest_id, //
        onChanged: (v) {
          guest_id = v;
          setState(() {});
        },
      ),

      OutlinedButton.icon(
        icon: Icon(Icons.check), //
        label: Text(is_submitting ? t("Updating...") : t("Update")), //
        onPressed: is_submitting ? null : on_update, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_update() async {
    if (is_submitting) return; // double-submit guard
    is_submitting = true;
    setState(() {});

    try {
      await dio.post(
        endpoint.FRONT_DESK_UPDATE_GUEST, //
        data: {
          sm_front_desk.ID: front_desk_id, //
          sm_front_desk.GUEST_ID: guest_id,
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
      child: Main_(
        room_id: "6a6ec9d7599d64fa5d293fb9", //
      ),
    ),
  );
}
