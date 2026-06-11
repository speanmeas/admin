import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/page/User_Profile.dart';
import 'package:speanmeas/utility/Dio.dart';
import 'package:speanmeas/utility/Secure_Storage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Panel_Top(),
    ),
  );
}

class Panel_Top extends StatelessWidget {
  const Panel_Top({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(body: const Panel_Top_()),
    );
  }
}

class Panel_Top_ extends StatefulWidget {
  const Panel_Top_({super.key});

  @override
  State<Panel_Top_> createState() => _Panel_Top_State();
}

class _Panel_Top_State extends State<Panel_Top_> {
  String VERSION = '0.0.0+0';

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() async {
    final info = await PackageInfo.fromPlatform();
    VERSION = '${info.version}+${info.buildNumber}';
    setState(() {});
  }

  bool isMobile = false;
  Global global = Global();

  @override
  Widget build(BuildContext context) {
    isMobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    global = context.watch<Global>();
    return Container(
      height: 48,
      decoration: isMobile ? null : BoxDecoration(border: Border(bottom: BorderSide())), //

      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          //
          if (!isMobile) SizedBox(width: 4),

          // logo
          SizedBox(
            width: 56,
            height: 32, //
            child: Image.asset(
              'asset/logo.png', //
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: 4), //

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(global.body), //
              Text(
                VERSION,
                style: TextStyle(
                  fontSize: 12, //
                  color: Colors.blue,
                ),
              ), //
            ],
          ),

          Spacer(),

          // Notification Icon
          if (kDebugMode)
            Badge(
              label: Text('3'), //
              offset: Offset(-4, 4),
              child: IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Handle notification tap
                },
              ),
            ),

          SizedBox(width: 4),

          // User Avatar
          InkWell(
            customBorder: const CircleBorder(),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: build_avatar(),
            ),
            onTap: () {
              Navigator.push(
                context, //
                MaterialPageRoute(builder: (_) => User_Profile_()),
              );
            },
          ),

          SizedBox(width: 8), //
        ],
      ),
    );
  }

  Widget build_avatar() {
    if (global.is_admin) return Text("A", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
    if (global.is_manager) return Text("M", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
    if (global.is_receptionist) return Text("R", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
    if (global.is_housekeeper) return Text("H", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));

    return Text("X", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }
}
