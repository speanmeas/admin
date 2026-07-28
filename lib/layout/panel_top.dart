///
///
///
///

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";

import "package:speanmeas/page/auth/schema.g.dart" as u_schema;
import "package:speanmeas/page/auth/profile.dart" as profile;

import "notification.dart" as notification;

class _Main_State extends State<Main_> {
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
          Badge(
            label: Text("3"), //
            offset: Offset(-4, 4),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {
                // Handle notification tap
                Navigator.push(context, MaterialPageRoute(builder: (_) => notification.Main_()));
              },
            ),
          ),

          SizedBox(width: 4),

          // User Avatar
          if (u_schema.data[u_schema.FULL_NAME]!["value"] != null) //
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
                  u_schema.data[u_schema.FULL_NAME]!["value"].substring(0, 1).toUpperCase() ?? "", //
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
