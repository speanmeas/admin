import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/theme/Theme_Data.dart";

import "package:speanmeas/utility/Dio.dart";
import "package:speanmeas/widget/Datetime_Picker.dart";
import "package:speanmeas/widget/Snackbar_Show.dart";

import "../../__Setup__.dart";
import "../../Schema.g.dart";
import "../../../room/Schema.g.dart" as room;

// import "Step_2_Select_Create_Guest.dart" as room_info;

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
  var NUMBER = "room_number";
  var TYPE = "room_type";
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
          room_infos.sort((a, b) => "${a[NUMBER]}".compareTo("${b[NUMBER]}"));
          setState(() {});
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check Out - Room", //
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
                              Text("Room ${room[NUMBER]} (${room[TYPE]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
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

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void on_selected(room) {
    //
  }
}
