import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:speanmeas/core/global.dart";

import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure.dart"; // ignore: unused_import
import "package:speanmeas/core/layout/layout.dart" as layout;

import "sign_in.dart" as form_si;
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  void initState() {
    super.initState();
    try_access_token();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Colors.blue, //
          strokeWidth: 4,
        ),
      ),
    );
  }

  void try_access_token() async {
    try {
      //
      final ac_tk = await secure.read(key: "access_token");

      if (ac_tk == null)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => form_si.Main_(), //
          ),
        );
      if (ac_tk == null) return;

      //
      tmp = await dio.post(
        endpoint.AUTH_ACCESS_TOKEN, //
        data: {"access_token": ac_tk},
      );
      if (tmp == null) throw Exception("Invalid Access Token");

      //
      dio.options.headers["Authorization"] =
          "Bearer ${await secure.read(
            key: "access_token", //
          )}";

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      //
      await glob.init();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Layout()));
    } catch (e, st) {
      pprint(st);
      await secure.delete(key: "access_token");
      await secure.delete(key: "_id");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => form_si.Main_(), //
        ),
      );
    }
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
      child: MaterialApp(
        home: Main_(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
