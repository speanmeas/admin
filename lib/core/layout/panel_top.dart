// * នាំចូល Flutter material និង Provider សម្រាប់ state management
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

import "package:speanmeas/features/auth/profile.dart";

// * ថ្នាក់ state របស់ Panel_Top គ្រប់គ្រងបន្ទះខាងលើ
class _Panel_TopState extends State<Panel_Top> {
  // * ឈ្មោះពេញរបស់អ្នកប្រើប្រាស់
  String? full_name;

  // * ចាប់ផ្តើមផ្ទុកព័ត៌មានអ្នកប្រើប្រាស់
  void init() async {
    // * ទទួលបានអ្នកប្រើបច្ចុប្បន្នពី AuthService (cache តែម្តងក្នុងមួយ shell)
    final user = await auth.fetch();
    full_name = user?.full_name ?? "X";
    setState(() {});
  }

  // * ទាញយកថ្មី (ក្រោយកែ profile)
  void refresh() async {
    final user = await auth.refresh();
    if (mounted) setState(() => full_name = user?.full_name ?? "X");
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
                nav_push(context, Profile());
                refresh();
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
