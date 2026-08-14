// * នាំចូល Flutter material និងធនធានចាំបាច់សម្រាប់ dialog
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/secure.dart"; // ignore: unused_import
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * ថ្នាក់ state របស់ Dialog_ គ្រប់គ្រង dialog កែពាក្យសម្ងាត់
class _Dialog_State extends State<Dialog_> {
  //
  dynamic tmp;

  final title = "Update Password"; //
  final label_pw = "New Password:";
  final label_cf_pw = "Confirm New Password:";

  final controller_pw = TextEditingController();
  final controller_cf_pw = TextEditingController();

  // * កំណត់ការបង្ហាញ/លាក់ពាក្យសម្ងាត់
  bool is_obscure_pw = true;
  bool is_obscure_cf_pw = true;

  void init() async {
    //
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
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), //
        ],
      ),

      content: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          // * ប្រអប់បញ្ចូលពាក្យសម្ងាត់ថ្មី
          TextField(
            controller: controller_pw,
            decoration: InputDecoration(
              labelText: label_pw, //
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
            onChanged: (v) => setState(() {}),
            onSubmitted: (v) => can_okay() ? on_okay() : null,
          ),

          // * ប្រអប់បញ្ចូលពាក្យសម្ងាត់បញ្ជាក់
          TextField(
            controller: controller_cf_pw,
            decoration: InputDecoration(
              labelText: label_cf_pw, //
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
            onChanged: (v) => setState(() {}),
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
    if (controller_pw.text.isEmpty) return false;
    if (controller_cf_pw.text.isEmpty) return false;
    if (controller_pw.text != controller_cf_pw.text) return false;
    return true;
  }

  // * រក្សាទុកពាក្យសម្ងាត់ថ្មី
  void on_okay() async {
    try {
      // * ផ្ញើសំណើធ្វើបច្ចុប្បន្នភាពពាក្យសម្ងាត់
      tmp = await dio.post(
        endpoint.USER_CRUD_UPDATE, //
        data: {
          "_id": await secure.read(key: "_id"), //
          sm_user.PASSWORD: controller_pw.text, //
        },
      );
      if (tmp == null) throw "Failed";

      //
      Navigator.pop(context, true);
      snackbar(ct: context, ms: "Success", cl: Colors.green);
    } catch (e, st) {
      // * បង្ហាញកំហុសប្រសិនបើមាន
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
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
