import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/theme/theme_data.dart";

import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/widget/datetime_picker.dart";
import "package:speanmeas/widget/snackbar_show.dart";

import "../_setup.dart";
import "../schema.g.dart";
import "../../room/schema.g.dart" as room;

// import "Step_2_Guest_Info.dart" as room_info;

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
  var ROOM_NUMBER = "room_number";
  var ROOM_TYPE = "room_type";
  var PRICE_DAY = "room_price_per_day_usd";
  var PRICE_3H = "room_price_per_3h_usd";
  var STATUS = "room_status";

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
          room_infos.sort((a, b) => "${a[ROOM_NUMBER]}".compareTo("${b[ROOM_NUMBER]}"));
          setState(() {});
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Room - Status", //
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
                if (room[STATUS] == "Available")
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
                          Icon(Icons.bed_outlined, color: Colors.green, size: 32), //
                          SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .start,
                            children: [
                              Text("Room ${room[ROOM_NUMBER]} (${room[ROOM_TYPE]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room[PRICE_DAY]}\$/day | ${room[PRICE_3H]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room[STATUS]}",
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),

                //
                if (room[STATUS] == "Pending Pay")
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
                              Text("Room ${room[ROOM_NUMBER]} (${room[ROOM_TYPE]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room[PRICE_DAY]}\$/day | ${room[PRICE_3H]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room[STATUS]}",
                            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),

                //
                if (room[STATUS] == "Pending Leave")
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
                          Icon(Icons.bed_outlined, color: Colors.red, size: 32), //
                          SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .start,
                            children: [
                              Text("Room ${room[ROOM_NUMBER]} (${room[ROOM_TYPE]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room[PRICE_DAY]}\$/day | ${room[PRICE_3H]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room[STATUS]}",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),

                //
                if (room[STATUS] == "Pending Clean")
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
                          Icon(Icons.bed_outlined, color: Colors.teal, size: 32), //
                          SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .start,
                            children: [
                              Text("Room ${room[ROOM_NUMBER]} (${room[ROOM_TYPE]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room[PRICE_DAY]}\$/day | ${room[PRICE_3H]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room[STATUS]}",
                            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),

                //
                if (room[STATUS] == "Pending Fix")
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
                          Icon(Icons.bed_outlined, color: Colors.grey, size: 32), //
                          SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .start,
                            children: [
                              Text("Room ${room[ROOM_NUMBER]} (${room[ROOM_TYPE]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room[PRICE_DAY]}\$/day | ${room[PRICE_3H]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room[STATUS]}",
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
              ],

              Container(
                width: 600,
                padding: EdgeInsets.fromLTRB(8, 0, 12, 0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black)),
                ),
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
