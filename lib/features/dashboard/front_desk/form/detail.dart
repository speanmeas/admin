import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import

import "package:speanmeas/core/schema/guest.g.dart";
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/widget/show/show_text.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Detail", //
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
            // spacing: 8,
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

  void init() async {
    try {
      tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
      map_r = tmp.data[0] as Map<String, dynamic>;
      // pprint(map_r);

      tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
      map_fd = tmp.data[0] as Map<String, dynamic>;
      pprint(map_fd);

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
      Show_Text(
        lead: "Room Number:", //
        value: map_fd[sm_front_desk.ROOM_ID]?[sm_room.NUMBER]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Room Type:", //
        value: map_fd[sm_front_desk.ROOM_ID]?[sm_room.KIND]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Room Price Per Day:", //
        value: map_fd[sm_front_desk.ROOM_ID]?[sm_room.USD_PER_DAY]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Room Price Per 3H:", //
        value: map_fd[sm_front_desk.ROOM_ID]?[sm_room.USD_PER_3H]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Guest Name:", //
        value: map_fd[sm_front_desk.GUEST_ID]?[sm_guest.FULL_NAME]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Guest Gender:", //
        value: map_fd[sm_front_desk.GUEST_ID]?[sm_guest.GENDER]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Guest Phone Number:", //
        value: map_fd[sm_front_desk.GUEST_ID]?[sm_guest.PHONE_NUMBER]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Number Of Guests:", //
        value: map_fd[sm_front_desk.CHECK_IN_NUMBER]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Stay Duration [Days]:", //
        value: map_fd[sm_front_desk.CHECK_IN_DAY]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Stay Duration [Hours]:", //
        value: map_fd[sm_front_desk.CHECK_IN_HOUR]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Stay Due To:", //
        value: DateTime.tryParse(map_fd[sm_front_desk.CHECK_IN_DUE]?.toString() ?? ""),
      ),
      Show_Text(
        lead: "Check In Note:", //
        value: map_fd[sm_front_desk.CHECK_IN_NOTE]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Check In By:", //
        value: map_fd[sm_front_desk.CHECK_IN_BY]?[sm_user.FULL_NAME]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Check In At:", //
        value: DateTime.tryParse(map_fd[sm_front_desk.CHECK_IN_AT]?.toString() ?? ""),
      ),
      Show_Text(
        lead: "Check Out Note:", //
        value: map_fd[sm_front_desk.CHECK_OUT_NOTE]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Check Out By:", //
        value: map_fd[sm_front_desk.CHECK_OUT_BY]?[sm_user.FULL_NAME]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Check Out At:", //
        value: DateTime.tryParse(map_fd[sm_front_desk.CHECK_OUT_AT]?.toString() ?? ""),
      ),
      Show_Text(
        lead: "Clean Note:", //
        value: map_fd[sm_front_desk.CLEAN_NOTE]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Clean By:", //
        value: map_fd[sm_front_desk.CLEAN_BY]?[sm_user.FULL_NAME]?.toString() ?? "",
      ),
      Show_Text(
        lead: "Clean At:", //
        value: DateTime.tryParse(map_fd[sm_front_desk.CLEAN_AT]?.toString() ?? ""),
      ),

      // TODO: add more details here

      //
      OutlinedButton.icon(
        autofocus: true,
        label: Text("OK"),
        icon: Icon(Icons.check), //
        onPressed: () => Navigator.pop(context), //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key, //
    this.room_id,
  });

  final String? room_id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      theme: theme_data, //
      home: Main_(
        room_id: "6a71dc186c013023294f6742", //
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
