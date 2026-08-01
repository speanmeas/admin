///
///
///
///

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/theme/theme_data.dart";

// dashboard
import "package:speanmeas/features/dashboard/front_desk/main.dart" as d_front_desk;

// database
import "package:speanmeas/features/database/front_desk/main.dart" as front_desk;
import "package:speanmeas/features/database/guest/main.dart" as guest;
import "package:speanmeas/features/database/room/main.dart" as room;
import "package:speanmeas/features/database/user/main.dart" as user;
import "package:speanmeas/features/database/nationality/main.dart" as nationality;

// report
import "package:speanmeas/features/report/daily/main.dart" as report_daily;
import "package:speanmeas/features/report/weekly/main.dart" as report_weekly;
import "package:speanmeas/features/report/monthly/main.dart" as report_monthly;
import "package:speanmeas/features/report/yearly/main.dart" as report_yearly;

import "package:speanmeas/features/database/demo_1/main.dart" as demo_1;
import "package:speanmeas/features/database/demo_2/main.dart" as demo_2;

// setting
import "package:speanmeas/features/setting/main.dart" as setting;

class _Main_State extends State<Main_> {
  //
  List<Map<String, dynamic>> panels = [
    {"name": "", "panel": Text("This page is under development..")},
    //
    {"name": "Front Desk", "panel": d_front_desk.Main_()}, //
    //
    {"name": "Data Front Desk", "panel": front_desk.Main_()}, //
    {"name": "Data Room", "panel": room.Main_()}, //
    {"name": "Data Guest", "panel": guest.Main_()},
    {"name": "Data User", "panel": user.Main_()},
    {"name": "Data Nationality", "panel": nationality.Main_()},
    //
    {"name": "Report Daily", "panel": report_daily.Main_()}, //
    {"name": "Report Weekly", "panel": report_weekly.Main_()}, //
    {"name": "Report Monthly", "panel": report_monthly.Main_()}, //
    {"name": "Report Yearly", "panel": report_yearly.Main_()}, //
    //
    {"name": "Demo 001", "panel": demo_1.Main_()},
    {"name": "Demo 002", "panel": demo_2.Main_()},

    //
    {"name": "Setting", "panel": setting.Main_()},
  ];

  @override
  Widget build(BuildContext context) {
    String body = context.watch<Global>().body;

    int index = 0;
    for (int i = 0; i < panels.length; i++) {
      if (panels[i]["name"] == body) {
        index = i;
        break;
      }
    }

    return IndexedStack(index: index, children: [for (var p in panels) p["panel"]]);
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
