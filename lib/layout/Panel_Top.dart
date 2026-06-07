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

  String? username;

  @override
  void initState() {
    super.initState();

    // add username to dio
    Future.microtask(() {
      secure_storage.read(key: 'username').then((value) {
        username = value;
        setState(() {});
      });
    });

    init();
  }

  void init() async {
    final info = await PackageInfo.fromPlatform();
    VERSION = '${info.version}+${info.buildNumber}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    final v = context.watch<Global>();
    return Container(
      height: 48,
      decoration: isMobile ? null : BoxDecoration(border: Border(bottom: BorderSide())), //

      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          //
          if (!isMobile) SizedBox(width: 4), //
          // logo
          SizedBox(
            width: 56,
            height: 32, //
            child: Image.asset(
              'asset/logo.png', //
              fit: BoxFit.contain,
            ),
          ), //
          SizedBox(width: 4), //
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(v.body), //
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
          // Dark Mode Toggle
          // IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode_outlined)), //
          // Search Icon
          // IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined)), //
          // Dark Mode Toggle
          // IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode_outlined)), //
          SizedBox(width: 4), //
          // DropdownButton<String>(
          //   value: 'En',
          //   items: ['En', 'Kh'].map((String value) {
          //     return DropdownMenuItem<String>(value: value, child: Text(value));
          //   }).toList(),
          //   onChanged: (String? newValue) {},
          // ),
          // SizedBox(width: 10),

          // Login Icon
          // IconButton(
          //   onPressed: () {}, //
          //   icon: Icon(Icons.login_outlined),
          // ),

          // User Avatar
          InkWell(
            onTap: () {
              Navigator.push(
                context, //
                MaterialPageRoute(builder: (_) => User_Profile_()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Text(username?.substring(0, 1).toUpperCase() ?? "X"), //
              ),
            ),
          ),

          // OutlinedButton.icon(
          //   onPressed: () {
          //     secure_storage.delete(key: 'access_token');
          //     dio.options.headers.remove('Authorization');
          //     username = null;
          //     setState(() {});
          //     Navigator.pushReplacement(
          //       context, //
          //       MaterialPageRoute(builder: (_) => Sign_In_()),
          //     );
          //   }, //
          //   icon: Icon(Icons.logout, color: Colors.red), //
          //   label: Text("Leave", style: TextStyle(color: Colors.red)), //
          // ),
          SizedBox(width: 8), //
        ],
      ),
    );
  }
}
