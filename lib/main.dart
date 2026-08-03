import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/theme/theme_data.dart";

import "features/auth/loading.dart" as loading;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => global, //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "$TITLE Admin", //
      theme: data(),
      debugShowCheckedModeBanner: false,
      // home: Layout_Dashboard_(),
      home: Main_(),
    );
  }
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

class _Main_State extends State<Main_> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final info = await PackageInfo.fromPlatform();
    global.VERSION = "${info.version}+${info.buildNumber}";
    global.notifyListeners();
    print("VERSION: ${global.VERSION}");
  }

  @override
  Widget build(BuildContext context) {
    return loading.Main_();
  }
}
