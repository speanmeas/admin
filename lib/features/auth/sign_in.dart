// * នាំចូល Flutter material និងធនធានចាំបាច់សម្រាប់ការចូលប្រព័ន្ធ
import "package:flutter/material.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/layout/layout.dart" as layout;
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទំព័រចូលប្រព័ន្ធ
class _Main_State extends State<Main_> {
  //
  dynamic tmp;
  // * កំណត់ថាតើបង្ហាញពាក្យសម្ងាត់ឬអត់
  bool is_password_visible = false;

  final c_username = TextEditingController();
  final c_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final VERSION = context.watch<Global>().VERSION;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // * បង្ហាញរូបសញ្ញាសណ្ឋាគារ
              Container(
                height: 160, //
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Image.asset("assets/logo.png"),
              ),

              // * បង្ហាញឈ្មោះសណ្ឋាគារ
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                alignment: Alignment.center,
                child: Text(
                  "Spean Meas Hotel", //
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              // * បង្ហាញលេខកំណែកម្មវិធី
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                alignment: Alignment.center,
                child: Text(
                  VERSION,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                ), //
              ), //
              // * ប្រអប់បញ្ចូលឈ្មោះអ្នកប្រើ
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  autofocus: true,
                  controller: c_username,
                  decoration: InputDecoration(
                    labelText: "Username:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) => setState(() {}),
                  onSubmitted: (_) => on_sign_in(),
                ),
              ),

              // * ប្រអប់បញ្ចូលពាក្យសម្ងាត់
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  controller: c_password,
                  decoration: InputDecoration(
                    labelText: "Password:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // * ប៊ូតុងបង្ហាញ/លាក់ពាក្យសម្ងាត់
                    suffixIcon: InkWell(
                      onTap: password_visibility_toggle,
                      child: Icon(!is_password_visible ? Icons.visibility_outlined : Icons.visibility_off_outlined), //
                    ),
                  ),
                  obscureText: !is_password_visible,
                  onChanged: (v) => setState(() {}),
                  onSubmitted: (_) => on_sign_in(),
                ),
              ),

              // * ប៊ូតុងចូលប្រព័ន្ធ
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.login), //
                  label: Text("Signin"),
                  onPressed: on_sign_in,
                ),
              ),

              SizedBox(height: height - 100),
            ],
          ),
        ),
      ),
    );
  }

  // * ដំណើរការចូលប្រព័ន្ធ
  void on_sign_in() async {
    try {
      // * ផ្ញើសំណើចូលប្រព័ន្ធទៅ server
      tmp = await dio.post(
        endpoint.AUTH_SIGN_IN, //
        data: {
          "username": c_username.text, //
          "password": c_password.text,
        },
      );
      if (tmp == null) throw Exception("Invalid Username or Password");

      // * រក្សាទុក token និង id អ្នកប្រើ
      final data = tmp.data;
      final id = data?["_id"]?.toString() ?? "";
      final token = data?["access_token"]?.toString() ?? "";
      await secure.write(key: "_id", value: id);
      await secure.write(key: "access_token", value: token);
      dio.setToken(token);

      await glob.init();
      snackbar(ct: context, ms: "Success", cl: Colors.green);

      // * ប្តូរទៅទំព័រមេ
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => layout.Layout()));

      //
    } catch (e, st) {
      // * បង្ហាញកំហុសប្រសិនបើមាន
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  // * ប្តូរការបង្ហាញពាក្យសម្ងាត់
  void password_visibility_toggle() {
    is_password_visible = !is_password_visible;
    setState(() {});
  }
}

// * ថ្នាក់ Main_ ជាទំព័រចូលប្រព័ន្ធ
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
