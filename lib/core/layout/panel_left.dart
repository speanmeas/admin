import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:speanmeas/core/i18n/main.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/schema/user.g.dart";
import "package:speanmeas/core/theme.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  bool is_mobile = false;
  bool is_admin = false;
  bool is_manager = false;
  bool is_recept = false;
  bool is_cleaner = false;

  void init() async {
    try {
      tmp = await dio.post(endpoint.AUTH_ACCESS_TOKEN);

      if (tmp.data[sm_user.IS_ADMIN]?["value"] == true) is_admin = true;
      if (tmp.data[sm_user.IS_MANAGER]?["value"] == true) is_manager = true;
      if (tmp.data[sm_user.IS_RECEPTIONIST]?["value"] == true) is_recept = true;
      if (tmp.data[sm_user.IS_HOUSEKEEPER]?["value"] == true) is_cleaner = true;

      setState(() {});
    } catch (e, st) {
      pprint(st);
      snackbar(ct: context, ms: e.toString(), cl: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              if (is_admin || is_manager || is_recept || is_cleaner) //
                list_tile_l1(name: "Front Desk", icon: Icons.table_bar_outlined),

              // mini bar
              // if (is_admin || is_manager || is_recept) //
              //   list_tile_l1(name: "Mini Bar", icon: Icons.local_bar_outlined),

              // data
              ExpansionTile(
                leading: Icon(Icons.storage_outlined), //
                title: Text("Database"),
                initiallyExpanded: true,
                children: [
                  // front desk
                  if (is_admin || is_manager || is_recept || is_cleaner) //
                    list_tile_l2(prefix: "Data", name: "Front Desk", icon: Icons.table_bar_outlined),

                  // guest
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Guest", icon: Icons.people_outline),

                  // room
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Room", icon: Icons.hotel_outlined),

                  // nationality
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Nationality", icon: Icons.flag_outlined),

                  // user
                  if (is_admin || is_manager) //
                    list_tile_l2(prefix: "Data", name: "User", icon: Icons.person_outline),

                  // mini bar
                  if (is_admin || is_manager || is_recept) //
                    list_tile_l2(prefix: "Data", name: "Mini Bar", icon: Icons.local_bar_outlined),
                ],
              ),

              // Reports
              if (is_admin | is_manager | is_recept)
                ExpansionTile(
                  leading: Icon(Icons.assessment_outlined), //
                  title: Text("Report"),
                  initiallyExpanded: true,
                  children: [
                    list_tile_l2(prefix: "Report", name: "Income", icon: Icons.today_outlined),
                    // list_tile_l2(prefix: "Report", name: "Weekly", icon: Icons.date_range_outlined),
                    // list_tile_l2(prefix: "Report", name: "Monthly", icon: Icons.calendar_month_outlined),
                    // list_tile_l2(prefix: "Report", name: "Yearly", icon: Icons.event_note_outlined),
                  ],
                ),

              // Demos
              if (is_admin)
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
        list_tile_l1(name: "Setting", icon: Icons.settings_outlined),

        //
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
        glob.body = name;
        glob.notify();
        if (is_mobile) Navigator.pop(context);
        setState(() {});
      },
    );
  }

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
      child: Main_(),
    ),
  );
}
