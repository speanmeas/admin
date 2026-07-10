import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/theme/theme_data.dart";

import "package:speanmeas/Global.dart";
import "package:speanmeas/page/guest/main.dart" as guest;
import "package:speanmeas/page/room/main.dart" as room;
import "package:speanmeas/page/user/main.dart" as user;
import "package:speanmeas/page/nationality/main.dart" as nationality;

import "package:speanmeas/page/front_desk_design/main.dart" as front_desk_design;

import "package:speanmeas/page/demo/main.dart" as demo;

// import "package:speanmeas/page/demo_1/Main.dart" as demo_1;
// import "package:speanmeas/page/.demo_1a/Main.dart" as demo_1a;
// import "package:speanmeas/page/.demo_1b/Main.dart" as demo_1b;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
      child: const Body(),
    ),
  );
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Body",
      theme: Theme_Data(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: const Panel_Body_()),
    );
  }
}

class Panel_Body_ extends StatefulWidget {
  const Panel_Body_({super.key});

  @override
  State<Panel_Body_> createState() => _Panel_Body_State();
}

class _Panel_Body_State extends State<Panel_Body_> {
  //

  @override
  Widget build(BuildContext context) {
    String body = context.watch<Global>().body;

    if (body == "Front Desk") {
      return front_desk_design.Main_();
    }

    if (body == "Room") {
      return room.Main_();
    }

    if (body == "Guest") {
      return guest.Main_();
    }

    if (body == "User") {
      return user.Main_();
    }

    if (body == "Nationality") {
      return nationality.Main_();
    }
    if (body == "Demo") {
      return demo.Main_();
    }

    // if (body == "Demo 1") {
    //   return demo_1.Main_();
    // }

    // if (body == "Demo 1A") {
    //   return demo_1a.Main_();
    // }

    // if (body == "Demo 1B") {
    //   return demo_1b.Main_();
    // }

    return const SizedBox();
  }
}
