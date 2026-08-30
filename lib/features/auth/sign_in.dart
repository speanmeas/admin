// * នាំចូល Flutter material និងធនធានចាំបាច់សម្រាប់ការចូលប្រព័ន្ធ
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/core/layout/layout.dart";

// * ថ្នាក់ state របស់ Main_ គ្រប់គ្រងទំព័រចូលប្រព័ន្ធ
class _Main_State extends State<Main_> {
  dynamic tmp;

  bool is_password_visible = false;

  String? username;
  String? password;

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
                  decoration: InputDecoration(
                    labelText: "Username:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onChanged: (v) {
                    username = v;
                    setState(() {});
                  },
                  onSubmitted: (_) => on_sign_in(),
                ),
              ),

              // * ប្រអប់បញ្ចូលពាក្យសម្ងាត់
              Container(
                width: 600,
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Password:", //
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // * ប៊ូតុងបង្ហាញ/លាក់ពាក្យសម្ងាត់
                    suffixIcon: InkWell(
                      onTap: () {
                        is_password_visible = !is_password_visible;
                        setState(() {});
                      },
                      child: Icon(!is_password_visible ? Icons.visibility_outlined : Icons.visibility_off_outlined), //
                    ),
                  ),
                  obscureText: !is_password_visible,
                  onChanged: (v) {
                    password = v;
                    setState(() {});
                  },
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
    // * ផ្ញើសំណើចូលប្រព័ន្ធទៅ server
    tmp = await dio.post(
      endpoint.AUTH_SIGN_IN, //
      data: {
        "username": username, //
        "password": password,
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: dio.error_msg ?? "", cl: Colors.red);

    // * រក្សាទុក token និង id អ្នកប្រើ
    final data = tmp.data;
    await secure.write(key: "_id", value: data?["_id"]?.toString() ?? "");
    await secure.write(key: "access_token", value: data?["access_token"]?.toString() ?? "");
    dio.set_token(data?["access_token"]?.toString() ?? "");
    auth.clear();

    await glob.init();
    snackbar(ct: context, ms: "Success", cl: Colors.green);

    // * ប្តូរទៅទំព័រមេ
    nav_replace(context, Layout());
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
