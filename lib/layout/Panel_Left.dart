import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:speanmeas/Environment.dart';
import 'package:speanmeas/Global.dart';
import 'package:speanmeas/theme/Theme_Data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global.variable, //
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

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    return ListView(
      children: [
        if (Global.variable.is_admin || Global.variable.is_manager || Global.variable.is_receptionist || Global.variable.is_housekeeper)
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text("Front Desk"),
            selected: Global.variable.body == "Front Desk",
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = "Front Desk";
              Global.variable.notifyListeners();
              if (is_mobile) Navigator.pop(context);
              setState(() {});
            }, //
          ),

        if (Global.variable.is_admin || Global.variable.is_manager || Global.variable.is_receptionist)
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text("Guest"),
            selected: Global.variable.body == "Guest",
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = "Guest";
              Global.variable.notifyListeners();
              if (is_mobile) Navigator.pop(context);
              setState(() {});
            }, //
          ),

        if (Global.variable.is_admin || Global.variable.is_manager)
          ListTile(
            leading: Icon(Icons.hotel_outlined),
            title: Text("Room"),
            selected: Global.variable.body == "Room",
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = "Room";
              Global.variable.notifyListeners();
              if (is_mobile) Navigator.pop(context);
              setState(() {});
            }, //
          ),

        // User
        if (Global.variable.is_admin || Global.variable.is_manager)
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("User"),
            selected: Global.variable.body == "User",
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = "User";
              Global.variable.notifyListeners();

              if (is_mobile) Navigator.pop(context);
              setState(() {});
            }, //
          ),

        // Reports
        ExpansionTile(
          leading: Icon(Icons.assessment_outlined), //
          title: Text('Reports'),
          children: [
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: Global.variable.body == "Daily Report",
              selectedColor: Colors.blue,
              title: Text(
                'Daily Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                Global.variable.body = "Daily Report";
                Global.variable.notifyListeners();
                if (is_mobile) Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: Global.variable.body == "Weekly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Weekly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                Global.variable.body = "Weekly Report";
                Global.variable.notifyListeners();
                if (is_mobile) Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: Global.variable.body == "Monthly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Monthly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                Global.variable.body = "Monthly Report";
                Global.variable.notifyListeners();
                if (is_mobile) Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined), //
              selected: Global.variable.body == "Yearly Report",
              selectedColor: Colors.blue,
              title: Text(
                'Yearly Report', //
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onTap: () {
                //
                Global.variable.body = "Yearly Report";
                Global.variable.notifyListeners();
                if (is_mobile) Navigator.pop(context);
                setState(() {});
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

        // Nationality
        (() {
          String name = "Nationality";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: Global.variable.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = name;
              Global.variable.notifyListeners();
              if (is_mobile) Navigator.pop(context);
              setState(() {});
            },
          );
        })(),

        // Template
        (() {
          String name = "Demo";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: Global.variable.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = name;
              Global.variable.notifyListeners();
              if (is_mobile) Navigator.pop(context);
              setState(() {});
            },
          );
        })(),

        // Template
        (() {
          String name = "Demo 1";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: Global.variable.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = name;
              Global.variable.notifyListeners();
              if (is_mobile) Navigator.pop(context);
              setState(() {});
            },
          );
        })(),

        // Template
        (() {
          String name = "Demo 1A";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: Global.variable.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = name;
              Global.variable.notifyListeners();
              if (is_mobile) Navigator.pop(context);
              setState(() {});
            },
          );
        })(),

        (() {
          String name = "Demo 1B";
          return ListTile(
            leading: Icon(Icons.model_training_outlined),
            title: Text(name),
            selected: Global.variable.body == name,
            selectedColor: Colors.blue,
            onTap: () {
              Global.variable.body = name;
              Global.variable.notifyListeners();
              if (is_mobile) Navigator.pop(context);
              setState(() {});
            },
          );
        })(),
      ],
    );
  }
}
