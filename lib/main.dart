import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n.dart";
import "package:speanmeas/core/theme_data.dart"; // ignore: unused_import
import "features/auth/loading.dart" as loading;
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import

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
      child: Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "$TITLE Admin", //
      theme: theme_data, //
      debugShowCheckedModeBanner: false,
      home: loading.Main_(),
    );
  }
}
