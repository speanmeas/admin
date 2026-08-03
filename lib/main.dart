import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n.dart";
import "package:speanmeas/core/theme/theme_data.dart" as theme;

import "features/auth/loading.dart" as loading;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await lang.set_locale("en_EN");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: glob),
        ChangeNotifierProvider.value(value: lang),
      ],
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
      theme: theme.data(),
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
    glob.VERSION = "${info.version}+${info.buildNumber}";
    glob.notifyListeners();
    print("VERSION: ${glob.VERSION}");
  }

  @override
  Widget build(BuildContext context) {
    return loading.Main_();
  }
}
