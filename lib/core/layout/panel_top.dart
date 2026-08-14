import "package:flutter/material.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/features/auth/profile.dart" as profile;
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  String? full_name;

  void init() async {
    //
    try {
      //
      tmp = await dio.post(endpoint.AUTH_ACCESS_TOKEN);

      full_name = tmp.data[sm_user.FULL_NAME]?["value"] ?? "X";

      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
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
          // if (kDebugMode) // TODO
          Tooltip(
            message: "ដំណឹង", //
            child: Badge(
              label: Text("N"), //
              offset: Offset(-4, 4),
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, size: 30),
                onPressed: () {
                  snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
                  // Handle notification tap
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => noti.Main_()));
                },
              ),
            ),
          ),

          SizedBox(width: 4),

          // User Avatar
          Tooltip(
            message: "អ្នកប្រើប្រាស់", //
            child: InkWell(
              customBorder: const CircleBorder(),
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Text(
                  (() {
                    if (full_name != null) //
                      return full_name!.substring(0, 1).toUpperCase();
                    else
                      return "X";
                  })(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => profile.Main_()));
                init();
              },
            ),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  glob.init();
  lang.init();
  //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
      child: Main_(),
    ),
  );
}
