import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:provider/provider.dart";

import "package:speanmeas/environment.dart";
import "package:speanmeas/global.dart";
import "package:speanmeas/page/auth/profile.dart";
import "package:speanmeas/utility/dio.dart";
import "package:speanmeas/utility/secure_storage.dart";
import "package:speanmeas/page/auth/user.g.dart" as user;

void main() {
  runApp(ChangeNotifierProvider(create: (_) => Global.variable, child: const Panel_Top()));
}

class Panel_Top extends StatelessWidget {
  const Panel_Top({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)), // todo: fix this later
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
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    String body = context.watch<Global>().body;
    String version = context.watch<Global>().VERSION;
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
              "asset/logo.png", //
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: 4), //

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(body), //
              Text(
                version,
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
              label: Text("3"), //
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
              child: Text(
                user.data[user.USER_FULL_NAME]!["value"].substring(0, 1).toUpperCase() ?? "", //
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              Navigator.push(
                context, //
                MaterialPageRoute(builder: (_) => User_Profile_()),
              ).then((v) => init());
            },
          ),

          SizedBox(width: 8), //
        ],
      ),
    );
  }
}
