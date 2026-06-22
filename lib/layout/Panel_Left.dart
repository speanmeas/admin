import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/theme/Theme_Data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global(), //
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: Theme_Data(),
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
  bool is_mobile = false;
  Global global = Global();

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    global = context.watch<Global>();
    return ListView(
      children: [
        if (global.is_admin || global.is_manager || global.is_receptionist || global.is_housekeeper)
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text("Front Desk"),
            selected: global.body == "Front Desk",
            selectedColor: Colors.blue,
            onTap: () {
              global.body = "Front Desk";
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            }, //
          ),

        if (global.is_admin || global.is_manager || global.is_receptionist)
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text("Guest"),
            selected: global.body == "Guest",
            selectedColor: Colors.blue,
            onTap: () {
              global.body = "Guest";
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            }, //
          ),

        if (global.is_admin || global.is_manager)
          ListTile(
            leading: Icon(Icons.hotel_outlined),
            title: Text("Room"),
            selected: global.body == "Room",
            selectedColor: Colors.blue,
            onTap: () {
              global.body = "Room";
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            }, //
          ),

        // User
        if (global.is_admin || global.is_manager)
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("User"),
            selected: global.body == "User",
            selectedColor: Colors.blue,
            onTap: () {
              global.body = "User";
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            }, //
          ),

        // Check In/Out/Clean
        if (false)
          ListTile(
            leading: Icon(Icons.meeting_room_outlined),
            title: Text("Check In"),
            selected: global.body == "Check In",
            selectedColor: Colors.blue,
            onTap: () {
              global.body = "Check In";
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            }, //
          ),

        // Check In/Out/Clean
        if (false)
          ListTile(
            leading: Icon(Icons.meeting_room_outlined),
            title: Text("Check In/Out/Clean"),
            selected: global.body == "Check In/Out/Clean",
            selectedColor: Colors.blue,
            onTap: () {
              global.body = "Check In/Out/Clean";
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            }, //
          ),

        // Reports
        ExpansionTile(
          leading: Icon(Icons.assessment_outlined), //
          title: Text('Reports'),
          children: [
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: global.body == "Daily Report",
              selectedColor: Colors.blue,
              title: Text(
                'Daily Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                global.body = "Daily Report";
                global.notifyListeners();
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: global.body == "Weekly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Weekly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                global.body = "Weekly Report";
                global.notifyListeners();
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: global.body == "Monthly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Monthly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                global.body = "Monthly Report";
                global.notifyListeners();
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: global.body == "Yearly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Yearly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                global.body = "Yearly Report";
                global.notifyListeners();
              },
            ),
          ],
        ),

        // Template
        // if (kDebugMode)
        //   ListTile(
        //     leading: Icon(Icons.model_training_outlined),
        //     title: Text("Template"),
        //     selected: global.body == "Template",
        //     selectedColor: Colors.blue,
        //     onTap: () {
        //       global.body = "Template";
        //       global.notifyListeners();
        //       if (is_mobile) Navigator.pop(context);
        //     }, //
        //   ),

        // Template
        (() {
          String name = "Demo";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: global.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              global.body = name;
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            },
          );
        })(),

        // Template
        (() {
          String name = "Demo 1";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: global.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              global.body = name;
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            },
          );
        })(),

        // Template
        (() {
          String name = "Demo 1A";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: global.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              global.body = name;
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            },
          );
        })(),

        (() {
          String name = "Demo 1B";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: global.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              global.body = name;
              global.notifyListeners();
              if (is_mobile) Navigator.pop(context);
            },
          );
        })(),
      ],
    );
  }
}
