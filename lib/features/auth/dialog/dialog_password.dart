// * នាំចូល Flutter material និងធនធានចាំបាច់សម្រាប់ dialog
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/schema.g.dart";

// * ថ្នាក់ state របស់ Dialog_ គ្រប់គ្រង dialog កែពាក្យសម្ងាត់
class _Dialog_State extends State<Dialog_> {
  dynamic tmp;

  String password = "";
  String confirmed_password = "";

  // * កំណត់ការបង្ហាញ/លាក់ពាក្យសម្ងាត់
  bool is_obscure_pw = true;
  bool is_obscure_cf_pw = true;

  void init() async {
    password = "";
    confirmed_password = "";
  }

  @override
  Widget build(BuildContext context) {
    // * បង្កើត AlertDialog សម្រាប់បញ្ចូលពាក្យសម្ងាត់ថ្មី
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(4),
      actionsPadding: EdgeInsets.all(4),
      alignment: AlignmentGeometry.topCenter, //
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Update Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
        ],
      ),

      content: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          // * ប្រអប់បញ្ចូលពាក្យសម្ងាត់ថ្មី
          TextField(
            decoration: InputDecoration(
              labelText: "New Password:", //
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // * ប៊ូតុងបង្ហាញ/លាក់ពាក្យសម្ងាត់
              suffixIcon: ExcludeFocus(
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(is_obscure_pw ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      is_obscure_pw = !is_obscure_pw;
                      setState(() {});
                    },
                  ), //
                ),
              ),
            ),
            obscureText: is_obscure_pw, //
            autofocus: true,
            onChanged: (v) {
              password = v;
              setState(() {});
            },
            onSubmitted: (v) => can_okay() ? on_okay() : null,
          ),

          // * ប្រអប់បញ្ចូលពាក្យសម្ងាត់បញ្ជាក់
          TextField(
            decoration: InputDecoration(
              labelText: "Confirm New Password:", //
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // * ប៊ូតុងបង្ហាញ/លាក់ពាក្យសម្ងាត់
              suffixIcon: ExcludeFocus(
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(is_obscure_cf_pw ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      is_obscure_cf_pw = !is_obscure_cf_pw;
                      setState(() {});
                    },
                  ), //
                ),
              ),
            ),
            obscureText: is_obscure_cf_pw, //
            onChanged: (v) {
              confirmed_password = v;
              setState(() {});
            },
            onSubmitted: (v) => can_okay() ? on_okay() : null,
          ),
        ],
      ),
      actions: [
        // * ប៊ូតុងបោះបង់
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context); //
          },
          child: Text("Cancel"), //
        ),
        // * ប៊ូតុងយល់ព្រម
        OutlinedButton(
          onPressed: can_okay() ? on_okay : null,
          child: Text("Okay"), //
        ),
      ],
    );
  }

  // * ពិនិត្យថាតើអាចរក្សាទុកបានឬអត់
  bool can_okay() {
    if (password.isEmpty) return false;
    if (confirmed_password.isEmpty) return false;
    if (password != confirmed_password) return false;
    return true;
  }

  // * រក្សាទុកពាក្យសម្ងាត់ថ្មី
  void on_okay() async {
    // * ផ្ញើសំណើធ្វើបច្ចុប្បន្នភាពពាក្យសម្ងាត់
    tmp = await dio.post(
      endpoint.USER_CRUD_UPDATE, //
      data: {
        User.ID: await secure.read(key: "_id"), //
        User.PASSWORD: password, //
      },
    );
    if (tmp == null) return snackbar(ct: context, ms: "Error: ${endpoint.USER_CRUD_UPDATE}", cl: Colors.red);

    snackbar(ct: context, ms: "Success", cl: Colors.green);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Dialog_ ជា dialog កែពាក្យសម្ងាត់
class Dialog_ extends StatefulWidget {
  const Dialog_({super.key});

  @override
  State<Dialog_> createState() => _Dialog_State();
}

// * បង្ហាញ dialog កែពាក្យសម្ងាត់
Future<dynamic> view({required BuildContext context}) {
  return showDialog<dynamic>(
    context: context,
    builder: (context) {
      return Dialog_(); //
    },
  );
}

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () async {
            final v = await view(context: context);
            print("value: $v");
          },
          child: const Text("Show Dialog"),
        ),
      ),
    );
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
