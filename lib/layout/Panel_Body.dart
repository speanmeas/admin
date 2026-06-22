import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/theme/Theme_Data.dart';
import 'package:speanmeas/Global.dart';

import 'package:speanmeas/page/front_desk/Main.dart' as front_desk;
import 'package:speanmeas/page/guest/Main.dart' as guest;
import 'package:speanmeas/page/room/Main.dart' as room;
import 'package:speanmeas/page/user/Main.dart' as user;
import 'package:speanmeas/page/.check_in/Main.dart' as check_in;
import 'package:speanmeas/page/.setting/Main.dart' as setting;

import 'package:speanmeas/page/demo/Main.dart' as demo;

import 'package:speanmeas/page/demo_1/Main.dart' as demo_1;
import 'package:speanmeas/page/demo_1a/Main.dart' as demo_1a;
import 'package:speanmeas/page/demo_1b/Main.dart' as demo_1b;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Body(),
    ),
  );
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Body',
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

  Global global = Global();

  @override
  Widget build(BuildContext context) {
    global = context.watch<Global>();

    if (global.body == "Front Desk") {
      return front_desk.Main_();
    }

    if (global.body == "Room") {
      return room.Main_();
    }

    if (global.body == "Guest") {
      return guest.Main_();
    }

    if (global.body == "User") {
      return user.Main_();
    }

    if (global.body == "Demo") {
      return demo.Main_();
    }

    if (global.body == "Demo 1") {
      return demo_1.Main_();
    }

    if (global.body == "Demo 1A") {
      return demo_1a.Main_();
    }

    if (global.body == "Demo 1B") {
      return demo_1b.Main_();
    }

    return const SizedBox();
  }
}
