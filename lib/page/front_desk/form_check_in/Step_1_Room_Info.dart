import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/utility/Datetime_format.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/widget/Datetime_Picker.dart';
import 'package:speanmeas/widget/Snackbar_Show.dart';

import '../__Setup__.dart';
import '../../room/Schema.g.dart';

import 'Step_2_Guest_Info.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
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
      home: Step_1_Room_Info_(),
    );
  }
}

class Step_1_Room_Info_ extends StatefulWidget {
  Step_1_Room_Info_({super.key});

  @override
  State<Step_1_Room_Info_> createState() => _Step_1_Room_Info_State();
}

class _Step_1_Room_Info_State extends State<Step_1_Room_Info_> {
  String room_number = "";

  List<Map<String, dynamic>> room_infos = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await dio
        .post('/room/data_read')
        .then((r) {
          room_infos = List<Map<String, dynamic>>.from(r.data);
          room_infos.sort((a, b) => "${a["room_number"]}".compareTo("${b["room_number"]}"));
          setState(() {});
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Room - Info.", //
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
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var room in room_infos) ...[
                //
                if (room["status"] == "Available")
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
                              Text("Room ${room["room_number"]} (${room["room_type"]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room["price_per_day"]}\$/day | ${room["price_per_3_hour"]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room["status"]}",
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                    onTap: () {
                      var info = room_infos.firstWhere((e) => e["room_number"] == room["room_number"]);

                      for (final e in info.entries) {
                        if (e.key == "id") continue;
                        var index = schema.indexWhere((s) => s["key"] == e.key);
                        if (index != -1) {
                          schema[index]["value"] = e.value;
                        }
                      }

                      Navigator.push(
                        context, //
                        MaterialPageRoute(builder: (context) => Step_2_Guest_Info_()),
                      );

                      setState(() {});
                    },
                  ),

                //
                if (room["status"] == "Occupied")
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
                              Text("Room ${room["room_number"]} (${room["room_type"]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room["price_per_day"]}\$/day | ${room["price_per_3_hour"]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room["status"]}",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                  ),

                //
                if (room["status"] == "Maintenance")
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
                              Text("Room ${room["room_number"]} (${room["room_type"]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room["price_per_day"]}\$/day | ${room["price_per_3_hour"]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room["status"]}",
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                  ),

                //
                if (room["status"] == "Dirty")
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
                              Text("Room ${room["room_number"]} (${room["room_type"]})", style: TextStyle(fontWeight: .bold, fontSize: 16)), //
                              Text("${room["price_per_day"]}\$/day | ${room["price_per_3_hour"]}\$/3h"),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "${room["status"]}",
                            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                          ), //
                        ],
                      ),
                    ),
                  ),
              ],

              SizedBox(height: screen_height - 80),
            ],
          ),
        ),
      ),
    );
  }
}
