import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global_Variable.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Variable(), //
      child: const Panel_Left(),
    ),
  );
}

class Panel_Left extends StatelessWidget {
  const Panel_Left({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(body: const Panel_Left_()),
    );
  }
}

class Panel_Left_ extends StatefulWidget {
  const Panel_Left_({super.key});

  @override
  State<Panel_Left_> createState() => _Panel_Left_State();
}

class _Panel_Left_State extends State<Panel_Left_> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    final v = context.watch<Variable>();
    return ListView(
      // shrinkWrap: true,
      children: [
        ListTile(
          leading: Icon(Icons.dashboard_outlined),
          title: Text("Dashboard"),
          selected: selected == "Dashboard",
          selectedColor: Colors.blue,
          onTap: () {
            if (v.body != "Dashboard") {
              v.body = "Dashboard";
              v.notifyListeners();
            }
            selected = "Dashboard";
            setState(() {});
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        ListTile(
          leading: Icon(Icons.people_outline),
          title: Text("Check In/Out"),
          selected: selected == "Check In/Out",
          selectedColor: Colors.blue,
          onTap: () {
            if (v.body != "Check In/Out") {
              v.body = "Check In/Out";
              v.notifyListeners();
            }
            selected = "Check In/Out";
            setState(() {});
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        ListTile(
          leading: Icon(Icons.hotel_outlined),
          title: Text("Room"),
          selected: selected == "Room",
          selectedColor: Colors.blue,
          onTap: () {
            if (v.body != "Room") {
              v.body = "Room";
              v.notifyListeners();
            }
            selected = "Room";
            setState(() {});
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        ListTile(
          leading: Icon(Icons.people_outline),
          title: Text("Guest"),
          selected: selected == "Guest",
          selectedColor: Colors.blue,
          onTap: () {
            if (v.body != "Guest") {
              v.body = "Guest";
              v.notifyListeners();
            }
            selected = "Guest";
            setState(() {});
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        ListTile(
          leading: Icon(Icons.work_outline),
          title: Text("Staff"),
          selected: selected == "Staff",
          selectedColor: Colors.blue,
          onTap: () {
            if (v.body != "Staff") {
              v.body = "Staff";
              v.notifyListeners();
            }
            selected = "Staff";
            setState(() {});
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        // Reports
        ExpansionTile(
          leading: Icon(Icons.assessment_outlined), //
          title: Text('Reports'),
          children: [
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: selected == "Daily Report",
              selectedColor: Colors.blue,
              title: Text(
                'Daily Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                selected = "Daily Report";
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: selected == "Weekly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Weekly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                selected = "Weekly Report";
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: selected == "Monthly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Monthly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                selected = "Monthly Report";
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: selected == "Yearly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Yearly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                selected = "Yearly Report";
                setState(() {});
              },
            ),
          ],
        ),

        // Template
        ListTile(
          leading: Icon(Icons.model_training_outlined),
          title: Text("Template"),
          selected: selected == "Template",
          selectedColor: Colors.blue,
          onTap: () {
            if (v.body != "Template") {
              v.body = "Template";
              v.notifyListeners();
            }
            selected = "Template";
            setState(() {});
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        // Setting
        // ListTile(
        //   leading: Icon(Icons.settings_outlined),
        //   title: Text("Setting"),
        //   onTap: () {
        //     if (v.body != "Setting") {
        //       v.body = "Setting";
        //       v.notifyListeners();
        //     }
        //     if (isMobile) Navigator.pop(context);
        //   }, //
        // ),

        // // User Profile
        // ListTile(
        //   leading: Icon(Icons.person_outline),
        //   title: Text("User"),
        //   onTap: () {
        //     if (v.body != "User") {
        //       v.body = "User";
        //       v.notifyListeners();
        //     }
        //     if (isMobile) Navigator.pop(context);
        //   }, //
        // ),
      ],
    );
  }
}
