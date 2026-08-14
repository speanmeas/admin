// * នាំចូល Flutter material និង Provider សម្រាប់ state management
import "package:flutter/material.dart";
import "package:speanmeas/core/i18n/main.dart";
import "package:provider/provider.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/features/auth/profile.dart" as profile;
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

// * ថ្នាក់ state របស់ Panel_Top គ្រប់គ្រងបន្ទះខាងលើ
class _Panel_TopState extends State<Panel_Top> {
  //
  dynamic tmp;

  // * ឈ្មោះពេញរបស់អ្នកប្រើប្រាស់
  String? full_name;

  // * ចាប់ផ្តើមផ្ទុកព័ត៌មានអ្នកប្រើប្រាស់
  void init() async {
    //
    try {
      //
      // * ទទួលបានព័ត៌មានអ្នកប្រើប្រាស់ពី server
      tmp = await dio.post(endpoint.AUTH_ACCESS_TOKEN);

      // * កំណត់ឈ្មោះពេញ
      full_name = tmp.data[sm_user.FULL_NAME]?["value"] ?? "X";

      setState(() {});
    } catch (e, st) {
      // * បង្ហាញកំហុសប្រសិនបើមាន
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    // * ពិនិត្យទទឹងអេក្រង់
    final is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    // * ទទួលបាន body និង version បច្ចុប្បន្ន
    String body = context.watch<Global>().body;
    String version = context.watch<Global>().VERSION;
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          //
          if (!is_mobile) SizedBox(width: 4),

          // * logo របស់កម្មវិធី
          SizedBox(
            width: 56,
            height: 32, //
            child: Image.asset(
              "assets/logo.png", //
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: 4), //

          // * បង្ហាញ body និង version
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(body), //
              Text(
                version,
                style: TextStyle(
                  fontSize: 12, //
                  color: Colors.blue,
                ),
              ), //
            ],
          ),

          Spacer(),

          // * រូបតំណាងដំណឹង
          // if (kDebugMode) // TODO
          Tooltip(
            message: "ដំណឹង", //
            child: Badge(
              label: Text("N"), //
              offset: Offset(-4, 4),
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, size: 30),
                onPressed: () {
                  snackbar(ct: context, ms: "កំពុងអភិវឌ្ឍន៍...", cl: Colors.blue);
                  // Handle notification tap
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => noti.Main_()));
                },
              ),
            ),
          ),

          SizedBox(width: 4),

          // * រូបតំណាងអ្នកប្រើប្រាស់
          Tooltip(
            message: "អ្នកប្រើប្រាស់", //
            child: InkWell(
              customBorder: const CircleBorder(),
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                // * បង្ហាញអក្សរទីមួយនៃឈ្មោះ
                child: Text(
                  (() {
                    if (full_name != null) //
                      return full_name!.substring(0, 1).toUpperCase();
                    else
                      return "X";
                  })(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              onTap: () {
                // * បើកទំព័រ profile
                Navigator.push(context, MaterialPageRoute(builder: (_) => profile.Main_()));
                init();
              },
            ),
          ),

          SizedBox(width: 8), //
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
}

// * ថ្នាក់ Panel_Top ជា widget សម្រាប់បន្ទះខាងលើ
class Panel_Top extends StatefulWidget {
  const Panel_Top({super.key});
  @override
  State<Panel_Top> createState() => _Panel_TopState();
}

// * ចំណុចចាប់ផ្តើមសម្រាប់ការអភិវឌ្ឍន៍
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
        home: Panel_Top(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
