import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/theme/light.dart" as theme;

import "package:speanmeas/features/auth/schema.g.dart" as sm_u;
import "package:speanmeas/features/auth/profile.dart" as profile;

import "../../notification.dart" as noti;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    final is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    String body = context.watch<Global>().body;
    String version = context.watch<Global>().VERSION;
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          //
          if (!is_mobile) SizedBox(width: 4),

          // logo
          SizedBox(
            width: 56,
            height: 32, //
            child: Image.asset(
              "assets/logo.png", //
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
          if (kDebugMode) // TODO
            Badge(
              label: Text("3"), //
              offset: Offset(-4, 4),
              child: IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Handle notification tap
                  Navigator.push(context, MaterialPageRoute(builder: (_) => noti.Main_()));
                },
              ),
            ),

          SizedBox(width: 4),

          // User Avatar
          InkWell(
            customBorder: const CircleBorder(),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Text(
                (() {
                  if (sm_u.data[sm_u.FULL_NAME]!["value"] != null) //
                    return sm_u.data[sm_u.FULL_NAME]!["value"].substring(0, 1).toUpperCase() ?? "X";
                  else
                    return "X";
                })(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => profile.Main_()));
              init();
            },
          ),

          SizedBox(width: 8), //
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
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
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
