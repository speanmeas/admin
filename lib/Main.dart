import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:provider/provider.dart";

import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/global.dart";
import "package:speanmeas/layout/layout.dart";
import "package:speanmeas/environment.dart";

import "page/auth/loading.dart";

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
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
      theme: Theme_Data(),
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
    Global.variable.VERSION = "${info.version}+${info.buildNumber}";
    Global.variable.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Loading_();
  }
}
