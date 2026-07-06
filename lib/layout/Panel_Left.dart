import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:speanmeas/Environment.dart";
import "package:speanmeas/Global.dart";
import "package:speanmeas/theme/Theme_Data.dart";
import "package:speanmeas/utility/Secure_Storage.dart";
import "package:speanmeas/page/main/_User.dart" as user;

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
      title: "Demo",
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
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    is_mobile = MediaQuery.of(context).size.width < MOBILE_SCREEN_WIDTH;
    return ListView(
      children: [
        // Front Desk
        list_tile_l1(name: "Front Desk", icon: Icons.table_bar_outlined),

        // Guest
        if (user.data[user.IS_ADMIN] == true || user.data[user.IS_MANAGER] == true || user.data[user.IS_RECEPTIONIST] == true) //
          list_tile_l1(name: "Guest", icon: Icons.people_outline),

        // Room
        if (user.data[user.IS_ADMIN] == true || user.data[user.IS_MANAGER] == true) //
          list_tile_l1(name: "Room", icon: Icons.hotel_outlined),

        // User
        if (user.data[user.IS_ADMIN] == true || user.data[user.IS_MANAGER] == true) //
          list_tile_l1(name: "User", icon: Icons.person_outline),

        list_tile_l1(name: "Nationality", icon: Icons.flag_outlined),

        // Reports
        ExpansionTile(
          leading: Icon(Icons.assessment_outlined), //
          title: Text("Reports"),
          children: [
            list_tile_l2(name: "Daily Report", icon: Icons.assessment_outlined),
            list_tile_l2(name: "Weekly Report", icon: Icons.assessment_outlined),
            list_tile_l2(name: "Monthly Report", icon: Icons.assessment_outlined),
            list_tile_l2(name: "Yearly Report", icon: Icons.assessment_outlined),
          ],
        ),

        // Demos
        if (user.data[user.IS_ADMIN] == true)
          ExpansionTile(
            leading: Icon(Icons.model_training_outlined), //
            title: Text("Demos"),
            initiallyExpanded: true,
            children: [
              list_tile_l2(name: "Demo", icon: Icons.model_training_outlined),
              // list_tile_l2(name: "Demo 1", icon: Icons.model_training_outlined),
              // list_tile_l2(name: "Demo 1A", icon: Icons.model_training_outlined),
              // list_tile_l2(name: "Demo 1B", icon: Icons.model_training_outlined),
            ],
          ),
      ],
    );
  }

  Widget list_tile_l1({required String name, required IconData icon}) {
    return ListTile(
      leading: Icon(icon),
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
  }

  Widget list_tile_l2({required String name, required IconData icon}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      selected: Global.variable.body == name,
      selectedColor: Colors.blue,
      contentPadding: EdgeInsets.only(left: 40),
      onTap: () {
        Global.variable.body = name;
        Global.variable.notifyListeners();
        if (is_mobile) Navigator.pop(context);
        setState(() {});
      },
    );
  }
}
