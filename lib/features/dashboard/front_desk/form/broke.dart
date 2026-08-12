import "package:flutter/material.dart";

import "package:speanmeas/core/utility/dio.dart";
import "package:speanmeas/core/endpoint.g.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/core/widget/input/input_text.dart";
import "package:speanmeas/core/widget/snackbar.dart";
import "package:speanmeas/core/schema/front_desk.g.dart";
import "package:speanmeas/core/schema/room.g.dart";

Widget _layout(List<Widget> children) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Broke", //
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
  String? note;

  void init() async {
    try {
      tmp = await dio.post(endpoint.ROOM_CRUD_READ_ID, data: {sm_room.ID: widget.room_id});
      map_r = tmp.data[0] as Map<String, dynamic>;

      if (map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID] != null) {
        tmp = await dio.post(endpoint.FRONT_DESK_READ_ID, data: {sm_front_desk.ID: map_r[sm_room.FRONT_DESK_ID][sm_front_desk.ID]});
        map_fd = tmp.data[0] as Map<String, dynamic>;
      }

      front_desk_id = map_fd[sm_front_desk.ID];
      room_number = map_r[sm_room.NUMBER];
      note = map_fd[sm_front_desk.BROKE_NOTE]?.toString() ?? "";

      is_loading = false;
      setState(() {});
    } catch (e, st) {
      print(st);
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
          Text("Room: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            room_number ?? "Unknown",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),

      Divider(height: 1, color: Colors.black),

      Input_Text(
        init: note, //
        lead: "Note:", //
        maxLines: 4,
        prefixIcon: Icons.note_alt_outlined, //
        onChanged: (v) {
          note = v;
          setState(() {});
        },
      ),

      OutlinedButton.icon(
        autofocus: true,
        icon: Icon(Icons.bug_report_outlined), //
        label: Text("Broke"), //
        onPressed: on_broke, //
      ),

      SizedBox(height: height - 100),
    ]);
  }

  void on_broke() async {
    try {
      await dio.post(
        endpoint.ROOM_CRUD_UPDATE, //
        data: {
          sm_room.ID: widget.room_id, //
          sm_room.STATUS: "Pending Fix", //
        },
      );

      if (front_desk_id != null)
        await dio.post(
          endpoint.FRONT_DESK_BROKE,
          data: {
            sm_front_desk.ID: front_desk_id, //
            sm_front_desk.BROKE_NOTE: note, //
          },
        );

      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      print(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
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
void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(
        room_id: "6a6ec9d7599d64fa5d293fb9", //
      ), //
      debugShowCheckedModeBanner: false,
    ),
  );
}
