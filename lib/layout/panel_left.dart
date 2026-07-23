import "package:flutter/material.dart";

import "package:speanmeas/__config__.dart";
import "package:speanmeas/__variable__.dart";
import "package:speanmeas/theme/theme_data.dart";
import "package:speanmeas/page/auth/schema.r.dart" as user;

class _Main_State extends State<Main_> {
  bool is_mobile = false;

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              // dashboard
              ExpansionTile(
                leading: Icon(Icons.dashboard_outlined), //
                title: Text("Dashboard"),
                initiallyExpanded: true,
                children: [
                  list_tile_l2(prefix: "Dashboard", name: "Front Desk", icon: Icons.table_bar_outlined), //
                ],
              ),

              // data
              ExpansionTile(
                leading: Icon(Icons.storage_outlined), //
                title: Text("Database"),
                children: [
                  list_tile_l2(prefix: "Database", name: "Front Desk", icon: Icons.table_bar_outlined), //
                  // Guest
                  if (user.data[user.IS_ADMIN]!["value"] == true || user.data[user.IS_MANAGER]!["value"] == true || user.data[user.IS_RECEPTIONIST]!["value"] == true) //
                    list_tile_l2(prefix: "Database", name: "Guest", icon: Icons.people_outline),

                  // Room
                  if (user.data[user.IS_ADMIN]!["value"] == true || user.data[user.IS_MANAGER]!["value"] == true) //
                    list_tile_l2(prefix: "Database", name: "Room", icon: Icons.hotel_outlined),

                  // User
                  if (user.data[user.IS_ADMIN]!["value"] == true || user.data[user.IS_MANAGER]!["value"] == true) //
                    list_tile_l2(prefix: "Database", name: "User", icon: Icons.person_outline),

                  list_tile_l2(prefix: "Database", name: "Nationality", icon: Icons.flag_outlined),
                ],
              ),

              // Reports
              ExpansionTile(
                leading: Icon(Icons.assessment_outlined), //
                title: Text("Report"),
                children: [
                  list_tile_l2(prefix: "Report", name: "Daily", icon: Icons.today_outlined),
                  list_tile_l2(prefix: "Report", name: "Weekly", icon: Icons.date_range_outlined),
                  list_tile_l2(prefix: "Report", name: "Monthly", icon: Icons.calendar_month_outlined),
                  list_tile_l2(prefix: "Report", name: "Yearly", icon: Icons.event_note_outlined),
                ],
              ),

              // Demos
              if (user.data[user.IS_ADMIN]!["value"] == true)
                ExpansionTile(
                  leading: Icon(Icons.model_training_outlined), //
                  title: Text("Demo"),
                  initiallyExpanded: true,
                  children: [
                    list_tile_l2(prefix: "Demo", name: "Demo 1", icon: Icons.model_training_outlined), //
                  ],
                ),

              //
            ],
          ),
        ),

        //
        list_tile_l1(name: "Setting", icon: Icons.settings_outlined),

        //
        SizedBox(height: 8),
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
      selected: global.body == name,
      selectedColor: Colors.blue,
      onTap: () {
        global.body = name;
        global.notifyListeners();
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
      selected: global.body == "$prefix - $name",
      selectedColor: Colors.blue,
      contentPadding: EdgeInsets.only(left: 40),
      onTap: () {
        global.body = "$prefix - $name";
        global.notifyListeners();
        if (is_mobile) Navigator.pop(context);
        setState(() {});
      },
    );
  }
}

class Main_ extends StatefulWidget {
  Main_({super.key});
  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development", //
      theme: Theme_Data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
