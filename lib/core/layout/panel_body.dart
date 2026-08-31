// * នាំចូល Flutter material និង Provider សម្រាប់ state management
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * dashboard
import "package:speanmeas/features/dashboard/front_desk/main.dart" as d_front_desk_new;
// import "package:speanmeas/features/dashboard/mini_bar/main.dart" as d_mini_bar;

// * database
// import "package:speanmeas/features/database/front_desk/main.dart" as front_desk;
import "package:speanmeas/features/database/guest/main.dart" as guest;
import "package:speanmeas/features/database/room/main.dart" as room;
import "package:speanmeas/features/database/user/main.dart" as user;
import "package:speanmeas/features/database/nationality/main.dart" as nationality;
import "package:speanmeas/features/database/bank/main.dart" as bank;
import "package:speanmeas/features/database/mini_bar/main.dart" as mini_bar;
import "package:speanmeas/features/database/penalty/main.dart" as penalty;

// * report
import "package:speanmeas/features/report/daily.dart" as report_daily;

import "package:speanmeas/features/database/demo_1/main.dart" as demo_1;
// import "package:speanmeas/features/database/demo_2_1/main.dart" as demo_2_1;
// import "package:speanmeas/features/database/demo_2_2/main.dart" as demo_2_2;

// * setting
import "package:speanmeas/features/setting/main.dart" as setting;

// * ថ្នាក់ state របស់ Panel_Body គ្រប់គ្រងការបង្ហាញ panel នីមួយៗ
class _Panel_BodyState extends State<Panel_Body> {
  // * បញ្ជី panel ទាំងអស់របស់កម្មវិធី
  List<Map<String, dynamic>> panels = [
    {"name": "", "panel": Text("This page is under development..")},
    //
    {"name": "Front Desk", "panel": d_front_desk_new.Main_()}, //
    //
    {"name": "Data Room", "panel": room.Main_()}, //
    {"name": "Data Guest", "panel": guest.Main_()},
    {"name": "Data User", "panel": user.Main_()},
    {"name": "Data Nationality", "panel": nationality.Main_()},
    {"name": "Data Bank", "panel": bank.Main_()},
    {"name": "Data Mini Bar", "panel": mini_bar.Main_()}, //
    {"name": "Data Penalty", "panel": penalty.Main_()}, //
    //
    {"name": "Report Daily", "panel": report_daily.Main_()}, //
    //
    {"name": "Demo 001", "panel": demo_1.Main_()},
    // {"name": "Demo 002-1", "panel": demo_2_1.Main_()},
    // {"name": "Demo 002-2", "panel": demo_2_2.Main_()},

    //
    {"name": "Setting", "panel": setting.Main_()},
  ];

  @override
  Widget build(BuildContext context) {
    // * ទទួលបាន body បច្ចុប្បន្នពី global state
    String body = context.watch<Global>().body;

    // * ស្វែងរក index នៃ panel ដែលត្រូវបង្ហាញ
    int index = 0;
    for (int i = 0; i < panels.length; i++) {
      if (panels[i]["name"] == body) {
        index = i;
        break;
      }
    }

    // * បង្ហាញ panel ដែលបានជ្រើសរើស
    return IndexedStack(index: index, children: [for (var p in panels) p["panel"]]);
  }
}

// * ថ្នាក់ Panel_Body ជា widget សម្រាប់បង្ហាញខ្លឹមសារ
class Panel_Body extends StatefulWidget {
  const Panel_Body({super.key});
  @override
  State<Panel_Body> createState() => _Panel_BodyState();
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
        home: Panel_Body(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
