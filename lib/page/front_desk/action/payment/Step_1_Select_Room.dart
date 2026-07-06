import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/theme/Theme_Data.dart";

import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/widget/Datetime_Picker.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";
import "package:speanmeas/page/room/Schema.g.dart" as room_schema;

import "../../Setup.dart";
import "../../Schema.g.dart" as schema;

import "Step_2_Payment.dart" as step_2;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme_Data(), //
      debugShowCheckedModeBanner: false,
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  // keys
  // var NUMBER = "room_number";
  // var TYPE = "room_type";
  // var PRICE_DAY = "room_price_per_day_usd";
  // var PRICE_3H = "room_price_per_3h_usd";
  // var STATUS = "room_status";

  List<Map<String, dynamic>> room_infos = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post("/room/data_read")
        .then((r) {
          room_infos = List<Map<String, dynamic>>.from(r.data);
          room_infos.sort((a, b) => "${a[room_schema.ROOM_NUMBER]}".compareTo("${b[room_schema.ROOM_NUMBER]}"));
          setState(() {});
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "1. Payment - Room", //
          style: TextStyle(
            fontSize: 20, //
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
        toolbarHeight: 40,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var room in room_infos) ...[
                //
                if (room[room_schema.ROOM_STATUS] == "Pending Pay")
                  InkWell(
                    child: Container(
                      height: 50,
                      width: 600,
                      padding: EdgeInsets.fromLTRB(8, 0, 12, 0),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black)),
                      ),

                      child: Row(
                        children: [
                          Icon(Icons.bed_outlined, color: Colors.amber, size: 32), //
                          SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .start,
                            children: [
                              Text("Room ${room[room_schema.ROOM_NUMBER]} (${room[room_schema.ROOM_TYPE]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room[room_schema.ROOM_PRICE_PER_DAY_USD]}\$/day | ${room[room_schema.ROOM_PRICE_PER_3H_USD]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room[room_schema.ROOM_STATUS]}",
                            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                    onTap: () => on_selected(room),
                  ),
              ],

              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 0, 12, 0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black)),
                ),
              ),

              // no room here
              (() {
                int count = 0;
                for (var room in room_infos) {
                  if (room[room_schema.ROOM_STATUS] == "Pending Pay") count++;
                }
                if (count > 0) return SizedBox();
                return Text("No room here.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
              })(),

              // if (room_infos.isEmpty) Container(width: 600, child: Text("No room here.")),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void on_selected(room) async {
    //
    await dio
        .post(
          "/front_desk/data_read",
          data: FormData.fromMap({
            "key": "_id", //
            "_id": room["front_desk_id"], //
          }),
        )
        .then((r) {
          //
          if (r.data == null || r.data.isEmpty) return;

          //
          for (var s in schema.data) {
            s["value"] = r.data[0][s["key"]];
          }

          //
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => step_2.Main_(), //
            ),
          );
        })
        .catchError((_) {});
  }
}
