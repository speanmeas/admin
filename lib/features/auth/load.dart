// * នាំចូល Flutter material និងធនធានចាំបាច់សម្រាប់ទំព័រផ្ទុក
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/layout/layout.dart";
import "sign_in.dart" as form_si;

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទំព័រផ្ទុក
class _LoadState extends State<Load> {
  //
  dynamic tmp;

  @override
  void initState() {
    super.initState();
    try_access_token();
  }

  @override
  Widget build(BuildContext context) {
    // * បង្ហាញរង្វង់ផ្ទុក
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

  // * ពិនិត្យ access token ដើម្បីកំណត់ទំព័របន្ទាប់
  void try_access_token() async {
    try {
      //
      // * អាន access token ពីការផ្ទុកសុវត្ថិភាព
      final ac_tk = await secure.read(key: "access_token");

      // * បើគ្មាន token ត្រឡប់ទៅទំព័រចូលប្រព័ន្ធ
      if (ac_tk == null) nav_replace(context, form_si.Main_());
      if (ac_tk == null) return;

      // * ផ្ទៀងផ្ទាត់ access token ជាមួយ server
      tmp = await dio.post(
        endpoint.AUTH_ACCESS_TOKEN, //
        data: {"access_token": ac_tk},
      );
      if (tmp == null) throw Exception("Invalid Access Token");

      // * កំណត់ Authorization header
      // dio.options.headers["Authorization"] = "Bearer $ac_tk";
      dio.set_token(ac_tk);

      //
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      // * ចូលទៅទំព័រមេ
      await glob.init();
      nav_replace(context, Layout());
    } catch (e, st) {
      // * បង្ហាញកំហុស និងលុប token មិនត្រឹមត្រូវ
      pprint(st);
      auth.clear();
      await secure.delete(key: "access_token");
      await secure.delete(key: "_id");
      nav_replace(context, form_si.Main_());
    }
  }
}

// * ថ្នាក់ Main_ ជាទំព័រផ្ទុក
class Load extends StatefulWidget {
  const Load({super.key});
  @override
  State<Load> createState() => _LoadState();
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
        home: Load(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
