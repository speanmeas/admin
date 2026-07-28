///
///
///
///

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";

// dashboard
import "package:speanmeas/page/dashboard/front_desk/main.dart" as d_front_desk;

// database
import "package:speanmeas/page/front_desk/main.dart" as front_desk;
import "package:speanmeas/page/guest/main.dart" as guest;
import "package:speanmeas/page/room/main.dart" as room;
import "package:speanmeas/page/user/main.dart" as user;
import "package:speanmeas/page/nationality/main.dart" as nationality;

// report
import "package:speanmeas/page/report/daily/main.dart" as report_daily;
import "package:speanmeas/page/report/weekly/main.dart" as report_weekly;
import "package:speanmeas/page/report/monthly/main.dart" as report_monthly;
import "package:speanmeas/page/report/yearly/main.dart" as report_yearly;

import "package:speanmeas/page/demo_1/main.dart" as demo_1;

// setting
import "package:speanmeas/page/setting/main.dart" as setting;

class _Main_State extends State<Main_> {
  //
  List<Map<String, dynamic>> panels = [
    {"name": "", "panel": Text("This page is under development..")},
    //
    {"name": "Dashboard - Front Desk", "panel": d_front_desk.Main_()}, //
    //
    {"name": "Database - Front Desk", "panel": front_desk.Main_()}, //
    {"name": "Database - Room", "panel": room.Main_()}, //
    {"name": "Database - Guest", "panel": guest.Main_()},
    {"name": "Database - User", "panel": user.Main_()},
    {"name": "Database - Nationality", "panel": nationality.Main_()},
    //
    {"name": "Report - Daily", "panel": report_daily.Main_()}, //
    {"name": "Report - Weekly", "panel": report_weekly.Main_()}, //
    {"name": "Report - Monthly", "panel": report_monthly.Main_()}, //
    {"name": "Report - Yearly", "panel": report_yearly.Main_()}, //
    //
    {"name": "Demo - Demo 1", "panel": demo_1.Main_()},

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
