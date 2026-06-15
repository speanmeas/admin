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

import 'package:speanmeas/page/template/Main.dart' as template;
import 'package:speanmeas/page/template_1/Main.dart' as template_1;

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

    if (global.body == "Template") {
      return template.Main_();
    }

    if (global.body == "Template 1") {
      return template_1.Main_();
    }

    return const SizedBox();
  }
}
