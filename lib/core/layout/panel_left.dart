///
///
///
///

import "package:flutter/material.dart";

import "package:speanmeas/core/config.dart";
import "package:speanmeas/core/global.dart";
import "package:speanmeas/core/theme/theme_data.dart";
import "package:speanmeas/features/auth/schema.g.dart" as u_schema;

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
              // ExpansionTile(
              //   leading: Icon(Icons.dashboard_outlined), //
              //   title: Text("Dashboard"),
              //   initiallyExpanded: true,
              //   children: [
              //     list_tile_l2(prefix: "Dashboard", name: "Front Desk", icon: Icons.table_bar_outlined), //
              //   ],
              // ),
              list_tile_l1(name: "Front Desk", icon: Icons.table_bar_outlined),

              // data
              ExpansionTile(
                leading: Icon(Icons.storage_outlined), //
                title: Text("Database"),
                initiallyExpanded: true,
                children: [
                  // front desk
                  if (u_schema.data[u_schema.IS_ADMIN]!["value"] == true || u_schema.data[u_schema.IS_MANAGER]!["value"] == true || u_schema.data[u_schema.IS_RECEPTIONIST]!["value"] == true) //
                    list_tile_l2(prefix: "Data", name: "Front Desk", icon: Icons.table_bar_outlined),

                  // guest
                  if (u_schema.data[u_schema.IS_ADMIN]!["value"] == true || u_schema.data[u_schema.IS_MANAGER]!["value"] == true || u_schema.data[u_schema.IS_RECEPTIONIST]!["value"] == true) //
                    list_tile_l2(prefix: "Data", name: "Guest", icon: Icons.people_outline),

                  // nationality
                  if (u_schema.data[u_schema.IS_ADMIN]!["value"] == true || u_schema.data[u_schema.IS_MANAGER]!["value"] == true || u_schema.data[u_schema.IS_RECEPTIONIST]!["value"] == true) //
                    list_tile_l2(prefix: "Data", name: "Nationality", icon: Icons.flag_outlined),

                  // room
                  if (u_schema.data[u_schema.IS_ADMIN]!["value"] == true || u_schema.data[u_schema.IS_MANAGER]!["value"] == true) //
                    list_tile_l2(prefix: "Data", name: "Room", icon: Icons.hotel_outlined),

                  // user
                  if (u_schema.data[u_schema.IS_ADMIN]!["value"] == true || u_schema.data[u_schema.IS_MANAGER]!["value"] == true) //
                    list_tile_l2(prefix: "Data", name: "User", icon: Icons.person_outline),
                ],
              ),

              // Reports
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
              if (u_schema.data[u_schema.IS_ADMIN]!["value"] == true)
                ExpansionTile(
                  leading: Icon(Icons.model_training_outlined), //
                  title: Text("Demo"),
                  initiallyExpanded: true,
                  children: [
                    list_tile_l2(prefix: "Demo", name: "001", icon: Icons.model_training_outlined), //
                    list_tile_l2(prefix: "Demo", name: "002", icon: Icons.model_training_outlined), //
                  ],
                ),

              //
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
      selected: global.body == "$prefix $name",
      selectedColor: Colors.blue,
      contentPadding: EdgeInsets.only(left: 40),
      onTap: () {
        global.body = "$prefix $name";
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
      theme: data(), //
      home: Main_(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
