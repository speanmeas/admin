import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";

import "package:speanmeas/page/guest/main.dart" as guest;
import "package:speanmeas/page/room/main.dart" as room;
import "package:speanmeas/page/user/main.dart" as user;
import "package:speanmeas/page/nationality/main.dart" as nationality;

import "package:speanmeas/page/demo_1/main.dart" as demo_1;

class _Main_State extends State<Main_> {
  //
  List<Map<String, dynamic>> panels = [
    {"name": "", "panel": Text("This page is under development.")}, //
    {"name": "Room", "panel": room.Main_()}, //
    {"name": "Guest", "panel": guest.Main_()},
    {"name": "User", "panel": user.Main_()},
    {"name": "Nationality", "panel": nationality.Main_()},
    {"name": "Demo 1", "panel": demo_1.Main_()},
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
