import "package:flutter/material.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/select/select_dynamic.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Change Room", //
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

  String? front_desk_id;
  String? room_number;

  String? to_room_number;
  String? change_note;

  String? to_room_id; // * សម្រាប់រក្សា ID បន្ទប់ថ្មី

  // List<Map<String, dynamic>> rooms = [];
  dynamic list_r = []; // * សម្រាប់រក្សាពត៏មានបន្ទប់ទាំងអស់

  void init() async {
    tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
    map_r = tmp.data[0] as Map<String, dynamic>;

    if (map_r[sm_room.FRONT_DESK_ID]?[sm_front_desk.ID] == null) throw Exception("Front desk ID is null");

    tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
    map_fd = tmp.data[0] as Map<String, dynamic>;

    tmp = await dio.post(endpoint.ROOM_CRUD_READ);
    list_r = tmp.data as List<dynamic>;

    front_desk_id = map_fd[sm_front_desk.ID];
    room_number = map_r[sm_room.NUMBER];

    is_loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (is_loading) return Center(child: CircularProgressIndicator());
    return _layout([
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Room ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            room_number ?? "Unknown",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Divider(height: 1, color: Colors.black),

      Select_Dynamic(
        lead: "New Room Number:", //
        prefixIcon: Icons.hotel_outlined, //
        options: (() {
          var options = [];
          for (var r in list_r) {
            if (r[sm_room.STATUS] == "Available") {
              options.add(r[sm_room.NUMBER]?.toString() ?? "");
            }
          }
          return options;
        })(),
        onChanged: (v) {
          to_room_number = v;

          for (var r in list_r) {
            if (r[sm_room.NUMBER]?.toString() == v) {
              to_room_id = r[sm_room.ID]?.toString();
              break;
            }
          }

          setState(() {});
        },
      ),

      Input_Text(
        init: change_note, //
        lead: "Note:", //
        maxLines: 4,
        onChanged: (v) {
          change_note = v;
          setState(() {});
        },
      ),

      OutlinedButton.icon(
        icon: Icon(Icons.swap_horiz_outlined), //
        label: Text("Change"), //
        onPressed: can_change ? on_change_room : null, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  bool get can_change {
    if (to_room_id == null || to_room_id!.isEmpty) return false;
    return true;
  }

  void on_change_room() async {
    try {
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Pending Clean", //
          sm_room.FRONT_DESK_ID: null, //
        },
      );

      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: to_room_id, //
          sm_room.STATUS: "Pending Pay", //
          sm_room.FRONT_DESK_ID: front_desk_id, //
        },
      );

      await dio.post(
        endpoint.FRONT_DESK_UPDATE_ROOM,
        data: {
          sm_front_desk.ID: front_desk_id, //
          sm_front_desk.ROOM_ID: to_room_id, //
          sm_front_desk.CHANGE_NOTE: change_note, //
        },
      );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

class Main_ extends StatefulWidget {
  const Main_({
    super.key,
    this.room_id, //
  });

  final String? room_id;

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
