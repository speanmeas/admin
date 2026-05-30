import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
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
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    final v = context.watch<Global>();
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.people_outline),
          title: Text("Check In/Out"),
          selected: v.body == "Check In/Out",
          selectedColor: Colors.blue,
          onTap: () {
            v.body = "Check In/Out";
            v.notifyListeners();
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        ListTile(
          leading: Icon(Icons.hotel_outlined),
          title: Text("Room"),
          selected: v.body == "Room",
          selectedColor: Colors.blue,
          onTap: () {
            v.body = "Room";
            v.notifyListeners();
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        ListTile(
          leading: Icon(Icons.people_outline),
          title: Text("Guest"),
          selected: v.body == "Guest",
          selectedColor: Colors.blue,
          onTap: () {
            v.body = "Guest";
            v.notifyListeners();
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        // User
        ListTile(
          leading: Icon(Icons.person_outline),
          title: Text("User"),
          selected: v.body == "User",
          selectedColor: Colors.blue,
          onTap: () {
            v.body = "User";
            v.notifyListeners();
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
              selected: v.body == "Daily Report",
              selectedColor: Colors.blue,
              title: Text(
                'Daily Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                v.body = "Daily Report";
                v.notifyListeners();
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: v.body == "Weekly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Weekly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                v.body = "Weekly Report";
                v.notifyListeners();
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: v.body == "Monthly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Monthly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                v.body = "Monthly Report";
                v.notifyListeners();
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: v.body == "Yearly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Yearly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                v.body = "Yearly Report";
                v.notifyListeners();
              },
            ),
          ],
        ),

        ListTile(
          leading: Icon(Icons.dashboard_outlined),
          title: Text("Dashboard"),
          selected: v.body == "Dashboard",
          selectedColor: Colors.blue,
          onTap: () {
            v.body = "Dashboard";
            v.notifyListeners();
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        // Template
        ListTile(
          leading: Icon(Icons.model_training_outlined),
          title: Text("Template"),
          selected: v.body == "Template",
          selectedColor: Colors.blue,
          onTap: () {
            v.body = "Template";
            v.notifyListeners();
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        ListTile(
          leading: Icon(Icons.work_outline),
          title: Text("Staff"),
          selected: v.body == "Staff",
          selectedColor: Colors.blue,
          onTap: () {
            v.body = "Staff";
            v.notifyListeners();
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text("Setting"),
          selected: v.body == "Setting",
          selectedColor: Colors.blue,
          onTap: () {
            v.body = "Setting";
            v.notifyListeners();
            if (isMobile) Navigator.pop(context);
          }, //
        ),

        // ListTile(
        //   leading: Icon(Icons.login_outlined),
        //   title: Text("Signin"),
        //   selected: v.body == "Signin",
        //   selectedColor: Colors.blue,
        //   onTap: () {
        //     v.body = "Signin";
        //     v.notifyListeners();
        //     if (isMobile) Navigator.pop(context);
        //   }, //
        // ),
      ],
    );
  }
}
