import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import
// dashboard
import "package:speanmeas/features/dashboard/front_desk/main.dart" as d_front_desk;
import "package:speanmeas/features/dashboard/mini_bar/main.dart" as d_mini_bar;

// database
// import "package:speanmeas/features/database/.front_desk/main.dart" as front_desk;
import "package:speanmeas/features/database/guest/main.dart" as guest;
import "package:speanmeas/features/database/room/main.dart" as room;
import "package:speanmeas/features/database/user/main.dart" as user;
import "package:speanmeas/features/database/nationality/main.dart" as nationality;
import "package:speanmeas/features/database/mini_bar/main.dart" as mini_bar;

// report
import "package:speanmeas/features/report/main.dart" as report;

import "package:speanmeas/features/database/demo_1/main.dart" as demo_1;
import "package:speanmeas/features/database/demo_2/main.dart" as demo_2;

// setting
import "package:speanmeas/features/setting/main.dart" as setting;
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  //
  List<Map<String, dynamic>> panels = [
    {"name": "", "panel": Text("This page is under development..")},
    //
    {"name": "Front Desk", "panel": d_front_desk.Main_()}, //
    {"name": "Mini Bar", "panel": d_mini_bar.Main_()}, //
    //
    // {"name": "Data Front Desk", "panel": front_desk.Main_()}, //
    {"name": "Data Room", "panel": room.Main_()}, //
    {"name": "Data Guest", "panel": guest.Main_()},
    {"name": "Data User", "panel": user.Main_()},
    {"name": "Data Nationality", "panel": nationality.Main_()},
    {"name": "Data Mini Bar", "panel": mini_bar.Main_()}, //
    //
    {"name": "Report Income", "panel": report.Main_()}, //
    // {"name": "Report Weekly", "panel": report_weekly.Main_()}, //
    // {"name": "Report Monthly", "panel": report_monthly.Main_()}, //
    // {"name": "Report Yearly", "panel": report_yearly.Main_()}, //
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
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme_data, //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
