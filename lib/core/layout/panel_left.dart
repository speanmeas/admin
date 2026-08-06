import "package:flutter/material.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/theme/theme_light.dart" as theme;
import "package:speanmeas/features/auth/schema.g.dart" as sm_u;

class _Main_State extends State<Main_> {
  //
  dynamic tmp;

  bool is_mobile = false;
  bool is_admin = false;
  bool is_manager = false;
  bool is_recept = false;
  bool is_cleaner = false;

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    is_admin = sm_u.data[sm_u.IS_ADMIN]?["value"] == true;
    is_manager = sm_u.data[sm_u.IS_MANAGER]?["value"] == true;
    is_recept = sm_u.data[sm_u.IS_RECEPTIONIST]?["value"] == true;
    is_cleaner = sm_u.data[sm_u.IS_HOUSEKEEPER]?["value"] == true;
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              if (is_admin || is_manager || is_recept || is_cleaner) //
                list_tile_l1(name: "Front Desk", icon: Icons.table_bar_outlined),

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
                ],
              ),

              // Reports
              if (is_admin)
                ExpansionTile(
                  leading: Icon(Icons.assessment_outlined), //
                  title: Text("Report"),
                  initiallyExpanded: true,
                  children: [
                    list_tile_l2(prefix: "Report", name: "Daily", icon: Icons.today_outlined),
                    list_tile_l2(prefix: "Report", name: "Weekly", icon: Icons.date_range_outlined),
                    list_tile_l2(prefix: "Report", name: "Monthly", icon: Icons.calendar_month_outlined),
                    list_tile_l2(prefix: "Report", name: "Yearly", icon: Icons.event_note_outlined),
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
}

class Main_ extends StatefulWidget {
  const Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: theme.data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
