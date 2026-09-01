// * នាំចូល Flutter material និង Provider សម្រាប់ state management
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/utility/all.dart";

// * ថ្នាក់ state របស់ Panel_Left គ្រប់គ្រង menu ខាងឆ្វេង
class _Panel_LeftState extends State<Panel_Left> {
  // * កំណត់របៀបបង្ហាញ
  bool is_mobile = false;
  // * តួនាទីរបស់អ្នកប្រើប្រាស់
  bool is_admin = false;
  bool is_manager = false;
  bool is_recept = false;
  bool is_cleaner = false;

  // * ចាប់ផ្តើមផ្ទុកតួនាទីរបស់អ្នកប្រើប្រាស់
  void init() async {
    // * ទទួលបានអ្នកប្រើបច្ចុប្បន្នពី AuthService (cache តែម្តងក្នុងមួយ shell)
    final user = await auth.fetch();
    if (user == null) return;

    // * កំណត់តួនាទីពីទិន្នន័យដែលបានទទួល
    if (user.is_admin == true) is_admin = true;
    if (user.is_manager == true) is_manager = true;
    if (user.is_receptionist == true) is_recept = true;
    if (user.is_housekeeper == true) is_cleaner = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // * ពិនិត្យទទឹងអេក្រង់
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              // * បង្ហាញ Front Desk សម្រាប់អ្នកប្រើប្រាស់ដែលមានសិទ្ធិ
              if (is_admin || is_manager || is_recept || is_cleaner) //
                list_tile_l1(name: "Front Desk", icon: Icons.table_bar_outlined),

              // * ផ្នែក Database
              ExpansionTile(
                leading: Icon(Icons.storage_outlined), //
                title: Text("Database"),
                initiallyExpanded: true,
                children: [
                  // * front desk
                  // if (is_admin || is_manager || is_recept || is_cleaner) //
                  // if (kDebugMode) //
                  //   list_tile_l2(prefix: "Data", name: "Front Desk", icon: Icons.table_bar_outlined),

                  // * guest
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Guest", icon: Icons.people_outline),

                  // * room
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Room", icon: Icons.hotel_outlined),

                  // * nationality
                  // if (is_admin || is_manager || is_recept) //
                  //   list_tile_l2(prefix: "Data", name: "Nationality", icon: Icons.flag_outlined),

                  // * bank
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Bank", icon: Icons.flag_outlined),

                  // * user
                  if (is_admin || is_manager) //
                    list_tile_l2(prefix: "Data", name: "User", icon: Icons.person_outline),

                  // * mini bar
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Mini Bar", icon: Icons.local_bar_outlined),

                  // * penalty
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Penalty", icon: Icons.gavel_outlined),
                ],
              ),

              // * ផ្នែក Reports
              if (is_admin || is_manager || is_recept)
                ExpansionTile(
                  leading: Icon(Icons.assessment_outlined), //
                  title: Text("Report"),
                  initiallyExpanded: true,
                  children: [
                    list_tile_l2(prefix: "Report", name: "Daily", icon: Icons.today_outlined),
                    // list_tile_l2(prefix: "Report", name: "Weekly", icon: Icons.date_range_outlined),
                    // list_tile_l2(prefix: "Report", name: "Monthly", icon: Icons.calendar_month_outlined),
                    // list_tile_l2(prefix: "Report", name: "Yearly", icon: Icons.event_note_outlined),
                  ],
                ),

              // * ផ្នែក Demos
              if (kDebugMode) //
                ExpansionTile(
                  leading: Icon(Icons.model_training_outlined), //
                  title: Text("Demo"),
                  initiallyExpanded: true,
                  children: [
                    list_tile_l2(prefix: "Demo", name: "001", icon: Icons.model_training_outlined), //
                    list_tile_l2(prefix: "Demo", name: "002", icon: Icons.model_training_outlined), //
                  ],
                ),
            ],
          ),
        ),

        //
        // * ប៊ូតុង Setting
        list_tile_l1(name: "Setting", icon: Icons.settings_outlined),

        //
        // * ផ្នែកខាងក្រោម
        Container(
          height: 32,
          alignment: .topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This footer is under development.", //
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // * បង្កើត ListTile កម្រិតទី 1
  Widget list_tile_l1({
    required String name, //
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      selected: glob.body == name,
      selectedColor: Colors.blue,
      onTap: () {
        // * ផ្លាស់ប្តូរ body បច្ចុប្បន្ន
        glob.body = name;
        glob.notify();
        if (is_mobile) Navigator.pop(context);
        setState(() {});
      },
    );
  }

  // * បង្កើត ListTile កម្រិតទី 2
  Widget list_tile_l2({
    required String prefix, //
    required String name, //
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      selected: glob.body == "$prefix $name",
      selectedColor: Colors.blue,
      contentPadding: EdgeInsets.only(left: 40),
      onTap: () {
        // * ផ្លាស់ប្តូរ body បច្ចុប្បន្នជាមួយ prefix
        glob.body = "$prefix $name";
        glob.notify();
        if (is_mobile) Navigator.pop(context);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  //
}

// * ថ្នាក់ Panel_Left ជា widget សម្រាប់ menu ខាងឆ្វេង
class Panel_Left extends StatefulWidget {
  const Panel_Left({super.key});
  @override
  State<Panel_Left> createState() => _Panel_LeftState();
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
        home: Panel_Left(), //
        theme: theme_data, //
        title: "Development", //
        debugShowCheckedModeBanner: false, //
      ),
    ),
  );
}
